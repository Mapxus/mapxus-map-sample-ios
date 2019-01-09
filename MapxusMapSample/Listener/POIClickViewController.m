//
//  POIClickViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/2.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "POIClickViewController.h"
@import Mapbox;
@import MapxusMapSDK;

@interface POIClickViewController () <MapxusMapDelegate, MGLMapViewDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *poiNameLabel;
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *map;
@property (nonatomic, strong) MXMPointAnnotation *ann;

@end

@implementation POIClickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.nameStr;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.poiNameLabel];
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
    self.map.delegate = self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mapView.frame = self.view.bounds;
    self.topView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    self.poiNameLabel.frame = CGRectMake(10, 0, self.view.frame.size.width-20, 40);
}

#pragma mark - MGLMapViewDelegate

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation
{
    return YES;
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation
{
    MGLAnnotationImage *annImg = [mapView dequeueReusableAnnotationImageWithIdentifier:@"ic_start_point"];
    if (annImg == nil) {
        UIImage *image = [UIImage imageNamed:@"ic_start_point"];
        image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
        annImg = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:@"ic_start_point"];
    }
    return annImg;
}

#pragma mark - MapxusMapDelegate

- (void)mapView:(MapxusMap *)mapView didTappedOnPOI:(MXMGeoPOI *)poi
{
    if (self.ann == nil) {
        MXMPointAnnotation *p = [[MXMPointAnnotation alloc] init];
        p.coordinate = poi.coordinate;
        p.title = poi.name;
        p.floor = poi.floor;
        p.buildingId = poi.buildingId;
        
        [self.map addMXMPointAnnotations:@[p]];
        self.ann = p;
    } else {
        self.ann.coordinate = poi.coordinate;
        self.ann.title = poi.name;
        self.ann.floor = poi.floor;
        self.ann.buildingId = poi.buildingId;
    }
}
    
- (void)mapView:(MapxusMap *)mapView didTappedOnMapBlank:(CLLocationCoordinate2D)coordinate
{
    [self cleanMapAnnotations];
}

- (void)cleanMapAnnotations
{
    if (self.map.MXMAnnotations.count) {
        [self.map removeMXMPointAnnotaions:self.map.MXMAnnotations];
        self.ann = nil;
    }
}

#pragma mark - access

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor blackColor];
        _topView.alpha = 0.6;
    }
    return _topView;
}

- (UILabel *)poiNameLabel
{
    if (!_poiNameLabel) {
        _poiNameLabel = [[UILabel alloc] init];
        _poiNameLabel.textColor = [UIColor whiteColor];
        _poiNameLabel.text = @"Click the map blank area and the POI.";
    }
    return _poiNameLabel;
}

- (MGLMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MGLMapView alloc] init];
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(22.304716516178253, 114.16186609400843);
        _mapView.zoomLevel = 16;
        _mapView.delegate = self; // 无论是否调用代理，都要设置
    }
    return _mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
