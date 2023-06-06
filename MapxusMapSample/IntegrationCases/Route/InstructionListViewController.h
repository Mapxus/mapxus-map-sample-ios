//
//  InstructionListViewController.h
//  MapxusMapSample
//
//  Created by guochenghao on 2023/6/2.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteViewController.h"

@class MXMInstruction;

NS_ASSUME_NONNULL_BEGIN

@interface InstructionListViewController : UIViewController <RouteViewControllerDelegate>

- (instancetype)initWithInstructions:(NSArray<MXMInstruction *> *)list distance:(double)distance time:(NSUInteger)time;

@end

NS_ASSUME_NONNULL_END
