//
//  CategoryCell.h
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/23.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapxusMapSDK/MapxusMapSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategoryCell : UITableViewCell
- (void)refreshData:(MXMCategory *)data;
@end

NS_ASSUME_NONNULL_END
