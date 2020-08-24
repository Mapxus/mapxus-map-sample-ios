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

@interface RouteViewController () <MapxusMapDelegate, MXMSearchDelegate, MGLMapViewDelegate, TrackDelegate, MXMRouteShortenerDelegate>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapPlugin;
@property (nonatomic, strong) UIButton *fromButton;
@property (nonatomic, strong) UIButton *toButton;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *goButton;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UISegmentedControl *travelWaySegmented;
@property (nonatomic, strong) UILabel *toDoorTip;
@property (nonatomic, strong) UISwitch *toDoorSwitch;
@property (nonatomic, strong) MXMPointAnnotation *fromAnnotation;
@property (nonatomic, strong) MXMPointAnnotation *toAnnotation;
@property (nonatomic, strong) NSMutableDictionary *fromDictionary;
@property (nonatomic, strong) NSMutableDictionary *toDictionary;
@property (nonatomic, strong) MXMRoutePainter *painter;
@property (nonatomic, strong) MXMRouteLocationManager *locationManager;
@property (nonatomic, strong) MXMRouteSearchResponse *currentResponse;
@end

@implementation RouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];
    // Specify the scene initialization map
    MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
    configuration.buildingId = @"harbourcity_hk_8b580b";
    configuration.floor = @"L2";
    self.mapPlugin = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
    self.mapPlugin.selectorPosition = MXMSelectorPositionCenterRight;
    self.mapPlugin.delegate = self;
    
    // The painter help to draw the route line on the mapview
    self.painter = [[MXMRoutePainter alloc] initWithMapView:self.mapView];
    // Set trackDelegate, callback to update map camera during navigation
    self.locationManager.trackDelegate = self;
    // Set delegate to redraw the shorter route line
    [self.locationManager setShorterDelegate:self];
    // Setting up a custom location manager
    self.mapView.locationManager = self.locationManager;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsUserHeadingIndicator = YES;
}

- (void)fromBtnOnClickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.toButton.selected = NO;
    if (sender.isSelected) {
        [self.fromDictionary removeAllObjects];
    } else {
        [self btnTitleSet];
    }
}

- (void)toBtnOnClickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.fromButton.selected = NO;
    if (sender.isSelected) {
        [self.toDictionary removeAllObjects];
    } else {
        [self btnTitleSet];
    }
}

