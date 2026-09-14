//
//  MapViewNetworkProtocolConfigurator.swift
//  MapxusMapSample
//
//  Created by guochenghao on 2026/9/10.
//  Copyright © 2026 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import UIKit
import Mapbox

@objc(MapViewNetworkProtocolConfigurator)
final class MapViewNetworkProtocolConfigurator: NSObject {
    private static var isConfigured = false
    
    /// Must be called at app launch, before any `MGLMapView` is created; later calls have no effect on already-created sessions.
    @objc static func configureIfNeeded() {
        guard !isConfigured else { return }
        isConfigured = true
        
        let networkConfiguration = MGLNetworkConfiguration.sharedManager
        let sessionConfiguration = networkConfiguration.sessionConfiguration ?? .default
        let customProtocolClasses: [AnyClass] = [
            GoogleMapURLProtocol.self,
            MapboxURLProtocol.self
        ]
        let existingProtocolClasses = sessionConfiguration.protocolClasses ?? []
        let remainingProtocolClasses = existingProtocolClasses.filter { existingClass in
            !customProtocolClasses.contains(where: { $0 == existingClass })
        }
        
        sessionConfiguration.protocolClasses = customProtocolClasses + remainingProtocolClasses
        networkConfiguration.sessionConfiguration = sessionConfiguration
    }
}
