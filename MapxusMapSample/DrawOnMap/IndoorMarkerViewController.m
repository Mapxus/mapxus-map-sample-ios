//
//  IndoorMarkerViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/20.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "IndoorMarkerViewController.h"
#import "ParamConfigInstance.h"

@interface IndoorMarkerViewController () <MGLMapViewDelegate, MapxusMapDelegate>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapxusMap;
@end

@implementation IndoorMarkerViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self.view addSubview:self.mapView];
  [self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
  [self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
  [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
  [self.mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
  
  MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
  configuration.defaultStyle = MXMStyleMAPXUS;
  self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
  
  NSMutableArray *annotations = [NSMutableArray array];
  for (ParamConfigDrawingMarker *marker in PARAMCONFIGINFO.drawing_markers) {
    MXMPointAnnotation *mxmAnn = [[MXMPointAnnotation alloc] init];
    mxmAnn.coordinate = CLLocationCoordinate2DMake(marker.latitude.doubleValue, marker.longitude.doubleValue);
    mxmAnn.title = marker.title;
    mxmAnn.subtitle =marker.subtitle;
    mxmAnn.floorId = marker.floorId;
    [annotations addObject:mxmAnn];
  }
  [self.mapxusMap addMXMPointAnnotations:annotations];
}

#pragma mark - MGLMapViewDelegate
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation
{
  return YES;
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

@end
