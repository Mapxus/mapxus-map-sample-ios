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
- (NSSet <NSNumber *> *)supportPulleyPosition; // 返回支持位置的MXMPulleyPosition枚举的NSNumber对象, 如果不实现或者返回空，就默认是所有位置都支持

- (UIVisualEffectView *)drawerBackgroundVisualEffectView; // 如果要展示毛玻璃效果，上层view需要设置为透明; 不需要返回nil即可
- (CGFloat)drawerCornerRadius; //是否需要圆角， 如果返回0.0则不需要圆角, 此处设置圆角，其他使用圆角位置自动设置，如黑色蒙层
- (UIView *)backgroundDimmingView; //蒙层View， 只需要初始化UIView，设置蒙层颜色即可, 不需要蒙层，返回nil即可

@end



@protocol MXMPulleyPrimaryDelegate <NSObject>
@property (nonatomic, strong) UIView *view;
@end

#endif /* MXMPulleyProtocols_h */
