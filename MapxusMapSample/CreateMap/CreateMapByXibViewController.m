//
//  CreateMapByXibViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/16.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "CreateMapByXibViewController.h"
#import "ParamConfigInstance.h"

@interface CreateMapByXibViewController ()
@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapPlugin;
@end

@implementation CreateMapByXibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the center coordinate of the map. When this value is changed, the scale level of the map does not change.
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(PARAMCONFIGINFO.center_latitude, PARAMCONFIGINFO.center_longitude);
    // Set the map scale level
    self.mapView.zoomLevel = 18;
    MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
    configuration.defaultStyle = MXMStyleMAPXUS;
    self.mapPlugin = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
}

@end
