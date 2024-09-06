//
//  SearchCategoryInBoundViewController.m
//  MapxusMapSample
//
//  Created by guochenghao on 2024/9/4.
//  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "SearchCategoryInBoundViewController.h"
#import "SearchCategoryInBoundParamViewController.h"
#import "SearchCategoryInBoundResultViewController.h"

#import <ProgressHUD.h>
#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "ParamConfigInstance.h"


@interface SearchCategoryInBoundViewController ()<MGLMapViewDelegate, MXMCategorySearchDelegate, Param>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapxusMap;
@property (strong, nonatomic) MGLPolygon *polygon;
@property (nonatomic, strong) MXMCategorySearch *categorySearcher;
@end

@implementation SearchCategoryInBoundViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self layoutUI];
  MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
  configuration.defaultStyle = MXMStyleMAPXUS;
  self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
}

- (void)openParam {
  SearchCategoryInBoundParamViewController *vc = [[SearchCategoryInBoundParamViewController alloc] init];
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

#pragma mark - MXMCategorySearchDelegate
- (void)categorySearcher:(MXMCategorySearch *)categorySearcher
  didReceivePoiCategoryInBoundingBoxWithResult:(MXMPoiCategoryBboxSearchResult *)searchResult
                   error:(NSError *)error {
  if (self.mapView.annotations.count) {
    [self.mapView removeAnnotations:self.mapView.annotations];
  }
  [self.mapView addAnnotation:self.polygon];
  [self.mapView showAnnotations:@[self.polygon] animated:YES];
  
  if (searchResult) {
    SearchCategoryInBoundResultViewController *vc = [[SearchCategoryInBoundResultViewController alloc] init];
    vc.categorys = searchResult.categoryVenueInfoExResults;
    [self presentViewController:vc animated:YES completion:nil];
    [ProgressHUD dismiss];
  } else {
    [ProgressHUD showError:NSLocalizedString(@"No category could be found", nil)];
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
  
  MXMPoiCategoryBboxSearchOption *option = [[MXMPoiCategoryBboxSearchOption alloc] init];
  option.keyword = param[@"keyword"];
  option.bbox = box;
  
  [self.categorySearcher searchPoiCategoriesInBoundingBox:option];
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

- (MXMCategorySearch *)categorySearcher {
  if (!_categorySearcher) {
    _categorySearcher = [[MXMCategorySearch alloc] init];
    _categorySearcher.delegate = self;
  }
  return _categorySearcher;
}


@end
