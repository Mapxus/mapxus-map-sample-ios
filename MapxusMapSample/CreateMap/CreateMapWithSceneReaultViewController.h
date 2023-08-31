//
//  CreateMapWithSceneReaultViewController.h
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/16.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreateMapWithSceneReaultViewController : UIViewController
@property (nonatomic, strong, nullable) NSString *floorId;
@property (nonatomic, strong, nullable) NSString *buildingId;
@property (nonatomic, strong, nullable) NSString *venueId;
@property (nonatomic, assign) UIEdgeInsets zoomInsets;
@end

NS_ASSUME_NONNULL_END
