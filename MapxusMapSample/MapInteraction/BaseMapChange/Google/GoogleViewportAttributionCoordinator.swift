//
//  GoogleViewportAttributionCoordinator.swift
//  MapxusMapSample
//
//  Created by guochenghao on 2026/9/17.
//  Copyright © 2026 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import Mapbox
import MapxusMapSDK

final class GoogleViewportAttributionCoordinator {
    // MARK: - Request Models

    private struct Fingerprint: Equatable {
        let north: Double
        let south: Double
        let east: Double
        let west: Double
        let zoom: Int
        let styleGeneration: UInt64
    }

    private enum Constants {
        static let viewportURL = "https://tile.googleapis.com/tile/v1/viewport"
        static let debounceDelay: TimeInterval = 0.2
        static let staleLifetime: TimeInterval = 5
        static let requestTimeout: TimeInterval = 5
        static let maximumAttempts = 3
    }

    // MARK: - Dependencies and State

    private weak var mapView: MGLMapView?
    private weak var mapxusMap: MapxusMap?
    private var mapType: GoogleMapURLProtocol.MapType?
    private var attachmentGeneration: UInt64 = 0
    private var styleGeneration: UInt64 = 0
    private var refreshSequence: UInt64 = 0
    private var requestSequence: UInt64 = 0
    private var latestTileZoom: Int?
    private var latestSessionRevision: UInt64?
    private var lastFingerprint: Fingerprint?
    private var hasAttribution = false
    private var debounceWorkItem: DispatchWorkItem?
    private var staleWorkItem: DispatchWorkItem?
    private var requestTask: URLSessionDataTask?
    private var sessionObserver: UUID?
    private var tileObserver: UUID?
    private var foregroundObserver: NSObjectProtocol?
    private let viewportSession: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [GoogleMapURLProtocol.self]
        return URLSession(configuration: configuration)
    }()

    deinit {
        viewportSession.invalidateAndCancel()
    }

    // MARK: - Lifecycle

    func attach(mapView: MGLMapView, mapxusMap: MapxusMap, mapType: GoogleMapURLProtocol.MapType?) {
        stop(clearAttribution: true)
        self.mapView = mapView
        self.mapxusMap = mapxusMap
        self.mapType = mapType
        guard let mapType else { return }
        latestTileZoom = Int(mapView.zoomLevel.rounded(.down))
        let attachmentGeneration = self.attachmentGeneration

        sessionObserver = GoogleMapURLProtocol.addSessionObserver { [weak self] context in
            guard let self,
                  self.attachmentGeneration == attachmentGeneration,
                  context.mapType == mapType else { return }
            self.handleSessionChange(context)
        }
        tileObserver = GoogleMapURLProtocol.addTileObserver { [weak self] context in
            guard let self,
                  self.attachmentGeneration == attachmentGeneration,
                  context.mapType == mapType else { return }
            self.latestTileZoom = context.zoom
            self.scheduleRefresh()
        }
        foregroundObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self, self.attachmentGeneration == attachmentGeneration else { return }
            self.scheduleRefresh()
        }
        scheduleRefresh()
    }

    func styleDidLoad() {
        guard mapType != nil else { return }
        styleGeneration &+= 1
        lastFingerprint = nil
        clearAttribution()
        scheduleRefresh()
    }

    func viewportDidChange() {
        scheduleRefresh()
    }

    func stop(clearAttribution: Bool) {
        attachmentGeneration &+= 1
        refreshSequence &+= 1
        requestSequence &+= 1
        cancelPendingWork()
        removeObservers()
        lastFingerprint = nil
        latestSessionRevision = nil
        latestTileZoom = nil
        if clearAttribution {
            self.clearAttribution()
        }
        mapType = nil
        mapView = nil
        mapxusMap = nil
    }

    private func cancelPendingWork() {
        debounceWorkItem?.cancel()
        staleWorkItem?.cancel()
        requestTask?.cancel()
        debounceWorkItem = nil
        staleWorkItem = nil
        requestTask = nil
    }

    private func removeObservers() {
        if let sessionObserver {
            GoogleMapURLProtocol.removeSessionObserver(sessionObserver)
        }
        if let tileObserver {
            GoogleMapURLProtocol.removeTileObserver(tileObserver)
        }
        if let foregroundObserver {
            NotificationCenter.default.removeObserver(foregroundObserver)
        }
        sessionObserver = nil
        tileObserver = nil
        foregroundObserver = nil
    }

    // MARK: - Refresh Scheduling

    private func handleSessionChange(_ context: GoogleMapURLProtocol.SessionChange) {
        guard latestSessionRevision != context.revision else { return }
        latestSessionRevision = context.revision
        clearAttribution()
        guard requestTask == nil else { return }
        lastFingerprint = nil
        scheduleRefresh()
    }

    private func scheduleRefresh() {
        guard mapType != nil, mapView != nil, latestTileZoom != nil else { return }
        debounceWorkItem?.cancel()
        refreshSequence &+= 1
        let sequence = refreshSequence
        let workItem = DispatchWorkItem { [weak self] in
            self?.beginRequest(sequence: sequence)
        }
        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.debounceDelay, execute: workItem)
    }

    private func beginRequest(sequence: UInt64) {
        guard sequence == refreshSequence,
              mapType != nil,
              let mapView,
              let zoom = latestTileZoom else { return }
        let bounds = mapView.visibleCoordinateBounds
        guard let coordinates = validatedCoordinates(bounds) else {
            clearAttribution()
            return
        }
        let fingerprint = Fingerprint(
            north: coordinates.north,
            south: coordinates.south,
            east: coordinates.east,
            west: coordinates.west,
            zoom: zoom,
            styleGeneration: styleGeneration
        )
        guard fingerprint != lastFingerprint else { return }
        requestTask?.cancel()
        requestTask = nil
        requestSequence &+= 1
        markCurrentAttributionStale()
        lastFingerprint = fingerprint
        performRequest(fingerprint: fingerprint, sequence: requestSequence, attempt: 1)
    }

    // MARK: - Viewport Request

    private func performRequest(
        fingerprint: Fingerprint,
        sequence: UInt64,
        attempt: Int
    ) {
        guard sequence == requestSequence,
              isCurrent(fingerprint),
              let request = makeRequest(fingerprint: fingerprint) else {
            finishFailure()
            return
        }

        requestTask = viewportSession.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.handleResponse(
                    data: data,
                    response: response,
                    error: error,
                    fingerprint: fingerprint,
                    sequence: sequence,
                    attempt: attempt
                )
            }
        }
        requestTask?.resume()
    }

    private func handleResponse(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        fingerprint: Fingerprint,
        sequence: UInt64,
        attempt: Int
    ) {
        guard sequence == requestSequence else { return }
        guard isCurrent(fingerprint) else {
            rescheduleForCurrentViewport()
            return
        }

        let statusCode = (response as? HTTPURLResponse)?.statusCode
        guard error == nil, (200...299).contains(statusCode ?? -1) else {
            handleFailure(
                error: error,
                statusCode: statusCode,
                fingerprint: fingerprint,
                sequence: sequence,
                attempt: attempt
            )
            return
        }

        applySuccessfulResponse(data: data, response: response, fingerprint: fingerprint)
    }

    private func handleFailure(
        error: Error?,
        statusCode: Int?,
        fingerprint: Fingerprint,
        sequence: UInt64,
        attempt: Int
    ) {
        guard isTransient(error: error, statusCode: statusCode),
              attempt < Constants.maximumAttempts else {
            finishFailure()
            return
        }

        let delay = 0.5 * Double(attempt)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self, sequence == self.requestSequence else { return }
            guard self.isCurrent(fingerprint) else {
                self.rescheduleForCurrentViewport()
                return
            }
            self.performRequest(fingerprint: fingerprint, sequence: sequence, attempt: attempt + 1)
        }
    }

    private func applySuccessfulResponse(data: Data?, response: URLResponse?, fingerprint: Fingerprint) {
        requestTask = nil
        let responseRevision = (response as? HTTPURLResponse)?
            .value(forHTTPHeaderField: GoogleMapURLProtocol.sessionRevisionHeader)
            .flatMap(UInt64.init)
        guard let responseRevision,
              responseRevision >= (latestSessionRevision ?? 0) else {
            rescheduleForCurrentViewport()
            return
        }
        latestSessionRevision = responseRevision

        guard let data,
              let response = try? JSONDecoder().decode(ViewportResponse.self, from: data),
              !response.copyright.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            finishFailure()
            return
        }

        applyAttribution(response.copyright)
        staleWorkItem?.cancel()
        staleWorkItem = nil
        hasAttribution = true
        lastFingerprint = fingerprint
    }

    private func isTransient(error: Error?, statusCode: Int?) -> Bool {
        if let error = error as NSError?,
           error.domain == NSURLErrorDomain,
           error.code != NSURLErrorCancelled {
            return true
        }
        guard let statusCode else { return false }
        return statusCode == 408 || statusCode == 429 || (500...599).contains(statusCode)
    }

    private func rescheduleForCurrentViewport() {
        requestTask = nil
        lastFingerprint = nil
        scheduleRefresh()
    }

    private struct ViewportResponse: Decodable {
        let copyright: String
    }

    private func makeRequest(fingerprint: Fingerprint) -> URLRequest? {
        guard let mapType, var components = URLComponents(string: Constants.viewportURL) else { return nil }
        components.queryItems = [
            URLQueryItem(name: "mapType", value: mapType.rawValue),
            URLQueryItem(name: "zoom", value: String(fingerprint.zoom)),
            URLQueryItem(name: "north", value: String(fingerprint.north)),
            URLQueryItem(name: "south", value: String(fingerprint.south)),
            URLQueryItem(name: "east", value: String(fingerprint.east)),
            URLQueryItem(name: "west", value: String(fingerprint.west))
        ]
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url)
        request.timeoutInterval = Constants.requestTimeout
        return GoogleMapURLProtocol.canonicalRequest(for: request)
    }

    // MARK: - Viewport Validation

    private func validatedCoordinates(_ bounds: MGLCoordinateBounds) -> (north: Double, south: Double, east: Double, west: Double)? {
        let north = bounds.ne.latitude
        let south = bounds.sw.latitude
        let east = normalizedLongitude(bounds.ne.longitude)
        let west = normalizedLongitude(bounds.sw.longitude)
        guard north.isFinite, south.isFinite, east.isFinite, west.isFinite,
              (-90...90).contains(north), (-90...90).contains(south), north >= south else { return nil }
        return (north, south, east, west)
    }

    private func normalizedLongitude(_ longitude: Double) -> Double {
        guard longitude.isFinite else { return longitude }
        var normalized = longitude.truncatingRemainder(dividingBy: 360)
        if normalized > 180 { normalized -= 360 }
        if normalized < -180 { normalized += 360 }
        return normalized
    }

    private func isCurrent(_ fingerprint: Fingerprint) -> Bool {
        guard fingerprint.styleGeneration == styleGeneration,
              latestTileZoom == fingerprint.zoom,
              let mapView,
              let coordinates = validatedCoordinates(mapView.visibleCoordinateBounds),
              coordinates.north == fingerprint.north,
              coordinates.south == fingerprint.south,
              coordinates.east == fingerprint.east,
              coordinates.west == fingerprint.west else { return false }
        return true
    }

    // MARK: - Attribution

    private func applyAttribution(_ text: String) {
        guard let mapxusMap else { return }
        let selector = NSSelectorFromString("updateDynamicAttributionInfos:")
        guard mapxusMap.responds(to: selector) else { return }
        let info = MGLAttributionInfo(title: NSAttributedString(string: text), url: nil)
        mapxusMap.perform(selector, with: [info])
    }

    private func clearAttribution() {
        hasAttribution = false
        guard let mapxusMap else { return }
        let selector = NSSelectorFromString("clearDynamicAttributionInfos")
        guard mapxusMap.responds(to: selector) else { return }
        mapxusMap.perform(selector)
    }

    private func finishFailure() {
        requestTask = nil
        lastFingerprint = nil
        if !hasAttribution {
            clearAttribution()
        }
    }

    private func markCurrentAttributionStale() {
        guard hasAttribution, staleWorkItem == nil else { return }
        let staleWorkItem = DispatchWorkItem { [weak self] in
            self?.clearAttribution()
            self?.staleWorkItem = nil
        }
        self.staleWorkItem = staleWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.staleLifetime, execute: staleWorkItem)
    }
}
