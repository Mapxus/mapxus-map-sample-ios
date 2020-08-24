//
//  MXMDrawerContentViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/28.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMDrawerContentViewController.h"
#import "MXMPulleyViewController.h"

@interface MXMDrawerContentViewController ()

@end

@implementation MXMDrawerContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBarHidden = YES;
}


#pragma mark - MXMPulleyViewControllerDelegate
- (void)drawerPositionDidChange:(MXMPulleyViewController *)drawer {

}

- (void)drawerDraggingProgress:(CGFloat)progress {
    
}

- (CGFloat)collapsedDrawerHeight {
    return 75.0f;
}

- (CGFloat)partialRevealDrawerHeight {
    return 264.0f;
}

- (NSSet<NSNumber *> *)supportPulleyPosition {
    NSArray *array = @[@(MXMPulleyPositionCollapsed), @(MXMPulleyPositionPartiallyRevealed), @(MXMPulleyPositionOpen),@(MXMPulleyPositionClosed)];
    return [NSSet setWithArray:array];
}

- (UIVisualEffectView *)drawerBackgroundVisualEffectView {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *drawerBackgroundVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    drawerBackgroundVisualEffectView.clipsToBounds = YES;
    return drawerBackgroundVisualEffectView;
}

- (CGFloat)drawerCornerRadius {
    return 13.0f;
}

- (UIView *)backgroundDimmingView {
    UIView *backgroundDimmingView = [[UIView alloc] init];
    backgroundDimmingView.backgroundColor = [UIColor blackColor];
    return backgroundDimmingView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.drawerScrollDelegate drawerScrollViewDidScroll:scrollView];
}


@end
