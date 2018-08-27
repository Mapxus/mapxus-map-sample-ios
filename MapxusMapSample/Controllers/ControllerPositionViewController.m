//
//  ControllerPositionViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/8/24.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "ControllerPositionViewController.h"
#import <MyLayout/MyLayout.h>
#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>

@interface ControllerPositionViewController () <MGLMapViewDelegate>

@property (nonatomic, strong) MapxusMap *map;

@end

@implementation ControllerPositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.nameStr;
    self.view.backgroundColor = [UIColor whiteColor];
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    rootLayout.frame = self.view.bounds;
    rootLayout.gravity = MyGravity_Horz_Fill; //里面所有子视图的宽度都填充为和父视图一样宽。
    rootLayout.myMargin = 0;
    [self.view addSubview:rootLayout];
    
    MyFlowLayout *buttonsView = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:2];
    buttonsView.wrapContentHeight = YES;
    buttonsView.gravity = MyGravity_Horz_Fill;  //所有子视图水平填充，也就是所有子视图的宽度相等。
    buttonsView.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    buttonsView.subviewHSpace = 5;
    buttonsView.subviewVSpace = 5;
    [rootLayout addSubview:buttonsView];
    
    NSArray *titles = @[@"top-left",
                        @"top-right",
                        @"bottom-left",
                        @"bottom-right",
                        @"center-left",
                        @"center-right"];
    
    for (int i=0; i<titles.count; i++) {
        UIButton *b = [self createButton:titles[i] tag:i];
        [buttonsView addSubview:b];
    }
    
    MGLMapView *mapview = [[MGLMapView alloc] init];
    mapview.delegate = self;
    mapview.centerCoordinate = CLLocationCoordinate2DMake(22.304716516178253, 114.16186609400843);
    mapview.zoomLevel = 16;
    mapview.weight = 1;
    [rootLayout addSubview:mapview];
    
    self.map = [[MapxusMap alloc] initWithMapView:mapview];
}

- (UIButton *)createButton:(NSString *)name tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.tag = tag;
    [button setTitle:name forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    button.myHeight = 30;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 0.5;
    return button;
}

- (void)clickBtn:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
            self.map.selectorPosition = MXMSelectorPositionTopLeft;
            break;
        case 1:
            self.map.selectorPosition = MXMSelectorPositionTopRight;
            break;
        case 2:
            self.map.selectorPosition = MXMSelectorPositionBottomLeft;
            break;
        case 3:
            self.map.selectorPosition = MXMSelectorPositionBottomRight;
            break;
        case 4:
            self.map.selectorPosition = MXMSelectorPositionCenterLeft;
            break;
        case 5:
            self.map.selectorPosition = MXMSelectorPositionCenterRight;
            break;
        default:
            break;
    }
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
