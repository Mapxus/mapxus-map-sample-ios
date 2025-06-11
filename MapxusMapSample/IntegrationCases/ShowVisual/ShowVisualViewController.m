//
//  ShowVisualViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/12/20.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import <MapxusVisualSDK/MapxusVisualSDK.h>
#import <MapxusComponentKit/MapxusComponentKit.h>
#import "ShowVisualViewController.h"
#import "VisualDirectionAnnotationView.h"
#import "Macro.h"

@interface ShowVisualViewController () <MGLMapViewDelegate, MapxusMapDelegate, MXMVisualSearchDelegate, MXMVisualDelegate>

@property (nonatomic, strong) MapxusMap *mapxusMap;

@property (nonatomic, strong) MGLMapView *mglMapView;
@property (nonatomic, strong) UIButton *shrinkBtn;
@property (nonatomic, strong) UIButton *openBtn;
@property (nonatomic, strong) MXMVisualView *visualView;

@property (nonatomic, strong) MXMPointAnnotation *ann;
@property (nonatomic, strong) VisualDirectionAnnotationView *annView;
@property (nonatomic, strong) MXMVisualFlagPainter *painter;
@property (nonatomic, strong) MXMVisualSearch *searchApi;
@property (nonatomic, strong) NSString *currentVisualBuildingId;
@property (nonatomic, assign) BOOL isFrist;

@end

@implementation ShowVisualViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.view.backgroundColor = [UIColor whiteColor];
  self.isFrist = YES;
  
  MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
  configuration.floorId = PARAMCONFIGINFO.visualFloorId;;
  configuration.defaultStyle = MXMStyleMAPXUS;
  self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mglMapView configuration:configuration];
  self.mapxusMap.delegate = self;
  
  [self.mapxusMap.floorBar removeFromSuperview];
  [self.mapxusMap.buildingSelectButton removeFromSuperview];
  
  [self.view addSubview:self.mglMapView];
  [self.view addSubview:self.mapxusMap.floorBar];
  [self.view addSubview:self.mapxusMap.buildingSelectButton];
  [self.view addSubview:self.openBtn];
  [self.view addSubview:self.visualView];
  [self.visualView addSubview:self.shrinkBtn];
  
  [self _layoutViews];
  
  __weak typeof(self) weakSelf = self;
  self.painter.circleOnClickBlock = ^(NSDictionary * _Nonnull node) {
    if (weakSelf.ann == nil) {
      weakSelf.ann = [[MXMPointAnnotation alloc] init];
      [weakSelf.mapxusMap addMXMPointAnnotations:@[weakSelf.ann]];
    }
    weakSelf.ann.floorId = node[@"floorId"];
    weakSelf.ann.coordinate = CLLocationCoordinate2DMake([node[@"latitude"] doubleValue], [node[@"longitude"] doubleValue]);
    
    weakSelf.visualView.hidden = NO;
    if (weakSelf.isFrist) {
      weakSelf.isFrist = NO;
      [weakSelf.visualView loadVisualViewWithFristImg:node[@"key"]];
      //            [weakSelf.visualView deactivateBearing];
      [weakSelf.visualView bringSubviewToFront:weakSelf.shrinkBtn];
    } else {
      [weakSelf.visualView moveToKey:node[@"key"]];
    }
  };
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self.visualView unloadVisualView];
}

#pragma mark - action

- (void)openVisual:(UIButton *)sender
{
  sender.selected = !sender.isSelected;
  if (sender.isSelected) {
    self.currentVisualBuildingId = self.mapxusMap.selectedBuildingId;
    MXMVisualBuildingSearchOption *option = [[MXMVisualBuildingSearchOption alloc] init];
    option.buildingId = self.mapxusMap.selectedBuildingId;
    option.scope = MXMVisualSearchScopeDetail;
    [self.searchApi searchVisualDataInBuilding:option];
  } else {
    self.currentVisualBuildingId = nil;
    [self.painter cleanLayer];
    if (self.ann) {
      [self.mapxusMap removeMXMPointAnnotaions:@[self.ann]];
      self.ann = nil;
      self.annView = nil;
    }
    self.visualView.hidden = YES;
  }
}

- (void)showVisual:(UIButton *)sender
{
  sender.selected = !sender.isSelected;
  if (sender.isSelected) {
    CGRect buttonRect = self.visualView.frame;
    self.visualView.layer.cornerRadius = 0;
    self.visualView.layer.borderWidth = 0;
    self.mglMapView.layer.cornerRadius = 3;
    self.mglMapView.layer.borderWidth = 7.5;
    self.mglMapView.layer.borderColor = [UIColor whiteColor].CGColor;
    [UIView animateWithDuration:0.3 animations:^{
      self.visualView.frame = self.view.bounds;
      [self.visualView resize];
      self.mglMapView.frame = buttonRect;
    } completion:^(BOOL finished) {
      [self.view bringSubviewToFront:self.mglMapView];
      [self.mglMapView addSubview:self.shrinkBtn];
      self.mapxusMap.indoorControllerAlwaysHidden = YES;
      self.mglMapView.zoomLevel = 17;
    }];
  } else {
    CGRect buttonRect = self.mglMapView.frame;
    self.mglMapView.layer.cornerRadius = 0;
    self.mglMapView.layer.borderWidth = 0;
    self.visualView.layer.cornerRadius = 3;
    self.visualView.layer.borderWidth = 7.5;
    self.visualView.layer.borderColor = [UIColor whiteColor].CGColor;
    [UIView animateWithDuration:0.3 animations:^{
      self.mglMapView.frame = self.view.bounds;
      self.visualView.frame = buttonRect;
    } completion:^(BOOL finished) {
      [self.view bringSubviewToFront:self.openBtn];
      [self.view bringSubviewToFront:self.mapxusMap.floorBar];
      [self.view bringSubviewToFront:self.mapxusMap.buildingSelectButton];
      [self.view bringSubviewToFront:self.visualView];
      [self.visualView addSubview:self.shrinkBtn];
      self.mapxusMap.indoorControllerAlwaysHidden = NO;
      [self.visualView resize];
    }];
  }
}

