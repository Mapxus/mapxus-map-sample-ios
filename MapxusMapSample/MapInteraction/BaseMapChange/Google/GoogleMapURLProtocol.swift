//
//  GoogleMapURLProtocol.swift
//  MapxusMapSample
//
//  Created by guochenghao on 2026/9/3.
//  Copyright © 2026 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import Foundation

/// Authenticates Google tile and viewport requests using the shared session manager.
final class GoogleMapURLProtocol: URLProtocol {
    typealias MapType = GoogleMapSessionManager.MapType
    private typealias SessionContext = GoogleMapSessionManager.SessionContext

    static let sessionRevisionHeader = "X-Mapxus-Google-Session-Revision"

    struct SessionChange {
        let mapType: MapType
        let revision: UInt64
    }

    private enum Constants {
        static let handledKey = "GoogleMapURLProtocolHandledKey"
        static let stateQueueLabel = "com.mapxus.BaseMapReplace.GoogleMapURLProtocol.state"
        static let tileHost = "tile.googleapis.com"
        static let tilePathComponent = "/v1/2dtiles"
        static let viewportPath = "/tile/v1/viewport"
        static let apiKeyQueryName = "key"
        static let sessionQueryName = "session"
        static let sourceMapTypeQueryName = "mapType"
        static let mapTypeQueryName = "_mapxusGoogleMapType"
        static let generationQueryName = "_mapxusGoogleGeneration"
        static let errorDomain = "GoogleMapURLProtocol"
    }

    struct TileContext {
        let zoom: Int
        let mapType: MapType
    }

    // MARK: - Shared Map State

    private static let stateQueueKey = DispatchSpecificKey<Void>()
    private static let stateQueue: DispatchQueue = {
        let queue = DispatchQueue(label: Constants.stateQueueLabel)
        queue.setSpecific(key: stateQueueKey, value: ())
        return queue
    }()
    private static var currentMapType: MapType = .roadmap
    private static var currentMapGeneration: UInt64 = 0
    private static var isGoogleMapActive = false
    private static var tileObservers: [UUID: (TileContext) -> Void] = [:]
    
    private let lifecycleLock = NSLock()
    private let sessionManager: GoogleMapSessionManager
    private let forwardingSession: URLSession
    private var dataTask: URLSessionTask?
    private var cancelled = false

    // MARK: - URLProtocol Lifecycle

