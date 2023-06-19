//
//  SearchIntegratePOIsViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/25.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "SearchIntegratePOIsViewController.h"
#import "SearchIntegratePOIDetailViewController.h"
#import "SearchIntegratePOICell.h"
#import "Macro.h"
#import "UIViewController+Pulley.h"
#import "MXMPrimaryContentViewController.h"
#import "MXMPOI+Language.h"
#import "MXMCategory+Language.h"

@interface SearchIntegratePOIsViewController () <UITableViewDelegate, UITableViewDataSource, MXMSearchDelegate>
@property (nonatomic, strong) UILabel *nameTip;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, weak) MXMPrimaryContentViewController *primaryVC;
@end

@implementation SearchIntegratePOIsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.nameTip.text = [self.category titleChooseBySystem];
    [self layoutUI];
    [self requestPOIs];
    self.primaryVC = (MXMPrimaryContentViewController *)self.pulleyViewController.primaryContentViewController;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

- (void)requestPOIs {
    MXMPOISearchRequest *re = [[MXMPOISearchRequest alloc] init];
    re.buildingId = self.building.identifier;
    re.category = self.category.category;
    re.offset = 100;
    re.page = 1;
    
    MXMSearchAPI *api = [[MXMSearchAPI alloc] init];
    api.delegate = self;
    [api MXMPOISearch:re];
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

#pragma mark - MXMSearchDelegate
- (void)MXMSearchRequest:(id)request didFailWithError:(NSError *)error {
    
}

- (void)onPOISearchDone:(MXMPOISearchRequest *)request response:(MXMPOISearchResponse *)response {
    NSMutableArray *anns = [NSMutableArray array];
    for (MXMPOI *poi in response.pois) {
        MXMPointAnnotation *annotation = [[MXMPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        annotation.buildingId = poi.buildingId;
        annotation.floor = poi.floor.code;
        annotation.title = [poi nameChooseBySystem];
        [anns addObject:annotation];
    }
    [self.primaryVC addAnnotations:anns];
    [self.annotations removeAllObjects];
    [self.annotations addObjectsFromArray:anns];
    [self.datas removeAllObjects];
    [self.datas addObjectsFromArray:response.pois];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchIntegratePOICell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchIntegratePOICell"];
    MXMPOI *poi = self.datas[indexPath.row];
    [cell refreshPOI:poi categoryName:self.allCategorys[poi.category.lastObject]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MXMPOI *poi = self.datas[indexPath.row];
    SearchIntegratePOIDetailViewController *vc = [[SearchIntegratePOIDetailViewController alloc] init];
    vc.poi = poi;
    vc.building = self.building;
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
        [_tableView registerClass:[SearchIntegratePOICell class] forCellReuseIdentifier:@"SearchIntegratePOICell"];
    }
    return _tableView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (NSMutableArray *)annotations {
    if (!_annotations) {
        _annotations = [NSMutableArray array];
    }
    return _annotations;
}

@end
