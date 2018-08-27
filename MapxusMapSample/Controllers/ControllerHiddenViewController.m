//
//  ControllerHiddenViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/8/24.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "ControllerHiddenViewController.h"
#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>

@interface ControllerHiddenViewController () <MGLMapViewDelegate>

@property (nonatomic, strong) MGLMapView *mapview;
@property (nonatomic, strong) MapxusMap *map;

@end

@implementation ControllerHiddenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.nameStr;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mapview = [[MGLMapView alloc] init];
    self.mapview.delegate = self;
    self.mapview.centerCoordinate = CLLocationCoordinate2DMake(22.304716516178253, 114.16186609400843);
    self.mapview.zoomLevel = 16;
    [self.view addSubview:self.mapview];
    
    self.map = [[MapxusMap alloc] initWithMapView:self.mapview];
    
    
    UISwitch *switchView = [[UISwitch alloc] init];
    switchView.backgroundColor = [UIColor whiteColor];
    switchView.on = YES;
    switchView.center = CGPointMake(30, 30);
    switchView.layer.cornerRadius = switchView.frame.size.height/2;
    [switchView addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mapview.frame = self.view.bounds;
}

- (void)switchChange:(UISwitch *)sender
{
    self.map.indoorControllerAlwaysHidden = !sender.isOn;
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
