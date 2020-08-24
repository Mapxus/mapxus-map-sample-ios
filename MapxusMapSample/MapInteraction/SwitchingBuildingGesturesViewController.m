//
//  SwitchingBuildingGesturesViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/17.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "SwitchingBuildingGesturesViewController.h"
#import "Macro.h"

@interface SwitchingBuildingGesturesViewController () <MGLMapViewDelegate>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapPlugin;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UISwitch *autoSwitch;
@property (nonatomic, strong) UILabel *autoTip;
@property (nonatomic, strong) UISwitch *gestureSwitch;
@property (nonatomic, strong) UILabel *gestureTip;
@end

@implementation SwitchingBuildingGesturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];
    self.mapPlugin = [[MapxusMap alloc] initWithMapView:self.mapView];
}

- (void)changeAutoSwitch:(UISwitch *)sender {
    if (sender.isOn == YES) {
        // When the center of the map changes, the building in the center of the map is automatically selected.
        self.mapPlugin.autoChangeBuilding = YES;
    } else {
        // Does not automatically switch the selected building when the map center is changed.
        self.mapPlugin.autoChangeBuilding = NO;
    }
}

- (void)changeGestureSwitch:(UISwitch *)sender {
    if (sender.isOn == YES) {
        // Support for users to select buildings by clicking on the map
        self.mapPlugin.gestureSwitchingBuilding = YES;
    } else {
        // User click on the map to select a building is not supported
        self.mapPlugin.gestureSwitchingBuilding = NO;
    }
}

- (void)layoutUI {
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.boxView];
    [self.boxView addSubview:self.autoSwitch];
    [self.boxView addSubview:self.autoTip];
    [self.boxView addSubview:self.gestureSwitch];
    [self.boxView addSubview:self.gestureTip];
    
    [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.mapView.bottomAnchor constraintEqualToAnchor:self.boxView.topAnchor].active = YES;
    
    [self.boxView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.boxView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.boxView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    if (@available(iOS 11.0, *)) {
        [self.boxView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-70].active = YES;
    } else {
        // Fallback on earlier versions
        [self.boxView.topAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-70].active = YES;
    }
    
    [self.autoSwitch.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:moduleSpace].active = YES;
    [self.autoSwitch.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    
    [self.autoTip.leadingAnchor constraintEqualToAnchor:self.autoSwitch.trailingAnchor constant:innerSpace].active = YES;
    [self.autoTip.centerYAnchor constraintEqualToAnchor:self.autoSwitch.centerYAnchor].active = YES;
    
    [self.gestureSwitch.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:moduleSpace].active = YES;
    [self.gestureSwitch.leadingAnchor constraintEqualToAnchor:self.boxView.centerXAnchor constant:10].active = YES;
    
    [self.gestureTip.leadingAnchor constraintEqualToAnchor:self.gestureSwitch.trailingAnchor constant:innerSpace].active = YES;
    [self.gestureTip.centerYAnchor constraintEqualToAnchor:self.gestureSwitch.centerYAnchor].active = YES;
}

#pragma mark - Lazy loading
- (MGLMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MGLMapView alloc] init];
        _mapView.translatesAutoresizingMaskIntoConstraints = NO;
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(22.370587, 114.111375);
        _mapView.zoomLevel = 17;
        _mapView.delegate = self;
    }
    return _mapView;
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _boxView;
}

- (UISwitch *)autoSwitch {
    if (!_autoSwitch) {
        _autoSwitch = [[UISwitch alloc] init];
        _autoSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        _autoSwitch.on = YES;
        [_autoSwitch addTarget:self action:@selector(changeAutoSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    return _autoSwitch;
}

- (UILabel *)autoTip {
    if (!_autoTip) {
        _autoTip = [[UILabel alloc] init];
        _autoTip.translatesAutoresizingMaskIntoConstraints = NO;
        _autoTip.text = @"auto switch";
    }
    return _autoTip;
}

- (UISwitch *)gestureSwitch {
    if (!_gestureSwitch) {
        _gestureSwitch = [[UISwitch alloc] init];
        _gestureSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        _gestureSwitch.on = YES;
        [_gestureSwitch addTarget:self action:@selector(changeGestureSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    return _gestureSwitch;
}

- (UILabel *)gestureTip {
    if (!_gestureTip) {
        _gestureTip = [[UILabel alloc] init];
        _gestureTip.translatesAutoresizingMaskIntoConstraints = NO;
        _gestureTip.text = @"gesture switch";
    }
    return _gestureTip;
}

@end
