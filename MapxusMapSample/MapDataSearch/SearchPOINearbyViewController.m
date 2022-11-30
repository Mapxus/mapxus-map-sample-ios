//
//  SearchPOINearbyViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/11.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <ProgressHUD.h>
#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "SearchPOINearbyViewController.h"
#import "SearchPOINearbyParamViewController.h"
#import "ParamConfigInstance.h"

@interface SearchPOINearbyViewController () <MGLMapViewDelegate, MXMSearchDelegate, Param>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapPlugin;
@end

@implementation SearchPOINearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];

    MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
    configuration.defaultStyle = MXMStyleMAPXUS;
    self.mapPlugin = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
}

- (void)openParam {
    SearchPOINearbyParamViewController *vc = [[SearchPOINearbyParamViewController alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)layoutUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Params" style:UIBarButtonItemStylePlain target:self action:@selector(openParam)];
    [self.view addSubview:self.mapView];
    [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.mapView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.mapView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
}

#pragma mark - MXMSearchDelegate
- (void)MXMSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [ProgressHUD showError:NSLocalizedString(@"No POI could be found", nil)];
}

- (void)onPOISearchDone:(MXMPOISearchRequest *)request response:(MXMPOISearchResponse *)response
{
    if (self.mapPlugin.MXMAnnotations.count) {
        [self.mapPlugin removeMXMPointAnnotaions:self.mapPlugin.MXMAnnotations];
    }

    NSMutableArray *anns = [NSMutableArray array];
    for (MXMPOI *poi in response.pois) {
        MXMPointAnnotation *ann = [[MXMPointAnnotation alloc] init];
        ann.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        ann.title = poi.name_default;
        ann.subtitle = [poi.floor.code stringByAppendingString:@"层"];
        ann.buildingId = poi.buildingId;
        ann.floor = poi.floor.code;
        [anns addObject:ann];
    }
    
    [self.mapPlugin addMXMPointAnnotations:anns];
    [self.mapView showAnnotations:anns animated:YES];
    
    [ProgressHUD dismiss];
}

#pragma mark - MGLMapViewDelegate
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation
{
    return YES;
}

#pragma mark - Param
- (void)completeParamConfiguration:(NSDictionary *)param {
    [ProgressHUD show];
        
    MXMGeoPoint *point = [[MXMGeoPoint alloc] init];
    point.latitude = [(NSString *)param[@"latitude"] doubleValue];
    point.longitude = [(NSString *)param[@"longitude"] doubleValue];
    
    MXMPOISearchRequest *re = [[MXMPOISearchRequest alloc] init];
    re.keywords = param[@"keywords"];
    re.center = point;
    re.category = param[@"category"];
    re.sort = param[@"sort"];
    re.meterDistance = [(NSString *)param[@"meterDistance"] integerValue];
    re.ordinal = [(NSString *)param[@"ordinal"] integerValue];
    re.buildingId = param[@"buildingId"];
    re.offset = [(NSString *)param[@"offset"] integerValue];
    re.page = [(NSString *)param[@"page"] integerValue];
    
    MXMSearchAPI *api = [[MXMSearchAPI alloc] init];
    api.delegate = self;
    [api MXMPOISearch:re];
}

#pragma mark - Lazy loading
- (MGLMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MGLMapView alloc] init];
        _mapView.translatesAutoresizingMaskIntoConstraints = NO;
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(PARAMCONFIGINFO.center_latitude, PARAMCONFIGINFO.center_longitude);
        _mapView.zoomLevel = 18;
        _mapView.delegate = self;
    }
    return _mapView;
}

@end
