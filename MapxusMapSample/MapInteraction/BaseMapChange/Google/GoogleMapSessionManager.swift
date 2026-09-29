import Foundation
import CryptoKit

/// Owns Google tile sessions, persistent responses, and active-map refreshes.
final class GoogleMapSessionManager {
    enum MapType: String {
        case roadmap
        case satellite
    }

    struct SessionContext {
        let sessionToken: String
        let revision: UInt64
        let mapType: MapType
        let requestFingerprint: String
        let expirationTimestamp: String

        fileprivate var isValid: Bool {
            guard !sessionToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                  let expiration = TimeInterval(expirationTimestamp), expiration.isFinite else { return false }
            return expiration > Date().timeIntervalSince1970 + 60
        }
    }

    private struct SessionResponse: Decodable {
        let session: String
        let expiry: String
    }

    private typealias Completion = (Result<SessionContext, Error>) -> Void

    static let shared = GoogleMapSessionManager()

    private let urlSession: URLSession
    private let defaults: UserDefaults
    private let apiKeyProvider: () -> String?
    private let stateQueue = DispatchQueue(label: "com.mapxus.BaseMapReplace.GoogleMapSessionManager.state")
    private var sessions: [String: SessionContext] = [:]
    private var revision: UInt64 = 0
    private var pendingCompletions: [String: [Completion]] = [:]
    private var observers: [UUID: (SessionContext) -> Void] = [:]
    private var activeMapType: MapType?
    private var refreshTimer: DispatchSourceTimer?

    init(
        urlSession: URLSession = .shared,
        userDefaults: UserDefaults = .standard,
        apiKeyProvider: @escaping () -> String? = {
            Bundle.main.object(forInfoDictionaryKey: "GoogleMapsAPIKey") as? String
        }
    ) {
        self.urlSession = urlSession
        self.defaults = userDefaults
        self.apiKeyProvider = apiKeyProvider
    }

    deinit {
        refreshTimer?.cancel()
    }

    var apiKey: String? {
        apiKeyProvider()
    }

    func activate(_ mapType: MapType) {
        stateQueue.async {
            self.activeMapType = mapType
            self.cancelScheduledRefresh()
            self.resolveSessionContext(for: mapType, completion: { _ in })
        }
    }

    func deactivate() {
        stateQueue.async {
            self.activeMapType = nil
            self.cancelScheduledRefresh()
        }
    }

    /// Reuses a newer session when the rejected token has already been replaced.
    func sessionContext(
        for mapType: MapType,
        refreshingAfter rejectedSession: SessionContext? = nil,
        completion: @escaping (Result<SessionContext, Error>) -> Void
    ) {
        stateQueue.async {
            self.resolveSessionContext(for: mapType, refreshingAfter: rejectedSession, completion: completion)
        }
    }

    func addSessionObserver(_ observer: @escaping (SessionContext) -> Void) -> UUID {
        let token = UUID()
        stateQueue.async {
            self.observers[token] = observer
        }
        return token
    }

    func removeObserver(_ token: UUID) {
        stateQueue.async {
            self.observers[token] = nil
        }
    }

    private func resolveSessionContext(
        for mapType: MapType,
        refreshingAfter rejectedSession: SessionContext? = nil,
        completion: @escaping Completion
    ) {
        guard let requestBody = Self.makeCreateSessionBody(for: mapType) else {
            deliver(.failure(Self.makeError(code: -7, message: "Session request body creation failed")), to: completion)
            return
        }
        let cacheKey = Self.requestFingerprint(for: requestBody)

        if let rejectedSession, rejectedSession.requestFingerprint == cacheKey {
            discardCachedSession(matching: rejectedSession)
        }

        if let cached = validCachedSession(for: mapType, cacheKey: cacheKey) {
            scheduleAutomaticRefresh(for: cached)
            deliver(.success(cached), to: completion)
            return
        }

        if joinPendingCreation(cacheKey: cacheKey, completion: completion) {
            return
        }

        guard let apiKey, !apiKey.isEmpty else {
            deliver(.failure(Self.makeError(code: -1, message: "Missing GoogleMapsAPIKey in Info.plist")), to: completion)
            return
        }

        pendingCompletions[cacheKey] = [completion]
        createSession(apiKey: apiKey, mapType: mapType, requestBody: requestBody, cacheKey: cacheKey)
    }

    private func joinPendingCreation(cacheKey: String, completion: @escaping Completion) -> Bool {
        guard pendingCompletions[cacheKey] != nil else { return false }
        pendingCompletions[cacheKey]?.append(completion)
        return true
    }

