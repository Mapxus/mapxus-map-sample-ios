//
//  GoogleMapURLProtocol.swift
//  MapxusMapSample
//
//  Created by guochenghao on 2026/9/3.
//  Copyright © 2026 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import Foundation

/// Intercepts Google 2D tile requests, attaches the required API key and tile
/// session, then forwards the response to the original URL loading client.
final class GoogleMapURLProtocol: URLProtocol {
    private enum Constants {
        static let handledKey = "GoogleMapURLProtocolHandledKey"
        static let apiKeyInfoPlistKey = "GoogleMapsAPIKey"
        static let defaultRefreshLeeway: TimeInterval = 60
        static let persistedSessionKey = "GoogleMapURLProtocol.persistedSession"
        static let stateQueueLabel = "com.mapxus.BaseMapReplace.GoogleMapURLProtocol.state"
        static let tileHost = "tile.googleapis.com"
        static let tilePathComponent = "/v1/2dtiles"
        static let createSessionURL = "https://tile.googleapis.com/v1/createSession"
        static let apiKeyQueryName = "key"
        static let sessionQueryName = "session"
        static let errorDomain = "GoogleMapURLProtocol"
    }
    
    /// Serializes access to the shared tile session and coalesces concurrent refreshes.
    private static let stateQueue = DispatchQueue(label: Constants.stateQueueLabel)
    private static var currentSession: TileSession?
    /// Callbacks waiting for the single in-flight session refresh to finish.
    private static var pendingCompletions: [(Result<TileSession, Error>) -> Void] = []
    private static var isRefreshingSession = false
    
    private var dataTask: URLSessionTask?
    private var isCancelled = false
    
    private struct TileSession: Codable {
        let session: String
        /// Expiration time returned by Google as Unix epoch seconds encoded as a string.
        let expiry: String
        let tileWidth: Int?
        let imageFormat: String?
        let tileHeight: Int?
        
        var expiryDate: Date? {
            guard let seconds = TimeInterval(expiry) else { return nil }
            return Date(timeIntervalSince1970: seconds)
        }
        
        var isExpired: Bool {
            guard let expiryDate = expiryDate else { return true }
            // Refresh shortly before expiration to avoid using a session that expires in flight.
            return expiryDate.timeIntervalSinceNow <= GoogleMapURLProtocol.Constants.defaultRefreshLeeway
        }
    }
    
    /// Handles only Google 2D tile requests that have not already passed through this protocol.
    override class func canInit(with request: URLRequest) -> Bool {
        if isHandled(request) {
            return false
        }
        
        guard let url = request.url,
              let host = url.host?.lowercased() else {
            return false
        }
        
        return host == Constants.tileHost && url.path.lowercased().contains(Constants.tilePathComponent)
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        isCancelled = false
        
        guard let apiKey = googleMapsAPIKey, !apiKey.isEmpty else {
            fail(with: Self.makeError(code: -1, message: "Missing GoogleMapsAPIKey in Info.plist"))
            return
        }
        
        Self.validSession(apiKey: apiKey) { [weak self] result in
            guard let self = self, !self.isCancelled else { return }
            
            switch result {
            case .success(let tileSession):
                self.loadTile(apiKey: apiKey, session: tileSession.session, retryOnSessionFailure: true)
            case .failure(let error):
                self.fail(with: error)
            }
        }
    }
    
    override func stopLoading() {
        isCancelled = true
        dataTask?.cancel()
        dataTask = nil
    }
    
    private func loadTile(apiKey: String, session: String, retryOnSessionFailure: Bool) {
        guard let mutableRequest = makeTileRequest(apiKey: apiKey, session: session) else {
            fail(with: Self.makeError(code: -2, message: "Request creation failed"))
            return
        }
        
        guard !isCancelled else {
            fail(with: NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled))
            return
        }
        
