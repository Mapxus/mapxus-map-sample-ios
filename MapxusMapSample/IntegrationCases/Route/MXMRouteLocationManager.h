//
//  MXMRouteLocationManager.h
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/23.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import <MapxusComponentKit/MapxusComponentKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TrackDelegate <NSObject>
- (void)excessiveDrift;
- (void)refreshTheAdsorptionLocation:(CLLocation *)location
                             heading:(CLLocationDirection)heading
                             floorId:(NSString *)floorId
                               state:(MXMAdsorptionState)state
                          fromActual:(CLLocation *)actual;
@end

@interface MXMRouteLocationManager : NSObject <MGLLocationManager>
@property (nonatomic, weak) id<TrackDelegate> trackDelegate;
@property (nonatomic, assign) BOOL isNavigation;
@property (nonatomic, strong) NSString *locationFloorId;
- (void)setShorterDelegate:(id<MXMRouteShortenerDelegate>)sDelegate;
- (void)updatePath:(MXMPath *)path wayPoints:(NSArray<MXMIndoorPoint *> *)wayPoints;
@end



NS_ASSUME_NONNULL_END
