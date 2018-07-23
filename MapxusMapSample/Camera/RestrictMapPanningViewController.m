//
//  RestrictMapPanningViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/10.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "RestrictMapPanningViewController.h"
@import Mapbox;
@import MapxusMapSDK;

@interface RestrictMapPanningViewController () <MGLMapViewDelegate>

@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *map;
@property (nonatomic) MGLCoordinateBounds colorado;

@end

@implementation RestrictMapPanningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.nameStr;
    
    CLLocationCoordinate2D ne = CLLocationCoordinate2DMake(22.308716516178253, 114.16586609400843);
    CLLocationCoordinate2D sw = CLLocationCoordinate2DMake(22.300716516178253, 114.15786609400843);
    self.colorado = MGLCoordinateBoundsMake(sw, ne);
    
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(22.304716516178253, 114.16186609400843);
    self.mapView.zoomLevel = 18;
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
}

- (BOOL)mapView:(MGLMapView *)mapView shouldChangeFromCamera:(MGLMapCamera *)oldCamera toCamera:(MGLMapCamera *)newCamera
{
    MGLMapCamera *currentCamera = mapView.camera;
    
    CLLocationCoordinate2D newCameraCenter = newCamera.centerCoordinate;
    
    mapView.camera = newCamera;
    MGLCoordinateBounds newVisibleCoordinates = mapView.visibleCoordinateBounds;
    
    mapView.camera = currentCamera;
    
    BOOL inside = MGLCoordinateInCoordinateBounds(newCameraCenter, self.colorado);
    BOOL intersects = MGLCoordinateInCoordinateBounds(newVisibleCoordinates.ne, self.colorado) && MGLCoordinateInCoordinateBounds(newVisibleCoordinates.sw, self.colorado);
    
    return inside && intersects;
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
