//
//  SearchCategoryInBoundParamViewController.h
//  MapxusMapSample
//
//  Created by guochenghao on 2024/9/4.
//  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Param.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchCategoryInBoundParamViewController : UIViewController
@property (nonatomic, weak) id<Param> delegate;
@end

NS_ASSUME_NONNULL_END
