//
//  SearchBuildingByIDParamViewController.h
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/22.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Param.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchBuildingByIDParamViewController : UIViewController
@property (nonatomic, weak) id<Param> delegate;
@end

NS_ASSUME_NONNULL_END
