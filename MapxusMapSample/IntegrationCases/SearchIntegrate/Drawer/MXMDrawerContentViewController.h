//
//  MXMDrawerContentViewController.h
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/28.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "MXMPulleyProtocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface MXMDrawerContentViewController : UINavigationController <MXMPulleyDrawerDelegate>
@property (nonatomic, weak) id<MXMDrawerScrollViewDelegate> drawerScrollDelegate;
@end

NS_ASSUME_NONNULL_END
