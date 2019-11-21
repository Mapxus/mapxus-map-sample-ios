//
//  AnimateMarkerPositionViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/3.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "AnimateMarkerPositionViewController.h"
@import Mapbox;
@import MapxusMapSDK;

@interface AnimateMarkerPositionViewController () <MGLMapViewDelegate, MapxusMapDelegate>

@property (nonatomic, weak) IBOutlet MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *map;
@property (nonatomic, strong) MGLPointAnnotation *annotation;

@end

@implementation AnimateMarkerPositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.nameStr;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(22.370787, 114.111375);
    self.mapView.zoomLevel = 18;
    // config MapxusMap
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
    self.map.delegate = self;
    
    self.annotation = [[MGLPointAnnotation alloc] init];
    self.annotation.coordinate = CLLocationCoordinate2DMake(22.370787, 114.111375);
    [self.mapView addAnnotation:self.annotation];
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation
{
    return NO;
}

- (void)mapView:(MapxusMap *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    self.annotation.coordinate = coordinate;
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
