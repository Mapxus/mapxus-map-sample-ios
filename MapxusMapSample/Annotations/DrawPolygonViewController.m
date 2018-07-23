//
//  DrawPolygonViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/3.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "DrawPolygonViewController.h"
@import Mapbox;
@import MapxusMapSDK;

@interface DrawPolygonViewController () <MGLMapViewDelegate>

@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *map;

@end

@implementation DrawPolygonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.nameStr;
    
    CLLocationCoordinate2D coordinates[] = {
        CLLocationCoordinate2DMake(22.307212, 114.161315),
        CLLocationCoordinate2DMake(22.306595, 114.163866),
        CLLocationCoordinate2DMake(22.302784, 114.163861),
        CLLocationCoordinate2DMake(22.302818, 114.167886),
        CLLocationCoordinate2DMake(22.301252, 114.167804),
        CLLocationCoordinate2DMake(22.299879, 114.159030),
        CLLocationCoordinate2DMake(22.298654, 114.158047),
        CLLocationCoordinate2DMake(22.298988, 114.155424),
        CLLocationCoordinate2DMake(22.307212, 114.161315),
    };
    NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);
    
    MGLPolygon *polygon = [MGLPolygon polygonWithCoordinates:coordinates count:numberOfCoordinates];
    [self.mapView addAnnotation:polygon];
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(22.304716516178253, 114.16186609400843);
    self.mapView.zoomLevel = 14;
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
}

- (UIColor *)mapView:(MGLMapView *)mapView fillColorForPolygonAnnotation:(MGLPolygon *)annotation
{
    return [UIColor colorWithRed:0.0/255.0 green:144.0/255.0 blue:80.0/255.0 alpha:1.0];
}

- (CGFloat)mapView:(MGLMapView *)mapView alphaForShapeAnnotation:(MGLShape *)annotation
{
    return 0.7;
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
