//
//  MXMSimulateLocationManager.h
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/22.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapbox/Mapbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXMSimulateLocationManager : NSObject <MGLLocationManager>
- (void)setSimulateLocation:(CLLocation *)location;
@end

NS_ASSUME_NONNULL_END
