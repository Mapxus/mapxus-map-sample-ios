//
//  MBXCustomLocationManager.m
//  BeeMapDemo
//
//  Created by Chenghao Guo on 2018/12/25.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MBXCustomLocationManager.h"

@interface MBXCustomLocationManager() <CLLocationManagerDelegate>
@property (nonatomic) CLLocationManager *locationManager;
@end

@implementation MBXCustomLocationManager

@synthesize delegate;

- (instancetype)init
{
  if (self = [super init]) {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.headingFilter = 10.0;
  }
  return self;
}

- (void)dealloc
{
  [self.locationManager stopUpdatingLocation];
  [self.locationManager stopUpdatingHeading];
  self.delegate = nil;
}


#pragma mark - MGLLocationManager
- (void)setHeadingOrientation:(CLDeviceOrientation)headingOrientation
{
  _locationManager.headingOrientation = headingOrientation;
}

- (CLDeviceOrientation)headingOrientation
{
  return _locationManager.headingOrientation;
}

- (void)setDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy {
  self.locationManager.desiredAccuracy = desiredAccuracy;
}

- (CLLocationAccuracy)desiredAccuracy {
  return self.locationManager.desiredAccuracy;
}

- (CLAuthorizationStatus)authorizationStatus
{
  return [CLLocationManager authorizationStatus];
}

- (void)setActivityType:(CLActivityType)activityType {
  self.locationManager.activityType = activityType;
}

- (CLActivityType)activityType {
  return self.locationManager.activityType;
}

- (void)requestAlwaysAuthorization
{
  [self.locationManager requestAlwaysAuthorization];
}

- (void)requestWhenInUseAuthorization
{
  [self.locationManager requestWhenInUseAuthorization];
}

- (void)startUpdatingHeading
{
  [self.locationManager startUpdatingHeading];
}

- (void)startUpdatingLocation
{
  [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingHeading
{
  [self.locationManager stopUpdatingHeading];
}

- (void)stopUpdatingLocation
{
  [self.locationManager stopUpdatingLocation];
}

- (void)dismissHeadingCalibrationDisplay
{
  [self.locationManager dismissHeadingCalibrationDisplay];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
  if ([self.delegate respondsToSelector:@selector(locationManager:didUpdateLocations:)]) {
    [self.delegate locationManager:self didUpdateLocations:locations];
  }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
  if ([self.delegate respondsToSelector:@selector(locationManager:didUpdateHeading:)]) {
    [self.delegate locationManager:self didUpdateHeading:newHeading];
  }
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
  if ([self.delegate respondsToSelector:@selector(locationManagerShouldDisplayHeadingCalibration:)]) {
    return [self.delegate locationManagerShouldDisplayHeadingCalibration:self];
  }
  
  return NO;
}

- (void)locationManager:(CLLocationManager *)locationManager didFailWithError:(nonnull NSError *)error {
  if ([self.delegate respondsToSelector:@selector(locationManager:didFailWithError:)]) {
    [self.delegate locationManager:self didFailWithError:error];
  }
}


@end
