//
//  MenuViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/4/25.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "Macro.h"


@interface MenuViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) id<MenuViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) NSUInteger defaultSelected;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *subNameLabel;
@property (nonatomic, assign) double tableWidth;
@property (nonatomic, strong) NSLayoutConstraint *tableLeft;
@end


@implementation MenuViewController

+ (void)presentMenuViewControllerOnViewController:(UIViewController *)orgvc withDelegate:(id<MenuViewControllerDelegate>)delegate andTitles:(NSArray<NSString *> *)titles defaultSelect:(NSUInteger)index
{
    MenuViewController *vc = [[MenuViewController alloc] init];
    vc.delegate = delegate;
    vc.titles = titles;
    vc.defaultSelected = index;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [orgvc presentViewController:vc animated:NO completion:^{
        [vc showVC];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableWidth = MIN(283, KScreenWidth/3*2);
    self.headerView.frame = CGRectMake(0, 0, self.tableWidth, 216);
    self.tableView.tableHeaderView = self.headerView;

    [self.view addSubview:self.bgView];
    [self.view addSubview:self.tableView];
    [self.headerView addSubview:self.boxView];
    [self.boxView addSubview:self.nameLabel];
    [self.boxView addSubview:self.subNameLabel];
    
    [self.bgView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.bgView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.bgView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.bgView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.tableView.widthAnchor constraintEqualToConstant:self.tableWidth].active = YES;
    self.tableLeft = [self.tableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:-self.tableWidth];
    self.tableLeft.active = YES;
    
    [self.boxView.topAnchor constraintEqualToAnchor:self.bgView.topAnchor].active = YES;
    [self.boxView.leftAnchor constraintEqualToAnchor:self.headerView.leftAnchor].active = YES;
    [self.boxView.rightAnchor constraintEqualToAnchor:self.headerView.rightAnchor].active = YES;
    [self.boxView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor constant:-28].active = YES;
    
    [self.nameLabel.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:20].active = YES;
    [self.nameLabel.bottomAnchor constraintEqualToAnchor:self.boxView.bottomAnchor constant:-39].active = YES;
    [self.nameLabel.widthAnchor constraintEqualToConstant:self.tableWidth].active = YES;
    [self.nameLabel.heightAnchor constraintEqualToConstant:36].active = YES;
    
    [self.subNameLabel.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:20].active = YES;
    [self.subNameLabel.bottomAnchor constraintEqualToAnchor:self.boxView.bottomAnchor constant:-8].active = YES;
    [self.subNameLabel.widthAnchor constraintEqualToConstant:self.tableWidth].active = YES;
    [self.subNameLabel.heightAnchor constraintEqualToConstant:30].active = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self showVC];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissVC];
}

- (void)showVC
{
    self.tableLeft.constant = -self.tableWidth;
    self.bgView.alpha = 0.0;
    [UIView animateWithDuration:0.2 animations:^{
        self.tableLeft.constant = 0;
        [self.view layoutIfNeeded];
        self.bgView.alpha = 0.5;
    } completion:nil];
}

- (void)dismissVC
{
    [UIView animateWithDuration:0.2 animations:^{
        self.tableLeft.constant = -self.tableWidth;
        [self.view layoutIfNeeded];
        self.bgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        __weak typeof(self) weakSelf = self;
        [self dismissViewControllerAnimated:NO completion:^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(dismissComplete)]) {
                [weakSelf.delegate dismissComplete];
            }
        }];
    }];
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    [self.tableView reloadData];
}

- (void)setDefaultSelected:(NSUInteger)defaultSelected
{
    _defaultSelected = defaultSelected;
    if (defaultSelected < self.titles.count) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:defaultSelected inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCell"];
    if (self.titles.count > indexPath.row) {
        [cell refreshData:self.titles[indexPath.row]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedMenuOnIndex:)]) {
        [self.delegate selectedMenuOnIndex:indexPath.row];
    }
    [self dismissVC];
}

#pragma mark - Lazy loading
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.translatesAutoresizingMaskIntoConstraints = NO;
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.0;
    }
    return _bgView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[MenuTableViewCell class] forCellReuseIdentifier:@"MenuTableViewCell"];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.clipsToBounds = NO;
    }
    return _headerView;
}

- (UIView *)boxView
{
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.translatesAutoresizingMaskIntoConstraints = NO;
        _boxView.backgroundColor = [UIColor colorWithRed:119.0/255.0 green:120.0/255.0 blue:124.0/255.0 alpha:1.0];
    }
    return _boxView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.text = @"Mapxus Map SDK";
        _nameLabel.font = [UIFont boldSystemFontOfSize:25];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (UILabel *)subNameLabel
{
    if (!_subNameLabel) {
        _subNameLabel = [[UILabel alloc] init];
        _subNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _subNameLabel.textColor = [UIColor whiteColor];
        _subNameLabel.font = [UIFont fontWithName:@"PingFang SC" size:16];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _subNameLabel.text = [NSString stringWithFormat:@"iOS examples (V%@)", [infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    }
    return _subNameLabel;
}

@end



