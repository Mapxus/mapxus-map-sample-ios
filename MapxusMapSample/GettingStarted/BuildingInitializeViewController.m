//
//  BuildingInitializeViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/10/8.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

@import MapxusMapSDK;
@import Mapbox;

#import "BuildingInitializeViewController.h"


@interface BuildingInitializeViewController () <MGLMapViewDelegate>

@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *map;

@end

@implementation BuildingInitializeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.nameStr;
    self.view.backgroundColor = [UIColor whiteColor];

    // 初始化室外地图
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.mapView];
    // 配置初始化项目
    MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
    configuration.buildingId = @"pacificplace_hk_4d1f10";
    configuration.floor = @"L3";
    // 初始化定内地图
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
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
