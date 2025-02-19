//
//  RoutePainterSettingViewController.m
//  MapxusMapSample
//
//  Created by guochenghao on 2024/11/12.
//  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "RoutePainterSettingViewController.h"
#import "RouteLineSettingViewController.h"
#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "ParamConfigInstance.h"
#import <MapxusComponentKit/MapxusComponentKit.h>
#import "Macro.h"

@interface RoutePainterSettingViewController () <MGLMapViewDelegate, MXMRouteSearchDelegate, MapxusMapDelegate, Param>
@property (nonatomic, strong) MGLMapView *mapView; // Render map using MGLMapView
@property (nonatomic, strong) MapxusMap *mapxusMap; // MapxusMap control and listen of the indoor map.
@property (nonatomic, strong) MXMRoutePainter *painter;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UISegmentedControl *markerControl;
@property (nonatomic, strong) UISegmentedControl *patternControl;
@property (nonatomic, strong) UIButton *lineSettingButton;

@property (nonatomic, strong) MXMRouteSearchResult *searchResult;
@end

@implementation RoutePainterSettingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self layoutUI];
  // Create MapxusMap instance with MGLMapView instance
  MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
  configuration.defaultStyle = MXMStyleMAPXUS;
  self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
  self.mapxusMap.delegate = self;
  self.mapxusMap.selectorPosition = MXMSelectorPositionCenterRight;
  // Create MXMRoutePainter instance with MGLMapView instance
  self.painter = [[MXMRoutePainter alloc] initWithMapView:self.mapView];
  [self searchRoute];
}

