//
//  SearchVenueByIDParamViewController.h
//  MapxusMapSample
//
//  Created by guochenghao on 2023/6/7.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Param.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchVenueByIDParamViewController : UIViewController
@property (nonatomic, weak) id<Param> delegate;
@end

NS_ASSUME_NONNULL_END
