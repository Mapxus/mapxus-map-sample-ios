//
//  SearchBuildingInBoundViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/10.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "SearchBuildingInBoundViewController.h"
@import ProgressHUD;

@import Mapbox;
@import MapxusMapSDK;

@interface SearchBuildingInBoundViewController () <MGLMapViewDelegate, MXMSearchDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *map;
@property (strong, nonatomic) MGLPolygon *polygon;

@end

@implementation SearchBuildingInBoundViewController

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
    
    MXMBuildingSearchRequest *re = [[MXMBuildingSearchRequest alloc] init];
    re.keywords = key;
    re.bbox = box;
    re.offset = 100;
    re.page = 1;
    
    MXMSearchAPI *api = [[MXMSearchAPI alloc] init];
    api.delegate = self;
    [api MXMBuildingSearch:re];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self requestData:textField.text];
    [textField endEditing:YES];
    return YES;
}

- (void)MXMSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [ProgressHUD showError:NSLocalizedString(@"No buildings were found", nil)];
}

- (void)onBuildingSearchDone:(MXMBuildingSearchRequest *)request response:(MXMBuildingSearchResponse *)response
{
    // 移除之前加入的标注点
    if (self.mapView.annotations.count) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    [self.mapView addAnnotation:self.polygon];

    // 添加标注
    NSMutableArray *anns = [NSMutableArray array];
    for (MXMBuilding *building in response.buildings) {
        // 只有一个结果，缩放到建筑
        if (response.total == 1) {
            MGLCoordinateBounds bounds = MGLCoordinateBoundsMake(CLLocationCoordinate2DMake(building.bbox.min_latitude, building.bbox.min_longitude), CLLocationCoordinate2DMake(building.bbox.max_latitude, building.bbox.max_longitude));
            self.mapView.visibleCoordinateBounds = bounds;
        }
        MGLPointAnnotation *ann = [[MGLPointAnnotation alloc] init];
        ann.coordinate = CLLocationCoordinate2DMake(building.labelCenter.latitude, building.labelCenter.longitude);
        ann.title = building.name_default;
        [anns addObject:ann];
    }
    [self.mapView addAnnotations:anns];
    // 有多个结果，缩放到显示所有建筑
    if (response.total > 1) {
        [self.mapView showAnnotations:anns animated:YES];
    }
    
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
