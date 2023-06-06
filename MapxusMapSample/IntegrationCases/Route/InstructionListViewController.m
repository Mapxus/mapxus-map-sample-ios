//
//  InstructionListViewController.m
//  MapxusMapSample
//
//  Created by guochenghao on 2023/6/2.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "Macro.h"
#import "InstructionListViewController.h"
#import "StatisticalView.h"
#import <MapxusMapSDK/MapxusMapSDK.h>

@interface InstructionListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<MXMInstruction *> *instructionList;
@property (nonatomic, strong) StatisticalView *statisticalView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation InstructionListViewController

- (instancetype)initWithInstructions:(NSArray<MXMInstruction *> *)list distance:(double)distance time:(NSUInteger)time {
  self = [super init];
  if (self) {
    [self.statisticalView setDistance:distance time:time];
    self.instructionList = list;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.statisticalView];
  [self.view addSubview:self.tableView];
  [self.view addSubview:self.closeButton];
  
  if (@available(iOS 11.0, *)) {
    [self.statisticalView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:moduleSpace].active = YES;
    [self.statisticalView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
    [self.statisticalView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
    [self.statisticalView.heightAnchor constraintEqualToConstant:110].active = YES;
    
    [self.tableView.topAnchor constraintEqualToAnchor:self.statisticalView.bottomAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-100].active = YES;
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
    [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
  } else {
    [self.statisticalView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:moduleSpace].active = YES;
    [self.statisticalView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.statisticalView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.statisticalView.heightAnchor constraintEqualToConstant:110].active = YES;

    [self.tableView.topAnchor constraintEqualToAnchor:self.statisticalView.bottomAnchor constant:moduleSpace].active = YES;
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

#pragma mark - RouteViewControllerDelegate
- (void)routeInstructionDidChange:(NSUInteger)index {
  [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"instructionCell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"instructionCell"];
    UIView *cellColor = [[UIView alloc] initWithFrame:cell.frame];
    cellColor.backgroundColor = [UIColor colorWithRed:80/255.0 green:175/255.0 blue:243/255.0 alpha:1.0];
    cell.selectedBackgroundView = cellColor;
  }
  if (self.instructionList.count > indexPath.row) {
    MXMInstruction *instruction = self.instructionList[indexPath.row];
    if (@available(iOS 14.0, *)) {
      UIListContentConfiguration *conf = [UIListContentConfiguration valueCellConfiguration];
      conf.text = instruction.text;
      conf.secondaryText = [NSString stringWithFormat:@"%.0fm", instruction.distance];
      cell.contentConfiguration = conf;
    } else {
      // Fallback on earlier versions
      cell.textLabel.text = instruction.text;
      cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0fm", instruction.distance];
    }
  }
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.instructionList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}

#pragma mark - Lazy loading
- (StatisticalView *)statisticalView {
  if (!_statisticalView) {
    _statisticalView = [[StatisticalView alloc] init];
    _statisticalView.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _statisticalView;
}

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] init];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
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
