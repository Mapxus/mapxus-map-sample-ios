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
    /// Hide the drawer page.
    MXMPulleyPositionClosed,
    /// Collapse the drawer page.
    MXMPulleyPositionCollapsed,
    /// Partially reveal the drawer page.
    MXMPulleyPositionPartiallyRevealed,
    /// Fully reveal the drawer page.
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
