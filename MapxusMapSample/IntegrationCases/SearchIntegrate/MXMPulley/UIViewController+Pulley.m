//
//  UIViewController+Pulley.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/30.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "UIViewController+Pulley.h"

@implementation UIViewController (Pulley)

- (MXMPulleyViewController *)pulleyViewController {
    UIViewController *parentVC = self.parentViewController;
    while (parentVC != nil) {
        if ([parentVC isKindOfClass:[MXMPulleyViewController class]]) {
            return (MXMPulleyViewController *)parentVC;
        }
        parentVC = parentVC.parentViewController;
    }
    return nil;
}

@end
