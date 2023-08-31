//
//  MXMRouteLocationManager.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/23.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMRouteLocationManager.h"

@interface MXMRouteLocationManager () <CLLocationManagerDelegate, MXMRouteAdsorberDelegate>

/** Virtual positioning function  */
//@property (nonatomic, assign) NSInteger index;
//@property (nonatomic, strong) NSTimer *locationUpdateTimer;
//@property (nonatomic, strong) NSArray *acoordinates;
/** Virtual positioning function */

@property (nonatomic, strong) CLLocation *lastActualLocation;

@property (nonatomic, strong) CLLocationManager *innerLocationManager;
@property (nonatomic, strong) MXMRouteAdsorber *adsorber;
@property (nonatomic, strong) MXMRouteShortener *shortener;
@end

@implementation MXMRouteLocationManager

- (void)setShorterDelegate:(id<MXMRouteShortenerDelegate>)sDelegate {
  self.shortener.delegate = sDelegate;
}

- (void)updatePath:(MXMPath *)path wayPoints:(NSArray<MXMIndoorPoint *> *)wayPoints {
  MXMNavigationPathDTO *pathDTO = [[MXMNavigationPathDTO alloc] initWithPath:path];
  [self.adsorber updateNavigationPathDTO:pathDTO];
  [self.shortener inputSourceWithOriginalPath:path originalWayPoints:wayPoints andNavigationPathDTO:pathDTO];
}

