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

- (void)mapView:(MapxusMap *)mapView didTappedOnPOI:(MXMGeoPOI *)poi
{
    if (poi) {
        self.poiNameLabel.text = [NSString stringWithFormat:@"Click POI:%@", poi.name];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
