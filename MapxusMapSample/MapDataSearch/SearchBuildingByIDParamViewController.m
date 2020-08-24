//
//  SearchBuildingByIDParamViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/22.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <IQKeyboardManager/IQKeyboardManager.h>
#import "Macro.h"
#import "BuildingIDCell.h"
#import "SearchBuildingByIDParamViewController.h"

@interface SearchBuildingByIDParamViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UITableView *tableVeiw;
@property (nonatomic, strong) UIButton *createButton;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSLayoutConstraint *tableHeightConstraint;
@end

@implementation SearchBuildingByIDParamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.dataSource addObject:@"tsuenwanplaza_hk_369d01"];
    [self layoutUI];
}

- (void)createButtonAction {
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(completeParamConfiguration:)]) {
            NSMutableArray *result = [NSMutableArray array];
            for (NSString *text in weakSelf.dataSource) {
                if (text != nil && ![text isEqualToString:@""]) {
                    [result addObject:text];
                }
            }
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"buildingIds"] = [result copy];
            [self.delegate completeParamConfiguration:params];
        }
    }];
}

- (void)addButtonAction {
    [self.dataSource addObject:@""];
    [self.tableVeiw reloadData];
    self.tableHeightConstraint.constant = 64*self.dataSource.count+64;
    [self.view layoutIfNeeded];
}

- (void)layoutUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.boxView];
    [self.boxView addSubview:self.tableVeiw];
    [self.boxView addSubview:self.createButton];
    
    if (@available(iOS 11.0, *)) {
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
    } else {
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    }
    
    [self.boxView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor].active = YES;
    [self.boxView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor].active = YES;
    [self.boxView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor].active = YES;
    [self.boxView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor].active = YES;
    [self.boxView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor].active = YES;
    
    [self.tableVeiw.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:moduleSpace].active = YES;
    [self.tableVeiw.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor].active = YES;
    [self.tableVeiw.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor].active = YES;
    self.tableHeightConstraint = [self.tableVeiw.heightAnchor constraintEqualToConstant:64*self.dataSource.count+64];
    self.tableHeightConstraint.active = YES;
    
    [self.createButton.widthAnchor constraintEqualToConstant:150].active = YES;
    [self.createButton.heightAnchor constraintEqualToConstant:44].active = YES;
    [self.createButton.centerXAnchor constraintEqualToAnchor:self.boxView.centerXAnchor].active = YES;
    [self.createButton.topAnchor constraintEqualToAnchor:self.tableVeiw.bottomAnchor constant:40].active = YES;
    [self.createButton.bottomAnchor constraintEqualToAnchor:self.boxView.bottomAnchor constant:-40].active = YES;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BuildingIDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuildingIDCell"];
    [cell refreshData:self.dataSource[indexPath.row]];
    __weak typeof(self) weakSelf = self;
    cell.endEditBlock = ^(BuildingIDCell * _Nonnull cell, NSString * _Nullable text) {
        NSIndexPath *path = [tableView indexPathForCell:cell];
        weakSelf.dataSource[path.row] = text ? text : @"";
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake((KScreenWidth-200)/2, 10, 200, 44);
    addButton.layer.cornerRadius = 5;
    [addButton setTitle:@"Add ID" forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    addButton.backgroundColor = [UIColor colorWithRed:123/255.0 green:133/255.0 blue:228/255.0 alpha:1.0];
    
    UIView *fView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    [fView addSubview:addButton];
    
    return fView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 64;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[IQKeyboardManager sharedManager] goNext];
    return YES;
}

#pragma mark - Lazy loading
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _scrollView;
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _boxView;
}

- (UITableView *)tableVeiw {
    if (!_tableVeiw) {
        _tableVeiw = [[UITableView alloc] init];
        _tableVeiw.translatesAutoresizingMaskIntoConstraints = NO;
        _tableVeiw.delegate = self;
        _tableVeiw.dataSource = self;
        _tableVeiw.scrollEnabled = NO;
        _tableVeiw.allowsSelection = NO;
        [_tableVeiw registerClass:[BuildingIDCell class] forCellReuseIdentifier:@"BuildingIDCell"];
    }
    return _tableVeiw;
}

- (UIButton *)createButton {
    if (!_createButton) {
        _createButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _createButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_createButton setTitle:@"Create" forState:UIControlStateNormal];
        [_createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _createButton.backgroundColor = [UIColor colorWithRed:80/255.0 green:175/255.0 blue:243/255.0 alpha:1.0];
        [_createButton addTarget:self action:@selector(createButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _createButton.layer.cornerRadius = 5;
    }
    return _createButton;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
