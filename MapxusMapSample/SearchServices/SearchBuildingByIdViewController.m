//
//  SearchBuildingByIdViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/11.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "SearchBuildingByIdViewController.h"
@import ProgressHUD;

@import MapxusMapSDK;
@import Mapbox;

@interface SearchBuildingByIdViewController () <MGLMapViewDelegate, MXMSearchDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) MapxusMap *map;

@end

@implementation SearchBuildingByIdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.nameStr;
    [self requestData:@"elements_hk_dc005f"];
    
    self.mapView.compassView.hidden = YES;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(22.304716516178253, 114.16186609400843);
    self.mapView.zoomLevel = 16;
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    [self requestData:textField.text];
    return YES;
}

- (void)requestData:(NSString *)key
{
    if (key) {
        [ProgressHUD show];
        MXMBuildingSearchRequest *re = [[MXMBuildingSearchRequest alloc] init];
        re.buildingIds = @[key];
        
        MXMSearchAPI *api = [[MXMSearchAPI alloc] init];
        api.delegate = self;
        [api MXMBuildingSearch:re];
    }
}

- (void)MXMSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [ProgressHUD showError:NSLocalizedString(@"No buildings were found", nil)];
}

- (void)onBuildingSearchDone:(MXMBuildingSearchRequest *)request response:(MXMBuildingSearchResponse *)response
{
    if (self.mapView.annotations.count) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }

    MXMBuilding *building = response.buildings.firstObject;
    
    MGLCoordinateBounds bounds = MGLCoordinateBoundsMake(CLLocationCoordinate2DMake(building.bbox.min_latitude, building.bbox.min_longitude), CLLocationCoordinate2DMake(building.bbox.max_latitude, building.bbox.max_longitude));
    self.mapView.visibleCoordinateBounds = bounds;
    
    MGLPointAnnotation *ann = [[MGLPointAnnotation alloc] init];
    ann.coordinate = CLLocationCoordinate2DMake(building.labelCenter.latitude, building.labelCenter.longitude);
    ann.title = building.name_default;
    
    [self.mapView addAnnotation:ann];
    
    self.nameLabel.text = building.name_default;
    self.addressLabel.text = [building.address_default.street stringByAppendingString:building.address_default.housenumber];
    
    [ProgressHUD dismiss];
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation
{
    return YES;
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
