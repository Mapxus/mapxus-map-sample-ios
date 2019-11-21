//
//  SearchBuildingGlobalViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/11.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

@import MapxusMapSDK;
@import Mapbox;

#import "SearchBuildingGlobalViewController.h"
@import ProgressHUD;

@interface SearchBuildingGlobalViewController () <MXMSearchDelegate, MGLMapViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *keyTF;
@property (nonatomic, strong) MapxusMap *map;

@end

@implementation SearchBuildingGlobalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.nameStr;
    self.mapView.compassView.hidden = YES;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(22.370787, 114.111375);
    self.mapView.zoomLevel = 18;
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self requestData:textField.text];
    [textField endEditing:YES];
    return YES;
}

- (void)requestData:(NSString *)key
{
    [ProgressHUD show];
    MXMBuildingSearchRequest *re = [[MXMBuildingSearchRequest alloc] init];
    re.keywords = self.keyTF.text;
    re.offset = 100;
    re.page = 1;
    
    MXMSearchAPI *api = [[MXMSearchAPI alloc] init];
    api.delegate = self;
    [api MXMBuildingSearch:re];
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
    
    // 添加标注
    NSMutableArray *anns = [NSMutableArray array];
    for (MXMBuilding *building in response.buildings) {
        // 只有一个结果，缩放到建筑
        if (response.total == 1) {
            [self.map selectBuilding:building.buildingId zoomMode:MXMZoomAnimated edgePadding:UIEdgeInsetsZero];
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
