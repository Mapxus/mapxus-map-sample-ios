//
//  SearchPOIInBoundViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/11.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <ProgressHUD.h>
#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "SearchPOIInBoundViewController.h"
#import "SearchPOIInBoundParamViewController.h"
#import "ParamConfigInstance.h"

@interface SearchPOIInBoundViewController () <MGLMapViewDelegate, MXMPoiSearchDelegate, Param>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapxusMap;
@property (strong, nonatomic) MGLPolygon *polygon;
@end

@implementation SearchPOIInBoundViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self layoutUI];
  
  MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
  configuration.defaultStyle = MXMStyleMAPXUS;
  self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
}

- (void)openParam {
  SearchPOIInBoundParamViewController *vc = [[SearchPOIInBoundParamViewController alloc] init];
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

#pragma mark - MXMPoiSearchDelegate
- (void)poiSearcher:(MXMPoiSearch *)poiSearcher didReceivePoisWithResult:(MXMPoiSearchResult *)searchResult error:(NSError *)error {
  if (searchResult) {
    if (self.mapxusMap.MXMAnnotations.count) {
      [self.mapxusMap removeMXMPointAnnotaions:self.mapxusMap.MXMAnnotations];
    }
    [self.mapView addAnnotation:self.polygon];
    
    NSMutableArray *anns = [NSMutableArray array];
    for (MXMPOI *poi in searchResult.pois) {
      MXMPointAnnotation *ann = [[MXMPointAnnotation alloc] init];
      ann.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
      ann.title = poi.nameMap.Default;
      ann.subtitle = [poi.floor.name stringByAppendingString:@"层"];
      ann.floorId = poi.floor.floorId;
      [anns addObject:ann];
    }
    [self.mapxusMap addMXMPointAnnotations:anns];
    if (searchResult.pois.count == 1) {
      MXMPOI *firstPoi = searchResult.pois.firstObject;
      [self.mapxusMap selectFloorById:firstPoi.floor.floorId];
    } else if (searchResult.pois.count > 1) {
      [self.mapView showAnnotations:anns animated:YES];
    }
    [ProgressHUD dismiss];
  } else {
    [ProgressHUD showError:NSLocalizedString(@"No POI could be found", nil)];
  }
}


#pragma mark - MGLMapViewDelegate
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
  return YES;
}

- (UIColor *)mapView:(MGLMapView *)mapView fillColorForPolygonAnnotation:(MGLPolygon *)annotation {
  return [UIColor grayColor];
}

- (CGFloat)mapView:(MGLMapView *)mapView alphaForShapeAnnotation:(MGLShape *)annotation {
  return 0.5;
}

#pragma mark - Param
- (void)completeParamConfiguration:(NSDictionary *)param {
  double min_latitude = [(NSString *)param[@"min_latitude"] doubleValue];
  double min_longitude = [(NSString *)param[@"min_longitude"] doubleValue];
  double max_latitude = [(NSString *)param[@"max_latitude"] doubleValue];
  double max_longitude = [(NSString *)param[@"max_longitude"] doubleValue];
  
  CLLocationCoordinate2D coordinates[] = {
    CLLocationCoordinate2DMake(min_latitude, min_longitude),
    CLLocationCoordinate2DMake(max_latitude, min_longitude),
    CLLocationCoordinate2DMake(max_latitude, max_longitude),
    CLLocationCoordinate2DMake(min_latitude, max_longitude),
    CLLocationCoordinate2DMake(min_latitude, min_longitude),
  };
  NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);
  self.polygon = [MGLPolygon polygonWithCoordinates:coordinates count:numberOfCoordinates];
  
  [ProgressHUD show];
  MXMBoundingBox *box = [[MXMBoundingBox alloc] init];
  box.min_latitude = min_latitude;
  box.min_longitude = min_longitude;
  box.max_latitude = max_latitude;
  box.max_longitude = max_longitude;
  
  MXMPoiBboxSearchOption *opt = [[MXMPoiBboxSearchOption alloc] init];
  opt.keyword = param[@"keywords"];
  opt.orderBy = [(NSNumber *)param[@"orderBy"] unsignedIntegerValue];
  opt.category = param[@"category"];
  opt.excludeCategories = param[@"excludeCategories"];
  opt.bbox = box;
  opt.offset = [(NSString *)param[@"offset"] integerValue];
  opt.page = [(NSString *)param[@"page"] integerValue];
  
  MXMPoiSearch *api = [[MXMPoiSearch alloc] init];
  api.delegate = self;
  [api searchPoisInBoundingBox:opt];
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
