//
//  MapboxURLProtocol.swift
//  MapxusMapSample
//
//  Created by guochenghao on 2026/9/3.
//  Copyright © 2026 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import Foundation

/// Intercepts Mapbox vector tile requests and appends the access token required by the tile endpoint.
final class MapboxURLProtocol: URLProtocol {
    private enum Constants {
        static let handledKey = "MapboxURLProtocolHandledKey"
        static let accessTokenInfoPlistKey = "MapboxAccessToken"
        static let mapboxHost = "api.mapbox.com"
        static let vectorTilePathSuffix = ".vector.pbf"
        static let accessTokenQueryName = "access_token"
        static let errorDomain = "MapboxURLProtocol"
    }
    
    private var dataTask: URLSessionTask?
    private var isCancelled = false
    
    override class func canInit(with request: URLRequest) -> Bool {
        // The forwarded request retains this marker, preventing it from being intercepted recursively.
        if isHandled(request) {
            return false
        }
        
        guard let url = request.url,
              let host = url.host?.lowercased() else {
            return false
        }
        
        return host == Constants.mapboxHost && url.path.lowercased().contains(Constants.vectorTilePathSuffix)
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        isCancelled = false
        
        guard let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            fail(with: Self.makeError(code: -1, message: "Request creation failed"))
            return
        }
        
        appendAccessTokenIfNeeded(to: mutableRequest)
        // Mark the mutable copy before forwarding it through another URL session.
        URLProtocol.setProperty(true, forKey: Constants.handledKey, in: mutableRequest)
        
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
            
            guard let response = response, let data = data else {
                self.fail(with: Self.makeError(code: -2, message: "No response data"))
                return
            }
            
            self.complete(with: response, data: data)
        }
        dataTask?.resume()
    }
    
    override func stopLoading() {
        isCancelled = true
        dataTask?.cancel()
        dataTask = nil
    }
    
    private class func isHandled(_ request: URLRequest) -> Bool {
        URLProtocol.property(forKey: Constants.handledKey, in: request) as? Bool == true
    }
    
    private class func makeError(code: Int, message: String) -> NSError {
        NSError(domain: Constants.errorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
    private var accessToken: String? {
        // Build configuration exposes the token through the app's Info.plist.
        Bundle.main.object(forInfoDictionaryKey: Constants.accessTokenInfoPlistKey) as? String
    }
    
    private func appendAccessTokenIfNeeded(to request: NSMutableURLRequest) {
        guard let token = accessToken, !token.isEmpty,
              let requestURL = request.url,
              var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: false) else {
            return
        }
        
        var queryItems = components.queryItems ?? []
        guard !queryItems.contains(where: { $0.name == Constants.accessTokenQueryName }) else { return }
        
        queryItems.append(URLQueryItem(name: Constants.accessTokenQueryName, value: token))
        components.queryItems = queryItems
        request.url = components.url
    }
    
    private func fail(with error: Error) {
        guard !isCancelled || (error as NSError).code == NSURLErrorCancelled else { return }
        client?.urlProtocol(self, didFailWithError: error)
    }
    
    private func complete(with response: URLResponse, data: Data) {
        guard !isCancelled else { return }
        // URLProtocol subclasses must relay the complete loading lifecycle to their client.
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }
}
