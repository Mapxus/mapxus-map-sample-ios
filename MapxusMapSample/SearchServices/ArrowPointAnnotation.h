//
//  ArrowPointAnnotation.h
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/13.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

@import Mapbox;

@interface ArrowPointAnnotation : MGLPointAnnotation

@property (nonatomic, assign) double angle;
@property (nonatomic, assign) int type; // 0:方向标，1:起始点，2:终点，3:每段的起点

@end
