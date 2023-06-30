//
//  DisplayLocationViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "MBXCustomLocationManager.h"
#import "DisplayLocationViewController.h"
#import "Macro.h"

@interface DisplayLocationViewController () <MGLMapViewDelegate, MapxusMapDelegate>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapxusMap;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *latLabel;
@property (nonatomic, strong) UILabel *lonLabel;
@property (nonatomic, strong) UILabel *floorLabel;
@property (nonatomic, strong) UILabel *accuracyLabel;
@property (nonatomic, strong) UIButton *trackButton;
@property (nonatomic, assign) int times;
@end

@implementation DisplayLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];
    self.times = 0;
    MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
    configuration.defaultStyle = MXMStyleMAPXUS;
    self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];

    // Use Custom Location Manager to limit positioning delays caused by frequent angle changes
    self.mapView.locationManager = [[MBXCustomLocationManager alloc] init];
    self.mapView.showsUserHeadingIndicator = YES;
    self.mapView.showsUserLocation = YES;
}

- (void)changeTrack:(UIButton *)sender {
    self.times = (self.times+1)%3;
    if (self.times) {
        CLAuthorizationStatus s = [CLLocationManager authorizationStatus];
        if (s != kCLAuthorizationStatusAuthorizedAlways &&
            s != kCLAuthorizationStatusAuthorizedWhenInUse) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Open location service" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];

        }
    }
    
    switch (self.times) {
        case 0:
        {
            [self.mapView setUserTrackingMode:MGLUserTrackingModeNone animated:YES completionHandler:nil];
        }
            break;
        case 1:
        {
            [self.mapView setUserTrackingMode:MGLUserTrackingModeFollow animated:YES completionHandler:nil];
        }
            break;
        case 2:
        {
            [self.mapView setUserTrackingMode:MGLUserTrackingModeFollowWithHeading animated:YES completionHandler:nil];
        }
            break;
        default:
            break;
    }
}

- (void)layoutUI {
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.boxView];
    [self.view addSubview:self.trackButton];
    [self.boxView addSubview:self.latLabel];
    [self.boxView addSubview:self.lonLabel];
    [self.boxView addSubview:self.floorLabel];
    [self.boxView addSubview:self.accuracyLabel];
    
    [self.boxView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.boxView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.boxView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    
    [self.latLabel.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:moduleSpace].active = YES;
    [self.latLabel.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    
    [self.lonLabel.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:moduleSpace].active = YES;
    [self.lonLabel.leadingAnchor constraintEqualToAnchor:self.boxView.centerXAnchor constant:innerSpace].active = YES;
    
    [self.floorLabel.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.floorLabel.topAnchor constraintEqualToAnchor:self.latLabel.bottomAnchor constant:innerSpace].active = YES;
    
    [self.accuracyLabel.leadingAnchor constraintEqualToAnchor:self.boxView.centerXAnchor constant:innerSpace].active = YES;
    [self.accuracyLabel.topAnchor constraintEqualToAnchor:self.lonLabel.bottomAnchor constant:innerSpace].active = YES;
    [self.accuracyLabel.bottomAnchor constraintEqualToAnchor:self.boxView.bottomAnchor constant:-moduleSpace].active = YES;
    
    [self.mapView.topAnchor constraintEqualToAnchor:self.boxView.bottomAnchor].active = YES;
    [self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    
    [self.trackButton.widthAnchor constraintEqualToConstant:80].active = YES;
    [self.trackButton.heightAnchor constraintEqualToConstant:40].active = YES;
    if (@available(iOS 11.0, *)) {
        [self.trackButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-30].active = YES;
        [self.trackButton.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor constant:-30].active = YES;
    } else {
        [self.trackButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-30].active = YES;
        [self.trackButton.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-30].active = YES;
    }
}

#pragma mark - MapxusMapDelegate
- (void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(MGLUserLocation *)userLocation
{
    self.latLabel.text = [NSString stringWithFormat:@"lat:%f", userLocation.location.coordinate.latitude];
    self.lonLabel.text = [NSString stringWithFormat:@"lon:%f", userLocation.location.coordinate.longitude];
    if (userLocation.location.floor) {
        self.floorLabel.text = [NSString stringWithFormat:@"floor:%ld", (long)userLocation.location.floor.level];
    } else {
        self.floorLabel.text = @"floor:N/A";
    }
    self.accuracyLabel.text = [NSString stringWithFormat:@"accuracy:%f", userLocation.location.horizontalAccuracy];
}

#pragma mark - MGLMapViewDelegate
- (void)mapView:(MGLMapView *)mapView didChangeUserTrackingMode:(MGLUserTrackingMode)mode animated:(BOOL)animated
{
    switch (mode) {
        case MGLUserTrackingModeNone:
            [self.trackButton setTitle:@"None" forState:UIControlStateNormal];
            break;
        case MGLUserTrackingModeFollow:
            [self.trackButton setTitle:@"Follow" forState:UIControlStateNormal];
            break;
        case MGLUserTrackingModeFollowWithHeading:
            [self.trackButton setTitle:@"Heading" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
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

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _boxView;
}

- (UILabel *)latLabel {
    if (!_latLabel) {
        _latLabel = [[UILabel alloc] init];
        _latLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _latLabel.text = @"lat:N/A";
    }
    return _latLabel;
}

- (UILabel *)lonLabel {
    if (!_lonLabel) {
        _lonLabel = [[UILabel alloc] init];
        _lonLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _lonLabel.text = @"lon:N/A";
    }
    return _lonLabel;
}

- (UILabel *)floorLabel {
    if (!_floorLabel) {
        _floorLabel = [[UILabel alloc] init];
        _floorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _floorLabel.text = @"floor:N/A";
    }
    return _floorLabel;
}

- (UILabel *)accuracyLabel {
    if (!_accuracyLabel) {
        _accuracyLabel = [[UILabel alloc] init];
        _accuracyLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _accuracyLabel.text = @"accuracy:N/A";
    }
    return _accuracyLabel;
}

- (UIButton *)trackButton {
    if (!_trackButton) {
        _trackButton = [[UIButton alloc] init];
        _trackButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_trackButton setTitle:@"None" forState:UIControlStateNormal];
        [_trackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _trackButton.backgroundColor = [UIColor colorWithRed:80/255.0 green:175/255.0 blue:243/255.0 alpha:1.0];
        [_trackButton addTarget:self action:@selector(changeTrack:) forControlEvents:UIControlEventTouchUpInside];
        _trackButton.layer.cornerRadius = 5;

    }
    return _trackButton;
}

@end
