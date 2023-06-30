//
//  IndoorSceneInAndOutListeningViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/17.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "IndoorSceneInAndOutListeningViewController.h"
#import "Macro.h"

@interface IndoorSceneInAndOutListeningViewController () <MGLMapViewDelegate, MapxusMapDelegate>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapxusMap;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *statuLabel;
@end

@implementation IndoorSceneInAndOutListeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];
    MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
    configuration.defaultStyle = MXMStyleMAPXUS;
    self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
    self.mapxusMap.delegate = self;
}

- (void)layoutUI {
    [self.view addSubview:self.boxView];
    [self.boxView addSubview:self.statuLabel];
    [self.view addSubview:self.mapView];
    
    [self.boxView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.boxView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.boxView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    
    [self.statuLabel.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:moduleSpace].active = YES;
    [self.statuLabel.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.statuLabel.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    [self.statuLabel.bottomAnchor constraintEqualToAnchor:self.boxView.bottomAnchor constant:-moduleSpace].active = YES;
    
    [self.mapView.topAnchor constraintEqualToAnchor:self.boxView.bottomAnchor].active = YES;
    [self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
}

#pragma mark - MapxusMapDelegate
- (void)map:(MapxusMap *)map
    didChangeIndoorSiteAccess:(BOOL)flag
    selectedFloor:(MXMFloor *)floor
    selectedBuilding:(MXMGeoBuilding *)building
    selectedVenue:(MXMGeoVenue *)venue
{
    self.statuLabel.text = flag ? @"Indoor now" : @"Outdoor now";
}

#pragma mark - Lazy loading
- (MGLMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MGLMapView alloc] init];
        _mapView.translatesAutoresizingMaskIntoConstraints = NO;
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(PARAMCONFIGINFO.center_latitude, PARAMCONFIGINFO.center_longitude);
        _mapView.zoomLevel = 18;
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

- (UILabel *)statuLabel {
    if (!_statuLabel) {
        _statuLabel = [[UILabel alloc] init];
        _statuLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _statuLabel;
}

@end
