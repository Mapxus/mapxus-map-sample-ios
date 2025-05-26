//
//  FocusOnIndoorSceneViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/17.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "Param.h"
#import "FocusOnIndoorSceneViewController.h"
#import "FocusOnIndoorSceneParamViewController.h"

@interface FocusOnIndoorSceneViewController () <MGLMapViewDelegate, Param>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapxusMap;
@end

@implementation FocusOnIndoorSceneViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Params" style:UIBarButtonItemStylePlain target:self action:@selector(openParam)];
  [self layoutUI];
  MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
  configuration.defaultStyle = MXMStyleMAPXUS;
  self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
}

- (void)openParam {
  FocusOnIndoorSceneParamViewController *vc = [[FocusOnIndoorSceneParamViewController alloc] init];
  vc.delegate = self;
  [self presentViewController:vc animated:YES completion:nil];
}

- (void)layoutUI {
  [self.view addSubview:self.mapView];
  
  [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
  [self.mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
  [self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
  [self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
}

#pragma mark - Param
- (void)completeParamConfiguration:(NSDictionary *)param {
  __weak typeof(self) weakSelf = self;
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Focus on the scene with the params now?" preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    // Floor ID in focus
    NSString *floorId = param[@"floorId"];
    // sharedFloor ID in focus
    NSString *sharedFloorId = param[@"sharedFloorId"];
    // Building ID in focus
    NSString *buildingId = param[@"buildingId"];
    // Venue ID in focus
    NSString *venueId = param[@"venueId"];
    // Animation method during focus
    MXMZoomMode zoomMode = [(NSNumber *)param[@"zoomMode"] integerValue];
    // Margins when focusing on a scene, effective when zoomMode is not MXMZoomDisable.
    UIEdgeInsets padding = UIEdgeInsetsMake([(NSString *)param[@"edgeTop"] floatValue],
                                            [(NSString *)param[@"edgeLeft"] floatValue],
                                            [(NSString *)param[@"edgeBottom"] floatValue],
                                            [(NSString *)param[@"edgeRight"] floatValue]);
    if (floorId) {
      [weakSelf.mapxusMap selectFloorById:floorId zoomMode:zoomMode edgePadding:padding];
      return;
    }
    if (buildingId) {
      [weakSelf.mapxusMap selectBuildingById:buildingId zoomMode:zoomMode edgePadding:padding];
      return;
    }
    if(sharedFloorId){
      [weakSelf.mapxusMap selectSharedFloorById:sharedFloorId zoomMode:zoomMode edgePadding:padding];
      return;
    }
    if (venueId) {
      [weakSelf.mapxusMap selectVenueById:venueId zoomMode:zoomMode edgePadding:padding];
      return;
    }
    
    
  }];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
  
  [alert addAction:okAction];
  [alert addAction:cancelAction];
  [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Lazy loading
- (MGLMapView *)mapView {
  if (!_mapView) {
    _mapView = [[MGLMapView alloc] init];
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(PARAMCONFIGINFO.center_latitude, PARAMCONFIGINFO.center_longitude);
    _mapView.zoomLevel = 17;
    _mapView.delegate = self;
  }
  return _mapView;
}

@end
