//
//  ParamConfigInstance.m
//  MapxusMapSample
//
//  Created by mapxus on 2022/11/29.
//  Copyright © 2022 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "ParamConfigInstance.h"

@implementation ParamConfigInstance

static ParamConfigInstance *__onetimeClass;
+ (ParamConfigInstance *)shared
{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        __onetimeClass = [[ParamConfigInstance alloc] init];
    });
    return __onetimeClass;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *param = [self getJsonDataJsonname:PARAM_CONFIG_FILE];
        self.info = [[ParamConfigInfo alloc] initWithDictionary:param];
    }
    return self;
}

- (id)getJsonDataJsonname:(NSString *)jsonname
{
    NSString *path = [[NSBundle mainBundle] pathForResource:jsonname ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (!jsonData || error) {
        return nil;
    } else {
        return jsonObj;
    }
}

@end


@implementation ParamConfigInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dictionary];
        
        ParamConfigSearchNearby *s_n = [[ParamConfigSearchNearby alloc] initWithDictionary:dictionary[@"search_nearby"]];
        self.search_nearby = s_n;
        
        ParamConfigAreaBbox *area_bbox = [[ParamConfigAreaBbox alloc] initWithDictionary:dictionary[@"rectangular_area_bbox"]];
        self.rectangular_area_bbox = area_bbox;
        
        ParamConfigAreaBbox *specified_area = [[ParamConfigAreaBbox alloc] initWithDictionary:dictionary[@"rectangular_area_bbox"]];
        self.specified_area = specified_area;
        
        _polygons = [NSMutableArray array];
        for (NSDictionary *dict in dictionary[@"polygons"]) {
            ParamConfigPolygon *tagInfo = [[ParamConfigPolygon alloc] initWithDictionary:dict];
            [self.polygons addObject:tagInfo];
        }
        
        _drawing_markers = [NSMutableArray array];
        for (NSDictionary *dict in dictionary[@"drawing_markers"]) {
            ParamConfigDrawingMarker *tagInfo = [[ParamConfigDrawingMarker alloc] initWithDictionary:dict];
            [self.drawing_markers addObject:tagInfo];
        }
        
    }
    return self;
}

@end


@implementation ParamConfigPolygon

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

@end


@implementation ParamConfigDrawingMarker

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
@end


@implementation ParamConfigSearchNearby

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

@end

@implementation ParamConfigAreaBbox

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

@end
