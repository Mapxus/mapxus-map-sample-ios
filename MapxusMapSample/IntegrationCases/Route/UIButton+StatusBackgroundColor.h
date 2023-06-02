//
//  UIButton+StatusBackgroundColor.h
//  MapxusMapSample
//
//  Created by guochenghao on 2023/6/2.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (StatusBackgroundColor)

@property(nonatomic, strong) NSMutableDictionary *stateBackgroundColor;

- (void)setBackgroundColor:(UIColor *)backgroundColor state:(UIControlState)state;

- (void)setCustomEnabled:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
