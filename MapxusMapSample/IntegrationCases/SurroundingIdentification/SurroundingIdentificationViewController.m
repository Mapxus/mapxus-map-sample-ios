//
//  SurroundingIdentificationViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/22.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <ProgressHUD.h>
#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import <MapxusComponentKit/MapxusComponentKit.h>
#import "MXMSimulateLocationManager.h"
#import "SurroundingIdentificationViewController.h"
#import "SurroundingIdentificationParamViewController.h"
#import "ParamConfigInstance.h"

@interface SurroundingIdentificationViewController () <MGLMapViewDelegate, MXMSearchDelegate, MXMGeoCodeSearchDelegate, Param>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapxusMap;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) MXMSimulateLocationManager *locationManager;
@property (nonatomic, strong) MXMGeoCodeSearch *geoCodeSearcher;
@property (nonatomic, copy) NSDictionary *params;
@end

@implementation SurroundingIdentificationViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self layoutUI];
  // Use Customized Location Manager
  self.mapView.locationManager = self.locationManager;
  self.mapView.showsUserLocation = YES;
  self.mapView.showsUserHeadingIndicator = YES;
  MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
  configuration.defaultStyle = MXMStyleMAPXUS;
  self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
}

- (void)openParam {
  SurroundingIdentificationParamViewController *vc = [[SurroundingIdentificationParamViewController alloc] init];
  vc.delegate = self;
  [self presentViewController:vc animated:YES completion:nil];
}

- (void)layoutUI {
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Params" style:UIBarButtonItemStylePlain target:self action:@selector(openParam)];
  [self.view addSubview:self.mapView];
  [self.view addSubview:self.searchButton];
  
  [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
  [self.mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
  [self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
  [self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
  
  [self.searchButton.widthAnchor constraintEqualToConstant:80].active = YES;
  [self.searchButton.heightAnchor constraintEqualToConstant:40].active = YES;
  if (@available(iOS 11.0, *)) {
    [self.searchButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-30].active = YES;
    [self.searchButton.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor constant:-30].active = YES;
  } else {
    [self.searchButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-30].active = YES;
    [self.searchButton.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-30].active = YES;
  }
}

- (void)requestData
{
  [ProgressHUD show];
  // Reverse Geo to indoor scene
  MXMReverseGeoCodeSearchOption *opt = [[MXMReverseGeoCodeSearchOption alloc] init];
  opt.location = self.mapView.userLocation.location.coordinate;
  if (self.mapView.userLocation.location.floor) {
    opt.floorOrdinal = @(self.mapView.userLocation.location.floor.level);
  }
  
  [self.geoCodeSearcher reverseGeoCode:opt];
}

#pragma mark - Param
- (void)completeParamConfiguration:(NSDictionary *)param {
  self.params = param;
  // Create an indoor CLLocation instance
  CLFloor *floor = [CLFloor createFloorWihtLevel:[(NSString *)param[@"ordinal"] integerValue]];
  CLLocation *location = [[CLLocation alloc] initWithLatitude:[(NSString *)param[@"latitude"] doubleValue] longitude:[(NSString *)param[@"longitude"] doubleValue]];
  location.myFloor = floor;
  // Set analog positioning
  self.mapView.centerCoordinate = location.coordinate;
  [self.locationManager setSimulateLocation:location];
}

#pragma mark - MXMGeoCodeSearchDelegate
- (void)onGetReverseGeoCode:(MXMGeoCodeSearch *)searcher result:(MXMReverseGeoCodeSearchResult *)result error:(NSError *)error {
  if (result) {
    [self.mapxusMap selectFloorById:result.floor.floorId zoomMode:MXMZoomDisable edgePadding:UIEdgeInsetsZero];
    MXMGeoPoint *point = [[MXMGeoPoint alloc] init];
    point.latitude = [(NSString *)self.params[@"latitude"] doubleValue];
    point.longitude = [(NSString *)self.params[@"longitude"] doubleValue];
    
    MXMOrientationPOISearchRequest *re = [[MXMOrientationPOISearchRequest alloc] init];
    re.center = point;
    re.distance = [(NSString *)self.params[@"distance"] integerValue];
    re.angle = self.mapView.userLocation.heading.trueHeading;
    re.floorId = result.floor.floorId;
    re.distanceSearchType = self.params[@"distanceSearchType"];
    // Search POI near the center
    MXMSearchAPI *api = [[MXMSearchAPI alloc] init];
    api.delegate = self;
    [api MXMOrientationPOISearch:re];
  } else {
    [ProgressHUD showError:NSLocalizedString(@"No POI could be found", nil)];
  }
}

#pragma mark - MXMSearchDelegate
- (void)MXMSearchRequest:(id)request didFailWithError:(NSError *)error
{
  [ProgressHUD showError:NSLocalizedString(@"No POI could be found", nil)];
}

- (void)onOrientationPOISearchDone:(MXMOrientationPOISearchRequest *)request response:(MXMOrientationPOISearchResponse *)response
{
  if (self.mapxusMap.MXMAnnotations.count) {
    [self.mapxusMap removeMXMPointAnnotaions:self.mapxusMap.MXMAnnotations];
  }
  
  NSMutableArray *anns = [NSMutableArray array];
  for (MXMPOI *poi in response.pois) {
    MXMPointAnnotation *ann = [[MXMPointAnnotation alloc] init];
    ann.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    ann.title = poi.name_default;
    // Use POI`s angle to calculate bearing
    if (poi.angle > 315 || poi.angle <= 44) {
      ann.subtitle = @"In the front";
    } else if (poi.angle > 44 && poi.angle <= 134) {
      ann.subtitle = @"On the right";
    } else if (poi.angle > 134 && poi.angle <= 224) {
      ann.subtitle = @"In the back";
    } else if (poi.angle > 224 && poi.angle <= 314) {
      ann.subtitle = @"On the left";
    }
    ann.floorId = poi.floor.floorId;
    [anns addObject:ann];
  }
  
  [self.mapxusMap addMXMPointAnnotations:anns];
  
  [ProgressHUD dismiss];
}

#pragma mark - MGLMapViewDelegate
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation
{
  return YES;
}

#pragma mark - Lazy loading
- (MGLMapView *)mapView {
  if (!_mapView) {
    _mapView = [[MGLMapView alloc] init];
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(PARAMCONFIGINFO.center_latitude, PARAMCONFIGINFO.center_longitude);
    _mapView.zoomLevel = 18;
    _mapView.delegate = self;
  }
  return _mapView;
}

- (UIButton *)searchButton {
  if (!_searchButton) {
    _searchButton = [[UIButton alloc] init];
    _searchButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_searchButton setTitle:@"Search" forState:UIControlStateNormal];
    [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _searchButton.backgroundColor = [UIColor colorWithRed:80/255.0 green:175/255.0 blue:243/255.0 alpha:1.0];
    [_searchButton addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
    _searchButton.layer.cornerRadius = 5;
    
  }
  return _searchButton;
}

- (MXMSimulateLocationManager *)locationManager {
  if (!_locationManager) {
    _locationManager = [[MXMSimulateLocationManager alloc] init];
  }
  return _locationManager;
}

- (MXMGeoCodeSearch *)geoCodeSearcher {
  if (!_geoCodeSearcher) {
    _geoCodeSearcher = [[MXMGeoCodeSearch alloc] init];
    _geoCodeSearcher.delegate = self;
  }
  return _geoCodeSearcher;
}

@end
