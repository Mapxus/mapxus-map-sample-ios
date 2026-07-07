//
//  MXMPulleyProtocols.h
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/28.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#ifndef MXMPulleyProtocols_h
#define MXMPulleyProtocols_h
@class MXMPulleyViewController;



@protocol MXMDrawerScrollViewDelegate
- (void)drawerScrollViewDidScroll:(UIScrollView *)scrollView;
@end



@protocol MXMPulleyDrawerDelegate <NSObject>

@property (nonatomic, strong) UIView *view;
@property (nonatomic, weak) id<MXMDrawerScrollViewDelegate> drawerScrollDelegate;

- (void)drawerPositionDidChange:(MXMPulleyViewController *)drawer;

@optional
- (void)drawerDraggingProgress:(CGFloat)progress;//0 - 1

- (CGFloat)collapsedDrawerHeight;
- (CGFloat)partialRevealDrawerHeight;
- (NSSet <NSNumber *> *)supportPulleyPosition; // Return NSNumber-wrapped MXMPulleyPosition values. All positions are supported by default when this is not implemented or returns empty.

- (UIVisualEffectView *)drawerBackgroundVisualEffectView; // Return a blur effect view when needed. The upper view must be transparent; return nil when no blur is needed.
- (CGFloat)drawerCornerRadius; // Return the drawer corner radius. Return 0.0 when rounded corners are not needed; related rounded areas are configured automatically.
- (UIView *)backgroundDimmingView; // Return a configured dimming overlay view, or nil when no dimming overlay is needed.

@end



@protocol MXMPulleyPrimaryDelegate <NSObject>
@property (nonatomic, strong) UIView *view;
@end

#endif /* MXMPulleyProtocols_h */
