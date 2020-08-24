//
//  MXMPulleyViewController.h
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/28.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXMPulleyProtocols.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MXMPulleyPosition) {
    /// 不显示滑动页
    MXMPulleyPositionClosed,
    /// 收起滑动页
    MXMPulleyPositionCollapsed,
    /// 展示部分滑动页
    MXMPulleyPositionPartiallyRevealed,
    /// 全部展示滑动页
    MXMPulleyPositionOpen,
};

static CGFloat kMXMTopInset = 20.0f;



@interface MXMPulleyViewController : UIViewController <MXMDrawerScrollViewDelegate>

@property (nonatomic, assign) MXMPulleyPosition currentPosition;
@property (nonatomic, assign) BOOL shouldScrollDrawerScrollView;

@property (nonatomic, strong, readonly) UIViewController<MXMPulleyPrimaryDelegate> *primaryContentViewController;
@property (nonatomic, strong, readonly) UIViewController<MXMPulleyDrawerDelegate> *drawerContentViewController;

- (instancetype)initWithPrimaryContentViewController:(UIViewController<MXMPulleyPrimaryDelegate> *)primaryContentViewController
                         drawerContentViewController:(UIViewController<MXMPulleyDrawerDelegate> *)drawerContentViewController;
- (void)setDrawerPosition:(MXMPulleyPosition)position animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
