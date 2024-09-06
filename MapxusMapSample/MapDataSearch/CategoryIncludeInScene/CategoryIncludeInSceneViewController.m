//
//  CategoryIncludeInSceneViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/22.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <ProgressHUD.h>
#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "CategoryIncludeInSceneViewController.h"
#import "CategoryIncludeInSceneResultViewController.h"
#import "Macro.h"

@interface CategoryIncludeInSceneViewController () <MGLMapViewDelegate, MXMCategorySearchDelegate>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapxusMap;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIButton *searchInVenueButton;
@property (nonatomic, strong) UIButton *searchInBuildingButton;
@property (nonatomic, strong) UIButton *searchOnFloorButton;
@end

@implementation CategoryIncludeInSceneViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self layoutUI];
  
  MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
  configuration.defaultStyle = MXMStyleMAPXUS;
  self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
}

// Search all categories in venue
- (void)searchInVenueButtonAction:(UIButton *)sender {
  if (self.mapxusMap.selectedVenueId == nil) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Please select the scene first." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    return;
  }
  [ProgressHUD show];
  
  MXMPoiCategoryVenueSearchOption *option = [[MXMPoiCategoryVenueSearchOption alloc] init];
  option.venueId = self.mapxusMap.selectedVenueId;
  
  MXMCategorySearch *api = [[MXMCategorySearch alloc] init];
  api.delegate = self;
  [api searchPoiCategoriesByVenue:option];
}

// Search all categories in building
- (void)searchInBuildingButtonAction:(UIButton *)sender {
  if (self.mapxusMap.selectedBuildingId == nil) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Please select the scene first." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    return;
  }
  [ProgressHUD show];
  
  MXMPoiCategoryBuildingSearchOption *option = [[MXMPoiCategoryBuildingSearchOption alloc] init];
  option.buildingId = self.mapxusMap.selectedBuildingId;
  
  MXMCategorySearch *api = [[MXMCategorySearch alloc] init];
  api.delegate = self;
  [api searchPoiCategoriesByBuilding:option];
}

// Search all categories on the floor
- (void)searchOnFloorButtonAction:(UIButton *)sender {
  if (self.mapxusMap.selectedFloor == nil) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Please select the scene first." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    return;
  }
  [ProgressHUD show];
  
  MXMPoiCategoryFloorSearchOption *option = [[MXMPoiCategoryFloorSearchOption alloc] init];
  option.floorId = self.mapxusMap.selectedFloor.floorId;
  
  MXMCategorySearch *api = [[MXMCategorySearch alloc] init];
  api.delegate = self;
  [api searchPoiCategoriesByFloor:option];
}

- (void)layoutUI {
  [self.view addSubview:self.mapView];
  [self.view addSubview:self.boxView];
  [self.boxView addSubview:self.tipLabel];
  [self.boxView addSubview:self.stackView];
  [self.stackView addArrangedSubview:self.searchOnFloorButton];
  [self.stackView addArrangedSubview:self.searchInBuildingButton];
  [self.stackView addArrangedSubview:self.searchInVenueButton];
  
  [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
  [self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
  [self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
  [self.mapView.bottomAnchor constraintEqualToAnchor:self.boxView.topAnchor].active = YES;
  
  [self.boxView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
  [self.boxView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
  [self.boxView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
  if (@available(iOS 11.0, *)) {
    [self.boxView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-100].active = YES;
  } else {
    [self.boxView.topAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-100].active = YES;
  }
  
  [self.tipLabel.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.tipLabel.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:moduleSpace].active = YES;
  
  [self.stackView.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.stackView.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.stackView.topAnchor constraintEqualToAnchor:self.tipLabel.bottomAnchor constant:moduleSpace].active = YES;
  [self.stackView.heightAnchor constraintEqualToConstant:40].active = YES;
}

#pragma mark - MXMCategorySearchDelegate
- (void)categorySearcher:(MXMCategorySearch *)categorySearcher 
  didReceivePoiCategoryWithResult:(MXMPoiCategorySearchResult *)searchResult
                   error:(NSError *)error {
  if (searchResult) {
    [ProgressHUD dismiss];
    CategoryIncludeInSceneResultViewController *vc = [[CategoryIncludeInSceneResultViewController alloc] init];
    vc.categorys = searchResult.categoryResults;
    [self presentViewController:vc animated:YES completion:nil];
  } else {
    [ProgressHUD showError:NSLocalizedString(@"No categories could be found", nil)];
  }
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

- (UIView *)boxView {
  if (!_boxView) {
    _boxView = [[UIView alloc] init];
    _boxView.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _boxView;
}

- (UILabel *)tipLabel {
  if (!_tipLabel) {
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.text = @"Search category in";
    _tipLabel.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _tipLabel;
}

- (UIStackView *)stackView {
  if (!_stackView) {
    _stackView = [[UIStackView alloc] init];
    _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    _stackView.axis = UILayoutConstraintAxisHorizontal;
    _stackView.distribution = UIStackViewDistributionFillEqually;
    _stackView.spacing = moduleSpace;
  }
  return _stackView;
}

- (UIButton *)searchInVenueButton {
  if (!_searchInVenueButton) {
    _searchInVenueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchInVenueButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_searchInVenueButton setTitle:@"Venue" forState:UIControlStateNormal];
    [_searchInVenueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _searchInVenueButton.backgroundColor = [UIColor colorWithRed:80/255.0 green:175/255.0 blue:243/255.0 alpha:1.0];
    [_searchInVenueButton addTarget:self action:@selector(searchInVenueButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _searchInVenueButton.layer.cornerRadius = 5;
  }
  return _searchInVenueButton;
}

- (UIButton *)searchInBuildingButton {
  if (!_searchInBuildingButton) {
    _searchInBuildingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchInBuildingButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_searchInBuildingButton setTitle:@"Building" forState:UIControlStateNormal];
    [_searchInBuildingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _searchInBuildingButton.backgroundColor = [UIColor colorWithRed:80/255.0 green:175/255.0 blue:243/255.0 alpha:1.0];
    [_searchInBuildingButton addTarget:self action:@selector(searchInBuildingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _searchInBuildingButton.layer.cornerRadius = 5;
  }
  return _searchInBuildingButton;
}


- (UIButton *)searchOnFloorButton {
  if (!_searchOnFloorButton) {
    _searchOnFloorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchOnFloorButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_searchOnFloorButton setTitle:@"Floor" forState:UIControlStateNormal];
    [_searchOnFloorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _searchOnFloorButton.backgroundColor = [UIColor colorWithRed:80/255.0 green:175/255.0 blue:243/255.0 alpha:1.0];
    [_searchOnFloorButton addTarget:self action:@selector(searchOnFloorButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _searchOnFloorButton.layer.cornerRadius = 5;
  }
  return _searchOnFloorButton;
}

@end
