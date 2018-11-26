//
//  OutdoorHiddenViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/11/23.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

@import MapxusMapSDK;
@import Mapbox;

#import "OutdoorHiddenViewController.h"

@interface OutdoorHiddenViewController () <MGLMapViewDelegate>

@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *map;

@end

@implementation OutdoorHiddenViewController

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
    configuration.poiId = @"75656";
    configuration.outdoorHidden = YES;
    // 初始化定内地图
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
    
    UISwitch *outdoorSwitch = [[UISwitch alloc] init];
    outdoorSwitch.on = NO;
    [outdoorSwitch addTarget:self action:@selector(outdoorSwitchAction:) forControlEvents:UIControlEventValueChanged];
    outdoorSwitch.center = CGPointMake(40, 40);
    [self.view addSubview:outdoorSwitch];
}

#pragma mark - actions

- (void)outdoorSwitchAction:(UISwitch *)sender
{
    [self.map setOutdoorHidden:!sender.isOn];
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
