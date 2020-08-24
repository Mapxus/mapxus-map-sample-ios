//
//  ExplorerButtonViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/29.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <MapxusMapSDK/MapxusMapSDK.h>
#import "ExplorerButtonViewController.h"
#import "SearchIntegrateCategoryViewController.h"
#import "UIViewController+Pulley.h"
#import "MXMPrimaryContentViewController.h"
#import "MXMGeoBuilding+Language.h"

@interface ExplorerButtonViewController () <MXMPrimaryContentControlDelegate>
@property (nonatomic, strong) UIButton *exploreButton;
@property (nonatomic, strong) MXMGeoBuilding *building;
@property (nonatomic, weak) MXMPrimaryContentViewController *primaryVC;
@end

@implementation ExplorerButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self LayoutUI];
    self.primaryVC = (MXMPrimaryContentViewController *)self.pulleyViewController.primaryContentViewController;
    self.primaryVC.primaryControlDelegate = self;
}

- (void)LayoutUI {
    [self.view addSubview:self.exploreButton];
    [self.exploreButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:18].active = YES;
    [self.exploreButton.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:18].active = YES;
    [self.exploreButton.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-13].active = YES;
    [self.exploreButton.heightAnchor constraintEqualToConstant:40].active = YES;
}

- (void)exploreButtonAction {
    [self.pulleyViewController setDrawerPosition:MXMPulleyPositionPartiallyRevealed animated:YES];
    SearchIntegrateCategoryViewController *vc = [[SearchIntegrateCategoryViewController alloc] init];
    vc.building = self.building;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MXMPrimaryContentControlDelegate
- (void)mapDidChangeFloor:(NSString *)floorName atBuilding:(MXMGeoBuilding *)building {
    self.building = building;
    [self.exploreButton setTitle:[NSString stringWithFormat:@"Explore %@", building.nameChooseBySystem] forState:UIControlStateNormal];
}

#pragma mark - Lazy loading
- (UIButton *)exploreButton {
    if (!_exploreButton) {
        _exploreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _exploreButton.translatesAutoresizingMaskIntoConstraints = NO;
        _exploreButton.backgroundColor = [UIColor colorWithRed:240/255.0 green:92/255.0 blue:102/255.0 alpha:1.0];
        _exploreButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _exploreButton.layer.cornerRadius = 20;
        [_exploreButton addTarget:self action:@selector(exploreButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exploreButton;
}


@end
