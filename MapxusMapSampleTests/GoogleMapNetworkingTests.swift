#if os(macOS)
import Foundation
import XCTest
import CryptoKit

private final class MockGoogleTransport: URLProtocol {
    static var handler: ((MockGoogleTransport) -> Void)?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() { Self.handler?(self) }
    override func stopLoading() {}

    func respond(status: Int = 200, data: Data = Data(), headers: [String: String] = [:]) {
        let response = HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: nil, headerFields: headers)!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }
}

private final class RecordingClient: NSObject, URLProtocolClient {
    let finished: XCTestExpectation
    var response: HTTPURLResponse?
    var error: Error?
    var policy: URLCache.StoragePolicy?
    var callbackCount = 0

    init(_ finished: XCTestExpectation) { self.finished = finished }
    func urlProtocol(_ protocol: URLProtocol, didReceive response: URLResponse, cacheStoragePolicy policy: URLCache.StoragePolicy) {
        callbackCount += 1
        self.response = response as? HTTPURLResponse
        self.policy = policy
    }
    func urlProtocol(_ protocol: URLProtocol, didLoad data: Data) { callbackCount += 1 }
    func urlProtocolDidFinishLoading(_ protocol: URLProtocol) {
        callbackCount += 1
        finished.fulfill()
    }
    func urlProtocol(_ protocol: URLProtocol, didFailWithError error: Error) {
        callbackCount += 1
        self.error = error
        finished.fulfill()
    }
    func urlProtocol(_ protocol: URLProtocol, wasRedirectedTo request: URLRequest, redirectResponse: URLResponse) { XCTFail("Unexpected redirect") }
    func urlProtocol(_ protocol: URLProtocol, cachedResponseIsValid cachedResponse: CachedURLResponse) {}
    func urlProtocol(_ protocol: URLProtocol, didReceive challenge: URLAuthenticationChallenge) {}
    func urlProtocol(_ protocol: URLProtocol, didCancel challenge: URLAuthenticationChallenge) {}
}

final class GoogleMapNetworkingTests: XCTestCase {
    private var transport: URLSession!
    private var defaults: UserDefaults!
    private var suiteName: String!
    private var manager: GoogleMapSessionManager!
    private var generatedKey = UUID().uuidString

