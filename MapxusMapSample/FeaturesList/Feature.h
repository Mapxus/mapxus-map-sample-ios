//
//  Feature.h
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/4/25.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FeatureType) {
    FeatureTypeSimpleMapView,
    FeatureTypeMapFragment,
    FeatureTypeDynamicallyBuild,
    FeatureTypeDefaultStyles,
    FeatureTypeDrawMarker,
    FeatureTypeDrawCustomMarkerIcon,
    FeatureTypeDrawPolygon,
    FeatureTypeDrawPolygonWithHoles,
    FeatureTypeAnimateMarkerPosition,
    FeatureTypeAnimateTheMapCamera,
    FeatureTypeRestrictMapPanning,
    FeatureTypeBuildingAndFloorChange,
    FeatureTypePOIClickListener,
    FeatureTypeCameraChange,
    FeatureTypeRoutePlanning,
    FeatureTypeSearchBuildingNearby,
    FeatureTypeSearchBuildingInBound,
    FeatureTypeSearchBuildingDetailById,
    FeatureTypeSearchBuildingGlobal,
    FeatureTypeSearchPOINearby,
    FeatureTypeSearchPOIInBound,
    FeatureTypeSearchPOIDetailById,
    FeatureTypeSearchPOIInBuilding,
    FeatureTypeShowLocation,
};

@interface Feature : NSObject

@property (nonatomic, assign) FeatureType identifie;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;

- (instancetype)initWithIdentifie:(FeatureType)identifie imageName:(NSString *)imageName title:(NSString *)title subTitle:(NSString *)subTitle;

+ (NSArray *)gettingStartedList;
+ (NSArray *)stylesList;
+ (NSArray *)annotationsList;
+ (NSArray *)cameraList;
+ (NSArray *)listenerList;
+ (NSArray *)searchServicesList;
+ (NSArray *)locationList;

@end
