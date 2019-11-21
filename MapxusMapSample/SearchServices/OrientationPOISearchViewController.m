//
//  OrientationPOISearchViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2019/6/20.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "OrientationPOISearchViewController.h"
@import ProgressHUD;

@import Mapbox;
@import MapxusMapSDK;

@interface OrientationPOISearchViewController ()<MXMSearchDelegate, MGLMapViewDelegate>

@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *map;

@end

@implementation OrientationPOISearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.nameStr;
    
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(22.370787, 114.111375);
    self.mapView.zoomLevel = 18.5;
    [self.view addSubview:self.mapView];
    
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(10, 20, 130, 30);
    searchBtn.layer.cornerRadius = 5;
    searchBtn.backgroundColor = [UIColor blueColor];
    [searchBtn setTitle:@"Search Nearby" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
}

- (void)requestData
{
    [ProgressHUD show];
    
    CLLocationCoordinate2D coor = [self.mapView convertPoint:self.mapView.center toCoordinateFromView:self.mapView];
    
    MXMGeoPoint *point = [[MXMGeoPoint alloc] init];
    point.latitude = coor.latitude;
    point.longitude = coor.longitude;
    
    MXMOrientationPOISearchRequest *re = [[MXMOrientationPOISearchRequest alloc] init];
    re.center = point;
    re.distance = 10;
    re.angle = self.mapView.direction;
    re.buildingId = self.map.building.identifier;
    re.floor = self.map.floor;
    re.distanceSearchType = @"Polygon";
    
    MXMSearchAPI *api = [[MXMSearchAPI alloc] init];
    api.delegate = self;
    [api MXMOrientationPOISearch:re];
}

- (void)MXMSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [ProgressHUD showError:NSLocalizedString(@"No POI were found", nil)];
}

- (void)onOrientationPOISearchDone:(MXMOrientationPOISearchRequest *)request response:(MXMOrientationPOISearchResponse *)response
{
    if (self.map.MXMAnnotations.count) {
        [self.map removeMXMPointAnnotaions:self.map.MXMAnnotations];
    }
    
    NSMutableArray *anns = [NSMutableArray array];
    for (MXMPOI *poi in response.pois) {
        MXMPointAnnotation *ann = [[MXMPointAnnotation alloc] init];
        ann.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        ann.title = poi.name_default;
        if (poi.angle > 315 || poi.angle <= 44) {
            ann.subtitle = @"In the front";
        } else if (poi.angle > 44 && poi.angle <= 134) {
            ann.subtitle = @"On the right";
        } else if (poi.angle > 134 && poi.angle <= 224) {
            ann.subtitle = @"In the back";
        } else if (poi.angle > 224 && poi.angle <= 314) {
            ann.subtitle = @"On the left";
        }
        ann.buildingId = poi.buildingId;
        ann.floor = poi.floor;
        [anns addObject:ann];
    }
    // 中心点
    MXMPointAnnotation *ann = [[MXMPointAnnotation alloc] init];
    ann.coordinate = CLLocationCoordinate2DMake(request.center.latitude, request.center.longitude);
    ann.title = @"your location";
    [anns addObject:ann];
    
    [self.map addMXMPointAnnotations:anns];
    
    [ProgressHUD dismiss];
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