    override func setUp() {
        super.setUp()
        XCTAssertNil(Bundle.main.object(forInfoDictionaryKey: "GoogleMapsAPIKey"))
        suiteName = "GoogleMapNetworkingTests." + UUID().uuidString
        defaults = UserDefaults(suiteName: suiteName)
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockGoogleTransport.self]
        transport = URLSession(configuration: configuration)
        manager = makeManager()
        GoogleMapURLProtocol.setMapType(.roadmap)
    }

    override func tearDown() {
        GoogleMapURLProtocol.deactivate()
        manager.deactivate()
        transport.invalidateAndCancel()
        defaults.removePersistentDomain(forName: suiteName)
        MockGoogleTransport.handler = nil
        super.tearDown()
    }

    private func makeManager() -> GoogleMapSessionManager {
        let generatedKey = self.generatedKey
        return GoogleMapSessionManager(urlSession: transport, userDefaults: defaults, apiKeyProvider: { generatedKey })
    }

    private func sessionData(expiration: TimeInterval = 3600) -> Data {
        try! JSONSerialization.data(withJSONObject: [
            "session": UUID().uuidString,
            "expiry": String(Date().timeIntervalSince1970 + expiration),
            "tileWidth": 512,
            "tileHeight": 512,
            "imageFormat": "png"
        ])
    }

    private func fetch(_ manager: GoogleMapSessionManager, mapType: GoogleMapSessionManager.MapType = .roadmap,
                       replacing rejected: GoogleMapSessionManager.SessionContext? = nil) throws -> GoogleMapSessionManager.SessionContext {
        let completed = expectation(description: "session")
        var result: Result<GoogleMapSessionManager.SessionContext, Error>?
        manager.sessionContext(for: mapType, refreshingAfter: rejected) {
            result = $0
            completed.fulfill()
        }
        wait(for: [completed], timeout: 3)
        return try XCTUnwrap(result).get()
    }

    @objc func testCachePersistenceAndMapTypeIsolation() throws {
        var requests = 0
        let payload = sessionData()
        MockGoogleTransport.handler = { request in
            requests += 1
            XCTAssertEqual(request.request.url?.path, "/v1/createSession")
            XCTAssertEqual(request.request.httpMethod, "POST")
            request.respond(data: payload)
        }
        let initial = try fetch(manager)
        XCTAssertEqual(try fetch(manager).sessionToken, initial.sessionToken)
        XCTAssertEqual(try fetch(makeManager()).sessionToken, initial.sessionToken)
        XCTAssertEqual(requests, 1)
        let body = try JSONSerialization.data(withJSONObject: [
            "mapType": "roadmap", "layerTypes": ["layerRoadmap"], "language": "en-US",
            "region": "US", "scale": "scaleFactor2x", "highDpi": true
        ], options: [.sortedKeys])
        let digest = Insecure.MD5.hash(data: body).map { String(format: "%02x", $0) }.joined()
        XCTAssertEqual(initial.requestFingerprint, digest)
        XCTAssertEqual(defaults.data(forKey: "GoogleMapURLProtocol.session." + digest), payload)
        let satellite = try fetch(manager, mapType: .satellite)
        XCTAssertNotEqual(initial.requestFingerprint, satellite.requestFingerprint)
        XCTAssertEqual(requests, 2)
    }

    @objc func testConcurrentCreationAndLateRejection() throws {
        var requests = 0
        MockGoogleTransport.handler = { request in
            requests += 1
            request.respond(data: self.sessionData())
        }
        let completed = expectation(description: "coalesced sessions")
        completed.expectedFulfillmentCount = 12
        var sessions: [GoogleMapSessionManager.SessionContext] = []
        for _ in 0..<12 {
            manager.sessionContext(for: .roadmap) { result in
                if case .success(let context) = result { sessions.append(context) }
                completed.fulfill()
            }
        }
        wait(for: [completed], timeout: 3)
        XCTAssertEqual(requests, 1)
        XCTAssertEqual(sessions.count, 12)
        XCTAssertEqual(Set(sessions.map(\.sessionToken)).count, 1)
        let old = try XCTUnwrap(sessions.first)
        let replacement = try fetch(manager, replacing: old)
        XCTAssertNotEqual(replacement.sessionToken, old.sessionToken)
        XCTAssertEqual(try fetch(manager, replacing: old).sessionToken, replacement.sessionToken)
        XCTAssertEqual(requests, 2)
    }

    @objc func testExpiredResponseIsNotPersisted() {
        var requests = 0
        MockGoogleTransport.handler = { request in
            requests += 1
            request.respond(data: self.sessionData(expiration: -10))
        }
        XCTAssertThrowsError(try fetch(manager))
        XCTAssertThrowsError(try fetch(manager))
        XCTAssertEqual(requests, 2)
        XCTAssertTrue(defaults.dictionaryRepresentation().keys.filter { $0.hasPrefix("GoogleMapURLProtocol.session.") }.isEmpty)
    }

    @objc func testRoutingAndCanonicalIdentity() {
        for path in ["/v1/2dtiles/18/1/2", "/tile/v1/viewport"] {
            let request = URLRequest(url: URL(string: "https://tile.googleapis.com" + path + "?mapType=roadmap")!)
            XCTAssertTrue(GoogleMapURLProtocol.canInit(with: request))
            let canonical = GoogleMapURLProtocol.canonicalRequest(for: request)
            XCTAssertEqual(GoogleMapURLProtocol.canonicalRequest(for: canonical), canonical)
            let mutable = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
            URLProtocol.setProperty(true, forKey: "GoogleMapURLProtocolHandledKey", in: mutable)
            XCTAssertFalse(GoogleMapURLProtocol.canInit(with: mutable as URLRequest))
        }
        for url in ["https://tile.googleapis.com/v1/createSession", "https://tile.googleapis.com/other/v1/2dtiles/1",
                    "https://example.org/v1/2dtiles/1", "http://tile.googleapis.com/tile/v1/viewport"] {
            XCTAssertFalse(GoogleMapURLProtocol.canInit(with: URLRequest(url: URL(string: url)!)))
        }
    }

    private func verifyForwarding(path: String, finalStatus: Int) throws {
        var creations = 0
        var resources = 0
        var forwardedSessions: [String] = []
        let expiredHeader = "Thu, 01 Jan 1970 00:00:00 GMT"
        MockGoogleTransport.handler = { request in
            if request.request.url?.path == "/v1/createSession" {
                creations += 1
                request.respond(data: self.sessionData())
                return
            }
            resources += 1
            XCTAssertFalse(GoogleMapURLProtocol.canInit(with: request.request))
            let items = URLComponents(url: request.request.url!, resolvingAgainstBaseURL: false)!.queryItems!
            XCTAssertEqual(items.filter { $0.name == "key" }.map(\.value), [self.generatedKey])
            XCTAssertEqual(items.filter { $0.name == "session" }.count, 1)
            XCTAssertFalse(items.contains { $0.name == "mapType" || $0.name.hasPrefix("_mapxus") })
            forwardedSessions.append(items.first { $0.name == "session" }!.value!)
            request.respond(status: resources == 1 ? 403 : finalStatus,
                            headers: ["Cache-Control": "max-age=86400", "Expires": expiredHeader, "ETag": "test-version"])
        }
        let client = RecordingClient(expectation(description: "resource response"))
        let request = GoogleMapURLProtocol.canonicalRequest(for: URLRequest(url: URL(string:
            "https://tile.googleapis.com" + path + "?mapType=roadmap&zoom=18")!))
        let interceptor = GoogleMapURLProtocol(request: request, cachedResponse: nil, client: client,
                                               sessionManager: manager, forwardingSession: transport)
        interceptor.startLoading()
        wait(for: [client.finished], timeout: 3)
        XCTAssertNil(client.error)
        XCTAssertEqual(client.response?.statusCode, finalStatus)
        XCTAssertEqual(creations, 2)
        XCTAssertEqual(resources, 2)
        XCTAssertEqual(Set(forwardedSessions).count, 2)
        XCTAssertEqual(client.response?.value(forHTTPHeaderField: "ETag"), "test-version")
        if path == "/tile/v1/viewport" {
            XCTAssertEqual(client.response?.value(forHTTPHeaderField: "Expires"), expiredHeader)
            XCTAssertNotNil(client.response?.value(forHTTPHeaderField: GoogleMapURLProtocol.sessionRevisionHeader))
            XCTAssertEqual(client.policy, .notAllowed)
        } else {
            XCTAssertNil(client.response?.value(forHTTPHeaderField: "Expires"))
            XCTAssertEqual(client.policy, .allowed)
        }
    }

    @objc func testViewportAuthenticationRetryAndHeaders() throws {
        try verifyForwarding(path: "/tile/v1/viewport", finalStatus: 200)
    }

    @objc func testTileAuthenticationRetryAndHeaders() throws {
        try verifyForwarding(path: "/v1/2dtiles/18/1/2", finalStatus: 200)
    }

    @objc func testAuthenticationRetryStopsAfterOneRefresh() throws {
        try verifyForwarding(path: "/tile/v1/viewport", finalStatus: 403)
    }

    @objc func testCancellationWhileAwaitingSession() {
        let started = expectation(description: "create started")
        var pending: MockGoogleTransport?
        MockGoogleTransport.handler = { request in
            pending = request
            started.fulfill()
        }
        let client = RecordingClient(expectation(description: "no callback after cancellation"))
        client.finished.isInverted = true
        let request = URLRequest(url: URL(string: "https://tile.googleapis.com/tile/v1/viewport?mapType=roadmap")!)
        let interceptor = GoogleMapURLProtocol(request: request, cachedResponse: nil, client: client,
                                               sessionManager: manager, forwardingSession: transport)
        interceptor.startLoading()
        wait(for: [started], timeout: 3)
        interceptor.stopLoading()
        pending?.respond(data: sessionData())
        wait(for: [client.finished], timeout: 0.2)
        XCTAssertEqual(client.callbackCount, 0)
    }
}

@main
private enum GoogleMapNetworkingTestRunner {
    static func main() {
        let suite = GoogleMapNetworkingTests.defaultTestSuite
        suite.run()
        guard let result = suite.testRun, result.executionCount == 8, result.hasSucceeded else { exit(1) }
    }
}
#endif