//
//  Feature.h
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/4/25.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Feature : NSObject
@property (nonatomic, strong) NSString *pageClassName;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
+ (instancetype)createWithPageClassName:(NSString *)className
                              imageName:(NSString *)imageName
                                  title:(NSString *)title
                               subTitle:(NSString *)subTitle;
@end