- (void)layoutUI {
  [self.view addSubview:self.mapView];
  [self.view addSubview:self.boxView];
  [self.boxView addSubview:self.markerControl];
  [self.boxView addSubview:self.patternControl];
  [self.boxView addSubview:self.lineSettingButton];
  
  [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
  [self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
  [self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
  [self.mapView.bottomAnchor constraintEqualToAnchor:self.boxView.topAnchor].active = YES;
  
  [self.boxView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
  [self.boxView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
  [self.boxView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
  if (@available(iOS 11.0, *)) {
    [self.boxView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-200].active = YES;
  } else {
    [self.boxView.topAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-200].active = YES;
  }
  
  [self.markerControl.centerXAnchor constraintEqualToAnchor:self.boxView.centerXAnchor].active = YES;
  [self.markerControl.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:moduleSpace].active = YES;
  [self.markerControl.heightAnchor constraintEqualToConstant:40].active = YES;
  
  [self.patternControl.centerXAnchor constraintEqualToAnchor:self.boxView.centerXAnchor].active = YES;
  [self.patternControl.topAnchor constraintEqualToAnchor:self.markerControl.bottomAnchor constant:moduleSpace].active = YES;
  [self.patternControl.heightAnchor constraintEqualToConstant:40].active = YES;
  
  [self.lineSettingButton.topAnchor constraintEqualToAnchor:self.patternControl.bottomAnchor constant:moduleSpace].active = YES;
  [self.lineSettingButton.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:60].active = YES;
  [self.lineSettingButton.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-60].active = YES;
  [self.lineSettingButton.heightAnchor constraintEqualToConstant:40].active = YES;
}

- (void)searchRoute {
  MXMWaypoint *p1 = [MXMWaypoint createWaypointWithLatitude:PARAMCONFIGINFO.routeStylePoint1_lat longitude:PARAMCONFIGINFO.routeStylePoint1_lon floorId:nil];
  MXMWaypoint *p2 = [MXMWaypoint createWaypointWithLatitude:PARAMCONFIGINFO.routeStylePoint2_lat longitude:PARAMCONFIGINFO.routeStylePoint2_lon floorId:PARAMCONFIGINFO.routeStylePoint2_floorId];
  MXMWaypoint *p3 = [MXMWaypoint createWaypointWithLatitude:PARAMCONFIGINFO.routeStylePoint3_lat longitude:PARAMCONFIGINFO.routeStylePoint3_lon floorId:PARAMCONFIGINFO.routeStylePoint3_floorId];
  
  MXMRouteSearchOption *option = [[MXMRouteSearchOption alloc] init];
  option.points = @[p1, p2, p3];
  option.locale = MXMEn;
  option.vehicle = MXMFoot;
  
  MXMRouteSearch *searcher = [[MXMRouteSearch alloc] init];
  searcher.delegate = self;
  [searcher findRouteWithSearchOption:option];
}

- (void)showAlertTitle:(NSString *)title message:(NSString *)message {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                 message:message
                                                          preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
  [alert addAction:action];
  [self presentViewController:alert animated:YES completion:nil];
}

- (void)markerControlOnChange:(UISegmentedControl *)sender {
  switch (sender.selectedSegmentIndex) {
    case 0:
      self.painter.routeStyle.waypointSymbols = nil;
      break;
    case 1:
    {
      MXMSymbolInfo *start = [[MXMSymbolInfo alloc] init];
      start.icon = [UIImage imageNamed:@"new_start_point"];
      MXMSymbolInfo *center = [[MXMSymbolInfo alloc] init];
      center.icon = [UIImage imageNamed:@"new_way_point"];
      MXMSymbolInfo *end = [[MXMSymbolInfo alloc] init];
      end.icon = [UIImage imageNamed:@"new_end_point"];
      self.painter.routeStyle.waypointSymbols = @[start, center, end];
    }
      break;
    default:
      break;
  }
}

- (void)patternControlOnChange:(UISegmentedControl *)sender {
  switch (sender.selectedSegmentIndex) {
    case 0:
      self.painter.routeStyle.lineSymbol = nil;
      break;
    case 1:
    {
      MXMSymbolInfo *pattern = [[MXMSymbolInfo alloc] init];
      pattern.icon = [UIImage imageNamed:@"new_pattern"];
      self.painter.routeStyle.lineSymbol = pattern;
    }
      break;
    default:
      break;
  }
}

- (void)lineSettingButtonOnClick:(UIButton *)sender {
  RouteLineSettingViewController *vc = [[RouteLineSettingViewController alloc] init];
  vc.delegate = self;
  [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - Param
- (void)completeParamConfiguration:(NSDictionary *)param {
  NSString *inactiveLineOpacity = param[@"inactiveLineOpacity"];
  NSString *outdoorLineOpacity = param[@"outdoorLineOpacity"];
  NSString *indoorLineColor = param[@"indoorLineColor"];
  NSString *outdoorLineColor = param[@"outdoorLineColor"];
  NSString *dashLineColor = param[@"dashLineColor"];
  NSString *lineWidth = param[@"lineWidth"];
  NSString *dashLineWidth = param[@"dashLineWidth"];
  
  self.painter.routeStyle.inactiveLineOpacity = @(inactiveLineOpacity.floatValue);
  self.painter.routeStyle.outdoorLineOpacity = @(outdoorLineOpacity.floatValue);
  self.painter.routeStyle.indoorLineColor = [self colorWithHexString:indoorLineColor];
  self.painter.routeStyle.outdoorLineColor = [self colorWithHexString:outdoorLineColor];
  self.painter.routeStyle.dashedLineColor = [self colorWithHexString:dashLineColor];
  self.painter.routeStyle.lineWidth = [NSExpression expressionForConstantValue:@(lineWidth.integerValue)];
  self.painter.routeStyle.dashedLineWidth = [NSExpression expressionForConstantValue:@(dashLineWidth.integerValue)];
}

- (UIColor *)colorWithHexString:(NSString *)hexString {
  NSString *cleanedString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
  unsigned int hexValue;
  NSScanner *scanner = [NSScanner scannerWithString:cleanedString];
  [scanner scanHexInt:&hexValue];
  
  CGFloat alpha = 1.0;
  CGFloat red = ((hexValue & 0xFF000000) >> 24) / 255.0;
  CGFloat green = ((hexValue & 0x00FF0000) >> 16) / 255.0;
  CGFloat blue = ((hexValue & 0x0000FF00) >> 8) / 255.0;
  
  if (cleanedString.length == 8) {
    alpha = (hexValue & 0x000000FF) / 255.0;
  }
  
  return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#pragma mark - MapxusMapDelegate

- (void)map:(MapxusMap *)map didChangeSelectedFloor:(MXMFloor *)floor inSelectedBuildingId:(NSString *)buildingId atSelectedVenueId:(NSString *)venueId {
  [self.painter changeOnVenue:venueId ordinal:floor.ordinal];
}

#pragma mark - MXMRouteSearchDelegate

- (void)routeSearcher:(MXMRouteSearch *)routeSearcher didReceiveRouteResult:(MXMRouteSearchResult *)searchResult error:(NSError *)error {
  if (searchResult) {
    self.searchResult = searchResult;
    [self.painter updateFullPath:searchResult.paths.firstObject waypoints:searchResult.waypoints];
    [self.painter drawRouteWithPath:searchResult.paths.firstObject];
    NSString *key = self.painter.dto.keys.firstObject;
    MXMParagraph *paph = self.painter.dto.paragraphs[key];
    [self.mapxusMap selectFloorById:paph.floorId zoomMode:MXMZoomDisable edgePadding:UIEdgeInsetsZero];
    [self.painter changeOnVenue:paph.venueId ordinal:paph.ordinal];
    [self.painter focusOnKeys:@[key] edgePadding:UIEdgeInsetsMake(130, 30, 110, 80)];
  } else {
    [self showAlertTitle:@"Warning" message:@"Sorry, I can't find the route."];
  }
}

#pragma mark - Lazy loading
- (MGLMapView *)mapView {
  if (!_mapView) {
    _mapView = [[MGLMapView alloc] init];
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(PARAMCONFIGINFO.center_latitude, PARAMCONFIGINFO.center_longitude);
    _mapView.zoomLevel = 18;
    // Regardless of whether the callback method of MGLMapViewDelegate is implemented or not, the delegate must be set.
    _mapView.delegate = self;
  }
  return _mapView;
}

- (UIView *)boxView {
  if (!_boxView) {
    _boxView = [[UIView alloc] init];
    _boxView.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _boxView;
}

- (UISegmentedControl *)markerControl {
  if (!_markerControl) {
    _markerControl = [[UISegmentedControl alloc] initWithItems:@[@"Default Marker", @"Sample New Marker"]];
    _markerControl.translatesAutoresizingMaskIntoConstraints = NO;
    _markerControl.selectedSegmentIndex = 0;
    [_markerControl addTarget:self action:@selector(markerControlOnChange:) forControlEvents:UIControlEventValueChanged];
  }
  return _markerControl;
}

- (UISegmentedControl *)patternControl {
  if (!_patternControl) {
    _patternControl = [[UISegmentedControl alloc] initWithItems:@[@"Default Pattern", @"Sample New Pattern"]];
    _patternControl.translatesAutoresizingMaskIntoConstraints = NO;
    _patternControl.selectedSegmentIndex = 0;
    [_patternControl addTarget:self action:@selector(patternControlOnChange:) forControlEvents:UIControlEventValueChanged];
  }
  return _patternControl;
}

- (UIButton *)lineSettingButton {
  if (!_lineSettingButton) {
    _lineSettingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _lineSettingButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_lineSettingButton setTitle:@"Route Display Setting" forState:UIControlStateNormal];
    [_lineSettingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _lineSettingButton.backgroundColor = [UIColor colorWithRed:80/255.0 green:175/255.0 blue:243/255.0 alpha:1.0];
    [_lineSettingButton addTarget:self action:@selector(lineSettingButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _lineSettingButton.layer.cornerRadius = 5;
  }
  return _lineSettingButton;
}

@end
