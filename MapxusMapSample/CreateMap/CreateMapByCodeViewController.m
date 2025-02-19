//
//  CreateMapByCodeViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/16.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "CreateMapByCodeViewController.h"
#import "ParamConfigInstance.h"

@interface CreateMapByCodeViewController () <MGLMapViewDelegate>
@property (nonatomic, strong) MGLMapView *mapView; // Render map using MGLMapView
@property (nonatomic, strong) MapxusMap *mapxusMap; // MapxusMap control and listen of the indoor map.
@end

@implementation CreateMapByCodeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self layoutUI];
  // Create MapxusMap instance with MGLMapView instance
  MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
  configuration.defaultStyle = MXMStyleMAPXUS;
  self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
  self.mapxusMap.mapxusLogoEnabled = NO;
}

- (void)layoutUI {
  [self.view addSubview:self.mapView];
  [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
  [self.mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
  [self.mapView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
  [self.mapView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
}

#pragma mark - Lazy loading
- (MGLMapView *)mapView {
  if (!_mapView) {
    _mapView = [[MGLMapView alloc] init];
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(PARAMCONFIGINFO.center_latitude, PARAMCONFIGINFO.center_longitude);
    _mapView.zoomLevel = 18;
    // Regardless of whether the callback method of MGLMapViewDelegate is implemented or not, the delegate must be set.
    _mapView.delegate = self;
  }
  return _mapView;
}

@end
