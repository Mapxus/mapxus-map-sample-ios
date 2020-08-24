//
//  VisualDirectionAnnotationView.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/12/20.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "VisualDirectionAnnotationView.h"

#define angle2Rad(angle) ((angle) / 180.0 * M_PI)

@interface VisualDirectionAnnotationView ()

@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation VisualDirectionAnnotationView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 72, 72);
        self.rotatesToMatchCamera = YES;
        self.iconView.frame = CGRectMake(0, 0, 72, 72);
        [self addSubview:self.iconView];
    }
    return self;
}

- (void)changeRotate:(double)rotate
{
    self.iconView.transform = CGAffineTransformMakeRotation((angle2Rad(rotate)));
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_current_position"]];
    }
    return _iconView;
}

@end
