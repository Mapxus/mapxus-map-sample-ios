//
//  VisualDirectionAnnotationView.h
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/12/20.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface VisualDirectionAnnotationView : MGLAnnotationView

- (void)changeRotate:(double)rotate;

@end

NS_ASSUME_NONNULL_END
