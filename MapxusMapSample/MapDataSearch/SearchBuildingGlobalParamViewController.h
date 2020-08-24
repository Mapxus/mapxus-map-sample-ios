//
//  SearchBuildingGlobalParamViewController.h
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/21.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Param.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchBuildingGlobalParamViewController : UIViewController
@property (nonatomic, weak) id<Param> delegate;
@end

NS_ASSUME_NONNULL_END
