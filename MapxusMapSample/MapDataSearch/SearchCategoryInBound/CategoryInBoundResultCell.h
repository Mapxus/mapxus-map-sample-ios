//
//  CategoryInBoundResultCell.h
//  MapxusMapSample
//
//  Created by guochenghao on 2024/9/4.
//  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapxusMapSDK/MapxusMapSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategoryInBoundResultCell : UITableViewCell
- (void)refreshData:(MXMPoiCategoryVenueInfoEx *)data;

@end

NS_ASSUME_NONNULL_END