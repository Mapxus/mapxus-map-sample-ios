//
//  SceneChangedEventListeningViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/17.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "SceneChangedEventListeningViewController.h"
#import "Macro.h"

@interface SceneChangedEventListeningViewController () <MGLMapViewDelegate, MapxusMapDelegate>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapxusMap;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *buildingNameLabel;
@property (nonatomic, strong) UILabel *floorNameLabel;
@end

@implementation SceneChangedEventListeningViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.view.backgroundColor = [UIColor whiteColor];
  [self layoutUI];
  MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
  configuration.defaultStyle = MXMStyleMAPXUS;
  self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
  self.mapxusMap.delegate = self;
}

- (void)layoutUI {
  [self.view addSubview:self.boxView];
  [self.boxView addSubview:self.buildingNameLabel];
  [self.boxView addSubview:self.floorNameLabel];
  [self.view addSubview:self.mapView];
  
  [self.boxView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
  [self.boxView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
  [self.boxView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
  
  [self.buildingNameLabel.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:moduleSpace].active = YES;
  [self.buildingNameLabel.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.buildingNameLabel.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.floorNameLabel.topAnchor constraintEqualToAnchor:self.buildingNameLabel.bottomAnchor constant:innerSpace].active = YES;
  [self.floorNameLabel.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.floorNameLabel.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.floorNameLabel.bottomAnchor constraintEqualToAnchor:self.boxView.bottomAnchor constant:-moduleSpace].active = YES;
  
  [self.mapView.topAnchor constraintEqualToAnchor:self.boxView.bottomAnchor].active = YES;
  [self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
  [self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
  [self.mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
}

#pragma mark - MapxusMapDelegate
- (void)map:(MapxusMap *)map didChangeSelectedFloor:(MXMFloor *)floor inSelectedBuildingId:(NSString *)buildingId atSelectedVenueId:(NSString *)venueId
{
  MXMGeoBuilding *building = buildingId ? map.buildings[buildingId] : nil;
  self.buildingNameLabel.text = [NSString stringWithFormat:@"BuildingName:%@", building.name];
  self.floorNameLabel.text = [NSString stringWithFormat:@"Floor:%@", floor.code];  
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

- (UILabel *)buildingNameLabel {
  if (!_buildingNameLabel) {
    _buildingNameLabel = [[UILabel alloc] init];
    _buildingNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _buildingNameLabel;
}

- (UILabel *)floorNameLabel {
  if (!_floorNameLabel) {
    _floorNameLabel = [[UILabel alloc] init];
    _floorNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _floorNameLabel;
}

@end
