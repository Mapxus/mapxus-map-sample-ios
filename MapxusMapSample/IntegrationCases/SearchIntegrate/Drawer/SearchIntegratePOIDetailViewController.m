//
//  SearchIntegratePOIDetailViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/25.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "SearchIntegratePOIDetailViewController.h"
#import "SearchIntegratePOIDetailBaseCell.h"
#import "SearchIntegratePOIDetailBuildingCell.h"
#import "Macro.h"
#import "UIViewController+Pulley.h"
#import "MXMPrimaryContentViewController.h"
#import "MXMPOI+Language.h"
#import "MXMGeoBuilding+Language.h"
#import "UIImage+icon.h"

@interface SearchIntegratePOIDetailViewController () <UITableViewDelegate, UITableViewDataSource, MXMSearchDelegate>
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameTip;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSString *buildingAddress;
@property (nonatomic, weak) MXMPrimaryContentViewController *primaryVC;
@property (nonatomic, strong) NSArray *annotations;
@end

@implementation SearchIntegratePOIDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  MXMPointAnnotation *annotation = [[MXMPointAnnotation alloc] init];
  annotation.coordinate = CLLocationCoordinate2DMake(self.poi.location.latitude, self.poi.location.longitude);
  annotation.floorId = self.poi.floor.floorId;
  annotation.title = [self.poi nameChooseBySystem];
  
  self.annotations = @[annotation];
  
  self.primaryVC = (MXMPrimaryContentViewController *)self.pulleyViewController.primaryContentViewController;
  [self.primaryVC moveToPOICenter:CLLocationCoordinate2DMake(self.poi.location.latitude, self.poi.location.longitude) floorId:self.poi.floor.floorId];
  [self fillData];
  [self layoutUI];
  [self requestNetBuilding];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.pulleyViewController setDrawerPosition:MXMPulleyPositionPartiallyRevealed animated:YES];
  if (self.annotations.count) {
    [self.primaryVC addAnnotations:self.annotations];
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  if (self.annotations.count) {
    [self.primaryVC removeAnnotations:self.annotations];
  }
}

- (void)requestNetBuilding {
  MXMBuildingSearchRequest *re = [[MXMBuildingSearchRequest alloc] init];
  re.buildingIds = @[self.building.identifier];
  
  MXMSearchAPI *api = [[MXMSearchAPI alloc] init];
  api.delegate = self;
  [api MXMBuildingSearch:re];
}

- (void)fillData {
  self.icon.image = [UIImage categoryIconWithType:self.poi.category.lastObject];
  self.nameTip.text = [self.poi nameChooseBySystem];
  [self.datas removeAllObjects];
  if (self.poi.openingHours) {
    [self.datas addObject:@{@"tip": @"Opening Hours", @"value": self.poi.openingHours, @"cell": @"SearchIntegratePOIDetailBaseCell"}];
  }
  if (self.building) {
    [self.datas addObject:@{@"name": [self.building nameChooseBySystem], @"type": self.building.category, @"address": [NSString stringWithFormat:@"%@ · %@", self.buildingAddress?:@"", self.poi.floor.code], @"cell": @"SearchIntegratePOIDetailBuildingCell"}];
  }
  if (self.poi.phone) {
    [self.datas addObject:@{@"tip": @"Phone", @"value": self.poi.phone, @"cell": @"SearchIntegratePOIDetailBaseCell"}];
  }
  if (self.poi.website) {
    [self.datas addObject:@{@"tip": @"Websit", @"value": self.poi.website, @"cell": @"SearchIntegratePOIDetailBaseCell"}];
  }
  if (self.poi.accessibilityDetail) {
    [self.datas addObject:@{@"tip": @"Accessibility Details", @"value": self.poi.accessibilityDetail, @"cell": @"SearchIntegratePOIDetailBaseCell"}];
  }
  [self.tableView reloadData];
}

