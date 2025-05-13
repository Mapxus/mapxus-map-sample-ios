//
//  SearchPOIByIDViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/22.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <ProgressHUD.h>
#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "SearchPOIByIDViewController.h"
#import "SearchPOIByIDParamViewController.h"
#import "ParamConfigInstance.h"

@interface SearchPOIByIDViewController () <MGLMapViewDelegate, MXMPoiSearchDelegate, Param>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapxusMap;
@end

@implementation SearchPOIByIDViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self layoutUI];
  
  MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
  configuration.defaultStyle = MXMStyleMAPXUS;
  self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
}

- (void)openParam {
  SearchPOIByIDParamViewController *vc = [[SearchPOIByIDParamViewController alloc] init];
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
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation
{
  return YES;
}

#pragma mark - Param
- (void)completeParamConfiguration:(NSDictionary *)param {
  [ProgressHUD show];
  MXMPoiIdSearchOption *opt = [[MXMPoiIdSearchOption alloc] init];
  opt.poiIds = param[@"POIIds"];
  
  MXMPoiSearch *api = [[MXMPoiSearch alloc] init];
  api.delegate = self;
  [api searchPoisById:opt];
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
