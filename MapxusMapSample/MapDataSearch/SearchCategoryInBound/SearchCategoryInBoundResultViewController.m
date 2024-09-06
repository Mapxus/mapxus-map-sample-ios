//
//  SearchCategoryInBoundResultViewController.m
//  MapxusMapSample
//
//  Created by guochenghao on 2024/9/4.
//  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "SearchCategoryInBoundResultViewController.h"
#import "CategoryInBoundResultCell.h"
#import "Macro.h"

@interface SearchCategoryInBoundResultViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation SearchCategoryInBoundResultViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.tableView];
  [self.view addSubview:self.closeButton];
  
  if (@available(iOS 11.0, *)) {
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:moduleSpace].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-100].active = YES;
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
    [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
  } else {
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:moduleSpace].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-100].active = YES;
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
  }
  
  [self.closeButton.widthAnchor constraintEqualToConstant:150].active = YES;
  [self.closeButton.heightAnchor constraintEqualToConstant:44].active = YES;
  [self.closeButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
  [self.closeButton.topAnchor constraintEqualToAnchor:self.tableView.bottomAnchor constant:30].active = YES;
}

- (void)closeButtonAction {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CategoryInBoundResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryInBoundResultCell"];
  [cell refreshData:self.categorys[indexPath.row]];
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.categorys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 180;
}

#pragma mark - Lazy loading
- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] init];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[CategoryInBoundResultCell class] forCellReuseIdentifier:@"CategoryInBoundResultCell"];
  }
  return _tableView;
}

- (UIButton *)closeButton {
  if (!_closeButton) {
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _closeButton.backgroundColor = [UIColor colorWithRed:80/255.0 green:175/255.0 blue:243/255.0 alpha:1.0];
    [_closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.layer.cornerRadius = 5;
  }
  return _closeButton;
}


@end
