//
//  ParamConfigInstance.h
//  MapxusMapSample
//
//  Created by mapxus on 2022/11/29.
//  Copyright © 2022 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

NS_ASSUME_NONNULL_BEGIN

#define PARAMCONFIGINFO [ParamConfigInstance shared].info

@class ParamConfigInfo;
@interface ParamConfigInstance : NSObject

@property (strong, nonatomic) ParamConfigInfo *info;
+ (ParamConfigInstance *)shared;

@end

@class ParamConfigPolygon;
@class ParamConfigAreaBbox;
@class ParamConfigSearchNearby;
@class ParamConfigDrawingMarker;

@interface ParamConfigInfo : NSObject

@property (strong, nonatomic) NSString *buildingId;
@property (strong, nonatomic) NSString *buildingId_1;
@property (strong, nonatomic) NSString *poiId;
@property (strong, nonatomic) NSString *floor;
@property (assign, nonatomic) CLLocationDegrees center_latitude;
@property (assign, nonatomic) CLLocationDegrees center_longitude;

@property (strong, nonatomic) ParamConfigSearchNearby *search_nearby;       //搜索附近建筑
@property (strong, nonatomic) ParamConfigAreaBbox *specified_area;      //指定区域内搜索建筑和 指定矩形区域内*POI*搜寻
@property (strong, nonatomic) ParamConfigAreaBbox *rectangular_area_bbox;       //矩形区域*POI*搜索的bbox：

@property (strong, nonatomic) NSMutableArray<ParamConfigPolygon *> *polygons;       //polygons
@property (strong, nonatomic) NSMutableArray<ParamConfigDrawingMarker *> *drawing_markers;      //按楼层绘制标注

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end


@interface ParamConfigPolygon : NSObject

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end


@interface ParamConfigDrawingMarker : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSString *buildingId;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *floor;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end


@interface ParamConfigSearchNearby : NSObject

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end


@interface ParamConfigAreaBbox : NSObject

@property (strong, nonatomic) NSString *min_latitude;
@property (strong, nonatomic) NSString *min_longitude;

@property (strong, nonatomic) NSString *max_latitude;
@property (strong, nonatomic) NSString *max_longitude;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end


NS_ASSUME_NONNULL_END
