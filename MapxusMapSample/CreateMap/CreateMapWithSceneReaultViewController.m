//
//  CreateMapWithSceneReaultViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/16.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "CreateMapWithSceneReaultViewController.h"

@interface CreateMapWithSceneReaultViewController () <MGLMapViewDelegate>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapxusMap;
@end

@implementation CreateMapWithSceneReaultViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self layoutUI];
  
  // Create the MXMConfiguration instance
  MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
  configuration.floorId = self.floorId;
  configuration.sharedFloorId = self.sharedFloorId;
  configuration.buildingId = self.buildingId;
  configuration.venueId = self.venueId;
  configuration.zoomInsets = self.zoomInsets;
  configuration.defaultStyle = MXMStyleMAPXUS;
  // Create MapxusMap with MGLMapView instance and MXMConfiguration instance
  self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
}

- (void)layoutUI {
  [self.view addSubview:self.mapView];
  [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
  [self.mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
  [self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
  [self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
}

#pragma mark - Lazy loading
- (MGLMapView *)mapView {
  if (!_mapView) {
    _mapView = [[MGLMapView alloc] init];
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    _mapView.delegate = self;
  }
  return _mapView;
}



@end
