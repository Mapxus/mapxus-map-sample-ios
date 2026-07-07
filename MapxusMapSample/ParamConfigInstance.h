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

@property (strong, nonatomic) NSString *venueId;
@property (strong, nonatomic) NSString *buildingId;
@property (strong, nonatomic) NSString *buildingId_1;
@property (strong, nonatomic) NSString *floorId;
@property (strong, nonatomic) NSString *floorId_1;
@property (strong, nonatomic) NSString *floorIds;
@property (strong, nonatomic) NSString *visualFloorId;
@property (strong, nonatomic) NSString *poiId;
@property (assign, nonatomic) CLLocationDegrees center_latitude;
@property (assign, nonatomic) CLLocationDegrees center_longitude;
@property (strong, nonatomic) NSString *sharedFloorId;
@property (strong, nonatomic) NSString *sharedFloorIds;

@property (nonatomic, assign) double routeStylePoint1_lat;
@property (nonatomic, assign) double routeStylePoint1_lon;
@property (nonatomic, assign) double routeStylePoint2_lat;
@property (nonatomic, assign) double routeStylePoint2_lon;
@property (nonatomic, strong) NSString *routeStylePoint2_floorId;
@property (nonatomic, assign) double routeStylePoint3_lat;
@property (nonatomic, assign) double routeStylePoint3_lon;
@property (nonatomic, strong) NSString *routeStylePoint3_floorId;


@property (strong, nonatomic) ParamConfigSearchNearby *search_nearby;       // Search nearby buildings.
@property (strong, nonatomic) ParamConfigAreaBbox *specified_area;      // Search buildings in a specified area and POIs in a specified rectangular area.
@property (strong, nonatomic) ParamConfigAreaBbox *rectangular_area_bbox;       // Bounding box for rectangular POI search.

@property (strong, nonatomic) NSMutableArray<ParamConfigPolygon *> *polygons;       //polygons
@property (strong, nonatomic) NSMutableArray<ParamConfigDrawingMarker *> *drawing_markers;      // Draw markers by floor.

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
@property (strong, nonatomic) NSString *floorId;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
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
