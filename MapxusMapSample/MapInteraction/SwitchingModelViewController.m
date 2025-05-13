//
//  SwitchingModelViewController.m
//  MapxusMapSample
//
//  Created by guochenghao on 2023/6/20.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "SwitchingModelViewController.h"
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "Macro.h"

@interface SwitchingModelViewController () <MGLMapViewDelegate>

@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapxusMap;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIButton *floorSwitchModeButton;
@property (nonatomic, strong) UISwitch *maskModeSwitch;
@property (nonatomic, strong) UILabel *maskModeTip;

@end

@implementation SwitchingModelViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self layoutUI];
  MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
  configuration.defaultStyle = MXMStyleMAPXUS;
  self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
}

- (void)changeSwitchMode:(UIButton *)sender {
  __weak typeof(self) weakSelf = self;
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
  UIAlertAction *venueAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Switching By Venue", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    //weakSelf.mapxusMap.floorSwitchMode = MXMSwitchedByVenue;
  }];
//  UIAlertAction *buildingAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Switching By Building", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//    weakSelf.mapxusMap.floorSwitchMode = MXMSwitchedByBuilding;
//  }];
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:(UIAlertActionStyleCancel) handler:nil];
  
  [alert addAction:venueAction];
  //[alert addAction:buildingAction];
  [alert addAction:cancelAction];
  
  if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    UIPopoverPresentationController *popoverPresentCtr = alert.popoverPresentationController;
    popoverPresentCtr.sourceView = sender;
  }
  [self presentViewController:alert animated:YES completion:nil];
}

- (void)changeMaskModeSwitch:(UISwitch *)sender {
    if (sender.isOn == YES) {
        // When the center of the map changes, the building in the center of the map is automatically selected.
        self.mapxusMap.maskNonSelectedSite = YES;
    } else {
        // Does not automatically switch the selected building when the map center is changed.
        self.mapxusMap.maskNonSelectedSite = NO;
    }
}

- (void)layoutUI {
  [self.view addSubview:self.mapView];
  [self.view addSubview:self.boxView];
  [self.boxView addSubview:self.floorSwitchModeButton];
  [self.boxView addSubview:self.maskModeSwitch];
  [self.boxView addSubview:self.maskModeTip];
  
  [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
  [self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
  [self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
  [self.mapView.bottomAnchor constraintEqualToAnchor:self.boxView.topAnchor].active = YES;
  
  [self.boxView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
  [self.boxView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
  [self.boxView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
  if (@available(iOS 11.0, *)) {
    [self.boxView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-70].active = YES;
  } else {
    [self.boxView.topAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-70].active = YES;
  }
  
  [self.floorSwitchModeButton.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:moduleSpace].active = YES;
  [self.floorSwitchModeButton.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:10].active = YES;
  [self.floorSwitchModeButton.widthAnchor constraintEqualToConstant:170].active = YES;
  [self.floorSwitchModeButton.heightAnchor constraintEqualToConstant:40].active = YES;
  
  [self.maskModeSwitch.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:moduleSpace].active = YES;
  [self.maskModeSwitch.leadingAnchor constraintEqualToAnchor:self.boxView.centerXAnchor constant:10].active = YES;
  
  [self.maskModeTip.leadingAnchor constraintEqualToAnchor:self.boxView.centerXAnchor constant:50 + innerSpace + moduleSpace].active = YES;
  [self.maskModeTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-innerSpace].active = YES;
  [self.maskModeTip.centerYAnchor constraintEqualToAnchor:self.maskModeSwitch.centerYAnchor].active = YES;
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

- (UIView *)boxView {
  if (!_boxView) {
    _boxView = [[UIView alloc] init];
    _boxView.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _boxView;
}

- (UIButton *)floorSwitchModeButton {
  if (!_floorSwitchModeButton) {
    _floorSwitchModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _floorSwitchModeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_floorSwitchModeButton setTitle:@"Floor switch Mode" forState:UIControlStateNormal];
    [_floorSwitchModeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _floorSwitchModeButton.backgroundColor = [UIColor colorWithRed:80/255.0 green:175/255.0 blue:243/255.0 alpha:1.0];
    [_floorSwitchModeButton addTarget:self action:@selector(changeSwitchMode:) forControlEvents:UIControlEventTouchUpInside];
    _floorSwitchModeButton.layer.cornerRadius = 5;
  }
  return _floorSwitchModeButton;
}

- (UISwitch *)maskModeSwitch {
  if (!_maskModeSwitch) {
    _maskModeSwitch = [[UISwitch alloc] init];
    _maskModeSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [_maskModeSwitch addTarget:self action:@selector(changeMaskModeSwitch:) forControlEvents:UIControlEventValueChanged];
  }
  return _maskModeSwitch;
}

- (UILabel *)maskModeTip {
    if (!_maskModeTip) {
      _maskModeTip = [[UILabel alloc] init];
      _maskModeTip.translatesAutoresizingMaskIntoConstraints = NO;
      _maskModeTip.text = @"mask non selected site";
      _maskModeTip.numberOfLines = 0;
    }
    return _maskModeTip;
}


@end
