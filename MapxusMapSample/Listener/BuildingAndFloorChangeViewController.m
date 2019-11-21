//
//  BuildingAndFloorChangeViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/2.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "BuildingAndFloorChangeViewController.h"
@import Mapbox;
@import MapxusMapSDK;

@interface BuildingAndFloorChangeViewController () <MGLMapViewDelegate, MapxusMapDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *buildingNameLabel;
@property (nonatomic, strong) UILabel *floorNameLabel;
@property (nonatomic, strong) UILabel *indoorLabel;
@property (nonatomic, strong) MapxusMap *map;
@property (nonatomic, strong) MGLMapView *mapView;

@end

@implementation BuildingAndFloorChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.nameStr;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.buildingNameLabel];
    [self.topView addSubview:self.floorNameLabel];
    [self.topView addSubview:self.indoorLabel];
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
    self.map.delegate = self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mapView.frame = self.view.bounds;
    self.topView.frame = CGRectMake(0, 0, self.view.frame.size.width, 90);
    self.buildingNameLabel.frame = CGRectMake(10, 10, self.view.frame.size.width-20, 20);
    self.floorNameLabel.frame = CGRectMake(10, 35, self.view.frame.size.width-20, 20);
    self.indoorLabel.frame = CGRectMake(10, 60, self.view.frame.size.width-20, 20);
}

#pragma mark - MapxusMapDelegate
- (void)mapView:(MapxusMap *)mapView didChangeFloor:(NSString *)floorName atBuilding:(MXMGeoBuilding *)building
{
    self.buildingNameLabel.text = [NSString stringWithFormat:@"BuildingName:%@", building.name];
    self.floorNameLabel.text = [NSString stringWithFormat:@"Floor:%@", floorName];
}

- (void)mapView:(MapxusMap *)mapView indoorMapWithIn:(BOOL)flag building:(NSString *)buildingId floor:(NSString *)floor
{
    self.indoorLabel.text = flag ? @"Indoor now" : @"Outdoor now";
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

- (UILabel *)buildingNameLabel
{
    if (!_buildingNameLabel) {
        _buildingNameLabel = [[UILabel alloc] init];
        _buildingNameLabel.textColor = [UIColor whiteColor];
    }
    return _buildingNameLabel;
}

- (UILabel *)floorNameLabel
{
    if (!_floorNameLabel) {
        _floorNameLabel = [[UILabel alloc] init];
        _floorNameLabel.textColor = [UIColor whiteColor];
    }
    return _floorNameLabel;
}

- (UILabel *)indoorLabel
{
    if (!_indoorLabel) {
        _indoorLabel = [[UILabel alloc] init];
        _indoorLabel.textColor = [UIColor yellowColor];
    }
    return _indoorLabel;
}

- (MGLMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MGLMapView alloc] init];
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(22.370787, 114.111375);
        _mapView.zoomLevel = 18;
        _mapView.delegate = self; // 无论是否调用代理，都要设置
    }
    return _mapView;
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