#pragma mark - MGLMapViewDelegate

- (MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id<MGLAnnotation>)annotation
{
  if (annotation == self.ann) {
    VisualDirectionAnnotationView *imgView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"annImg"];
    if (imgView == nil) {
      imgView = [[VisualDirectionAnnotationView alloc] initWithReuseIdentifier:@"annImg"];
      self.annView = imgView;
    }
    double bearing = [self.visualView getBearing];
    [imgView changeRotate:bearing];
    return imgView;
  }
  return nil;
}

#pragma makr - MapxusMapDelegate

- (void)map:(MapxusMap *)map didChangeSelectedFloor:(id<MXMFloorProtocol>)floor inSelectedBuildingId:(NSString *)buildingId atSelectedVenueId:(NSString *)venueId
{
  self.visualView.hidden = YES;
  if ([self.currentVisualBuildingId isEqualToString:buildingId]) {
    [self.painter changeOnFloorId:floor.floorId];
  } else {
    if (self.openBtn.isSelected) {
      self.currentVisualBuildingId = buildingId;
      MXMVisualBuildingSearchOption *option = [[MXMVisualBuildingSearchOption alloc] init];
      option.buildingId = buildingId;
      option.scope = MXMVisualSearchScopeDetail;
      [self.searchApi searchVisualDataInBuilding:option];
    }
  }
}

#pragma mark - MXMVisualSearchAPIDelegate

- (void)onGetVisualDataInBuilding:(MXMVisualSearch *)searcher result:(NSArray *)list error:(NSError *)error
{
  NSMutableArray *arr = [NSMutableArray array];
  for (MXMNodeGroup *g in list) {
    for (MXMNode *n in g.nodes) {
      NSDictionary *nd = [n toJson];
      [arr addObject:nd];
    }
  }
  [self.painter renderFlagUsingNodes:arr];
  // Filter the current floor data
  [self.painter changeOnFloorId:self.mapxusMap.selectedFloor.floorId];
}


#pragma mark - MXMVisualDelegate

- (void)visualView:(MXMVisualView *)view didNodeChanged:(MXMNode *)node
{
  CLLocationCoordinate2D center = CLLocationCoordinate2DMake(node.latitude, node.longitude);
  self.ann.coordinate = center;
  [self.mglMapView setCenterCoordinate:center animated:YES];
}

- (void)visualView:(MXMVisualView *)view didBearingChanged:(double)bearing
{
  [self.annView changeRotate:bearing];
}

#pragma mark - private

- (void)_layoutViews
{
  self.mglMapView.frame = self.view.bounds;
  self.mglMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  CGFloat height = 0;
  if (@available(iOS 11.0, *)) {
    UIEdgeInsets safeArea = [[UIApplication sharedApplication] keyWindow].safeAreaInsets;
    height = safeArea.bottom;
  }
  self.visualView.frame = CGRectMake(10, self.view.frame.size.height-height-200, 105, 105);
  self.shrinkBtn.frame = self.visualView.bounds;
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapxusMap.floorBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:200]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapxusMap.floorBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapxusMap.buildingSelectButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.mapxusMap.floorBar attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapxusMap.buildingSelectButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mapxusMap.floorBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:-20]];
  
  [self.openBtn addConstraint:[NSLayoutConstraint constraintWithItem:self.openBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0 constant:48]];
  [self.openBtn addConstraint:[NSLayoutConstraint constraintWithItem:self.openBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0 constant:48]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.openBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.mapxusMap.floorBar attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.openBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mapxusMap.buildingSelectButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:-20]];
}

#pragma mark - getter and setter

- (MGLMapView *)mglMapView
{
  if (!_mglMapView) {
    _mglMapView = [[MGLMapView alloc] init];
    _mglMapView.delegate = self;
    _mglMapView.compassView.hidden = YES;
  }
  return _mglMapView;
}

- (UIButton *)openBtn
{
  if (!_openBtn) {
    _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _openBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_openBtn setImage:[UIImage imageNamed:@"visualMapTrigger"] forState:UIControlStateNormal];
    [_openBtn setImage:[UIImage imageNamed:@"visualMapTriggerHL"] forState:UIControlStateSelected];
    [_openBtn addTarget:self action:@selector(openVisual:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _openBtn;
}

- (MXMVisualView *)visualView
{
  if (!_visualView) {
    _visualView = [[MXMVisualView alloc] init];
    _visualView.clipsToBounds = YES;
    _visualView.delegate = self;
    _visualView.hidden = YES;
    _visualView.layer.cornerRadius = 3;
    _visualView.layer.borderWidth = 7.5;
    _visualView.layer.borderColor = [UIColor whiteColor].CGColor;
  }
  return _visualView;
}

- (UIButton *)shrinkBtn
{
  if (!_shrinkBtn) {
    _shrinkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shrinkBtn.backgroundColor = [UIColor clearColor];
    [_shrinkBtn addTarget:self action:@selector(showVisual:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _shrinkBtn;
}

- (MXMVisualSearch *)searchApi
{
  if (!_searchApi) {
    _searchApi = [[MXMVisualSearch alloc] init];
    _searchApi.delegate = self;
  }
  return _searchApi;
}

- (MXMVisualFlagPainter *)painter
{
  if (!_painter) {
    _painter = [[MXMVisualFlagPainter alloc] initWithMapView:self.mglMapView];
  }
  return _painter;
}

@end
