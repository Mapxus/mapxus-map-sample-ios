//
//  DrawMarkerViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/3.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "DrawMarkerViewController.h"
@import Mapbox;
@import MapxusMapSDK;

@interface DrawMarkerViewController () <MGLMapViewDelegate>

@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *map;

@end

@implementation DrawMarkerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.nameStr;
    
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(22.370787, 114.111375);
    self.mapView.zoomLevel = 18;
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
    
    MGLPointAnnotation *ann = [[MGLPointAnnotation alloc] init];
    ann.coordinate = CLLocationCoordinate2DMake(22.370779, 114.111341);
    ann.title = @"室外测试点";
    ann.subtitle = @"lat:22.370779,lon:114.111341";
    [self.mapView addAnnotation:ann];
    
    MXMPointAnnotation *mxmAnn = [[MXMPointAnnotation alloc] init];
    mxmAnn.coordinate = CLLocationCoordinate2DMake(22.371147, 114.111073);
    mxmAnn.title = @"室内测试点";
    mxmAnn.subtitle = @"L1层";
    mxmAnn.buildingId = @"tsuenwanplaza_hk_369d01";
    mxmAnn.floor = @"L1";
    
    MXMPointAnnotation *mxmAnn1 = [[MXMPointAnnotation alloc] init];
    mxmAnn1.coordinate = CLLocationCoordinate2DMake(22.370561, 114.111290);
    mxmAnn1.title = @"室内测试点";
    mxmAnn1.subtitle = @"L2层";
    mxmAnn1.buildingId = @"tsuenwanplaza_hk_369d01";
    mxmAnn1.floor = @"L2";
    
    MXMPointAnnotation *mxmAnn2 = [[MXMPointAnnotation alloc] init];
    mxmAnn2.coordinate = CLLocationCoordinate2DMake(22.371006, 114.111675);
    mxmAnn2.title = @"室内测试点";
    mxmAnn2.subtitle = @"L2层";
    mxmAnn2.buildingId = @"tsuenwanplaza_hk_369d01";
    mxmAnn2.floor = @"L2";
    
    MXMPointAnnotation *mxmAnn3 = [[MXMPointAnnotation alloc] init];
    mxmAnn3.coordinate = CLLocationCoordinate2DMake(22.370606, 114.111830);
    mxmAnn3.title = @"室内测试点";
    mxmAnn3.subtitle = @"L3层";
    mxmAnn3.buildingId = @"tsuenwanplaza_hk_369d01";
    mxmAnn3.floor = @"L3";
    
    [self.map addMXMPointAnnotations:@[mxmAnn, mxmAnn1, mxmAnn2, mxmAnn3]];

}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation
{
    return YES;
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
