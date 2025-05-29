//
//  SearchIntegrateCategoryViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/25.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "SearchIntegrateCategoryCell.h"
#import "SearchIntegrateCategoryViewController.h"
#import "SearchIntegratePOIsViewController.h"
#import "Macro.h"
#import "MXMGeoBuilding+Language.h"
#import "MXMCategory+Language.h"

@interface SearchIntegrateCategoryViewController () <UITableViewDelegate, UITableViewDataSource, MXMCategorySearchDelegate>
@property (nonatomic, strong) UILabel *nameTip;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSDictionary *categoryDictionary;
@end

@implementation SearchIntegrateCategoryViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  self.nameTip.text = [self.building nameChooseBySystem];
  [self layoutUI];
  [self requestCategory];
}

- (void)requestCategory {
  MXMPoiCategoryBuildingSearchOption *re = [[MXMPoiCategoryBuildingSearchOption alloc] init];
  re.buildingId = self.building.identifier;
  
  MXMCategorySearch *api = [[MXMCategorySearch alloc] init];
  api.delegate = self;
  [api searchPoiCategoriesByBuilding:re];
}

- (void)layoutUI {
  [self.view addSubview:self.nameTip];
  [self.view addSubview:self.closeButton];
  [self.view addSubview:self.tableView];
  
  [self.nameTip.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:18].active = YES;
  [self.nameTip.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:18].active = YES;
  
  [self.closeButton.widthAnchor constraintEqualToConstant:30].active = YES;
  [self.closeButton.heightAnchor constraintEqualToConstant:30].active = YES;
  [self.closeButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20].active = YES;
  [self.closeButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20].active = YES;
  
  [self.tableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
  [self.tableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
  [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:55].active = YES;
  [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
}

- (void)closeButtonAction:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MXMCategorySearchDelegate

//- (void)categorySearcher:(MXMCategorySearch *)categorySearcher didReceivePoiCategoryWithResult:(MXMPoiCategorySearchResult *)searchResult error:(NSError *)error {
//  [self.datas removeAllObjects];
//  [self.datas addObjectsFromArray:searchResult.categoryResults];
//  
//  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//  for (MXMCategory*category in self.datas) {
//    dic[category.category] = [category titleChooseBySystem];
//  }
//  self.categoryDictionary = [dic copy];
//  [self.tableView reloadData];
//}
- (void)categorySearcher:(MXMCategorySearch *)categorySearcher didReceivePoiCategoryWithResultV2:(MXMPoiCategorySearchResultV2 *)searchResult error:(NSError *)error {
  NSMutableArray<MXMCategory*>* array = [[NSMutableArray alloc]init];
  [searchResult.categoryVenueInfoExResults enumerateObjectsUsingBlock:^(MXMPoiCategoryVenueInfoEx * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [array addObject:obj.category];
  }];
  [self.datas removeAllObjects];
  [self.datas addObjectsFromArray:array];
  
  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
  for (MXMCategory*category in self.datas) {
    dic[category.category] = [category titleChooseBySystem];
  }
  self.categoryDictionary = [dic copy];
  [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SearchIntegrateCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchIntegrateCategoryCell"];
  MXMCategory *category = self.datas[indexPath.row];
  [cell refreshCategory:category.category categoryName:[category titleChooseBySystem]];
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 67;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  SearchIntegratePOIsViewController *vc = [[SearchIntegratePOIsViewController alloc] init];
  vc.building = self.building;
  vc.category = self.datas[indexPath.row];
  vc.allCategorys = self.categoryDictionary;
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Lazy loading
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

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] init];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[SearchIntegrateCategoryCell class] forCellReuseIdentifier:@"SearchIntegrateCategoryCell"];
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
