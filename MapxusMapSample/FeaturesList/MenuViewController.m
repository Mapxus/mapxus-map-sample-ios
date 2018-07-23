//
//  MenuViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/4/25.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
@import HandyFrame;

@interface MenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *subNameLabel;
@property (nonatomic, strong) UILabel *footerTextView;

@end

@implementation MenuViewController


+ (void)presentMenuViewControllerOnViewController:(UIViewController *)orgvc withDelegate:(id<MenuViewControllerDelegate>)delegate andTitles:(NSArray<NSString *> *)titles defaultSelect:(NSUInteger)index
{
    MenuViewController *vc = [[MenuViewController alloc] init];
    vc.delegate = delegate;
    vc.titles = titles;
    vc.defaultSelected = index;
    if (SYSTEM_VERSION_GREATER_THAN(@"8.0")) {
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    } else {
        vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [orgvc presentViewController:vc animated:NO completion:^{
        [vc showVC];
    }];
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerTextView];
    [self.headerView addSubview:self.boxView];
    [self.boxView addSubview:self.nameLabel];
    [self.boxView addSubview:self.subNameLabel];
    self.tableView.tableHeaderView = self.headerView;
    
    self.bgView.frame = self.view.bounds;
    self.bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.frame = CGRectMake(-MIN(283, SCREEN_WIDTH/3*2), -20, MIN(283, SCREEN_WIDTH/3*2), SCREEN_HEIGHT-10);
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.headerView.frame = CGRectMake(0, 0, self.tableView.ct_width, 216);
    self.headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.boxView.frame = CGRectMake(0, 0, self.tableView.ct_width, 188);
    self.boxView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.nameLabel.frame = CGRectMake(20, 113, self.headerView.ct_width, 36);
    self.subNameLabel.frame = CGRectMake(20, 150, self.headerView.ct_width, 22);
    self.footerTextView.frame = CGRectMake(0, 0, self.tableView.ct_width, 30);
    [self.footerTextView bottomInContainer:0 shouldResize:NO];
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
    self.tableView.ct_x = -self.tableView.ct_width;
    self.footerTextView.ct_x = -self.footerTextView.ct_width;
    self.bgView.alpha = 0.0;
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.ct_x = 0;
        self.footerTextView.ct_x = 0;
        self.bgView.alpha = 0.5;
    } completion:^(BOOL finished) {
    }];
}

- (void)dismissVC
{
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.ct_x = -self.tableView.ct_width;
        self.footerTextView.ct_x = -self.footerTextView.ct_width;
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
#pragma mark end







#pragma mark - access
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.0;
    }
    return _bgView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
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
    }
    return _headerView;
}

- (UIView *)boxView
{
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = [UIColor colorWithRed:119.0/255.0 green:120.0/255.0 blue:124.0/255.0 alpha:1.0];
    }
    return _boxView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
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
        _subNameLabel.textColor = [UIColor whiteColor];
        _subNameLabel.font = [UIFont fontWithName:@"PingFang SC" size:16];
        _subNameLabel.text = @"iOS examples";
    }
    return _subNameLabel;
}

- (UILabel *)footerTextView
{
    if (!_footerTextView) {
        _footerTextView = [[UILabel alloc] init];
        _footerTextView.backgroundColor = [UIColor whiteColor];
        _footerTextView.font = [UIFont systemFontOfSize:12];
        _footerTextView.textAlignment = NSTextAlignmentCenter;
        _footerTextView.textColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1/1.0];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _footerTextView.text = [NSString stringWithFormat:@"V%@", [infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    }
    return _footerTextView;
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
#pragma mark end



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



