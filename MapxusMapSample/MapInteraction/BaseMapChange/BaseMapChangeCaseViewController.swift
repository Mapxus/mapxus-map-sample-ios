//
//  BaseMapChangeCaseViewController.swift
//  MapxusMapSample
//
//  Created by guochenghao on 2026/8/18.
//  Copyright © 2026 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import UIKit
import Mapbox
import MapxusMapSDK

final class BaseMapChangeCaseViewController: UIViewController, MGLMapViewDelegate {
    
    private enum Constants {
        static let defaultCoordinate = CLLocationCoordinate2D(
            latitude: ParamConfigInstance.shared().info.center_latitude,
            longitude: ParamConfigInstance.shared().info.center_longitude
        )
        static let singaporeCoordinate = CLLocationCoordinate2D(
            latitude: ParamConfigInstance.shared().info.singapore_center_latitude,
            longitude: ParamConfigInstance.shared().info.singapore_center_longitude
        )
        static let defaultZoomLevel: Double = 18
        static let selectorHeight: CGFloat = 44
        static let selectorOuterInset: CGFloat = 12
        static let selectorVerticalInset: CGFloat = 6
        static let selectorHorizontalInset: CGFloat = 8
        static let selectorCornerRadius: CGFloat = 12
        static let buttonMinWidth: CGFloat = 72
        static let buttonCornerRadius: CGFloat = 8
        static let buttonSpacing: CGFloat = 8
    }
    
    private struct StyleOption {
        let title: String
        let resourceName: String
        let centerCoordinate: CLLocationCoordinate2D?
    }
    
    private var mapView: MGLMapView!
    private var mapxusMap: MapxusMap!
    private let styleSelectorScrollView = UIScrollView()
    private let styleSelectorStackView = UIStackView()
    private var styleButtons: [UIButton] = []
    private var selectedStyleIndex = 1
    private let styleOptions: [StyleOption] = [
        StyleOption(title: "Google", resourceName: "mapxus_v8_googlemap", centerCoordinate: Constants.defaultCoordinate),
        StyleOption(title: "LandsD", resourceName: "mapxus_v8_landsd", centerCoordinate: Constants.defaultCoordinate),
        StyleOption(title: "Mapbox", resourceName: "mapxus_v8_mapbox", centerCoordinate: Constants.defaultCoordinate),
        StyleOption(title: "OneMap", resourceName: "mapxus_v8_onemap", centerCoordinate: Constants.singaporeCoordinate),
        StyleOption(title: "OSM", resourceName: "mapxus_v8", centerCoordinate: Constants.defaultCoordinate)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupMapView()
        setupLayout()
        setupMapxusMap()
        applyStyle(at: selectedStyleIndex)
    }
    
    private func setupMapView() {
        mapView = MGLMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.centerCoordinate = Constants.defaultCoordinate
        mapView.zoomLevel = Constants.defaultZoomLevel
        // Regardless of whether the callback method of MGLMapViewDelegate is implemented or not, the delegate must be set.
        mapView.delegate = self
    }
    
    private func setupMapxusMap() {
        let configuration = MXMConfiguration()
        mapxusMap = MapxusMap(mapView: mapView, configuration: configuration)
    }
    
    private func setupLayout() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        setupStyleSelector()
    }
    
    private func setupStyleSelector() {
        styleSelectorScrollView.translatesAutoresizingMaskIntoConstraints = false
        styleSelectorScrollView.showsHorizontalScrollIndicator = false
        styleSelectorScrollView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        styleSelectorScrollView.layer.cornerRadius = Constants.selectorCornerRadius
        styleSelectorScrollView.layer.masksToBounds = true
        
        styleSelectorStackView.translatesAutoresizingMaskIntoConstraints = false
        styleSelectorStackView.axis = .horizontal
        styleSelectorStackView.spacing = Constants.buttonSpacing
        styleSelectorStackView.alignment = .fill
        styleSelectorStackView.distribution = .fill
        
        view.addSubview(styleSelectorScrollView)
        styleSelectorScrollView.addSubview(styleSelectorStackView)
        
        NSLayoutConstraint.activate([
            styleSelectorScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.selectorOuterInset),
            styleSelectorScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.selectorOuterInset),
            styleSelectorScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.selectorOuterInset),
            styleSelectorScrollView.heightAnchor.constraint(equalToConstant: Constants.selectorHeight),
            
            styleSelectorStackView.topAnchor.constraint(equalTo: styleSelectorScrollView.contentLayoutGuide.topAnchor, constant: Constants.selectorVerticalInset),
            styleSelectorStackView.bottomAnchor.constraint(equalTo: styleSelectorScrollView.contentLayoutGuide.bottomAnchor, constant: -Constants.selectorVerticalInset),
            styleSelectorStackView.leadingAnchor.constraint(equalTo: styleSelectorScrollView.contentLayoutGuide.leadingAnchor, constant: Constants.selectorHorizontalInset),
            styleSelectorStackView.trailingAnchor.constraint(equalTo: styleSelectorScrollView.contentLayoutGuide.trailingAnchor, constant: -Constants.selectorHorizontalInset),
            styleSelectorStackView.heightAnchor.constraint(equalTo: styleSelectorScrollView.frameLayoutGuide.heightAnchor, constant: -(Constants.selectorVerticalInset * 2))
        ])
        
        styleButtons = styleOptions.enumerated().map { index, option in
            makeStyleButton(title: option.title, tag: index)
        }
        updateStyleButtons()
    }
    
    private func makeStyleButton(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.tag = tag
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.layer.masksToBounds = true
        button.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.buttonMinWidth).isActive = true
        button.addTarget(self, action: #selector(styleButtonTapped(_:)), for: .touchUpInside)
        styleSelectorStackView.addArrangedSubview(button)
        return button
    }
    
    private func applyStyle(at index: Int) {
        guard styleOptions.indices.contains(index) else { return }
        
        let option = styleOptions[index]
        selectedStyleIndex = index
        mapxusMap.setMapStyleWithName(option.resourceName)
        if let centerCoordinate = option.centerCoordinate {
            mapView.setCenter(centerCoordinate, animated: true)
        }
        updateStyleButtons()
    }
    
    private func updateStyleButtons() {
        for (index, button) in styleButtons.enumerated() {
            let isSelected = index == selectedStyleIndex
            button.backgroundColor = isSelected ? view.tintColor : UIColor.systemGray5
            button.setTitleColor(isSelected ? .white : .label, for: .normal)
        }
    }
    
    @objc private func styleButtonTapped(_ sender: UIButton) {
        applyStyle(at: sender.tag)
    }
}
