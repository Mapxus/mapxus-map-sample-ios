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
    
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(22.304716516178253, 114.16186609400843);
    self.mapView.zoomLevel = 16;
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
    
    MGLPointAnnotation *ann = [[MGLPointAnnotation alloc] init];
    ann.coordinate = CLLocationCoordinate2DMake(22.304716516178253, 114.16186609400843);
    ann.title = @"测试点";
    ann.subtitle = @"lat:22.304716516178253,lon:114.16186609400843";
    [self.mapView addAnnotation:ann];
    
    MXMPointAnnotation *mxmAnn = [[MXMPointAnnotation alloc] init];
    mxmAnn.coordinate = CLLocationCoordinate2DMake(22.304816516178253, 114.16226609400843);
    mxmAnn.title = @"测试点";
    mxmAnn.subtitle = @"G层";
    mxmAnn.buildingId = @"elements_hk_dc005f";
    mxmAnn.floor = @"G";
    
    MXMPointAnnotation *mxmAnn1 = [[MXMPointAnnotation alloc] init];
    mxmAnn1.coordinate = CLLocationCoordinate2DMake(22.305316516178253, 114.16186609400843);
    mxmAnn1.title = @"测试点";
    mxmAnn1.subtitle = @"L1层";
    mxmAnn1.buildingId = @"elements_hk_dc005f";
    mxmAnn1.floor = @"L1";
    
    MXMPointAnnotation *mxmAnn2 = [[MXMPointAnnotation alloc] init];
    mxmAnn2.coordinate = CLLocationCoordinate2DMake(22.303316516178253, 114.16016609400843);
    mxmAnn2.title = @"测试点";
    mxmAnn2.subtitle = @"L2层";
    mxmAnn2.buildingId = @"elements_hk_dc005f";
    mxmAnn2.floor = @"L2";
    
    MXMPointAnnotation *mxmAnn3 = [[MXMPointAnnotation alloc] init];
    mxmAnn3.coordinate = CLLocationCoordinate2DMake(22.304816516178253, 114.16326609400843);
    mxmAnn3.title = @"测试点";
    mxmAnn3.subtitle = @"L3层";
    mxmAnn3.buildingId = @"elements_hk_dc005f";
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
