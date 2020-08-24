//
//  MXMPassThroughScrollView.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/28.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMPassThroughScrollView.h"

@implementation MXMPassThroughScrollView

#pragma mark - overwrite
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.touchDelegate && [self.touchDelegate shouldTouchPassThroughScrollView:self atPoint:point]) {
        UIView *view = [self.touchDelegate viewToReceiveTouchOnScrollView:self atPoint:point];
        CGPoint p = [view convertPoint:point fromView:self];
        return [view hitTest:p withEvent:event];
    }
    return [super hitTest:point withEvent:event];
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    // if there is a button on the scrollView, scroll frist.
    if ([view isKindOfClass:[UIButton class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

@end
