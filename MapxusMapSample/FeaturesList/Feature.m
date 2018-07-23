//
//  Feature.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/4/25.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "Feature.h"

@implementation Feature


- (instancetype)initWithIdentifie:(FeatureType)identifie imageName:(NSString *)imageName title:(NSString *)title subTitle:(NSString *)subTitle
{
    self = [super init];
    if (self) {
        self.identifie = identifie;
        self.imageName = imageName;
        self.title = title;
        self.subTitle = subTitle;
    }
    return self;
}


+ (NSArray *)gettingStartedList
{
    Feature *feature1 = [[Feature alloc] initWithIdentifie:FeatureTypeSimpleMapView
                                                 imageName:@"0_1-1"
                                                     title:NSLocalizedString(@"A simple Map View", nil)
                                                  subTitle:NSLocalizedString(@"Show a map in your app using the Mapxus Maps SDK.", nil)];
    Feature *feature3 = [[Feature alloc] initWithIdentifie:FeatureTypeDynamicallyBuild
                                                 imageName:@"0_1-3"
                                                     title:NSLocalizedString(@"Build a map view using xib", nil)
                                                  subTitle:NSLocalizedString(@"Add a mapview in xib.", nil)];
    
    return @[feature1, feature3];
}


+ (NSArray *)stylesList
{
    Feature *feature1 = [[Feature alloc] initWithIdentifie:FeatureTypeDefaultStyles
                                                 imageName:@"0_2-1"
                                                     title:NSLocalizedString(@"Default Styles", nil)
                                                  subTitle:NSLocalizedString(@"Use a variety of professionally designed styles with the Mapxus Maps SDK.", nil)];
    return @[feature1];
}


+ (NSArray *)annotationsList
{
    Feature *feature1 = [[Feature alloc] initWithIdentifie:FeatureTypeDrawMarker
                                                 imageName:@"0_3-1"
                                                     title:NSLocalizedString(@"Draw a marker", nil)
                                                  subTitle:NSLocalizedString(@"Create a default marker using the Mapxus Maps SDK.", nil)];
    Feature *feature2 = [[Feature alloc] initWithIdentifie:FeatureTypeDrawCustomMarkerIcon
                                                 imageName:@"0_3-2"
                                                     title:NSLocalizedString(@"Draw a custom marker icon", nil)
                                                  subTitle:NSLocalizedString(@"Create a marker with a custom icon using the Mapxus Maps SDK.", nil)];
    Feature *feature3 = [[Feature alloc] initWithIdentifie:FeatureTypeDrawPolygon
                                                 imageName:@"0_3-3"
                                                     title:NSLocalizedString(@"Draw a polygon", nil)
                                                  subTitle:NSLocalizedString(@"Draw a vector polygon on a map with the Mapxus Maps SDK.", nil)];
    Feature *feature4 = [[Feature alloc] initWithIdentifie:FeatureTypeDrawPolygonWithHoles
                                                 imageName:@"0_3-4"
                                                     title:NSLocalizedString(@"Draw a polygon with holes", nil)
                                                  subTitle:NSLocalizedString(@"Draw a vector polygon with holes on a map using the Mapxus Maps SDK.", nil)];
    Feature *feature5 = [[Feature alloc] initWithIdentifie:FeatureTypeAnimateMarkerPosition
                                                 imageName:@"0_3-5"
                                                     title:NSLocalizedString(@"Animate marker position", nil)
                                                  subTitle:NSLocalizedString(@"Animate the marker to a new position on the map.", nil)];
    
    return @[feature1, feature2, feature3, feature4, feature5];
}


+ (NSArray *)cameraList
{
    Feature *feature1 = [[Feature alloc] initWithIdentifie:FeatureTypeAnimateTheMapCamera
                                                 imageName:@"0_4-1"
                                                     title:NSLocalizedString(@"Animate the map camera", nil)
                                                  subTitle:NSLocalizedString(@"Animate the map’s camera position, tile, bearing and the zoom.", nil)];
    Feature *feature2 = [[Feature alloc] initWithIdentifie:FeatureTypeRestrictMapPanning
                                                 imageName:@"0_4-2"
                                                     title:NSLocalizedString(@"Restrict map panning", nil)
                                                  subTitle:NSLocalizedString(@"Prevent a map from being panned to a different place.", nil)];
    return @[feature1, feature2];
}