    override convenience init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        self.init(request: request, cachedResponse: cachedResponse, client: client,
                  sessionManager: .shared, forwardingSession: .shared)
    }

    init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?,
         sessionManager: GoogleMapSessionManager, forwardingSession: URLSession) {
        self.sessionManager = sessionManager
        self.forwardingSession = forwardingSession
        super.init(request: request, cachedResponse: cachedResponse, client: client)
    }

    private struct RequestContext {
        let mapType: MapType
        let mapGeneration: UInt64
    }

    private enum Resource {
        case tile
        case viewport
    }

    private static func resource(for url: URL?) -> Resource? {
        guard let url, url.scheme?.lowercased() == "https",
              url.host?.lowercased() == Constants.tileHost else { return nil }
        if url.path.hasPrefix(Constants.tilePathComponent + "/") { return .tile }
        if url.path == Constants.viewportPath { return .viewport }
        return nil
    }

    static func setMapType(_ mapType: MapType) {
        stateQueue.sync {
            guard !isGoogleMapActive || currentMapType != mapType else { return }
            currentMapType = mapType
            currentMapGeneration &+= 1
            isGoogleMapActive = true
            GoogleMapSessionManager.shared.activate(mapType)
        }
    }

    static func deactivate() {
        stateQueue.sync {
            guard isGoogleMapActive else { return }
            isGoogleMapActive = false
            currentMapGeneration &+= 1
            GoogleMapSessionManager.shared.deactivate()
        }
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        !isHandled(request) && resource(for: request.url) != nil
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
                guard resource(for: request.url) != nil,
              let url = request.url else { return request }

        var canonicalRequest = request
                let context = requestContext(from: request) ?? currentRequestContext()
                canonicalRequest.url = cacheKeyURL(for: url, context: context)
        return canonicalRequest
    }

    private static func cacheKeyURL(for url: URL, context: RequestContext) -> URL {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return url
        }

        var queryItems = components.queryItems ?? []
        upsertQueryItem(name: Constants.mapTypeQueryName, value: context.mapType.rawValue, in: &queryItems)
        upsertQueryItem(name: Constants.generationQueryName, value: String(context.mapGeneration), in: &queryItems)
        components.queryItems = queryItems
        return components.url ?? url
    }

    override func startLoading() {
        lifecycleLock.lock()
        cancelled = false
        lifecycleLock.unlock()
        
        guard let apiKey = sessionManager.apiKey, !apiKey.isEmpty else {
            fail(with: Self.makeError(code: -1, message: "Missing GoogleMapsAPIKey in Info.plist"))
            return
        }
        
        let context = Self.requestContext(from: request) ?? Self.currentRequestContext()
        guard Self.isActive(context) else {
            fail(with: Self.cancellationError)
            return
        }
        Self.publishTileContext(from: request, context: context)

        sessionManager.sessionContext(for: context.mapType) { [weak self] result in
            guard let self, self.canContinueLoading(context) else { return }
            
            switch result {
            case .success(let session):
                self.loadResource(apiKey: apiKey, session: session, context: context, canRefreshSession: true)
            case .failure(let error):
                self.fail(with: error)
            }
        }
    }
    
    override func stopLoading() {
        lifecycleLock.lock()
        cancelled = true
        let task = dataTask
        dataTask = nil
        lifecycleLock.unlock()
        task?.cancel()
    }

    // MARK: - Request Forwarding

    private func loadResource(apiKey: String, session: SessionContext, context: RequestContext, canRefreshSession: Bool) {
        guard Self.isActive(context), context.mapType == session.mapType else {
            fail(with: Self.cancellationError)
            return
        }

        guard let mutableRequest = makeAuthenticatedRequest(apiKey: apiKey, session: session.sessionToken) else {
            fail(with: Self.makeError(code: -2, message: "Request creation failed"))
            return
        }
        
        guard !isCancelled else {
            fail(with: Self.cancellationError)
            return
        }
        
        let task = forwardingSession.dataTask(with: mutableRequest as URLRequest) { [weak self] data, response, error in
            guard let self, self.canContinueLoading(context) else { return }
            
            if let error = error {
                self.fail(with: error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               canRefreshSession,
               Self.isSessionFailureStatusCode(httpResponse.statusCode) {
                self.refreshSessionAndRetry(apiKey: apiKey, rejectedSession: session, context: context)
                return
            }
            
            guard let response = response, let data = data else {
                self.fail(with: Self.makeError(code: -3, message: "No response data"))
                return
            }
            
            self.complete(with: response, data: data, context: context, sessionRevision: session.revision)
        }
        installAndResume(task)
    }

    private func refreshSessionAndRetry(apiKey: String, rejectedSession: SessionContext, context: RequestContext) {
        sessionManager.sessionContext(for: rejectedSession.mapType, refreshingAfter: rejectedSession) { [weak self] result in
            guard let self, self.canContinueLoading(context) else { return }

            switch result {
            case .success(let refreshedSession):
                self.loadResource(
                    apiKey: apiKey,
                    session: refreshedSession,
                    context: context,
                    canRefreshSession: false
                )
            case .failure(let error):
                self.fail(with: error)
            }
        }
    }

    private func canContinueLoading(_ context: RequestContext) -> Bool {
        guard !isCancelled else { return false }
        guard Self.isActive(context) else {
            fail(with: Self.cancellationError)
            return false
        }
        return true
    }

    // MARK: - Observers

    static func addSessionObserver(_ observer: @escaping (SessionChange) -> Void) -> UUID {
        GoogleMapSessionManager.shared.addSessionObserver { context in
            observer(SessionChange(mapType: context.mapType, revision: context.revision))
        }
    }

    static func addTileObserver(_ observer: @escaping (TileContext) -> Void) -> UUID {
        let token = UUID()
        stateQueue.async {
            tileObservers[token] = observer
        }
        return token
    }

    static func removeSessionObserver(_ token: UUID) {
        GoogleMapSessionManager.shared.removeObserver(token)
    }

    static func removeTileObserver(_ token: UUID) {
        stateQueue.async {
            tileObservers[token] = nil
        }
    }

    private class func publishTileContext(from request: URLRequest, context: RequestContext) {
        guard resource(for: request.url) == .tile,
              let pathComponents = request.url?.pathComponents,
              let tilePathIndex = pathComponents.firstIndex(of: "2dtiles"),
              pathComponents.indices.contains(tilePathIndex + 1),
              let zoom = Int(pathComponents[tilePathIndex + 1]) else { return }
        let tileContext = TileContext(zoom: zoom, mapType: context.mapType)
        stateQueue.async {
            let observers = Array(tileObservers.values)
            DispatchQueue.main.async {
                guard isActive(context) else { return }
                observers.forEach { $0(tileContext) }
            }
        }
    }

    private class func currentRequestContext() -> RequestContext {
        withState {
            RequestContext(mapType: currentMapType, mapGeneration: currentMapGeneration)
        }
    }

    private class func isActive(_ context: RequestContext) -> Bool {
        withState {
            isGoogleMapActive && currentMapType == context.mapType && currentMapGeneration == context.mapGeneration
        }
    }

    private class func withState<T>(_ action: () -> T) -> T {
        guard DispatchQueue.getSpecific(key: stateQueueKey) == nil else { return action() }
        return stateQueue.sync(execute: action)
    }

    private class func requestContext(from request: URLRequest) -> RequestContext? {
        guard let url = request.url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems,
              let mapTypeValue = queryItems.first(where: {
                  $0.name == Constants.sourceMapTypeQueryName || $0.name == Constants.mapTypeQueryName
              })?.value,
              let mapType = MapType(rawValue: mapTypeValue) else { return nil }
        let mapGeneration = queryItems.first(where: { $0.name == Constants.generationQueryName })
            .flatMap(\.value)
            .flatMap(UInt64.init) ?? withState { currentMapGeneration }
        return RequestContext(mapType: mapType, mapGeneration: mapGeneration)
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

    private class var cancellationError: NSError {
        NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled)
    }

    // MARK: - Request Construction

    private func makeAuthenticatedRequest(apiKey: String, session: String) -> NSMutableURLRequest? {
        guard let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            return nil
        }
        
        if let requestURL = mutableRequest.url,
           var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: false) {
            var queryItems = components.queryItems ?? []
            queryItems.removeAll {
                $0.name == Constants.sourceMapTypeQueryName ||
                    $0.name == Constants.mapTypeQueryName ||
                    $0.name == Constants.generationQueryName ||
                    $0.name == Constants.apiKeyQueryName ||
                    $0.name == Constants.sessionQueryName
            }
            Self.upsertQueryItem(name: Constants.apiKeyQueryName, value: apiKey, in: &queryItems)
            Self.upsertQueryItem(name: Constants.sessionQueryName, value: session, in: &queryItems)
            components.queryItems = queryItems
            mutableRequest.url = components.url
        }
        
        // Prevent the forwarded request from being intercepted recursively.
        URLProtocol.setProperty(true, forKey: Constants.handledKey, in: mutableRequest)
        return mutableRequest
    }
    
    private class func upsertQueryItem(name: String, value: String, in queryItems: inout [URLQueryItem]) {
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

    private var isCancelled: Bool {
        lifecycleLock.lock()
        defer { lifecycleLock.unlock() }
        return cancelled
    }

    private func installAndResume(_ task: URLSessionTask) {
        lifecycleLock.lock()
        if cancelled {
            lifecycleLock.unlock()
            task.cancel()
            return
        }
        dataTask = task
        lifecycleLock.unlock()
        task.resume()
    }

    // MARK: - Response Delivery

    private func complete(with response: URLResponse, data: Data, context: RequestContext, sessionRevision: UInt64) {
        let isTile = Self.resource(for: request.url) == .tile
        let response = isTile
            ? Self.responseByRemovingConflictingExpires(response)
            : Self.response(response, withSessionRevision: sessionRevision)
        DispatchQueue.main.async { [weak self] in
            guard let self = self, !self.isCancelled else { return }
            guard Self.isActive(context) else {
                self.fail(with: Self.cancellationError)
                return
            }
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: isTile ? .allowed : .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }

    private static func response(_ response: URLResponse, withSessionRevision revision: UInt64) -> URLResponse {
        guard let response = response as? HTTPURLResponse, let url = response.url else { return response }
        var headers: [String: String] = [:]
        for (key, value) in response.allHeaderFields {
            guard let name = key as? String,
                  name.caseInsensitiveCompare(sessionRevisionHeader) != .orderedSame else { continue }
            headers[name] = String(describing: value)
        }
        headers[sessionRevisionHeader] = String(revision)
        return HTTPURLResponse(url: url, statusCode: response.statusCode, httpVersion: nil, headerFields: headers) ?? response
    }

    private class func responseByRemovingConflictingExpires(_ response: URLResponse) -> URLResponse {
        guard let httpResponse = response as? HTTPURLResponse,
              let url = httpResponse.url,
              let cacheControl = httpResponse.value(forHTTPHeaderField: "Cache-Control"),
              cacheControl.range(
                of: #"(?:^|,)\s*max-age\s*=\s*"?\d+"?\s*(?:,|$)"#,
                options: [.regularExpression, .caseInsensitive]
              ) != nil else {
            return response
        }

        var headerFields: [String: String] = [:]
        for (key, value) in httpResponse.allHeaderFields {
            guard let name = key as? String,
                  name.caseInsensitiveCompare("Expires") != .orderedSame else {
                continue
            }
            headerFields[name] = String(describing: value)
        }

        return HTTPURLResponse(
            url: url,
            statusCode: httpResponse.statusCode,
            httpVersion: nil,
            headerFields: headerFields
        ) ?? response
    }
}
