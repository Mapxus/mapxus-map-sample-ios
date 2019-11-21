//
//  XibBuildViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/4/27.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "XibBuildViewController.h"
@import Mapbox;
@import MapxusMapSDK;

@interface XibBuildViewController ()

@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *map;

@end

@implementation XibBuildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.nameStr;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(22.370787, 114.111375);
    self.mapView.zoomLevel = 18;
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
