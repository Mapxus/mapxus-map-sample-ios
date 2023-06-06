//
//  RouteViewController.h
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/23.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RouteViewControllerDelegate <NSObject>

- (void)routeInstructionDidChange:(NSUInteger)index;

@end

@interface RouteViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
