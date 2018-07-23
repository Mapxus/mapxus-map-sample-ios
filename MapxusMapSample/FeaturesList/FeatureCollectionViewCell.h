//
//  FeatureCollectionViewCell.h
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/11.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Feature;

@interface FeatureCollectionViewCell : UICollectionViewCell

- (void)refreshData:(Feature *)data;

@end