- (void)btnTitleSet {
    MXMGeoPoint *fromP = self.fromDictionary[@"point"];
    if (fromP) {
        NSString *fromTitle = [NSString stringWithFormat:@"%.4f, %.4f ", fromP.latitude, fromP.longitude];
        if (self.fromDictionary[@"floor"]) {
            fromTitle = [fromTitle stringByAppendingString:self.fromDictionary[@"floor"]];
        }
        [self.fromButton setTitle:fromTitle forState:UIControlStateNormal];
    } else {
        [self.fromButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    MXMGeoPoint *toP = self.toDictionary[@"point"];
    if (toP) {
        NSString *toTitle = [NSString stringWithFormat:@"%.4f, %.4f ", toP.latitude, toP.longitude];
        if (self.toDictionary[@"floor"]) {
            toTitle = [toTitle stringByAppendingString:self.toDictionary[@"floor"]];
        }
        [self.toButton setTitle:toTitle forState:UIControlStateNormal];
    } else {
        [self.toButton setTitle:@"End" forState:UIControlStateNormal];
    }
}

// Search a route with params
- (void)searchRouteAction:(UIButton *)sender {
    [self.painter cleanRoute];

    MXMRouteSearchRequest *re = [[MXMRouteSearchRequest alloc] init];
    re.fromBuilding = self.fromDictionary[@"building"];
    re.fromFloor = self.fromDictionary[@"floor"];
    MXMGeoPoint *fromP = self.fromDictionary[@"point"];
    re.fromLat = fromP.latitude;
    re.fromLon = fromP.longitude;
    re.toBuilding = self.toDictionary[@"building"];
    re.toFloor = self.toDictionary[@"floor"];
    MXMGeoPoint *toP = self.toDictionary[@"point"];
    re.toLat = toP.latitude;
    re.toLon = toP.longitude;
    re.locale = @"zh-Hans";
    re.toDoor = self.toDoorSwitch.isOn ? YES : NO;
    if (self.travelWaySegmented.selectedSegmentIndex == 0) {
        re.vehicle = @"foot";
    } else {
        re.vehicle = @"wheelchair";
    }
    
    MXMSearchAPI *api = [[MXMSearchAPI alloc] init];
    api.delegate = self;
    [api MXMRouteSearch:re];
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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Please search the route first." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    // Hide the start marker point when starting navigation
    self.painter.isAddStartDash = NO;
    // Update navigation data
    [self.locationManager updatePath:self.currentResponse.paths.firstObject wayPoints:self.currentResponse.wayPointList];
    // Start to navigation
    self.locationManager.isNavigation = YES;
}

- (void)setCamera:(CLLocationCoordinate2D)location heading:(CLLocationDirection)heading buildingID:(NSString *)buildingID floor:(NSString *)floor zoomLevel:(double)zoomLevel {
    [self.mapPlugin selectBuilding:buildingID floor:floor zoomMode:MXMZoomDisable edgePadding:UIEdgeInsetsZero];
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
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.fromButton];
    [self.view addSubview:self.toButton];
    [self.view addSubview:self.searchButton];
    [self.view addSubview:self.goButton];
    [self.view addSubview:self.boxView];
    [self.boxView addSubview:self.travelWaySegmented];
    [self.boxView addSubview:self.toDoorTip];
    [self.boxView addSubview:self.toDoorSwitch];
    
    [self.mapView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.mapView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;

    [self.fromButton.heightAnchor constraintEqualToConstant:40].active = YES;
    [self.fromButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20].active = YES;
    [self.fromButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10].active = YES;
    [self.fromButton.trailingAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:-5].active = YES;

    [self.toButton.heightAnchor constraintEqualToConstant:40].active = YES;
    [self.toButton.widthAnchor constraintEqualToAnchor:self.fromButton.widthAnchor].active = YES;
    [self.toButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10].active = YES;
    [self.toButton.topAnchor constraintEqualToAnchor:self.fromButton.bottomAnchor constant:10].active = YES;
    
    [self.searchButton.widthAnchor constraintEqualToConstant:80].active = YES;
    [self.searchButton.heightAnchor constraintEqualToConstant:40].active = YES;
    [self.searchButton.leadingAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:5].active = YES;
    [self.searchButton.centerYAnchor constraintEqualToAnchor:self.fromButton.bottomAnchor constant:5].active = YES;
    
    [self.goButton.widthAnchor constraintEqualToConstant:80].active = YES;
    [self.goButton.heightAnchor constraintEqualToConstant:40].active = YES;
    [self.goButton.leadingAnchor constraintEqualToAnchor:self.searchButton.trailingAnchor constant:10].active = YES;
    [self.goButton.centerYAnchor constraintEqualToAnchor:self.searchButton.centerYAnchor].active = YES;
    
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
    
    [self.toDoorSwitch.topAnchor constraintEqualToAnchor:self.travelWaySegmented.bottomAnchor constant:10].active = YES;
    [self.toDoorSwitch.leadingAnchor constraintEqualToAnchor:self.boxView.centerXAnchor constant:5].active = YES;

    [self.toDoorTip.centerYAnchor constraintEqualToAnchor:self.toDoorSwitch.centerYAnchor].active = YES;
    [self.toDoorTip.trailingAnchor constraintEqualToAnchor:self.boxView.centerXAnchor constant:-5].active = YES;
    
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

- (void)refreshTheAdsorptionLocation:(CLLocation *)location heading:(CLLocationDirection)heading buildingId:(NSString *)buildingId floor:(NSString *)floor state:(MXMAdsorptionState)state fromActual:(CLLocation *)actual {
    [self setCamera:location.coordinate heading:heading buildingID:buildingId floor:floor zoomLevel:self.mapView.zoomLevel];
}

#pragma mark - MXMRouteShortenerDelegate
- (void)routeShortener:(MXMRouteShortener *)shortener redrawingNewPath:(MXMPath *)path fromInstructionIndex:(NSUInteger)index {
    // repaint
    [self.painter cleanRoute];
    [self.painter paintRouteUsingPath:path wayPoints:shortener.originalWayPoints];
    [self.painter changeOnBuilding:self.mapPlugin.building.identifier floor:self.mapPlugin.floor];
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

- (void)mapView:(MapxusMap *)mapView didChangeFloor:(NSString *)floorName atBuilding:(MXMGeoBuilding *)building
{
    // show different line on different scene
    [self.painter changeOnBuilding:building.identifier floor:floorName];
}

/// Use two callbacks to cover all situations
- (void)mapView:(MapxusMap *)mapView didSingleTappedOnMapBlank:(CLLocationCoordinate2D)coordinate onFloor:(NSString *)floorName inBuilding:(MXMGeoBuilding *)building {
    [self didTappedAtCoordinate:coordinate onFloor:floorName inBuilding:building];
}

- (void)mapView:(MapxusMap *)mapView didSingleTappedOnPOI:(MXMGeoPOI *)poi atCoordinate:(CLLocationCoordinate2D)coordinate onFloor:(NSString *)floorName inBuilding:(MXMGeoBuilding *)building {
    [self didTappedAtCoordinate:coordinate onFloor:floorName inBuilding:building];
}
/// --end

- (void)didTappedAtCoordinate:(CLLocationCoordinate2D)coordinate onFloor:(nullable NSString *)floorName inBuilding:(nullable MXMGeoBuilding *)building
{
    if (self.fromButton.isSelected) {
        self.fromDictionary[@"floor"] = floorName;
        self.fromDictionary[@"building"] = building.identifier;
        MXMGeoPoint *p = [[MXMGeoPoint alloc] init];
        p.latitude = coordinate.latitude;
        p.longitude = coordinate.longitude;
        self.fromDictionary[@"point"] = p;

        if (self.fromAnnotation == nil) {
            self.fromAnnotation = [[MXMPointAnnotation alloc] init];
            self.fromAnnotation.coordinate = coordinate;
            self.fromAnnotation.floor = floorName;
            self.fromAnnotation.buildingId = building.identifier;
            [self.mapPlugin addMXMPointAnnotations:@[self.fromAnnotation]];
        } else {
            self.fromAnnotation.coordinate = coordinate;
            self.fromAnnotation.floor = floorName;
            self.fromAnnotation.buildingId = building.identifier;
        }

    } else if (self.toButton.isSelected) {
        self.toDictionary[@"floor"] = floorName;
        self.toDictionary[@"building"] = building.identifier;
        MXMGeoPoint *p = [[MXMGeoPoint alloc] init];
        p.latitude = coordinate.latitude;
        p.longitude = coordinate.longitude;
        self.toDictionary[@"point"] = p;

        if (self.toAnnotation == nil) {
            self.toAnnotation = [[MXMPointAnnotation alloc] init];
            self.toAnnotation.coordinate = coordinate;
            self.toAnnotation.floor = floorName;
            self.toAnnotation.buildingId = building.identifier;
            [self.mapPlugin addMXMPointAnnotations:@[self.toAnnotation]];
        } else {
            self.toAnnotation.coordinate = coordinate;
            self.toAnnotation.floor = floorName;
            self.toAnnotation.buildingId = building.identifier;
        }
    }
}

#pragma mark - MXMSearchDelegate

- (void)MXMSearchRequest:(id)request didFailWithError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Sorry, I can't find the route." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)onRouteSearchDone:(MXMRouteSearchRequest *)request response:(MXMRouteSearchResponse *)response
{
    self.currentResponse = response;
    self.fromAnnotation = nil;
    self.toAnnotation = nil;
    [self.mapPlugin removeMXMPointAnnotaions:self.mapPlugin.MXMAnnotations];
    
    self.painter.isAddStartDash = YES;
    [self.painter cleanRoute];
    
    [self.painter paintRouteUsingPath:response.paths.firstObject wayPoints:response.wayPointList];
    for (NSString *key in self.painter.dto.keys) {
        if (![key containsString:@"outdoor"]) {
            MXMParagraph *paph = self.painter.dto.paragraphs[key];
            [self.mapPlugin selectBuilding:paph.buildingId floor:paph.floor zoomMode:MXMZoomDisable edgePadding:UIEdgeInsetsZero];
            [self.painter changeOnBuilding:paph.buildingId floor:paph.floor];
            [self.painter focusOnKeys:@[key] edgePadding:UIEdgeInsetsMake(130, 30, 110, 80)];
            break;
        }
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

- (UIButton *)fromButton {
    if (!_fromButton) {
        _fromButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fromButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_fromButton setTitle:@"Start" forState:UIControlStateNormal];
        [_fromButton setTitle:@"Tap screen for Start" forState:UIControlStateSelected];
        [_fromButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fromButton addTarget:self action:@selector(fromBtnOnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _fromButton.backgroundColor = [UIColor colorWithRed:100/255.0 green:149/255.0 blue:237/255.0 alpha:1];
        _fromButton.layer.cornerRadius = 5;
        _fromButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _fromButton;
}

- (UIButton *)toButton {
    if (!_toButton) {
        _toButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _toButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_toButton setTitle:@"End" forState:UIControlStateNormal];
        [_toButton setTitle:@"Tap screen for End" forState:UIControlStateSelected];
        [_toButton setTitleColor:[UIColor colorWithRed:100/255.0 green:149/255.0 blue:237/255.0 alpha:1] forState:UIControlStateNormal];
        [_toButton addTarget:self action:@selector(toBtnOnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _toButton.backgroundColor = [UIColor whiteColor];
        _toButton.layer.cornerRadius = 5;
        _toButton.layer.borderWidth = 2;
        _toButton.layer.borderColor = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:0.4].CGColor;
        _toButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _toButton;
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
        _travelWaySegmented = [[UISegmentedControl alloc] initWithItems:@[@"foot", @"wheelchair"]];
        _travelWaySegmented.translatesAutoresizingMaskIntoConstraints = NO;
        _travelWaySegmented.selectedSegmentIndex = 0;
    }
    return _travelWaySegmented;
}

- (UILabel *)toDoorTip {
    if (!_toDoorTip) {
        _toDoorTip = [[UILabel alloc] init];
        _toDoorTip.translatesAutoresizingMaskIntoConstraints = NO;
        _toDoorTip.text = @"toDoor";
    }
    return _toDoorTip;
}

- (UISwitch *)toDoorSwitch {
    if (!_toDoorSwitch) {
        _toDoorSwitch = [[UISwitch alloc] init];
        _toDoorSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        _toDoorSwitch.backgroundColor = [UIColor whiteColor];
        _toDoorSwitch.layer.cornerRadius = 20;
    }
    return _toDoorSwitch;
}

- (NSMutableDictionary *)fromDictionary {
    if (!_fromDictionary) {
        _fromDictionary = [NSMutableDictionary dictionary];
    }
    return _fromDictionary;
}

- (NSMutableDictionary *)toDictionary {
    if (!_toDictionary) {
        _toDictionary = [NSMutableDictionary dictionary];
    }
    return _toDictionary;
}

- (MXMRouteLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[MXMRouteLocationManager alloc] init];
    }
    return _locationManager;
}

@end
