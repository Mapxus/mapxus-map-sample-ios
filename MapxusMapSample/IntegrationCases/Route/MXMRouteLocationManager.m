//
//  MXMRouteLocationManager.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/23.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMRouteLocationManager.h"
#import "TestLocationManager.h"

@interface MXMRouteLocationManager () <CLLocationManagerDelegate, MXMRouteAdsorberDelegate>

@property (nonatomic, strong) CLLocation *lastActualLocation;

@property (nonatomic, strong) CLLocationManager *innerLocationManager;
@property (nonatomic, strong) MXMRouteAdsorber *adsorber;
@property (nonatomic, strong) MXMRouteShortener *shortener;
@end

@implementation MXMRouteLocationManager

- (void)setShorterDelegate:(id<MXMRouteShortenerDelegate>)sDelegate {
  self.shortener.delegate = sDelegate;
}

- (void)updatePath:(MXMPath *)path waypoints:(NSArray<MXMWaypoint *> *)waypoints {
  MXMNavigationPathDTO *pathDTO = [[MXMNavigationPathDTO alloc] initWithPath:path];
  [self.adsorber updateNavigationPathDTO:pathDTO];
  [self.shortener configureWithOriginalPath:path originalWaypoints:waypoints navigationDTO:pathDTO];
}

#pragma mark - MXMRouteAdsorberDelegate
- (void)refreshTheAdsorptionLocation:(CLLocation *)location
                             venueId:(nullable NSString *)venueId
                          buildingId:(nullable NSString *)buildingId
                             floorId:(nullable NSString *)floorId
                               state:(MXMAdsorptionState)state
                          fromActual:(CLLocation *)actual {
  // Discard obsolete data
  if (actual.timestamp.timeIntervalSince1970 < self.lastActualLocation.timestamp.timeIntervalSince1970) {
    return;
  }
  
  self.locationFloorId = floorId;
  
  switch (state) {
    case MXMAdsorptionStateDefault:
    case MXMAdsorptionStateDrifting:
      // In general, calculate the route after interception
      [self.shortener cutFromTheLocationProjection:location floorId:floorId];
      break;
    case MXMAdsorptionStateDriftsNumberExceeded:
      // Initiate a callback after the number of drifts exceeds the limit
    {
      if (self.trackDelegate && [self.trackDelegate respondsToSelector:@selector(excessiveDrift)]) {
        [self.trackDelegate excessiveDrift];
      }
    }
      break;
    default:
      break;
  }
  self.lastActualLocation = actual;
  
  // Provide UI to show follow
  if (self.trackDelegate && [self.trackDelegate respondsToSelector:@selector(refreshTheAdsorptionLocation:heading:floorId:state:fromActual:)]) {
    [self.trackDelegate refreshTheAdsorptionLocation:location heading:self.innerLocationManager.heading.trueHeading floorId:floorId state:state fromActual:actual];
  }
  // Send the locations to mapbox view. If no adsorption locator is needed, annotate here.
  if (self.delegate && [self.delegate respondsToSelector:@selector(locationManager:didUpdateLocations:)]) {
    [self.delegate locationManager:self didUpdateLocations:@[location]];
  }
}

#pragma mark - MGLLocationManager

@synthesize delegate;

- (CLActivityType)activityType {
  return self.innerLocationManager.activityType;
}

- (void)setActivityType:(CLActivityType)activityType {
  self.innerLocationManager.activityType = activityType;
}

- (CLDeviceOrientation)headingOrientation {
  return self.innerLocationManager.headingOrientation;
}

- (void)setHeadingOrientation:(CLDeviceOrientation)headingOrientation {
  self.innerLocationManager.headingOrientation = headingOrientation;
}

- (CLAuthorizationStatus)authorizationStatus {
  return [CLLocationManager authorizationStatus];
}

- (void)dismissHeadingCalibrationDisplay {
  [self.innerLocationManager dismissHeadingCalibrationDisplay];
}

- (void)requestAlwaysAuthorization {
  [self.innerLocationManager requestAlwaysAuthorization];
}

- (void)requestWhenInUseAuthorization {
  [self.innerLocationManager requestWhenInUseAuthorization];
}

- (void)startUpdatingHeading {
  [self.innerLocationManager startUpdatingHeading];
}

- (void)startUpdatingLocation {
  [self.innerLocationManager startUpdatingLocation];
  [[MXMLocationEnhancer shared] start];
}

- (void)stopUpdatingHeading {
  [self.innerLocationManager stopUpdatingHeading];
}

- (void)stopUpdatingLocation {
  [self.innerLocationManager stopUpdatingLocation];
  [[MXMLocationEnhancer shared] stop];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
  if (self.isNavigation) {
    [self.adsorber calculateTheAdsorptionLocationFromActual:locations.lastObject];
  }
  else { // If no adsorption locator is needed, annotate here.
    [self.delegate locationManager:self didUpdateLocations:locations];
  }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
  [self.delegate locationManager:self didUpdateHeading:newHeading];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  [self.delegate locationManager:self didFailWithError:error];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
  return [self.delegate locationManagerShouldDisplayHeadingCalibration:self];
}

#pragma mark - Lazy loading
- (CLLocationManager *)innerLocationManager {
  if (!_innerLocationManager) {
    _innerLocationManager = [[CLLocationManager alloc] init];
    _innerLocationManager.delegate = self;
  }
  return _innerLocationManager;
}

- (MXMRouteAdsorber *)adsorber {
  if (!_adsorber) {
    _adsorber = [[MXMRouteAdsorber alloc] init];
    _adsorber.delegate = self;
  }
  return _adsorber;
}

- (MXMRouteShortener *)shortener {
  if (!_shortener) {
    _shortener = [[MXMRouteShortener alloc] init];
  }
  return _shortener;
}
@end
