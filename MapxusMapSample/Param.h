//
//  Param.h
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/20.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParamConfigInstance.h"

NS_ASSUME_NONNULL_BEGIN

@protocol Param <NSObject>
- (void)completeParamConfiguration:(NSDictionary *)param;
@end

NS_ASSUME_NONNULL_END
