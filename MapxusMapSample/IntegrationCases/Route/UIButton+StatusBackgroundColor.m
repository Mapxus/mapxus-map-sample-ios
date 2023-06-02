//
//  UIButton+StatusBackgroundColor.m
//  MapxusMapSample
//
//  Created by guochenghao on 2023/6/2.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <objc/runtime.h>
#import "UIButton+StatusBackgroundColor.h"

static const char *stateBackgroundColorID = "stateBackgroundColorID";

@implementation UIButton (StatusBackgroundColor)

- (void)setStateBackgroundColor:(NSMutableDictionary *)stateBackgroundColor {
  objc_setAssociatedObject(self, stateBackgroundColorID, stateBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)stateBackgroundColor {
  return objc_getAssociatedObject(self, stateBackgroundColorID);
}

- (void)setBackgroundColor:(UIColor *)backgroundColor state:(UIControlState)state {
  if (!self.stateBackgroundColor) {
    self.stateBackgroundColor = [NSMutableDictionary dictionary];
  }
  [self.stateBackgroundColor setObject:backgroundColor forKey:@(state)];
}

- (void)setCustomEnabled:(BOOL)enabled {
  self.enabled = enabled;
  [self updateBackgroundColor];
}

- (void)updateBackgroundColor {
  UIColor *backgroundColor = [self.stateBackgroundColor objectForKey:@(self.state)];
  if (backgroundColor) {
    self.backgroundColor = backgroundColor;
  }
}

@end