        dataTask = URLSession.shared.dataTask(with: mutableRequest as URLRequest) { [weak self] data, response, error in
            guard let self = self, !self.isCancelled else { return }
            
            if let error = error {
                self.fail(with: error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               retryOnSessionFailure,
               Self.isSessionFailureStatusCode(httpResponse.statusCode) {
                // A rejected session may have expired remotely. Refresh it and retry only once.
                Self.invalidateSession(session)
                Self.validSession(apiKey: apiKey, forceRefresh: true) { [weak self] result in
                    guard let self = self, !self.isCancelled else { return }
                    
                    switch result {
                    case .success(let tileSession):
                        self.loadTile(apiKey: apiKey, session: tileSession.session, retryOnSessionFailure: false)
                    case .failure(let error):
                        self.fail(with: error)
                    }
                }
                return
            }
            
            guard let response = response, let data = data else {
                self.fail(with: Self.makeError(code: -3, message: "No response data"))
                return
            }
            
            self.complete(with: response, data: data)
        }
        dataTask?.resume()
    }
    
    private class func validSession(apiKey: String, forceRefresh: Bool = false, completion: @escaping (Result<TileSession, Error>) -> Void) {
        stateQueue.async {
            if !forceRefresh,
               let validSession = currentValidSession() {
                completion(.success(validSession))
                return
            }
            
            // Multiple tile requests share one refresh instead of creating parallel sessions.
            pendingCompletions.append(completion)
            guard !isRefreshingSession else { return }
            isRefreshingSession = true
            
            requestSession(apiKey: apiKey)
        }
    }
    
    private class func currentValidSession() -> TileSession? {
        // Prefer the in-memory value, then restore a valid session from a previous launch.
        if let currentSession = currentSession, !currentSession.isExpired {
            return currentSession
        }
        
        if let persistedSession = loadPersistedSession(), !persistedSession.isExpired {
            currentSession = persistedSession
            return persistedSession
        }
        
        return nil
    }
    
    private class func requestSession(apiKey: String) {
        guard var components = URLComponents(string: Constants.createSessionURL) else {
            finishSessionRefresh(.failure(makeError(code: -4, message: "Invalid session URL")))
            return
        }
        
        components.queryItems = [URLQueryItem(name: Constants.apiKeyQueryName, value: apiKey)]
        
        guard let url = components.url else {
            finishSessionRefresh(.failure(makeError(code: -5, message: "Invalid session request")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = makeSessionRequestBody()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                finishSessionRefresh(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                finishSessionRefresh(.failure(makeError(code: httpResponse.statusCode, message: "Google tile session request failed")))
                return
            }
            
            guard let data = data else {
                finishSessionRefresh(.failure(makeError(code: -6, message: "No session response data")))
                return
            }
            
            do {
                let tileSession = try JSONDecoder().decode(TileSession.self, from: data)
                finishSessionRefresh(.success(tileSession))
            } catch {
                finishSessionRefresh(.failure(error))
            }
        }.resume()
    }
    
    private class func finishSessionRefresh(_ result: Result<TileSession, Error>) {
        stateQueue.async {
            if case .success(let tileSession) = result {
                currentSession = tileSession
                savePersistedSession(tileSession)
            }
            
            // Every request queued during the refresh receives the same result.
            let completions = pendingCompletions
            pendingCompletions.removeAll()
            isRefreshingSession = false
            
            completions.forEach { completion in
                completion(result)
            }
        }
    }
    
    private class func invalidateSession(_ session: String) {
        stateQueue.async {
            // Do not discard a newer session because an older request failed later.
            if currentSession?.session == session {
                currentSession = nil
                clearPersistedSession()
            }
        }
    }
    
    private class func loadPersistedSession() -> TileSession? {
        guard let data = UserDefaults.standard.data(forKey: Constants.persistedSessionKey) else { return nil }
        return try? JSONDecoder().decode(TileSession.self, from: data)
    }
    
    private class func savePersistedSession(_ tileSession: TileSession) {
        guard let data = try? JSONEncoder().encode(tileSession) else { return }
        UserDefaults.standard.set(data, forKey: Constants.persistedSessionKey)
    }
    
    private class func clearPersistedSession() {
        UserDefaults.standard.removeObject(forKey: Constants.persistedSessionKey)
    }
    
    private class func isSessionFailureStatusCode(_ statusCode: Int) -> Bool {
        statusCode == 401 || statusCode == 403
    }
    
    private class func isHandled(_ request: URLRequest) -> Bool {
        URLProtocol.property(forKey: Constants.handledKey, in: request) as? Bool == true
    }
    
    private class func makeError(code: Int, message: String) -> NSError {
        NSError(domain: Constants.errorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
    /// Builds the Google 2D tile session configuration.
    ///
    /// The session requests roadmap tiles localized for US English. `scaleFactor2x`
    /// and `highDpi` request high-density tiles suitable for Retina displays. These
    /// values become properties of the created session and therefore apply to every
    /// tile request that uses the returned session token.
    private class func makeSessionRequestBody() -> Data? {
        try? JSONSerialization.data(withJSONObject: [
            "mapType": "roadmap",
            "language": "en-US",
            "region": "US",
            "scale": "scaleFactor2x",
            "highDpi": true
        ])
    }
    
    private var googleMapsAPIKey: String? {
        Bundle.main.object(forInfoDictionaryKey: Constants.apiKeyInfoPlistKey) as? String
    }
    
    private func makeTileRequest(apiKey: String, session: String) -> NSMutableURLRequest? {
        guard let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            return nil
        }
        
        if let requestURL = mutableRequest.url,
           var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: false) {
            var queryItems = components.queryItems ?? []
            upsertQueryItem(name: Constants.apiKeyQueryName, value: apiKey, in: &queryItems)
            upsertQueryItem(name: Constants.sessionQueryName, value: session, in: &queryItems)
            components.queryItems = queryItems
            mutableRequest.url = components.url
        }
        
        // Prevent the forwarded request from being intercepted recursively.
        URLProtocol.setProperty(true, forKey: Constants.handledKey, in: mutableRequest)
        return mutableRequest
    }
    
    private func upsertQueryItem(name: String, value: String, in queryItems: inout [URLQueryItem]) {
        if let index = queryItems.firstIndex(where: { $0.name == name }) {
            queryItems[index] = URLQueryItem(name: name, value: value)
        } else {
            queryItems.append(URLQueryItem(name: name, value: value))
        }
    }
    
    private func fail(with error: Error) {
        guard !isCancelled || (error as NSError).code == NSURLErrorCancelled else { return }
        client?.urlProtocol(self, didFailWithError: error)
    }
    
    private func complete(with response: URLResponse, data: Data) {
        guard !isCancelled else { return }
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }
}
