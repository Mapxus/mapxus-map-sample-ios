//
//  Feature.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/4/25.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "Feature.h"


@implementation Feature

+ (instancetype)createWithPageClassName:(NSString *)className imageName:(NSString *)imageName title:(NSString *)title subTitle:(NSString *)subTitle
{
    Feature *object = [[Feature alloc] init];
    object.pageClassName = className;
    object.imageName = imageName;
    object.title = title;
    object.subTitle = subTitle;
    return object;
}

@end
