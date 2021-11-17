//
//  MXMPrimaryContentViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/28.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMPrimaryContentViewController.h"

@interface MXMPrimaryContentViewController () <MGLMapViewDelegate, MapxusMapDelegate>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapPlugin;
@end

@implementation MXMPrimaryContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];

    MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
    configuration.buildingId = @"harbourcity_hk_8b580b";
    configuration.floor = @"L2";
    configuration.defaultStyle = MXMStyleMAPXUS;
    self.mapPlugin = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
    self.mapPlugin.selectorPosition = MXMSelectorPositionTopRight;
    self.mapPlugin.delegate = self;
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

- (void)moveToPOICenter:(CLLocationCoordinate2D)center buildingID:( NSString * _Nullable)buildingID floor:( NSString * _Nullable)floor {
    [self setCameraCenter:center zoomLevel:18 animated:YES];
    [self.mapPlugin selectBuilding:buildingID floor:floor zoomMode:MXMZoomDisable edgePadding:UIEdgeInsetsZero];
}

- (void)addAnnotations:(NSArray<MXMPointAnnotation *> *)annotations {
    [self.mapPlugin addMXMPointAnnotations:annotations];
}

- (void)removeAnnotations:(NSArray<MXMPointAnnotation *> *)annotations {
    [self.mapPlugin removeMXMPointAnnotaions:annotations];
}

#pragma mark - MGLMapViewDelegate
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    return YES;
}

#pragma mark - MapxusMapDelegate
- (void)mapView:(MapxusMap *)mapView didChangeFloor:(NSString *)floorName atBuilding:(MXMGeoBuilding *)building {
    if (self.primaryControlDelegate && [self.primaryControlDelegate respondsToSelector:@selector(mapDidChangeFloor:atBuilding:)]) {
        [self.primaryControlDelegate mapDidChangeFloor:floorName atBuilding:building];
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
