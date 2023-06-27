//
//  VenueIDCell.h
//  MapxusMapSample
//
//  Created by guochenghao on 2023/6/7.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VenueIDCell : UITableViewCell
@property (nonatomic, copy) void (^endEditBlock)(VenueIDCell *cell,  NSString * _Nullable text);
- (void)refreshData:(NSString *)data;
@end

NS_ASSUME_NONNULL_END
