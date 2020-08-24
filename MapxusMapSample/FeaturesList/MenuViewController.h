//
//  MenuViewController.h
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/4/25.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MenuViewControllerDelegate <NSObject>
- (void)selectedMenuOnIndex:(NSInteger)index;
- (void)dismissComplete;
@end


@interface MenuViewController : UIViewController
+ (void)presentMenuViewControllerOnViewController:(UIViewController *)orgvc withDelegate:(id<MenuViewControllerDelegate>)delegate andTitles:(NSArray<NSString *> *)titles defaultSelect:(NSUInteger)index;
@end
