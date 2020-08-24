//
//  SearchIntegrateViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/23.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "SearchIntegrateViewController.h"
#import "MXMPulleyViewController.h"
#import "MXMPrimaryContentViewController.h"
#import "MXMDrawerContentViewController.h"
#import "ExplorerButtonViewController.h"


@implementation SearchIntegrateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    MXMPrimaryContentViewController *priamry = [[MXMPrimaryContentViewController alloc] init];
    ExplorerButtonViewController *explorer = [[ExplorerButtonViewController alloc] init];
    MXMDrawerContentViewController *drawer = [[MXMDrawerContentViewController alloc] initWithRootViewController:explorer];
    MXMPulleyViewController *pulley = [[MXMPulleyViewController alloc] initWithPrimaryContentViewController:priamry drawerContentViewController:drawer];
    
    drawer.drawerScrollDelegate = pulley;
    
    [self addChildViewController:pulley];
    pulley.view.frame = self.view.bounds;
    [self.view addSubview:pulley.view];
}

@end
