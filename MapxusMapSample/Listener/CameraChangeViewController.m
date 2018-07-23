//
//  CameraChangeViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/2.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "CameraChangeViewController.h"
@import MapxusMapSDK;
@import Mapbox;

@interface CameraChangeViewController () <MapxusMapDelegate, MGLMapViewDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *cameraInfoLabel;
@property (nonatomic, strong) UILabel *tapInfoLabel;
@property (nonatomic, strong) MapxusMap *map;
@property (nonatomic, strong) MGLMapView *mapView;

@end

@implementation CameraChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.nameStr;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.cameraInfoLabel];
    [self.topView addSubview:self.tapInfoLabel];
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
    self.map.delegate = self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mapView.frame = self.view.bounds;
    self.topView.frame = CGRectMake(0, 0, self.view.frame.size.width, 65);
    self.cameraInfoLabel.frame = CGRectMake(10, 10, self.view.frame.size.width-20, 20);
    self.tapInfoLabel.frame = CGRectMake(10, 35, self.view.frame.size.width-20, 20);
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

- (UILabel *)cameraInfoLabel
{
    if (!_cameraInfoLabel) {
        _cameraInfoLabel = [[UILabel alloc] init];
        _cameraInfoLabel.textColor = [UIColor whiteColor];
    }
    return _cameraInfoLabel;
}

- (UILabel *)tapInfoLabel
{
    if (!_tapInfoLabel) {
        _tapInfoLabel = [[UILabel alloc] init];
        _tapInfoLabel.textColor = [UIColor whiteColor];
    }
    return _tapInfoLabel;
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

- (void)mapView:(MGLMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.cameraInfoLabel.text = [NSString stringWithFormat:@"camera center:%f, %f", self.mapView.camera.centerCoordinate.latitude, self.mapView.camera.centerCoordinate.longitude];
}

- (void)mapView:(MapxusMap *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    self.tapInfoLabel.text = [NSString stringWithFormat:@"tap on the map:%f, %f", coordinate.latitude, coordinate.longitude];
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