/** Virtual positioning function  */
//- (void)loadRouteCoordinates {
//    self.acoordinates = @[@[@(114.17434634578406), @(22.294415525409875), @(-1)],
//                          @[@(114.17434930729888), @(22.294416210695720), @(-1)],
//                          @[@(114.17434924232869), @(22.294416974054414), @(-1)],
//                          @[@(114.17434916680120), @(22.294417426921136), @(-1)],
//                          @[@(114.17435041568386), @(22.294417354535636), @(-1)],
//                          @[@(114.17434963195260), @(22.294417192109140), @(-1)],
//                          @[@(114.17434938661647), @(22.294417018136812), @(-1)],
//                          @[@(114.17434867413125), @(22.294416540278082), @(-1)],
//                          @[@(114.17434652959473), @(22.294415246391750), @(-1)],
//                          @[@(114.17434858402919), @(22.294413772794194), @(-1)],
//                          @[@(114.17434874889439), @(22.294412206425662), @(-1)],
//                          @[@(114.17435178273466), @(22.294409461053476), @(-1)],
//                          @[@(114.17435738436181), @(22.294407535422570), @(-1)],
//                          @[@(114.17436458866787), @(22.294406001266356), @(-1)],
//                          @[@(114.17437684836291), @(22.294405475441433), @(-1)],
//                          @[@(114.17438084696980), @(22.294422372222350), @(-1)],
//                          @[@(114.17438702344678), @(22.294431074559533), @(-1)],
//                          @[@(114.17438842364939), @(22.294436109946492), @(-1)],
//                          @[@(114.17438867621867), @(22.294440281834480), @(-1)],
//                          @[@(114.17438988431338), @(22.294443715283762), @(-1)],
//                          @[@(114.17439073800276), @(22.294446732053370), @(-1)],
//                          @[@(114.17439111378143), @(22.294447901667215), @(-1)],
//                          @[@(114.17439473735374), @(22.294450137946427), @(-1)],
//                          @[@(114.17439768365644), @(22.294451794860066), @(-1)],
//                          @[@(114.17440148792522), @(22.294452648784560), @(-1)],
//                          @[@(114.17440279943494), @(22.294453185797686), @(-1)],
//                          @[@(114.17440623989508), @(22.294452868053373), @(-1)],
//                          @[@(114.17440826016103), @(22.294452808330590), @(-1)],
//                          @[@(114.17441700868521), @(22.294451962384727), @(-1)],
//                          @[@(114.17442728231494), @(22.294450002380874), @(-1)],
//                          @[@(114.17443101214887), @(22.294448775025412), @(-1)],
//                          @[@(114.17443056354506), @(22.294448320753794), @(-1)],
//                          @[@(114.17443224914592), @(22.294447678796587), @(-1)],
//                          @[@(114.17443304765084), @(22.294447152052280), @(-1)],
//                          @[@(114.17444302222990), @(22.294443826248010), @(-1)],
//                          @[@(114.17443417099909), @(22.294446577322528), @(-1)],
//                          @[@(114.17443112445018), @(22.294447715239418), @(-1)],
//                          @[@(114.17442981614010), @(22.294447795456720), @(-1)],
//                          @[@(114.17442794080313), @(22.294441198079067), @(-2)],
//                          @[@(114.17443196145034), @(22.294449695826483), @(-2)],
//                          @[@(114.17443954138113), @(22.294455339576448), @(-2)],
//                          @[@(114.17444787702613), @(22.294460665648458), @(-2)],
//                          @[@(114.17453458629890), @(22.294425541644088), @(-2)],
//                          @[@(114.17454564693699), @(22.294423623440185), @(-2)],
//                          @[@(114.17455688579045), @(22.294415941909460), @(-2)],
//                          @[@(114.17456927590140), @(22.294417999649470), @(-2)],
//                          @[@(114.17458412752298), @(22.294417175195380), @(-2)],
//                          @[@(114.17459799944632), @(22.294416825932450), @(-2)],
//                          @[@(114.17461078088596), @(22.294419945516780), @(-2)],
//                          @[@(114.17462248954179), @(22.294420587403570), @(-2)],
//                          @[@(114.17463309047079), @(22.294418127143995), @(-2)],
//                          @[@(114.17463896961686), @(22.294416701397427), @(-2)],
//                          @[@(114.17464249596955), @(22.294409257696362), @(-2)],
//                          @[@(114.17464629981662), @(22.294400222742162), @(-2)],
//                          @[@(114.17464567952025), @(22.294392897703364), @(-2)],
//                          @[@(114.17465449249775), @(22.294386710338433), @(-2)],
//                          @[@(114.17466625258861), @(22.294383807817706), @(-2)],
//                          @[@(114.17468059782652), @(22.294383292623298), @(-2)],
//                          @[@(114.17469564211500), @(22.294384164189957), @(-2)],
//                          @[@(114.17471041734136), @(22.294382700725365), @(-2)],
//                          @[@(114.17472071841189), @(22.294382371916168), @(-2)],
//                          @[@(114.17472638039702), @(22.294376320457050), @(-2)],
//                          @[@(114.17474479887228), @(22.294381624391020), @(-2)],
//                          @[@(114.17472820669029), @(22.294359733792156), @(-2)],
//                          @[@(114.17472498520539), @(22.294361890275006), @(-2)],
//                          @[@(114.17472880002379), @(22.294369441206065), @(-2)],
//                          @[@(114.17473068860123), @(22.294375920679713), @(-2)],
//                          @[@(114.17473462688154), @(22.294379956071648), @(-2)],
//                          @[@(114.17475968749368), @(22.294388228348947), @(-2)],
//                          @[@(114.17477228871743), @(22.294389636599632), @(-2)],
//                          @[@(114.17478350619345), @(22.294389589144988), @(-2)],
//                          @[@(114.17479564272509), @(22.294389625508373), @(-2)],
//                          @[@(114.17481947043947), @(22.294379930925057), @(-2)],
//                          @[@(114.17483394759321), @(22.294376076215176), @(-2)],
//                          @[@(114.17484210611734), @(22.294378876243640), @(-2)],
//                          @[@(114.17485004991707), @(22.294378242816860), @(-2)],
//                          @[@(114.17486159400298), @(22.294380939448560), @(-2)],
//                          @[@(114.17487096148457), @(22.294382307427817), @(-2)],
//                          @[@(114.17488390345785), @(22.294386464132305), @(-2)],
//                          @[@(114.17488782633562), @(22.294388826823514), @(-2)],
//                          @[@(114.17489252458428), @(22.294389993512755), @(-2)],
//                          @[@(114.17490204020400), @(22.294391648531864), @(-2)],
//                          @[@(114.17491395791806), @(22.294393378169087), @(-2)],
//                          @[@(114.17492204855246), @(22.294397468778950), @(-2)],
//                          @[@(114.17493045738135), @(22.294399743658440), @(-2)],
//                          @[@(114.17492620087916), @(22.294401117717168), @(-2)],
//                          @[@(114.17493303723428), @(22.294400927152324), @(-2)],
//                          @[@(114.17492774381564), @(22.294401117708766), @(-2)],
//                          @[@(114.17494774381564), @(22.294451117708766), @(-2)],
//                          @[@(114.17493510030337), @(22.294399544988227), @(-2)],];
//}
//
//- (void)updateLocation {
//    if (self.index >= self.acoordinates.count) {
//        self.index = 0;
//        self.acoordinates = [self.acoordinates reverseObjectEnumerator].allObjects;
//    }
//    NSArray *loc = self.acoordinates[self.index];
//    NSNumber *latitube = loc[1];
//    NSNumber *longitube = loc[0];
//    NSNumber *f = loc[2];
//    CLFloor *floor = [CLFloor createFloorWihtLevel:f.integerValue];
//    CLLocation *location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitube.doubleValue, longitube.doubleValue) altitude:50 horizontalAccuracy:0.0 verticalAccuracy:0.0 timestamp:[NSDate date]];
//    location.myFloor = floor;
//    self.index++;
//    [self locationManager:self.innerLocationManager didUpdateLocations:@[location]];
//}
/** Virtual positioning function */

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
  /** Virtual positioning function  */
  //    [self loadRouteCoordinates];
  //    self.locationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(updateLocation) userInfo:nil repeats:YES];
  /** Virtual positioning function */
}

- (void)stopUpdatingHeading {
  [self.innerLocationManager stopUpdatingHeading];
}

- (void)stopUpdatingLocation {
  [self.innerLocationManager stopUpdatingLocation];
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