- (void)layoutUI {
  [self.view addSubview:self.icon];
  [self.view addSubview:self.nameTip];
  [self.view addSubview:self.closeButton];
  [self.view addSubview:self.line];
  [self.view addSubview:self.tableView];
  
  [self.icon.widthAnchor constraintEqualToConstant:36].active = YES;
  [self.icon.heightAnchor constraintEqualToConstant:36].active = YES;
  [self.icon.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:18].active = YES;
  [self.icon.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:18].active = YES;
  
  [self.nameTip.centerYAnchor constraintEqualToAnchor:self.closeButton.centerYAnchor].active = YES;
  [self.nameTip.leadingAnchor constraintEqualToAnchor:self.icon.trailingAnchor constant:8].active = YES;
  
  [self.closeButton.widthAnchor constraintEqualToConstant:30].active = YES;
  [self.closeButton.heightAnchor constraintEqualToConstant:30].active = YES;
  [self.closeButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20].active = YES;
  [self.closeButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20].active = YES;
  
  [self.line.heightAnchor constraintEqualToConstant:1].active = YES;
  [self.line.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:65].active = YES;
  [self.line.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:18].active = YES;
  [self.line.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-18].active = YES;
  
  [self.tableView.topAnchor constraintEqualToAnchor:self.line.bottomAnchor constant:5].active = YES;
  [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
  [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
  [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
}

- (void)closeButtonAction:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MXMSearchDelegate
- (void)MXMSearchRequest:(id)request didFailWithError:(NSError *)error {
  
}

- (void)onBuildingSearchDone:(MXMBuildingSearchRequest *)request response:(MXMBuildingSearchResponse *)response {
  MXMBuilding *netBuilding = response.buildings.firstObject;
  if (netBuilding.city) {
    self.buildingAddress = [NSString stringWithFormat:@"%@, %@", netBuilding.city, netBuilding.address_default.street];
  } else if (netBuilding.region) {
    self.buildingAddress = [NSString stringWithFormat:@"%@, %@", netBuilding.region, netBuilding.address_default.street];
  } else {
    self.buildingAddress = [NSString stringWithFormat:@"%@, %@", netBuilding.country, netBuilding.address_default.street];
  }
  [self fillData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary *dic = self.datas[indexPath.row];
  NSString *cellStr = dic[@"cell"];
  if ([cellStr isEqualToString:@"SearchIntegratePOIDetailBuildingCell"]) {
    SearchIntegratePOIDetailBuildingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchIntegratePOIDetailBuildingCell"];
    [cell refreshData:dic];
    return cell;
    
  } else {
    SearchIntegratePOIDetailBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchIntegratePOIDetailBaseCell"];
    [cell refreshData:dic];
    return cell;
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.datas.count;
}

#pragma mark - Lazy loading
- (UIImageView *)icon {
  if (!_icon) {
    _icon = [[UIImageView alloc] init];
    _icon.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _icon;
}

- (UILabel *)nameTip {
  if (!_nameTip) {
    _nameTip = [[UILabel alloc] init];
    _nameTip.translatesAutoresizingMaskIntoConstraints = NO;
    _nameTip.font = [UIFont boldSystemFontOfSize:20];
    _nameTip.textColor = COLOR(0x464646);
  }
  return _nameTip;
}

- (UIButton *)closeButton {
  if (!_closeButton) {
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_closeButton setImage:[UIImage imageNamed:@"close_button"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _closeButton;
}

- (UIView *)line {
  if (!_line) {
    _line = [[UIView alloc] init];
    _line.translatesAutoresizingMaskIntoConstraints = NO;
    _line.backgroundColor = COLOR(0xEBEBEB);
  }
  return _line;
}

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] init];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelection = NO;
    _tableView.estimatedRowHeight = 56;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[SearchIntegratePOIDetailBaseCell class] forCellReuseIdentifier:@"SearchIntegratePOIDetailBaseCell"];
    [_tableView registerClass:[SearchIntegratePOIDetailBuildingCell class] forCellReuseIdentifier:@"SearchIntegratePOIDetailBuildingCell"];
  }
  return _tableView;
}

- (NSMutableArray *)datas {
  if (!_datas) {
    _datas = [NSMutableArray array];
  }
  return _datas;
}

@end
