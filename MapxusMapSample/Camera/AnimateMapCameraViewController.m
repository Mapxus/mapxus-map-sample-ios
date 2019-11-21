//
//  AnimateMapCameraViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/7.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "AnimateMapCameraViewController.h"
@import Mapbox;
@import MapxusMapSDK;

@interface AnimateMapCameraViewController () <MapxusMapDelegate>

@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *map;

@property (nonatomic) CLLocationCoordinate2D Element;
@property (nonatomic) CLLocationCoordinate2D admiraltystation;
@property (nonatomic, assign) BOOL isElement;

@end

@implementation AnimateMapCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.nameStr;
    self.Element = CLLocationCoordinate2DMake(22.297696, 114.168397);
    self.admiraltystation = CLLocationCoordinate2DMake(22.283109, 114.173036);
    self.isElement = YES;
    
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(22.297696, 114.168397);
    self.mapView.zoomLevel = 16;
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
    self.map.delegate = self;
}

- (void)mapView:(MapxusMap *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D changeCoordinate;
    if (self.isElement) {
        changeCoordinate = self.admiraltystation;
    } else {
        changeCoordinate = self.Element;
    }
    self.isElement = !self.isElement;
    MGLMapCamera *camera = [MGLMapCamera cameraLookingAtCenterCoordinate:changeCoordinate acrossDistance:1000 pitch:15 heading:0];
    [self.mapView setCamera:camera withDuration:2 animationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
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
