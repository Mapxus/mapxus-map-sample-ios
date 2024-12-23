//
//  SearchBuildingGlobalViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/11.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <ProgressHUD.h>
#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "SearchBuildingGlobalViewController.h"
#import "SearchBuildingGlobalParamViewController.h"

@interface SearchBuildingGlobalViewController () <MXMBuildingSearchDelegate, MGLMapViewDelegate, Param>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapxusMap;
@end

@implementation SearchBuildingGlobalViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self layoutUI];
  MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
  configuration.defaultStyle = MXMStyleMAPXUS;
  self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
}

- (void)openParam {
  SearchBuildingGlobalParamViewController *vc = [[SearchBuildingGlobalParamViewController alloc] init];
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

#pragma mark - MXMBuildingSearchDelegate
- (void)buildingSearcher:(MXMBuildingSearch *)buildingSearcher didReceiveBuildingsWithResult:(MXMBuildingSearchResult *)searchResult error:(NSError *)error {
  if (searchResult) {
    if (self.mapView.annotations.count) {
      [self.mapView removeAnnotations:self.mapView.annotations];
    }
    
    NSMutableArray *anns = [NSMutableArray array];
    for (MXMBuilding *building in searchResult.buildings) {
      if (searchResult.total == 1) {
        [self.mapxusMap selectBuildingById:building.buildingId];
      }
      MGLPointAnnotation *ann = [[MGLPointAnnotation alloc] init];
      ann.coordinate = CLLocationCoordinate2DMake(building.labelCenter.latitude, building.labelCenter.longitude);
      ann.title = building.nameMap.Default;
      [anns addObject:ann];
    }
    [self.mapView addAnnotations:anns];
    if (searchResult.total > 1) {
      [self.mapView showAnnotations:anns animated:YES];
    }
    
    [ProgressHUD dismiss];
  } else {
    [ProgressHUD showError:NSLocalizedString(@"No buildings could be found", nil)];
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
  MXMBuildingGlobalSearchOption *opt = [[MXMBuildingGlobalSearchOption alloc] init];
  opt.keyword = param[@"keywords"];
  opt.offset = [(NSString *)param[@"offset"] integerValue];
  opt.page = [(NSString *)param[@"page"] integerValue];
  
  MXMBuildingSearch *api = [[MXMBuildingSearch alloc] init];
  api.delegate = self;
  [api searchBuildingsInGlobal:opt];
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
