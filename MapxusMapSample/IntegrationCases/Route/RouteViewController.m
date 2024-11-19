//
//  RouteViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/23.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import <MapxusComponentKit/MapxusComponentKit.h>
#import "RouteViewController.h"
#import "MXMRouteLocationManager.h"
#import "ParamConfigInstance.h"
#import "InstructionListViewController.h"
#import "UIButton+StatusBackgroundColor.h"

@interface RouteViewController () <MapxusMapDelegate, MXMRouteSearchDelegate, MGLMapViewDelegate, TrackDelegate, MXMRouteShortenerDelegate>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *map;
@property (nonatomic, strong) UIButton *point1Btn;
@property (nonatomic, strong) UIButton *point2Btn;
@property (nonatomic, strong) UIButton *point3Btn;
@property (nonatomic, strong) UIButton *point4Btn;
@property (nonatomic, strong) UIButton *point5Btn;
@property (nonatomic, strong) UIStackView *pointsView;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *goButton;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UISegmentedControl *travelWaySegmented;
@property (nonatomic, strong) UIButton *instructionButton;

@property (nonatomic, strong) MXMPointAnnotation *point1Annotation;
@property (nonatomic, strong) MXMPointAnnotation *point2Annotation;
@property (nonatomic, strong) MXMPointAnnotation *point3Annotation;
@property (nonatomic, strong) MXMPointAnnotation *point4Annotation;
@property (nonatomic, strong) MXMPointAnnotation *point5Annotation;

@property (nonatomic, strong) NSArray<UIButton *> *buttons;
@property (nonatomic, strong) NSMutableArray<NSMutableDictionary *> *points;

@property (nonatomic, strong) MXMRoutePainter *painter;
@property (nonatomic, strong) MXMRouteLocationManager *locationManager;
@property (nonatomic, strong) MXMRouteSearchResult *currentResponse;
@property (nonatomic, assign) BOOL isEndOfNavigation;
@property (nonatomic, weak) id<RouteViewControllerDelegate> instructionDelegate;
@end

@implementation RouteViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self layoutUI];
  self.buttons = @[self.point1Btn, self.point2Btn, self.point3Btn, self.point4Btn, self.point5Btn];
  // Specify the scene initialization map
  MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
  configuration.floorId = PARAMCONFIGINFO.floorId_1;
  configuration.defaultStyle = MXMStyleMAPXUS;
  self.map = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
  self.map.selectorPosition = MXMSelectorPositionCenterRight;
  self.map.delegate = self;
  self.map.floorBar.isFolded = YES;
  
  // The painter help to draw the route line on the mapview
  self.painter = [[MXMRoutePainter alloc] initWithMapView:self.mapView];
  // Set route style
  MXMRouteStyle *style = [MXMRouteStyle defaultRouteStyle];
  MXMSymbolInfo *info1 = [[MXMSymbolInfo alloc] init];
  info1.icon = [UIImage imageNamed:@"start_marker"];
  MXMSymbolInfo *info2 = [[MXMSymbolInfo alloc] init];
  info2.icon = [UIImage imageNamed:@"ic_way_point"];
  MXMSymbolInfo *info3 = [[MXMSymbolInfo alloc] init];
  info3.icon = [UIImage imageNamed:@"end_marker"];
  style.waypointSymbols = @[info1, info2, info3];
  self.painter.routeStyle = style;
  // Set trackDelegate, callback to update map camera during navigation
  self.locationManager.trackDelegate = self;
  // Set delegate to redraw the shorter route line
  [self.locationManager setShorterDelegate:self];
  // Setting up a custom location manager
  self.mapView.locationManager = self.locationManager;
  self.mapView.showsUserLocation = YES;
  self.mapView.showsUserHeadingIndicator = YES;
}

- (void)pointOnClickAction:(UIButton *)sender {
  sender.selected = !sender.isSelected;
  for (UIButton *btn in self.buttons) {
    if (btn.tag != sender.tag) {
      btn.selected = NO;
    }
  }
  
  for (UIButton *btn in self.buttons) {
    [self btnTitleSet:btn];
  }
}

- (void)btnTitleSet:(UIButton *)sender {
  NSDictionary *dic = self.points[sender.tag-1];
  if (dic.count != 0) {
    MXMFloor *floor = dic[@"floor"];
    MXMGeoPoint *point = dic[@"point"];

    NSString *title = [NSString stringWithFormat:@"%.4f, %.4f ", point.latitude, point.longitude];
    if (floor) {
      title = [title stringByAppendingString:floor.code];
    }
    [sender setTitle:title forState:UIControlStateNormal];
  }
}

