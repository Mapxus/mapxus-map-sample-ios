//
//  SearchIntegratePOIsViewController.h
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/25.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapxusMapSDK/MapxusMapSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchIntegratePOIsViewController : UIViewController
@property (nonatomic, strong) MXMGeoBuilding *building;
@property (nonatomic, strong) MXMCategory *category;
@property (nonatomic, strong) NSDictionary *allCategorys;
@end

NS_ASSUME_NONNULL_END
