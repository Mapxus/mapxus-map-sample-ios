//
//  ControllerHiddenViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/8/24.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "ControllerHiddenViewController.h"
#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import <MyLayout/MyLayout.h>

@interface ControllerHiddenViewController () <MGLMapViewDelegate>

@property (nonatomic, strong) MGLMapView *mapview;
@property (nonatomic, strong) MapxusMap *map;

@end

@implementation ControllerHiddenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.nameStr;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mapview = [[MGLMapView alloc] init];
    self.mapview.delegate = self;
    self.mapview.centerCoordinate = CLLocationCoordinate2DMake(22.370787, 114.111375);
    self.mapview.zoomLevel = 18;
    [self.view addSubview:self.mapview];
    
    self.map = [[MapxusMap alloc] initWithMapView:self.mapview];
    
    MyLinearLayout *boxView = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    boxView.myHorzMargin = 0;
    boxView.wrapContentHeight = YES;
    boxView.subviewVSpace = 10;
    boxView.padding = UIEdgeInsetsMake(5, 0, 5, 0);
    boxView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    boxView.topPos.equalTo(self.view.topPos);
    [self.view addSubview:boxView];
    
    MyLinearLayout *box1 = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    box1.subviewHSpace = 5;
    box1.wrapContentHeight = YES;
    box1.gravity = MyGravity_Vert_Center;
    [boxView addSubview:box1];
    
    UILabel *ctrlHiddenLabel = [[UILabel alloc] init];
    ctrlHiddenLabel.text = @"Controller Hidden";
    ctrlHiddenLabel.textAlignment = NSTextAlignmentRight;
    ctrlHiddenLabel.mySize = CGSizeMake(150, 20);
    
    UISwitch *ctrlHiddenSwitch = [[UISwitch alloc] init];
    ctrlHiddenSwitch.on = YES;
    [ctrlHiddenSwitch addTarget:self
                         action:@selector(switchChange:)
               forControlEvents:UIControlEventValueChanged];
    
    [box1 addSubview:ctrlHiddenLabel];
    [box1 addSubview:ctrlHiddenSwitch];
    
    
    MyLinearLayout *box2 = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    box2.subviewHSpace = 5;
    box2.wrapContentHeight = YES;
    box2.gravity = MyGravity_Vert_Center;
    [boxView addSubview:box2];
    
    UILabel *gestureSwitchingBuildingLabel = [[UILabel alloc] init];
    gestureSwitchingBuildingLabel.text = @"Gesture Switching";
    gestureSwitchingBuildingLabel.textAlignment = NSTextAlignmentRight;
    gestureSwitchingBuildingLabel.mySize = CGSizeMake(150, 20);
    
    UISwitch *gestureSwitchingBuildingSwitch = [[UISwitch alloc] init];
    gestureSwitchingBuildingSwitch.on = YES;
    [gestureSwitchingBuildingSwitch addTarget:self
                                       action:@selector(gestureSwitchingBuildingChange:)
                             forControlEvents:UIControlEventValueChanged];
    
    [box2 addSubview:gestureSwitchingBuildingLabel];
    [box2 addSubview:gestureSwitchingBuildingSwitch];
    
    
    MyLinearLayout *box3 = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    box3.subviewHSpace = 5;
    box3.wrapContentHeight = YES;
    box3.gravity = MyGravity_Vert_Center;
    [boxView addSubview:box3];
    
    UILabel *autoSwitchingBuildingLabel = [[UILabel alloc] init];
    autoSwitchingBuildingLabel.text = @"Auto Switching";
    autoSwitchingBuildingLabel.textAlignment = NSTextAlignmentRight;
    autoSwitchingBuildingLabel.mySize = CGSizeMake(150, 20);
    
    UISwitch *autoSwitchingBuildingSwitch = [[UISwitch alloc] init];
    autoSwitchingBuildingSwitch.on = YES;
    [autoSwitchingBuildingSwitch addTarget:self
                                       action:@selector(autoSwitchingBuildingChange:)
                             forControlEvents:UIControlEventValueChanged];
    
    [box3 addSubview:autoSwitchingBuildingLabel];
    [box3 addSubview:autoSwitchingBuildingSwitch];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.mapview.frame = self.view.bounds;
}

- (void)switchChange:(UISwitch *)sender {
    self.map.indoorControllerAlwaysHidden = !sender.isOn;
}

- (void)gestureSwitchingBuildingChange:(UISwitch *)sender {
    self.map.gestureSwitchingBuilding = sender.isOn;
}

- (void)autoSwitchingBuildingChange:(UISwitch *)sender {
    self.map.autoChangeBuilding = sender.isOn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
