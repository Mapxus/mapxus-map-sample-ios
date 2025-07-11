//
//  ClickEventListeningViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/17.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "ClickEventListeningViewController.h"
#import "ParamConfigInstance.h"

@interface ClickEventListeningViewController () <MGLMapViewDelegate, MapxusMapDelegate>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapxusMap;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation ClickEventListeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];
    MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
    configuration.defaultStyle = MXMStyleMAPXUS;
    self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
    self.mapxusMap.delegate = self;
}

- (void)layoutUI {
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.boxView];
    [self.boxView addSubview:self.tipLabel];
    
    [self.mapView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.mapView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.mapView.bottomAnchor constraintEqualToAnchor:self.boxView.topAnchor].active = YES;

    [self.boxView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.boxView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.boxView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.boxView.heightAnchor constraintEqualToConstant:80].active = YES;
    
    [self.tipLabel.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:20].active = YES;
    [self.tipLabel.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:20].active = YES;
    [self.tipLabel.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:20].active = YES;

}

#pragma mark - MapxusMapDelegate

// If you want to listen to this method, you need to block the corresponding two methods first.
//- (void)map:(MapxusMap *)map didSingleTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
//    NSString *message = [NSString stringWithFormat:@"You have tap at coordinate %f, %f", coordinate.latitude, coordinate.longitude];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//    [alert addAction:action];
//    [self presentViewController:alert animated:YES completion:nil];
//}

// This method is called back when the user clicks on the POI
- (void)map:(MapxusMap *)map didSingleTapOnPOI:(MXMGeoPOI *)poi atCoordinate:(CLLocationCoordinate2D)coordinate atSite:(MXMSite *)site {
    NSString *message = [NSString stringWithFormat:@"You have tap on \n POI: %@, \n floor: %@, \n building: %@, \n venue: %@", poi.nameMap.Default, site.floor.name, site.building.nameMap.Default, site.venue.nameMap.Default];
    if(poi.sections && poi.sections.count>0)
    {
      message = [NSString stringWithFormat:@"You have tap on \n POI: %@, \n section: %@, \n floor: %@, \n building: %@, \n venue: %@", poi.nameMap.Default,poi.sections[0].name, site.floor.name, site.building.nameMap.Default, site.venue.nameMap.Default];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

// This method is called back when the user clicks on a blank.
- (void)map:(MapxusMap *)map didSingleTapOnBlank:(CLLocationCoordinate2D)coordinate atSite:(MXMSite *)site {
    NSString *message = [NSString stringWithFormat:@"You have tap at \n coordinate: %f, %f, \n floor: %@, \n building: %@, \n venue: %@", coordinate.latitude, coordinate.longitude, site.floor.name, site.building.nameMap.Default, site.venue.nameMap.Default];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

// If you want to listen to this method, you need to block the corresponding method first.
//- (void)map:(MapxusMap *)map didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
//    NSString *message = [NSString stringWithFormat:@"You have long press at coordinate %f, %f", coordinate.latitude, coordinate.longitude];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//    [alert addAction:action];
//    [self presentViewController:alert animated:YES completion:nil];
//}

// This method is called back when the user long press on the map
- (void)map:(MapxusMap *)map didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate atSite:(MXMSite *)site {
    NSString *message = [NSString stringWithFormat:@"You have long press at \n coordinate: %f, %f, \n floor: %@, \n building: %@, \n venue: %@", coordinate.latitude, coordinate.longitude, site.floor.name, site.building.nameMap.Default, site.venue.nameMap.Default];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
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

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _tipLabel.text = @"Please long press or click on the map.";
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

@end
