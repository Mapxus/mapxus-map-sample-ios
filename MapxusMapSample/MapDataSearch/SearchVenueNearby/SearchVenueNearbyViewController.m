//
//  SearchVenueNearbyViewController.m
//  MapxusMapSample
//
//  Created by guochenghao on 2023/6/7.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <ProgressHUD.h>
#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "SearchVenueNearbyViewController.h"
#import "SearchBuildingNearbyParamViewController.h"


@interface SearchVenueNearbyViewController () <MGLMapViewDelegate, MXMVenueSearchDelegate, Param>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapxusMap;
@end

@implementation SearchVenueNearbyViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self layoutUI];
  MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
  configuration.defaultStyle = MXMStyleMAPXUS;
  self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
}

- (void)openParam {
  SearchBuildingNearbyParamViewController *vc = [[SearchBuildingNearbyParamViewController alloc] init];
  vc.delegate = self;
  [self presentViewController:vc animated:YES completion:nil];
}

- (void)layoutUI {
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Params" style:UIBarButtonItemStylePlain target:self action:@selector(openParam)];
  [self.view addSubview:self.mapView];
  
  [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
  [self.mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
  [self.mapView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
  [self.mapView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
}

#pragma mark - MXMVenueSearchDelegate
- (void)venueSearcher:(MXMVenueSearch *)venueSearcher didReceiveVenuesWithResult:(MXMVenueSearchResult *)searchResult error:(NSError *)error {
  if (searchResult) {
    if (self.mapView.annotations.count) {
      [self.mapView removeAnnotations:self.mapView.annotations];
    }
    
    NSMutableArray *anns = [NSMutableArray array];
    for (MXMBuilding *venue in searchResult.venues) {
      if (searchResult.total == 1) {
        MGLCoordinateBounds bounds = MGLCoordinateBoundsMake(CLLocationCoordinate2DMake(venue.bbox.min_latitude, venue.bbox.min_longitude), CLLocationCoordinate2DMake(venue.bbox.max_latitude, venue.bbox.max_longitude));
        self.mapView.visibleCoordinateBounds = bounds;
      }
      MGLPointAnnotation *ann = [[MGLPointAnnotation alloc] init];
      ann.coordinate = CLLocationCoordinate2DMake(venue.labelCenter.latitude, venue.labelCenter.longitude);
      ann.title = venue.nameMap.Default;
      [anns addObject:ann];
    }
    [self.mapView addAnnotations:anns];
    if (searchResult.total > 1) {
      [self.mapView showAnnotations:anns animated:YES];
    }
    
    [ProgressHUD dismiss];
  } else {
    [ProgressHUD showError:NSLocalizedString(@"No venues could be found", nil)];
  }
}


#pragma mark - MGLMapViewDelegate
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation
{
  return YES;
}

#pragma mark - Param
- (void)completeParamConfiguration:(NSDictionary *)param {
  [ProgressHUD show];
  
  MXMGeoPoint *point = [[MXMGeoPoint alloc] init];
  point.latitude = [(NSString *)param[@"latitude"] doubleValue];
  point.longitude = [(NSString *)param[@"longitude"] doubleValue];
  
  MXMVenueNearBySearchOption *opt = [[MXMVenueNearBySearchOption alloc] init];
  opt.keyword = param[@"keywords"];
  opt.center = point;
  opt.distance = [(NSString *)param[@"distance"] integerValue];
  opt.offset = [(NSString *)param[@"offset"] integerValue];
  opt.page = [(NSString *)param[@"page"] integerValue];
  
  MXMVenueSearch *api = [[MXMVenueSearch alloc] init];
  api.delegate = self;
  [api searchVenuesNearBy:opt];
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

@end
