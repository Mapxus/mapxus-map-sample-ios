//
//  StatisticalView.m
//  MapxusMapSample
//
//  Created by guochenghao on 2023/6/2.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "StatisticalView.h"

@interface StatisticalView ()
@property (nonatomic, strong) UILabel *distanceTip;
@property (nonatomic, strong) UILabel *timeTip;
@property (nonatomic, strong) UILabel *distance;
@property (nonatomic, strong) UILabel *time;
@end

@implementation StatisticalView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor lightGrayColor];
    [self addViews];
  }
  return self;
}

- (void)setDistance:(double)distance time:(NSUInteger)time {
  self.distance.text = [NSString stringWithFormat:@"%.0fm", distance];
  
  NSUInteger milliseconds = time;
  double seconds = milliseconds / 1000.0;
  double minutes = seconds / 60.0;

  NSString *formattedTime = [NSString stringWithFormat:@"%.02fmin", minutes];
  
  self.time.text = formattedTime;
}

- (void)addViews {
  [self addSubview:self.distanceTip];
  [self addSubview:self.timeTip];
  [self addSubview:self.distance];
  [self addSubview:self.time];

  [self.distanceTip.topAnchor constraintEqualToAnchor:self.topAnchor constant:10].active = YES;
  [self.distanceTip.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10].active = YES;
  [self.distanceTip.widthAnchor constraintEqualToConstant:200].active = YES;
  [self.distanceTip.heightAnchor constraintEqualToConstant:40].active = YES;
  
  [self.distance.topAnchor constraintEqualToAnchor:self.topAnchor constant:10].active = YES;
  [self.distance.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10].active = YES;
  [self.distance.widthAnchor constraintEqualToConstant:120].active = YES;
  [self.distance.heightAnchor constraintEqualToConstant:40].active = YES;


  [self.timeTip.topAnchor constraintEqualToAnchor:self.distanceTip.bottomAnchor constant:10].active = YES;
  [self.timeTip.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10].active = YES;
  [self.timeTip.widthAnchor constraintEqualToConstant:200].active = YES;
  [self.timeTip.heightAnchor constraintEqualToConstant:40].active = YES;
  
  [self.time.topAnchor constraintEqualToAnchor:self.distanceTip.bottomAnchor constant:10].active = YES;
  [self.time.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10].active = YES;
  [self.time.widthAnchor constraintEqualToConstant:120].active = YES;
  [self.time.heightAnchor constraintEqualToConstant:40].active = YES;

}

- (UILabel *)distanceTip {
  if (!_distanceTip) {
    _distanceTip = [[UILabel alloc] init];
    _distanceTip.translatesAutoresizingMaskIntoConstraints = NO;
    _distanceTip.text = @"Total Distance";
  }
  return _distanceTip;
}

- (UILabel *)timeTip {
  if (!_timeTip) {
    _timeTip = [[UILabel alloc] init];
    _timeTip.translatesAutoresizingMaskIntoConstraints = NO;
    _timeTip.text = @"Total time consumption";
  }
  return _timeTip;
}

- (UILabel *)distance {
  if (!_distance) {
    _distance = [[UILabel alloc] init];
    _distance.translatesAutoresizingMaskIntoConstraints = NO;
    _distance.textAlignment = NSTextAlignmentRight;

  }
  return _distance;
}

- (UILabel *)time {
  if (!_time) {
    _time = [[UILabel alloc] init];
    _time.translatesAutoresizingMaskIntoConstraints = NO;
    _time.textAlignment = NSTextAlignmentRight;
  }
  return _time;
}

@end
