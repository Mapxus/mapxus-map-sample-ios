//
//  SearchIntegratePOICell.h
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/25.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapxusMapSDK/MapxusMapSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchIntegratePOICell : UITableViewCell
- (void)refreshPOI:(MXMPOI *)poi categoryName:(NSString *)category;
@end

NS_ASSUME_NONNULL_END
