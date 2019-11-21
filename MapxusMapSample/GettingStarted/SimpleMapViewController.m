//
//  SimpleMapViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/4/25.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "SimpleMapViewController.h"
@import Mapbox;
@import MapxusMapSDK;

@interface SimpleMapViewController () <MGLMapViewDelegate>

@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *map;

@end

@implementation SimpleMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.nameStr;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mapView.frame = self.view.bounds;
}


- (MGLMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MGLMapView alloc] init];
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(22.370787, 114.111375);
        _mapView.zoomLevel = 18;
        _mapView.delegate = self;
    }
    return _mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
