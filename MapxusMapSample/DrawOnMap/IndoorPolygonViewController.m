//
//  IndoorPolygonViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/20.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "IndoorPolygonViewController.h"

@interface IndoorPolygonViewController () <MGLMapViewDelegate, MapxusMapDelegate>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapPlugin;
@end

@implementation IndoorPolygonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];
    MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
    configuration.defaultStyle = MXMStyleMAPXUS;
    self.mapPlugin = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
    self.mapPlugin.delegate = self;
}

- (void)addPolygon {
    CLLocationCoordinate2D coordinates[] = {
        CLLocationCoordinate2DMake(22.370860, 114.111155),
        CLLocationCoordinate2DMake(22.371031, 114.111280),
        CLLocationCoordinate2DMake(22.370941, 114.111481),
        CLLocationCoordinate2DMake(22.370873, 114.111423),
        CLLocationCoordinate2DMake(22.370816, 114.111512),
        CLLocationCoordinate2DMake(22.370703, 114.111449),
        CLLocationCoordinate2DMake(22.370860, 114.111155),
    };
    NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);
    
    MGLPolygonFeature *polygon = [MGLPolygonFeature polygonWithCoordinates:coordinates count:numberOfCoordinates];
    polygon.attributes = @{@"floor": @"L1", @"buildingId": @"tsuenwanplaza_hk_369d01"};
    
    MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"source" shape:polygon options:nil];
    MGLFillStyleLayer *layer = [[MGLFillStyleLayer alloc] initWithIdentifier:@"layer" source:source];
    layer.fillColor = [NSExpression expressionForConstantValue:[UIColor redColor]];
    layer.fillOpacity = [NSExpression expressionForConstantValue:@(0.5)];
    [self.mapView.style addSource:source];
    [self.mapView.style addLayer:layer];
}

- (void)layoutUI {
    [self.view addSubview:self.mapView];
    
    [self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
}

#pragma mark - MapxusMapDelegate
- (void)mapView:(MapxusMap *)mapView didChangeFloor:(NSString *)floorName atBuilding:(MXMGeoBuilding *)building {
    // When the scene is changed, modify the layer`s predicate to filter features
    MGLVectorStyleLayer *layer = (MGLVectorStyleLayer *)[self.mapView.style layerWithIdentifier:@"layer"];
    NSPredicate *p0 = [NSPredicate predicateWithFormat:@"buildingId == %@", building.identifier];
    NSPredicate *p1 = [NSPredicate predicateWithFormat:@"floor == %@", floorName];
    layer.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p0, p1]];
}

#pragma mark - MGLMapViewDelegate
- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    // Add style layer after loaded style
    [self addPolygon];
}

#pragma mark - Lazy loading
- (MGLMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MGLMapView alloc] init];
        _mapView.translatesAutoresizingMaskIntoConstraints = NO;
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(22.370787, 114.111375);
        _mapView.zoomLevel = 18;
        _mapView.delegate = self;
    }
    return _mapView;
}

@end
