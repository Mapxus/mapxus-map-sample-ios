//
//  DrawCustomMarkerViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/3.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "DrawCustomMarkerViewController.h"
@import Mapbox;
@import MapxusMapSDK;

@interface DrawCustomMarkerViewController () <MGLMapViewDelegate>

@property (nonatomic, weak) IBOutlet MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *map;

@end

@implementation DrawCustomMarkerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.nameStr;
    
    MGLPointAnnotation *ann = [[MGLPointAnnotation alloc] init];
    ann.coordinate = CLLocationCoordinate2DMake(22.304716516178253, 114.16186609400843);
    ann.title = @"测试点";
    ann.subtitle = @"测试点副标题";
    
    [self.mapView addAnnotation:ann];
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(22.304716516178253, 114.16186609400843);
    self.mapView.zoomLevel = 16;
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation
{
    MGLAnnotationImage *img = [MGLAnnotationImage annotationImageWithImage:[UIImage imageNamed:@"location_p"] reuseIdentifier:@"test"];
    return img;
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