- (MXMWaypoint *)makePointFromDic:(NSDictionary *)dic {
  MXMFloor *floor = dic[@"floor"];
  MXMGeoPoint *point = dic[@"point"];
  return [MXMWaypoint createWaypointWithLatitude:point.latitude
                                       longitude:point.longitude
                                         floorId:floor.floorId];
}

- (void)showAlertTitle:(NSString *)title message:(NSString *)message {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                 message:message
                                                          preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
  [alert addAction:action];
  [self presentViewController:alert animated:YES completion:nil];
}

// Search a route with params
- (void)searchRouteAction:(UIButton *)sender {
  [self.painter cleanRoute];
  self.isEndOfNavigation = NO;
  
  NSMutableArray *list = [NSMutableArray array];
  
  NSDictionary *start = self.points[0];
  NSDictionary *end = self.points[1];
  if (start.count == 0 || end.count == 0) {
    [self showAlertTitle:@"Error" message:@"Please select start and end point!"];
    return;
  }
  
  for (int i=0; i<self.points.count; i++) {
    NSDictionary *dic = self.points[i];
    if (i == 0 || i == 1) { continue; }
    if (dic.count) {
      MXMWaypoint *nP = [self makePointFromDic:dic];
      [list addObject:nP];
    }
  }
  
  MXMWaypoint *startP = [self makePointFromDic:start];
  MXMWaypoint *endP = [self makePointFromDic:end];
  [list insertObject:startP atIndex:0];
  [list addObject:endP];
  
  
  MXMRouteSearchOption *option = [[MXMRouteSearchOption alloc] init];
  option.points = list;
  option.locale = [self searchLocalBySystem];
  switch (self.travelWaySegmented.selectedSegmentIndex) {
    case 0:
      option.vehicle = MXMFoot;
      break;
    case 1:
      option.vehicle = MXMWheelchair;
      break;
    case 2:
      option.vehicle = MXMEmergency;
      break;
    default:
      break;
  }
  
  MXMRouteSearch *searcher = [[MXMRouteSearch alloc] init];
  searcher.delegate = self;
  [searcher findRouteWithSearchOption:option];
}

- (MXMLocale)searchLocalBySystem {
  MXMLocale local = MXMEn;
  NSString *preferredLanguage = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
  if ([preferredLanguage containsString:@"en"]) {
    local = MXMEn;
  } else if ([preferredLanguage containsString:@"Hans"]) {
    local = MXMZh_Hans;
  } else if ([preferredLanguage containsString:@"Hant"]) {
    local = MXMZh_Hant;
  } else if ([preferredLanguage containsString:@"ja"]) {
    local = MXMJa;
  } else if ([preferredLanguage containsString:@"ko"]) {
    local = MXMKo;
  }
  return local;
}

- (void)navigationAction:(UIButton *)sender {
  sender.selected = !sender.isSelected;
  // If you are navigating, stop navigation.
  if (!sender.isSelected) {
    self.locationManager.isNavigation = NO;
    return;
  }
  // If there are no navigation routes, send an alert.
  if (self.currentResponse == nil) {
    sender.selected = !sender.isSelected;
    [self showAlertTitle:@"Warning" message:@"Please search the route first."];
    return;
  }
  // Hide the start marker point when starting navigation
  self.painter.routeStyle.isAddStartDash = NO;
  // Update navigation data
  [self.locationManager updatePath:self.currentResponse.paths.firstObject waypoints:self.currentResponse.waypoints];
  // Start to navigation
  self.locationManager.isNavigation = YES;
}

- (void)showInstructions {
  MXMPath *path = self.currentResponse.paths.firstObject;
  InstructionListViewController *vc = [[InstructionListViewController alloc] initWithInstructions:path.instructions distance:path.distance time:path.time];
  self.instructionDelegate = vc;
  [self presentViewController:vc animated:YES completion:nil];
}

