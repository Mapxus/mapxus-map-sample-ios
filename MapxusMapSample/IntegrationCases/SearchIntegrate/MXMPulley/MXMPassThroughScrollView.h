//
//  MXMPassThroughScrollView.h
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/28.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MXMPassThroughScrollView;

@protocol MXMPassThroughScrollViewDelegate
- (BOOL)shouldTouchPassThroughScrollView:(MXMPassThroughScrollView *)scrollView atPoint:(CGPoint)point;
- (UIView *)viewToReceiveTouchOnScrollView:(MXMPassThroughScrollView *)scrollView atPoint:(CGPoint)point;
@end

@interface MXMPassThroughScrollView : UIScrollView
@property (nonatomic, weak) id<MXMPassThroughScrollViewDelegate> touchDelegate;
@end

NS_ASSUME_NONNULL_END
