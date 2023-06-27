//
//  IndoorControlsViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/17.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "IndoorControlsViewController.h"
#import "BoxLengthViewController.h"
#import "Macro.h"

@interface IndoorControlsViewController () <MGLMapViewDelegate, Param>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapPlugin;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *hiddenTip;
@property (nonatomic, strong) UISwitch *hiddenSwitch;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIButton *positionButton;
@property (nonatomic, strong) UIButton *boxLengthButton;
@property (nonatomic, assign) NSUInteger times;
@end

@implementation IndoorControlsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];
    MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
    configuration.defaultStyle = MXMStyleMAPXUS;
    self.mapPlugin = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
}

- (void)changeHiddenStatu:(UISwitch *)sender {
    if (sender.isOn == YES) {
        // Let floorBar and buildingSelectButton of MapxusMap instance always hidden
        self.mapPlugin.indoorControllerAlwaysHidden = YES;
    } else {
        // Let floorBar and buildingSelectButton of MapxusMap instance displayed when you in any indoor scene
        self.mapPlugin.indoorControllerAlwaysHidden = NO;
    }
}

- (void)changePosition:(UIButton *)sender {
    self.times = (self.times+1)%6;
    
    switch (self.times) {
        case 0:
            self.mapPlugin.selectorPosition = MXMSelectorPositionCenterLeft; // Let floorBar and buildingSelectButton of MapxusMap instance on the left
            break;
        case 1:
            self.mapPlugin.selectorPosition = MXMSelectorPositionCenterRight; // Let floorBar and buildingSelectButton of MapxusMap instance on the right
            break;
        case 2:
            self.mapPlugin.selectorPosition = MXMSelectorPositionBottomLeft; // Let floorBar and buildingSelectButton of MapxusMap instance on bottom left
            break;
        case 3:
            self.mapPlugin.selectorPosition = MXMSelectorPositionBottomRight; // Let floorBar and buildingSelectButton of MapxusMap instance on bottom right
            break;
        case 4:
            self.mapPlugin.selectorPosition = MXMSelectorPositionTopLeft; // Let floorBar and buildingSelectButton of MapxusMap instance on top left
            break;
        case 5:
            self.mapPlugin.selectorPosition = MXMSelectorPositionTopRight; // Let floorBar and buildingSelectButton of MapxusMap instance on top right
            break;
        default:
            break;
    }
}

- (void)clickToSetBoxLength {
  BoxLengthViewController *vc = [[BoxLengthViewController alloc] init];
  vc.delegate = self;
  [self presentViewController:vc
                     animated:YES
                   completion:nil];
}

- (void)layoutUI {
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.boxView];
    [self.boxView addSubview:self.hiddenSwitch];
    [self.boxView addSubview:self.hiddenTip];
    [self.boxView addSubview:self.stackView];
    [self.stackView addArrangedSubview:self.positionButton];
    [self.stackView addArrangedSubview:self.boxLengthButton];

    [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.mapView.bottomAnchor constraintEqualToAnchor:self.boxView.topAnchor].active = YES;
    
    [self.boxView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.boxView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.boxView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    if (@available(iOS 11.0, *)) {
        [self.boxView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-130].active = YES;
    } else {
        [self.boxView.topAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-130].active = YES;
    }

    [self.hiddenSwitch.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:trailingSpace].active = YES;
    [self.hiddenSwitch.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:moduleSpace].active = YES;
    
    [self.hiddenTip.centerYAnchor constraintEqualToAnchor:self.hiddenSwitch.centerYAnchor].active = YES;
    [self.hiddenTip.leadingAnchor constraintEqualToAnchor:self.hiddenSwitch.trailingAnchor constant:innerSpace].active  = YES;
    
    [self.stackView.topAnchor constraintEqualToAnchor:self.hiddenSwitch.bottomAnchor constant:moduleSpace].active = YES;
    [self.stackView.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.stackView.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    [self.stackView.heightAnchor constraintEqualToConstant:40].active = YES;
}

#pragma mark - Param

- (void)completeParamConfiguration:(NSDictionary *)param {
  NSUInteger count = [param[@"maxLength"] intValue];
  self.mapPlugin.floorBar.maxVisibleFloors = count;
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

- (UILabel *)hiddenTip {
    if (!_hiddenTip) {
        _hiddenTip = [[UILabel alloc] init];
        _hiddenTip.translatesAutoresizingMaskIntoConstraints = NO;
        _hiddenTip.text = @"isAlwaysHidden";
    }
    return _hiddenTip;
}

- (UISwitch *)hiddenSwitch {
    if (!_hiddenSwitch) {
        _hiddenSwitch = [[UISwitch alloc] init];
        _hiddenSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        [_hiddenSwitch addTarget:self action:@selector(changeHiddenStatu:) forControlEvents:UIControlEventValueChanged];
    }
    return _hiddenSwitch;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.spacing = moduleSpace;
    }
    return _stackView;
}

- (UIButton *)positionButton {
    if (!_positionButton) {
        _positionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _positionButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_positionButton setTitle:@"Position" forState:UIControlStateNormal];
        [_positionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _positionButton.backgroundColor = [UIColor colorWithRed:80/255.0 green:175/255.0 blue:243/255.0 alpha:1.0];
        [_positionButton addTarget:self action:@selector(changePosition:) forControlEvents:UIControlEventTouchUpInside];
        _positionButton.layer.cornerRadius = 5;
    }
    return _positionButton;
}

- (UIButton *)boxLengthButton {
    if (!_boxLengthButton) {
      _boxLengthButton = [UIButton buttonWithType:UIButtonTypeCustom];
      _boxLengthButton.translatesAutoresizingMaskIntoConstraints = NO;
      [_boxLengthButton setTitle:@"Box Length" forState:UIControlStateNormal];
      [_boxLengthButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      _boxLengthButton.backgroundColor = [UIColor colorWithRed:80/255.0 green:175/255.0 blue:243/255.0 alpha:1.0];
      [_boxLengthButton addTarget:self action:@selector(clickToSetBoxLength) forControlEvents:UIControlEventTouchUpInside];
      _boxLengthButton.layer.cornerRadius = 5;
    }
    return _boxLengthButton;
}


@end
