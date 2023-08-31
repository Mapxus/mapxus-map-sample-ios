//
//  MXMPrimaryContentViewController.h
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/28.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "MXMPulleyProtocols.h"


NS_ASSUME_NONNULL_BEGIN

@protocol MXMPrimaryContentControlDelegate <NSObject>
@optional
- (void)mapDidChangeFloorId:(nullable NSString *)floorId atBuilding:(nullable MXMGeoBuilding *)building;
@end

@interface MXMPrimaryContentViewController : UIViewController <MXMPulleyPrimaryDelegate>
/// map control other page
@property (nonatomic, weak) id<MXMPrimaryContentControlDelegate> primaryControlDelegate;
/// other page control map
- (void)moveToPOICenter:(CLLocationCoordinate2D)center floorId:(NSString *)floorId;
- (void)addAnnotations:(NSArray<MXMPointAnnotation *> *)annotations;
- (void)removeAnnotations:(NSArray<MXMPointAnnotation *> *)annotations;
@end

NS_ASSUME_NONNULL_END
