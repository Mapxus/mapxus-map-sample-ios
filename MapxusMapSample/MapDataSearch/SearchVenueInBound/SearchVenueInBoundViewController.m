//
//  SearchVenueInBoundViewController.m
//  MapxusMapSample
//
//  Created by guochenghao on 2023/6/7.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <ProgressHUD.h>
#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "SearchVenueInBoundViewController.h"
#import "SearchBuildingInBoundParamViewController.h"
#import "ParamConfigInstance.h"

@interface SearchVenueInBoundViewController () <MGLMapViewDelegate, MXMSearchDelegate, Param>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapxusMap;
@property (strong, nonatomic) MGLPolygon *polygon;
@end

@implementation SearchVenueInBoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];
    MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
    configuration.defaultStyle = MXMStyleMAPXUS;
    self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
}

- (void)openParam {
    SearchBuildingInBoundParamViewController *vc = [[SearchBuildingInBoundParamViewController alloc] init];
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
    [ProgressHUD showError:NSLocalizedString(@"No buildings could be found", nil)];
}

- (void)onVenueSearchDone:(MXMVenueSearchRequest *)request response:(MXMVenueSearchResponse *)response
{
    if (self.mapView.annotations.count) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    [self.mapView addAnnotation:self.polygon];
    
    NSMutableArray *anns = [NSMutableArray array];
    for (MXMBuilding *venue in response.venues) {
        if (response.total == 1) {
            MGLCoordinateBounds bounds = MGLCoordinateBoundsMake(CLLocationCoordinate2DMake(venue.bbox.min_latitude, venue.bbox.min_longitude), CLLocationCoordinate2DMake(venue.bbox.max_latitude, venue.bbox.max_longitude));
            self.mapView.visibleCoordinateBounds = bounds;
        }
        MGLPointAnnotation *ann = [[MGLPointAnnotation alloc] init];
        ann.coordinate = CLLocationCoordinate2DMake(venue.labelCenter.latitude, venue.labelCenter.longitude);
        ann.title = venue.name_default;
        [anns addObject:ann];
    }
    [self.mapView addAnnotations:anns];
    if (response.total > 1) {
        [self.mapView showAnnotations:anns animated:YES];
    }
    
    [ProgressHUD dismiss];
}

#pragma mark - MGLMapViewDelegate
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    return YES;
}

- (UIColor *)mapView:(MGLMapView *)mapView fillColorForPolygonAnnotation:(MGLPolygon *)annotation {
    return [UIColor grayColor];
}

- (CGFloat)mapView:(MGLMapView *)mapView alphaForShapeAnnotation:(MGLShape *)annotation {
    return 0.5;
}

#pragma mark - Param
- (void)completeParamConfiguration:(NSDictionary *)param {
    double min_latitude = [(NSString *)param[@"min_latitude"] doubleValue];
    double min_longitude = [(NSString *)param[@"min_longitude"] doubleValue];
    double max_latitude = [(NSString *)param[@"max_latitude"] doubleValue];
    double max_longitude = [(NSString *)param[@"max_longitude"] doubleValue];
    
    CLLocationCoordinate2D coordinates[] = {
        CLLocationCoordinate2DMake(min_latitude, min_longitude),
        CLLocationCoordinate2DMake(max_latitude, min_longitude),
        CLLocationCoordinate2DMake(max_latitude, max_longitude),
        CLLocationCoordinate2DMake(min_latitude, max_longitude),
        CLLocationCoordinate2DMake(min_latitude, min_longitude),
    };
    NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);
    self.polygon = [MGLPolygon polygonWithCoordinates:coordinates count:numberOfCoordinates];
    
    [ProgressHUD show];
    MXMBoundingBox *box = [[MXMBoundingBox alloc] init];
    box.min_latitude = min_latitude;
    box.min_longitude = min_longitude;
    box.max_latitude = max_latitude;
    box.max_longitude = max_longitude;
    
    MXMVenueSearchRequest *re = [[MXMVenueSearchRequest alloc] init];
    re.keywords = param[@"keywords"];
    re.bbox = box;
    re.offset = [(NSString *)param[@"offset"] integerValue];
    re.page = [(NSString *)param[@"page"] integerValue];
    
    MXMSearchAPI *api = [[MXMSearchAPI alloc] init];
    api.delegate = self;
    [api MXMVenueSearch:re];
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