    private func createSession(apiKey: String, mapType: MapType, requestBody: Data, cacheKey: String) {
        guard var components = URLComponents(string: "https://tile.googleapis.com/v1/createSession") else {
            finishSessionCreation(.failure(Self.makeError(code: -4, message: "Invalid session URL")), mapType: mapType, cacheKey: cacheKey)
            return
        }
        components.queryItems = [URLQueryItem(name: "key", value: apiKey)]
        guard let url = components.url else {
            finishSessionCreation(.failure(Self.makeError(code: -5, message: "Invalid session request")), mapType: mapType, cacheKey: cacheKey)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody
        urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            let result: Result<Data, Error>
            if let error {
                result = .failure(error)
            } else if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                result = .failure(Self.makeError(code: httpResponse.statusCode, message: "Google tile session request failed"))
            } else if let data {
                result = .success(data)
            } else {
                result = .failure(Self.makeError(code: -6, message: "No session response data"))
            }
            self.stateQueue.async {
                self.finishSessionCreation(result, mapType: mapType, cacheKey: cacheKey)
            }
        }.resume()
    }

    private func finishSessionCreation(_ response: Result<Data, Error>, mapType: MapType, cacheKey: String) {
        let result = response.flatMap { data -> Result<SessionContext, Error> in
            do {
                let context = try decodeSession(data, mapType: mapType, cacheKey: cacheKey)
                sessions[cacheKey] = context
                defaults.set(data, forKey: Self.persistentCacheKey(cacheKey))
                scheduleAutomaticRefresh(for: context)
                let callbacks = Array(observers.values)
                DispatchQueue.main.async {
                    callbacks.forEach { $0(context) }
                }
                return .success(context)
            } catch {
                return .failure(error)
            }
        }
        let completions = pendingCompletions.removeValue(forKey: cacheKey) ?? []
        completions.forEach { deliver(result, to: $0) }
    }

    private func decodeSession(_ data: Data, mapType: MapType, cacheKey: String) throws -> SessionContext {
        let response = try JSONDecoder().decode(SessionResponse.self, from: data)
        let context = SessionContext(
            sessionToken: response.session,
            revision: revision &+ 1,
            mapType: mapType,
            requestFingerprint: cacheKey,
            expirationTimestamp: response.expiry
        )
        guard context.isValid else {
            throw Self.makeError(code: -8, message: "Invalid or expired Google tile session response")
        }
        revision = context.revision
        return context
    }

    private func validCachedSession(for mapType: MapType, cacheKey: String) -> SessionContext? {
        if let context = sessions[cacheKey], context.isValid { return context }
        sessions[cacheKey] = nil
        let localKey = Self.persistentCacheKey(cacheKey)
        guard let data = defaults.data(forKey: localKey),
              let context = try? decodeSession(data, mapType: mapType, cacheKey: cacheKey) else {
            defaults.removeObject(forKey: localKey)
            return nil
        }
        sessions[cacheKey] = context
        return context
    }

    private func discardCachedSession(matching rejected: SessionContext) {
          guard let current = validCachedSession(for: rejected.mapType, cacheKey: rejected.requestFingerprint),
              current.sessionToken == rejected.sessionToken else { return }
          sessions[rejected.requestFingerprint] = nil
          defaults.removeObject(forKey: Self.persistentCacheKey(rejected.requestFingerprint))
        if activeMapType == rejected.mapType {
            cancelScheduledRefresh()
        }
    }

    private func scheduleAutomaticRefresh(for context: SessionContext) {
        guard activeMapType == context.mapType, context.isValid,
              let expiration = TimeInterval(context.expirationTimestamp) else { return }
        cancelScheduledRefresh()
        let timer = DispatchSource.makeTimerSource(queue: stateQueue)
        timer.schedule(deadline: .now() + max(0, expiration - Date().timeIntervalSince1970 - 60))
        timer.setEventHandler { [weak self] in
            guard let self, self.activeMapType == context.mapType,
                self.sessions[context.requestFingerprint]?.sessionToken == context.sessionToken else { return }
            self.cancelScheduledRefresh()
            self.resolveSessionContext(for: context.mapType, refreshingAfter: context, completion: { _ in })
        }
        refreshTimer = timer
        timer.resume()
    }

    private func cancelScheduledRefresh() {
        refreshTimer?.cancel()
        refreshTimer = nil
    }

    private func deliver(_ result: Result<SessionContext, Error>, to completion: @escaping Completion) {
        DispatchQueue.main.async {
            completion(result)
        }
    }

    private static func makeCreateSessionBody(for mapType: MapType) -> Data? {
        try? JSONSerialization.data(withJSONObject: [
            "mapType": mapType.rawValue,
            "layerTypes": [ "layerRoadmap" ],
            "language": "en-US",
            "region": "US",
            "scale": "scaleFactor2x",
            "highDpi": true
        ], options: [.sortedKeys])
    }

    private static func requestFingerprint(for requestBody: Data) -> String {
        Insecure.MD5.hash(data: requestBody)
            .map { String(format: "%02x", $0) }
            .joined()
    }

    private static func persistentCacheKey(_ cacheKey: String) -> String {
        "GoogleMapURLProtocol.session." + cacheKey
    }

    private static func makeError(code: Int, message: String) -> NSError {
        NSError(domain: "GoogleMapURLProtocol", code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}