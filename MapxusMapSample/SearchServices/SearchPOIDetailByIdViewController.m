//
//  SearchPOIDetailByIdViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/11.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "SearchPOIDetailByIdViewController.h"
@import ProgressHUD;

@import MapxusMapSDK;
@import Mapbox;

@interface SearchPOIDetailByIdViewController () <MGLMapViewDelegate, MXMSearchDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (nonatomic, strong) MapxusMap *map;

@end

@implementation SearchPOIDetailByIdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.nameStr;
    self.mapView.compassView.hidden = YES;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(22.304716516178253, 114.16186609400843);
    self.mapView.zoomLevel = 16;
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
    [self requestData:@"74216"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    [self requestData:textField.text];
    return YES;
}

- (void)requestData:(NSString *)key
{
    [ProgressHUD show];
    MXMPOISearchRequest *re = [[MXMPOISearchRequest alloc] init];
    re.POIIds = @[key];
    
    MXMSearchAPI *api = [[MXMSearchAPI alloc] init];
    api.delegate = self;
    [api MXMPOISearch:re];
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

    MXMPOI *poi = response.pois.firstObject;
    MXMPointAnnotation *ann = [[MXMPointAnnotation alloc] init];
    ann.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    ann.title = poi.name_default;
    ann.subtitle = [poi.floor stringByAppendingString:@"层"];
    ann.buildingId = poi.buildingId;
    ann.floor = poi.floor;
    
    [self.map addMXMPointAnnotations:@[ann]];
    self.mapView.centerCoordinate = ann.coordinate;
    
    self.nameLabel.text = poi.name_default;
    self.detailLabel.text = poi.buildingId;
    
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
