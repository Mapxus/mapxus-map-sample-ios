//
//  MXMPrimaryContentViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/28.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMPrimaryContentViewController.h"
#import "ParamConfigInstance.h"

@interface MXMPrimaryContentViewController () <MGLMapViewDelegate, MapxusMapDelegate>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapxusMap;
@end

@implementation MXMPrimaryContentViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self layoutUI];
  
  MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
  configuration.floorId = PARAMCONFIGINFO.floorId_1;
  configuration.defaultStyle = MXMStyleMAPXUS;
  self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
  self.mapxusMap.selectorPosition = MXMSelectorPositionTopRight;
  self.mapxusMap.delegate = self;
}

- (void)layoutUI {
  [self.view addSubview:self.mapView];
  
  [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
  [self.mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
  [self.mapView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
  [self.mapView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
}

- (void)setCameraCenter:(CLLocationCoordinate2D)center zoomLevel:(double)level animated:(BOOL)animated {
  MGLMapCamera *oldCamera = self.mapView.camera;
  CLLocationDistance altitube = MGLAltitudeForZoomLevel(level, oldCamera.pitch, center.latitude, self.mapView.frame.size);
  MGLMapCamera *newCamera = [MGLMapCamera cameraLookingAtCenterCoordinate:center fromEyeCoordinate:center eyeAltitude:altitube];
  newCamera.heading = oldCamera.heading;
  [self.mapView setCamera:newCamera];
}

- (void)moveToPOICenter:(CLLocationCoordinate2D)center floorId:(NSString *)floorId {
  [self setCameraCenter:center zoomLevel:18 animated:YES];
  [self.mapxusMap selectFloorById:floorId zoomMode:MXMZoomDisable edgePadding:UIEdgeInsetsZero];
}

- (void)addAnnotations:(NSArray<MXMPointAnnotation *> *)annotations {
  [self.mapxusMap addMXMPointAnnotations:annotations];
}

- (void)removeAnnotations:(NSArray<MXMPointAnnotation *> *)annotations {
  [self.mapxusMap removeMXMPointAnnotaions:annotations];
}

#pragma mark - MGLMapViewDelegate
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
  return YES;
}

- (void)mapViewDidBecomeIdle:(MGLMapView *)mapView {
  MXMGeoBuilding *building = self.mapxusMap.buildings[self.mapxusMap.selectedBuildingId];
  if (self.primaryControlDelegate && [self.primaryControlDelegate respondsToSelector:@selector(mapDidChangeFloorId:atBuilding:)]) {
    [self.primaryControlDelegate mapDidChangeFloorId:self.mapxusMap.selectedFloor.floorId atBuilding:building];
  }
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