- (void)setCamera:(CLLocationCoordinate2D)location heading:(CLLocationDirection)heading floorId:(NSString *)floorId zoomLevel:(double)zoomLevel {
  [self.map selectFloorById:floorId zoomMode:MXMZoomDisable edgePadding:UIEdgeInsetsZero];
  MGLMapCamera *old = self.mapView.camera;
  CLLocationDistance altitube = MGLAltitudeForZoomLevel(zoomLevel, old.pitch, location.latitude, self.mapView.frame.size);
  MGLMapCamera *newCamera = [MGLMapCamera cameraLookingAtCenterCoordinate:location fromEyeCoordinate:location eyeAltitude:altitube];
  if (heading == NAN) {
    newCamera.heading = old.heading;
  } else {
    newCamera.heading = heading;
  }
  [self.mapView setCamera:newCamera animated:YES];
}

- (void)layoutUI {
  [self.pointsView addArrangedSubview:self.point1Btn];
  [self.pointsView addArrangedSubview:self.point2Btn];
  [self.pointsView addArrangedSubview:self.point3Btn];
  [self.pointsView addArrangedSubview:self.point4Btn];
  [self.pointsView addArrangedSubview:self.point5Btn];
  
  [self.view addSubview:self.mapView];
  [self.view addSubview:self.pointsView];
  [self.view addSubview:self.boxView];
  [self.boxView addSubview:self.searchButton];
  [self.boxView addSubview:self.goButton];
  [self.boxView addSubview:self.travelWaySegmented];
  [self.boxView addSubview:self.instructionButton];
  
  [self.point1Btn.heightAnchor constraintEqualToConstant:40].active = YES;
  [self.point2Btn.heightAnchor constraintEqualToConstant:40].active = YES;
  [self.point3Btn.heightAnchor constraintEqualToConstant:40].active = YES;
  [self.point4Btn.heightAnchor constraintEqualToConstant:40].active = YES;
  [self.point5Btn.heightAnchor constraintEqualToConstant:40].active = YES;
  
  [self.mapView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
  [self.mapView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
  [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
  [self.mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
  
  [self.pointsView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20].active = YES;
  [self.pointsView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10].active = YES;
  [self.pointsView.trailingAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:-5].active = YES;
  
  [self.boxView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
  [self.boxView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
  if (@available(iOS 11.0, *)) {
    [self.boxView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.boxView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-85].active = YES;
  } else {
    // Fallback on earlier versions
    [self.boxView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.boxView.topAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-80].active = YES;
  }
  
  [self.travelWaySegmented.centerXAnchor constraintEqualToAnchor:self.boxView.centerXAnchor].active = YES;
  [self.travelWaySegmented.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:10].active = YES;
  
  [self.searchButton.widthAnchor constraintEqualToConstant:80].active = YES;
  [self.searchButton.heightAnchor constraintEqualToConstant:40].active = YES;
  [self.searchButton.centerXAnchor constraintEqualToAnchor:self.boxView.centerXAnchor].active = YES;
  [self.searchButton.topAnchor constraintEqualToAnchor:self.travelWaySegmented.bottomAnchor constant:10].active = YES;

  [self.instructionButton.widthAnchor constraintEqualToConstant:120].active = YES;
  [self.instructionButton.heightAnchor constraintEqualToConstant:40].active = YES;
  [self.instructionButton.trailingAnchor constraintEqualToAnchor:self.searchButton.leadingAnchor constant:-10].active = YES;
  [self.instructionButton.centerYAnchor constraintEqualToAnchor:self.searchButton.centerYAnchor].active = YES;

  [self.goButton.widthAnchor constraintEqualToConstant:80].active = YES;
  [self.goButton.heightAnchor constraintEqualToConstant:40].active = YES;
  [self.goButton.leadingAnchor constraintEqualToAnchor:self.searchButton.trailingAnchor constant:10].active = YES;
  [self.goButton.centerYAnchor constraintEqualToAnchor:self.searchButton.centerYAnchor].active = YES;

}

#pragma mark - TrackDelegate
- (void)excessiveDrift {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"You are seriously off course and will end navigation." preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *action = [UIAlertAction actionWithTitle:@"I know" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    self.locationManager.isNavigation = NO;
  }];
  [alert addAction:action];
  [self presentViewController:alert animated:YES completion:nil];
}

- (void)refreshTheAdsorptionLocation:(CLLocation *)location heading:(CLLocationDirection)heading floorId:(NSString *)floorId state:(MXMAdsorptionState)state fromActual:(CLLocation *)actual {
  [self setCamera:location.coordinate heading:heading floorId:floorId zoomLevel:self.mapView.zoomLevel];
}

#pragma mark - MXMRouteShortenerDelegate
- (void)routeShortener:(MXMRouteShortener *)shortener redrawingNewPath:(MXMPath *)path fromInstructionIndex:(NSUInteger)index {
  if (self.instructionDelegate && [self.instructionDelegate respondsToSelector:@selector(routeInstructionDidChange:)]) {
    [self.instructionDelegate routeInstructionDidChange:index];
  }
  if (!self.isEndOfNavigation) {
    
    MXMInstruction *lastInstruction;
    double distance = 0;
    for (MXMInstruction *inst in path.instructions) {
      distance += inst.distance;
      if (inst.sign == MXMReachedVia || inst.sign == MXMFinish) {
        lastInstruction = inst;
        break;
      }
    }
    
    BOOL isSameOutdoor = (lastInstruction.floorId == nil) && (self.locationManager.locationFloorId == nil);
    BOOL isSameSite = lastInstruction.floorId &&
    self.locationManager.locationFloorId &&
    [lastInstruction.floorId isEqualToString:self.locationManager.locationFloorId];
    
    if (path.distance < 3 && (isSameSite || isSameOutdoor)) {
      self.isEndOfNavigation = YES;
      self.currentResponse = nil;
      [self.painter cleanRoute];
      [self navigationAction:self.goButton]; // 模拟按下
    } else if (distance < 3 && (isSameSite || isSameOutdoor)) {
      [self showAlertTitle:@"Warning" message:@"You have arrived at the waypoint."];
    } else {
      // repaint
      [self.painter drawRouteWithPath:path];
      [self.painter changeOnVenue:self.map.selectedVenueId ordinal:self.map.selectedFloor.ordinal];
    }
  }
}

#pragma mark - MGLMapViewDelegate

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation
{
  MGLAnnotationImage *annImg = [mapView dequeueReusableAnnotationImageWithIdentifier:@"ic_start_point"];
  if (annImg == nil) {
    UIImage *image = [UIImage imageNamed:@"ic_start_point"];
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
    annImg = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:@"ic_start_point"];
  }
  return annImg;
}

#pragma mark - MapxusMapDelegate

- (void)map:(MapxusMap *)map didChangeSelectedFloor:(MXMFloor *)floor inSelectedBuildingId:(NSString *)buildingId atSelectedVenueId:(NSString *)venueId {
  // show different line on different scene
  [self.painter changeOnVenue:venueId ordinal:floor.ordinal];
}

/// Use two callbacks to cover all situations
- (void)map:(MapxusMap *)map didSingleTapOnBlank:(CLLocationCoordinate2D)coordinate atSite:(MXMSite *)site {
  [self didTappedAtCoordinate:coordinate onFloor:site.floor inBuilding:site.building];
}

- (void)map:(MapxusMap *)map didSingleTapOnPOI:(MXMGeoPOI *)poi atCoordinate:(CLLocationCoordinate2D)coordinate atSite:(MXMSite *)site {
  [self didTappedAtCoordinate:coordinate onFloor:site.floor inBuilding:site.building];
}
/// --end

- (void)didTappedAtCoordinate:(CLLocationCoordinate2D)coordinate onFloor:(nullable MXMFloor *)floor inBuilding:(nullable MXMGeoBuilding *)building
{
  NSMutableDictionary *dic;
  for (UIButton *btn in self.buttons) {
    if (btn.isSelected) {
      dic = self.points[btn.tag-1];
    }
  }
  
  if (!dic) {
    return;
  }
  
  dic[@"floor"] = floor;
  MXMGeoPoint *p = [[MXMGeoPoint alloc] init];
  p.latitude = coordinate.latitude;
  p.longitude = coordinate.longitude;
  dic[@"point"] = p;
  
  MXMPointAnnotation *ann = dic[@"ann"];
  if (ann == nil) {
    ann = [[MXMPointAnnotation alloc] init];
    ann.coordinate = coordinate;
    ann.floorId = floor.floorId;
    [self.map addMXMPointAnnotations:@[ann]];
    dic[@"ann"] = ann;
  } else {
    ann.coordinate = coordinate;
    ann.floorId = floor.floorId;
  }
  
}

#pragma mark - MXMRouteSearchDelegate

- (void)routeSearcher:(MXMRouteSearch *)routeSearcher didReceiveRouteResult:(MXMRouteSearchResult *)searchResult error:(NSError *)error {
  if (searchResult) {
    if (searchResult.paths.firstObject.instructions) {
      [self.instructionButton setCustomEnabled:YES];
    } else {
      [self.instructionButton setCustomEnabled:NO];
    }
    self.currentResponse = searchResult;
    [self.map removeMXMPointAnnotaions:self.map.MXMAnnotations];
    
    self.painter.routeStyle.isAddStartDash = YES;
    
    [self.painter updateFullPath:searchResult.paths.firstObject waypoints:searchResult.waypoints];
    [self.painter drawRouteWithPath:searchResult.paths.firstObject];
    NSString *key = self.painter.dto.keys.firstObject;
    MXMParagraph *paph = self.painter.dto.paragraphs[key];
    [self.map selectFloorById:paph.floorId zoomMode:MXMZoomDisable edgePadding:UIEdgeInsetsZero];
    [self.painter changeOnVenue:paph.venueId ordinal:paph.ordinal];
    [self.painter focusOnKeys:@[key] edgePadding:UIEdgeInsetsMake(130, 30, 110, 80)];
  } else {
    [self.instructionButton setCustomEnabled:NO];
    [self showAlertTitle:@"Warning" message:@"Sorry, I can't find the route."];
  }
}


#pragma mark - Lazy loading
- (MGLMapView *)mapView {
  if (!_mapView) {
    _mapView = [[MGLMapView alloc] init];
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    _mapView.delegate = self;
  }
  return _mapView;
}

- (UIButton *)point1Btn {
  if (!_point1Btn) {
    _point1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _point1Btn.translatesAutoresizingMaskIntoConstraints = NO;
    [_point1Btn setTitle:@"Start" forState:UIControlStateNormal];
    [_point1Btn setTitle:@"Tap screen for start" forState:UIControlStateSelected];
    [_point1Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_point1Btn addTarget:self action:@selector(pointOnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    _point1Btn.backgroundColor = [UIColor colorWithRed:100/255.0 green:149/255.0 blue:237/255.0 alpha:1];
    _point1Btn.layer.cornerRadius = 5;
    _point1Btn.titleLabel.font = [UIFont systemFontOfSize:14];
    _point1Btn.tag = 1;
  }
  return _point1Btn;
}

- (UIButton *)point2Btn {
  if (!_point2Btn) {
    _point2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _point2Btn.translatesAutoresizingMaskIntoConstraints = NO;
    [_point2Btn setTitle:@"End" forState:UIControlStateNormal];
    [_point2Btn setTitle:@"Tap screen for end" forState:UIControlStateSelected];
    [_point2Btn setTitleColor:[UIColor colorWithRed:100/255.0 green:149/255.0 blue:237/255.0 alpha:1] forState:UIControlStateNormal];
    [_point2Btn addTarget:self action:@selector(pointOnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    _point2Btn.backgroundColor = [UIColor whiteColor];
    _point2Btn.layer.cornerRadius = 5;
    _point2Btn.layer.borderWidth = 2;
    _point2Btn.layer.borderColor = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:0.4].CGColor;
    _point2Btn.titleLabel.font = [UIFont systemFontOfSize:14];
    _point2Btn.tag = 2;
  }
  return _point2Btn;
}

- (UIButton *)point3Btn {
  if (!_point3Btn) {
    _point3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _point3Btn.translatesAutoresizingMaskIntoConstraints = NO;
    [_point3Btn setTitle:@"waypoint 1" forState:UIControlStateNormal];
    [_point3Btn setTitle:@"Tap screen for point 1" forState:UIControlStateSelected];
    [_point3Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_point3Btn addTarget:self action:@selector(pointOnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    _point3Btn.backgroundColor = [UIColor colorWithRed:100/255.0 green:149/255.0 blue:237/255.0 alpha:1];
    _point3Btn.layer.cornerRadius = 5;
    _point3Btn.titleLabel.font = [UIFont systemFontOfSize:14];
    _point3Btn.tag = 3;
  }
  return _point3Btn;
}

- (UIButton *)point4Btn {
  if (!_point4Btn) {
    _point4Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _point4Btn.translatesAutoresizingMaskIntoConstraints = NO;
    [_point4Btn setTitle:@"waypoint 2" forState:UIControlStateNormal];
    [_point4Btn setTitle:@"Tap screen for point 2" forState:UIControlStateSelected];
    [_point4Btn setTitleColor:[UIColor colorWithRed:100/255.0 green:149/255.0 blue:237/255.0 alpha:1] forState:UIControlStateNormal];
    [_point4Btn addTarget:self action:@selector(pointOnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    _point4Btn.backgroundColor = [UIColor whiteColor];
    _point4Btn.layer.cornerRadius = 5;
    _point4Btn.layer.borderWidth = 2;
    _point4Btn.layer.borderColor = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:0.4].CGColor;
    _point4Btn.titleLabel.font = [UIFont systemFontOfSize:14];
    _point4Btn.tag = 4;
  }
  return _point4Btn;
}

- (UIButton *)point5Btn {
  if (!_point5Btn) {
    _point5Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _point5Btn.translatesAutoresizingMaskIntoConstraints = NO;
    [_point5Btn setTitle:@"waypoint 3" forState:UIControlStateNormal];
    [_point5Btn setTitle:@"Tap screen for point 3" forState:UIControlStateSelected];
    [_point5Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_point5Btn addTarget:self action:@selector(pointOnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    _point5Btn.backgroundColor = [UIColor colorWithRed:100/255.0 green:149/255.0 blue:237/255.0 alpha:1];
    _point5Btn.layer.cornerRadius = 5;
    _point5Btn.titleLabel.font = [UIFont systemFontOfSize:14];
    _point5Btn.tag = 5;
  }
  return _point5Btn;
}

- (UIStackView *)pointsView {
  if (!_pointsView) {
    _pointsView = [[UIStackView alloc] init];
    _pointsView.translatesAutoresizingMaskIntoConstraints = NO;
    _pointsView.axis = UILayoutConstraintAxisVertical;
    _pointsView.alignment = UIStackViewAlignmentFill;
    _pointsView.spacing = 10;
  }
  return _pointsView;
}

- (UIButton *)searchButton {
  if (!_searchButton) {
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_searchButton setTitle:@"Search" forState:UIControlStateNormal];
    _searchButton.backgroundColor = [UIColor colorWithRed:80/255.0 green:175/255.0 blue:243/255.0 alpha:1.0];
    _searchButton.layer.cornerRadius = 5;
    [_searchButton addTarget:self action:@selector(searchRouteAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _searchButton;
}

- (UIButton *)goButton {
  if (!_goButton) {
    _goButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _goButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_goButton setTitle:@"Go" forState:UIControlStateNormal];
    [_goButton setTitle:@"Stop" forState:UIControlStateSelected];
    _goButton.backgroundColor = [UIColor colorWithRed:80/255.0 green:175/255.0 blue:243/255.0 alpha:1.0];
    _goButton.layer.cornerRadius = 5;
    [_goButton addTarget:self action:@selector(navigationAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _goButton;
}

- (UIView *)boxView {
  if (!_boxView) {
    _boxView = [[UIView alloc] init];
    _boxView.translatesAutoresizingMaskIntoConstraints = NO;
    _boxView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
  }
  return _boxView;
}

- (UISegmentedControl *)travelWaySegmented {
  if (!_travelWaySegmented) {
    _travelWaySegmented = [[UISegmentedControl alloc] initWithItems:@[@"foot", @"wheelchair", @"emergency"]];
    _travelWaySegmented.translatesAutoresizingMaskIntoConstraints = NO;
    _travelWaySegmented.selectedSegmentIndex = 0;
  }
  return _travelWaySegmented;
}

- (UIButton *)instructionButton {
  if (!_instructionButton) {
    _instructionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _instructionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_instructionButton setTitle:@"Instructions" forState:UIControlStateNormal];
    [_instructionButton setBackgroundColor:[UIColor colorWithRed:80/255.0 green:175/255.0 blue:243/255.0 alpha:1.0] state:UIControlStateNormal];
    [_instructionButton setBackgroundColor:[UIColor grayColor] state:UIControlStateDisabled];
    _instructionButton.layer.cornerRadius = 5;
    [_instructionButton setCustomEnabled:NO];
    [_instructionButton addTarget:self action:@selector(showInstructions) forControlEvents:UIControlEventTouchUpInside];
  }
  return _instructionButton;
}

- (NSMutableArray<NSMutableDictionary *> *)points {
  if (!_points) {
    _points = [NSMutableArray arrayWithCapacity:5];
    for (int i=0; i<5; i++) {
      [_points addObject:[[NSMutableDictionary alloc] init]];
    }
  }
  return _points;
}

- (MXMRouteLocationManager *)locationManager {
  if (!_locationManager) {
    _locationManager = [[MXMRouteLocationManager alloc] init];
  }
  return _locationManager;
}

@end
