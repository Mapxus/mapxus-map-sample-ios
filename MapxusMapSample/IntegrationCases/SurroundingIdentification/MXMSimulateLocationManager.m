//
//  MXMSimulateLocationManager.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/22.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMSimulateLocationManager.h"

@interface MXMSimulateLocationManager () <CLLocationManagerDelegate>
@property (nonatomic) CLLocationManager *locationManager;
@end

@implementation MXMSimulateLocationManager

@synthesize delegate;

- (instancetype)init
{
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopUpdatingHeading];
    self.delegate = nil;
}

- (void)setSimulateLocation:(CLLocation *)location {
    if ([self.delegate respondsToSelector:@selector(locationManager:didUpdateLocations:)]) {
        [self.delegate locationManager:self didUpdateLocations:@[location]];
    }
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
//    [self.locationManager startUpdatingLocation];
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
//    if ([self.delegate respondsToSelector:@selector(locationManager:didUpdateLocations:)]) {
//        [self.delegate locationManager:self didUpdateLocations:locations];
//    }
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
