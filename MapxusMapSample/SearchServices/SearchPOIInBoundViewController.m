//
//  SearchPOIInBoundViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/11.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "SearchPOIInBoundViewController.h"
@import ProgressHUD;

@import MapxusMapSDK;
@import Mapbox;

@interface SearchPOIInBoundViewController () <MGLMapViewDelegate, MXMSearchDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *map;
@property (nonatomic, strong) MGLPolygon *polygon;

@end

@implementation SearchPOIInBoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.nameStr;
    
    CLLocationCoordinate2D coordinates[] = {
        CLLocationCoordinate2DMake(22.292540, 114.158608),
        CLLocationCoordinate2DMake(22.310600, 114.158608),
        CLLocationCoordinate2DMake(22.310600, 114.172422),
        CLLocationCoordinate2DMake(22.292540, 114.172422),
        CLLocationCoordinate2DMake(22.292540, 114.158608),
    };
    NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);
    self.polygon = [MGLPolygon polygonWithCoordinates:coordinates count:numberOfCoordinates];
    [self.mapView addAnnotation:self.polygon];
    
    self.mapView.compassView.hidden = YES;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(22.304716516178253, 114.16186609400843);
    self.mapView.zoomLevel = 16;
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
}

- (void)requestData:(NSString *)key
{
    [ProgressHUD show];
    MXMBoundingBox *box = [[MXMBoundingBox alloc] init];
    box.min_latitude = 22.292540;
    box.min_longitude = 114.158608;
    box.max_latitude = 22.310600;
    box.max_longitude = 114.172422;
    
    MXMPOISearchRequest *re = [[MXMPOISearchRequest alloc] init];
    re.keywords = key;
    re.bbox = box;
    re.offset = 100;
    re.page = 1;
    
    MXMSearchAPI *api = [[MXMSearchAPI alloc] init];
    api.delegate = self;
    [api MXMPOISearch:re];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self requestData:textField.text];
    [textField endEditing:YES];
    return YES;
}

- (void)MXMSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [ProgressHUD showError:NSLocalizedString(@"No POI were found", nil)];
}

- (void)onPOISearchDone:(MXMPOISearchRequest *)request response:(MXMPOISearchResponse *)response
{
    if (self.map.MXMAnnotations.count) {
        [self.map removeMXMPointAnnotaions:self.map.MXMAnnotations];
    }
    [self.mapView addAnnotation:self.polygon];
    
    NSMutableArray *anns = [NSMutableArray array];
    for (MXMPOI *poi in response.pois) {
        MXMPointAnnotation *ann = [[MXMPointAnnotation alloc] init];
        ann.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        ann.title = poi.name_default;
        ann.subtitle = [poi.floor stringByAppendingString:@"层"];
        ann.buildingId = poi.buildingId;
        ann.floor = poi.floor;
        [anns addObject:ann];
    }
    [self.map addMXMPointAnnotations:anns];
    [self.mapView showAnnotations:anns animated:YES];
    
    [ProgressHUD dismiss];
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation
{
    return YES;
}

- (void)mapViewDidFinishLoadingMap:(MGLMapView *)mapView
{
    self.mapView.visibleCoordinateBounds = MGLCoordinateBoundsMake(CLLocationCoordinate2DMake(22.292540, 114.158608), CLLocationCoordinate2DMake(22.310600, 114.172422));
}

- (UIColor *)mapView:(MGLMapView *)mapView fillColorForPolygonAnnotation:(MGLPolygon *)annotation
{
    return [UIColor grayColor];
}

- (CGFloat)mapView:(MGLMapView *)mapView lineWidthForPolylineAnnotation:(MGLPolyline *)annotation
{
    return 3;
}

- (CGFloat)mapView:(MGLMapView *)mapView alphaForShapeAnnotation:(MGLShape *)annotation
{
    return 0.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
