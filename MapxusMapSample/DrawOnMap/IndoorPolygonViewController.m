//
//  IndoorPolygonViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/20.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "IndoorPolygonViewController.h"
#import "ParamConfigInstance.h"

@interface IndoorPolygonViewController () <MGLMapViewDelegate, MapxusMapDelegate>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapxusMap;
@end

@implementation IndoorPolygonViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self layoutUI];
  MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
  configuration.defaultStyle = MXMStyleMAPXUS;
  configuration.floorId = PARAMCONFIGINFO.floorId;
  self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
  self.mapxusMap.delegate = self;
}

- (void)addPolygon {
  CLLocationCoordinate2D *coor = malloc(PARAMCONFIGINFO.polygons.count * sizeof(CLLocationCoordinate2D));
  
  for (int i = 0; i < PARAMCONFIGINFO.polygons.count ; i++) {
    ParamConfigPolygon *polygon = PARAMCONFIGINFO.polygons[i];
    coor[i].latitude = polygon.latitude.doubleValue;
    coor[i].longitude = polygon.longitude.doubleValue;
  }
  
  NSUInteger numberOfCoordinates = PARAMCONFIGINFO.polygons.count;
  MGLPolygonFeature *polygon = [MGLPolygonFeature polygonWithCoordinates:coor count:numberOfCoordinates];
  polygon.attributes = @{@"floorId": PARAMCONFIGINFO.floorId};
  
  MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"source" shape:polygon options:nil];
  MGLFillStyleLayer *layer = [[MGLFillStyleLayer alloc] initWithIdentifier:@"layer" source:source];
  layer.fillColor = [NSExpression expressionForConstantValue:[UIColor redColor]];
  layer.fillOpacity = [NSExpression expressionForConstantValue:@(0.5)];
  [self.mapView.style addSource:source];
  [self.mapView.style addLayer:layer];
}

- (void)layoutUI {
  [self.view addSubview:self.mapView];
  
  [self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
  [self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
  [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
  [self.mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
}

#pragma mark - MapxusMapDelegate
- (void)map:(MapxusMap *)map didChangeSelectedFloor:(MXMFloor *)floor inSelectedBuildingId:(NSString *)buildingId atSelectedVenueId:(NSString *)venueId {
  // When the scene is changed, modify the layer`s predicate to filter features
  MGLVectorStyleLayer *layer = (MGLVectorStyleLayer *)[self.mapView.style layerWithIdentifier:@"layer"];
  layer.predicate = [NSPredicate predicateWithFormat:@"floorId == %@", floor.floorId];
}

#pragma mark - MGLMapViewDelegate
- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
  // Add style layer after loaded style
  [self addPolygon];
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
