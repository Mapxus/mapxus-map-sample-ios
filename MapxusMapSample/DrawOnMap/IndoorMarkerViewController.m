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

@interface IndoorMarkerViewController () <MGLMapViewDelegate, MapxusMapDelegate>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapPlugin;
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
    configuration.defaultStyle = MXMStyleMAPXUS_V2;
    self.mapPlugin = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];

    // Add outdoor reference points
    MGLPointAnnotation *ann = [[MGLPointAnnotation alloc] init];
    ann.coordinate = CLLocationCoordinate2DMake(22.370779, 114.111341);
    ann.title = @"室外测试点";
    ann.subtitle = @"lat:22.370779,lon:114.111341";
    [self.mapView addAnnotation:ann];
    
    // Adding indoor case points
    MXMPointAnnotation *mxmAnn = [[MXMPointAnnotation alloc] init];
    mxmAnn.coordinate = CLLocationCoordinate2DMake(22.371147, 114.111073);
    mxmAnn.title = @"室内测试点";
    mxmAnn.subtitle = @"L1层";
    mxmAnn.buildingId = @"tsuenwanplaza_hk_369d01";
    mxmAnn.floor = @"L1";
    
    MXMPointAnnotation *mxmAnn1 = [[MXMPointAnnotation alloc] init];
    mxmAnn1.coordinate = CLLocationCoordinate2DMake(22.370561, 114.111290);
    mxmAnn1.title = @"室内测试点";
    mxmAnn1.subtitle = @"L2层";
    mxmAnn1.buildingId = @"tsuenwanplaza_hk_369d01";
    mxmAnn1.floor = @"L2";
    
    MXMPointAnnotation *mxmAnn2 = [[MXMPointAnnotation alloc] init];
    mxmAnn2.coordinate = CLLocationCoordinate2DMake(22.371006, 114.111675);
    mxmAnn2.title = @"室内测试点";
    mxmAnn2.subtitle = @"L2层";
    mxmAnn2.buildingId = @"tsuenwanplaza_hk_369d01";
    mxmAnn2.floor = @"L2";
    
    MXMPointAnnotation *mxmAnn3 = [[MXMPointAnnotation alloc] init];
    mxmAnn3.coordinate = CLLocationCoordinate2DMake(22.370606, 114.111830);
    mxmAnn3.title = @"室内测试点";
    mxmAnn3.subtitle = @"L3层";
    mxmAnn3.buildingId = @"tsuenwanplaza_hk_369d01";
    mxmAnn3.floor = @"L3";
    
    [self.mapPlugin addMXMPointAnnotations:@[mxmAnn, mxmAnn1, mxmAnn2, mxmAnn3]];
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
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(22.370787, 114.111375);
        _mapView.zoomLevel = 18;
        _mapView.delegate = self;
    }
    return _mapView;
}

@end