+ (NSArray *)listenerList
{
    Feature *feature1 = [[Feature alloc] initWithIdentifie:FeatureTypeBuildingAndFloorChange
                                                 imageName:@"5-1"
                                                     title:NSLocalizedString(@"Building and floor change", nil)
                                                  subTitle:NSLocalizedString(@"Build and floor change.", nil)];
    Feature *feature2 = [[Feature alloc] initWithIdentifie:FeatureTypePOIClickListener
                                                 imageName:@"5-2"
                                                     title:NSLocalizedString(@"POI click listener", nil)
                                                  subTitle:NSLocalizedString(@"POI Click Listner.", nil)];
    Feature *feature3 = [[Feature alloc] initWithIdentifie:FeatureTypeCameraChange
                                                 imageName:@"5-3"
                                                     title:NSLocalizedString(@"Camera Change", nil)
                                                  subTitle:NSLocalizedString(@"Camera Change.", nil)];
    return @[feature1, feature2, feature3];
}


+ (NSArray *)searchServicesList
{
    Feature *feature1 = [[Feature alloc] initWithIdentifie:FeatureTypeRoutePlanning
                                                 imageName:@"06-1"
                                                     title:NSLocalizedString(@"Route Planning", nil)
                                                  subTitle:NSLocalizedString(@"Route Planning.", nil)];
    Feature *feature2 = [[Feature alloc] initWithIdentifie:FeatureTypeSearchBuildingNearby
                                                 imageName:@"06-2"
                                                     title:NSLocalizedString(@"Search Building Nearby", nil)
                                                  subTitle:NSLocalizedString(@"Search building nearby.", nil)];
    Feature *feature3 = [[Feature alloc] initWithIdentifie:FeatureTypeSearchBuildingInBound
                                                 imageName:@"06-3"
                                                     title:NSLocalizedString(@"Search Building in bound", nil)
                                                  subTitle:NSLocalizedString(@"Search building in bound.", nil)];
    Feature *feature4 = [[Feature alloc] initWithIdentifie:FeatureTypeSearchBuildingDetailById
                                                 imageName:@"06-4"
                                                     title:NSLocalizedString(@"Search Building Detail by ID", nil)
                                                  subTitle:NSLocalizedString(@"Search Building detail by ID.", nil)];
    Feature *feature5 = [[Feature alloc] initWithIdentifie:FeatureTypeSearchBuildingGlobal
                                                 imageName:@"06-5"
                                                     title:NSLocalizedString(@"Search Building Global", nil)
                                                  subTitle:NSLocalizedString(@"Search Building Global.", nil)];
    Feature *feature6 = [[Feature alloc] initWithIdentifie:FeatureTypeSearchPOINearby
                                                 imageName:@"06-6"
                                                     title:NSLocalizedString(@"Search POI nearby", nil)
                                                  subTitle:NSLocalizedString(@"Search POI nearby.", nil)];
    Feature *feature7 = [[Feature alloc] initWithIdentifie:FeatureTypeSearchPOIInBound
                                                 imageName:@"06-7"
                                                     title:NSLocalizedString(@"Search POI in bound", nil)
                                                  subTitle:NSLocalizedString(@"Search POI in bound.", nil)];
    Feature *feature8 = [[Feature alloc] initWithIdentifie:FeatureTypeSearchPOIDetailById
                                                 imageName:@"06-8"
                                                     title:NSLocalizedString(@"Search POI detail by ID", nil)
                                                  subTitle:NSLocalizedString(@"Search POI detail by ID.", nil)];
    Feature *feature9 = [[Feature alloc] initWithIdentifie:FeatureTypeSearchPOIInBuilding
                                                 imageName:@"06-9"
                                                     title:NSLocalizedString(@"Search POI in building", nil)
                                                  subTitle:NSLocalizedString(@"Search POI in building.", nil)];
    return @[feature1, feature2, feature3, feature4, feature5, feature6, feature7, feature8, feature9];
}

+ (NSArray *)locationList
{
    Feature *feature1 = [[Feature alloc] initWithIdentifie:FeatureTypeShowLocation
                                                 imageName:@"Location"
                                                     title:NSLocalizedString(@"Displaying the users location", nil)
                                                  subTitle:NSLocalizedString(@"Displaying the users location.", nil)];
    return @[feature1];
}


@end
