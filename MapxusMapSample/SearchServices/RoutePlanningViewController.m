//
//  RoutePlanningViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/10.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "RoutePlanningViewController.h"
@import MyLayout;
@import ProgressHUD;
@import Mapbox;
@import MapxusMapSDK;
@import MXMComponentKit;

@interface RoutePlanningViewController () <MapxusMapDelegate, MXMSearchDelegate, MGLMapViewDelegate>

// 负责地图渲染
@property (nonatomic, strong) MGLMapView *mapView;
// 负责室内地图处理
@property (nonatomic, strong) MapxusMap *map;
// 负责路线绘制与控制
@property (nonatomic, strong) MXMRoutePainter *painter;
// 起点按钮
@property (nonatomic, strong) UIButton *fromBtn;
// 终点按钮
@property (nonatomic, strong) UIButton *toBtn;
// 起点标识
@property (nonatomic, strong) MXMPointAnnotation *fromAnnotation;
// 终点标识
@property (nonatomic, strong) MXMPointAnnotation *toAnnotation;
// 保存起点数据
@property (nonatomic, strong) NSMutableDictionary *fromDic;
// 保存终点数据
@property (nonatomic, strong) NSMutableDictionary *toDic;

@end

@implementation RoutePlanningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.nameStr;
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建室内地图处理对象
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
    self.map.delegate = self;
    self.map.selectorPosition = MXMSelectorPositionCenterRight;
    // 创建路线绘制与控制对象
    self.painter = [[MXMRoutePainter alloc] initWithMapView:self.mapView map:self.map];
    // 布局页面内容
    [self _layoutViews];
}

#pragma mark - MGLMapViewDelegate

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation
{
    MGLAnnotationImage *annImg = [mapView dequeueReusableAnnotationImageWithIdentifier:@"ic_start_point"];
    if (annImg == nil) {
        UIImage *image = [UIImage imageNamed:@"ic_start_point"];
        image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
        annImg = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:@"ic_start_point"];
    }
    return annImg;
}

#pragma mark - MapxusMapDelegate

- (void)mapView:(MapxusMap *)mapView didChangeFloor:(NSString *)floorName atBuilding:(MXMGeoBuilding *)building
{
    [self.painter changeOnBuilding:building.identifier floor:floorName];
}

- (void)mapView:(MapxusMap *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate onFloor:(nullable NSString *)floorName inBuilding:(nullable MXMGeoBuilding *)building
{
    if (self.fromBtn.isSelected) {
        self.fromDic[@"floor"] = floorName;
        self.fromDic[@"building"] = building.identifier;
        MXMGeoPoint *p = [[MXMGeoPoint alloc] init];
        p.latitude = coordinate.latitude;
        p.longitude = coordinate.longitude;
        self.fromDic[@"point"] = p;

        if (self.fromAnnotation == nil) {
            self.fromAnnotation = [[MXMPointAnnotation alloc] init];
            self.fromAnnotation.coordinate = coordinate;
            self.fromAnnotation.floor = floorName;
            self.fromAnnotation.buildingId = building.identifier;
            [self.map addMXMPointAnnotations:@[self.fromAnnotation]];
        } else {
            self.fromAnnotation.coordinate = coordinate;
            self.fromAnnotation.floor = floorName;
            self.fromAnnotation.buildingId = building.identifier;
        }

    } else if (self.toBtn.isSelected) {
        self.toDic[@"floor"] = floorName;
        self.toDic[@"building"] = building.identifier;
        MXMGeoPoint *p = [[MXMGeoPoint alloc] init];
        p.latitude = coordinate.latitude;
        p.longitude = coordinate.longitude;
        self.toDic[@"point"] = p;

        if (self.toAnnotation == nil) {
            self.toAnnotation = [[MXMPointAnnotation alloc] init];
            self.toAnnotation.coordinate = coordinate;
            self.toAnnotation.floor = floorName;
            self.toAnnotation.buildingId = building.identifier;
            [self.map addMXMPointAnnotations:@[self.toAnnotation]];
        } else {
            self.toAnnotation.coordinate = coordinate;
            self.toAnnotation.floor = floorName;
            self.toAnnotation.buildingId = building.identifier;
        }
    }
}

#pragma mark -

- (void)MXMSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [ProgressHUD showError:NSLocalizedString(@"We can't find the route", nil)];
}

- (void)onRouteSearchDone:(MXMRouteSearchRequest *)request response:(MXMRouteSearchResponse *)response
{
    [self.painter paintRouteUsingRequest:request Result:response];
    [ProgressHUD dismiss];
}

#pragma mark - actions

- (void)fromBtnOnClickAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.toBtn.selected = NO;
    if (sender.isSelected) {
        [self.fromDic removeAllObjects];
    } else {
        [self btnTitleSet];
    }
}

- (void)toBtnOnClickAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.fromBtn.selected = NO;
    if (sender.isSelected) {
        [self.toDic removeAllObjects];
    } else {
        [self btnTitleSet];
    }
}

- (void)btnTitleSet
{
    MXMGeoPoint *fromP = self.fromDic[@"point"];
    if (fromP) {
        [self.fromBtn setTitle:[NSString stringWithFormat:@"%f, %f", fromP.latitude, fromP.longitude] forState:UIControlStateNormal];
    } else {
        [self.fromBtn setTitle:@"选择起点" forState:UIControlStateNormal];
    }
    MXMGeoPoint *toP = self.toDic[@"point"];
    if (toP) {
        [self.toBtn setTitle:[NSString stringWithFormat:@"%f, %f", toP.latitude, toP.longitude] forState:UIControlStateNormal];
    } else {
        [self.toBtn setTitle:@"选择终点" forState:UIControlStateNormal];
    }
}

- (void)showRouteAction:(id)sender
{
    [self.painter cleanRoute];

    [ProgressHUD show];
    MXMRouteSearchRequest *re = [[MXMRouteSearchRequest alloc] init];
    re.fromBuilding = self.fromDic[@"building"];
    re.fromFloor = self.fromDic[@"floor"];
    MXMGeoPoint *fromP = self.fromDic[@"point"];
    re.fromLat = fromP.latitude;
    re.fromLon = fromP.longitude;
    re.toBuilding = self.toDic[@"building"];
    re.toFloor = self.toDic[@"floor"];
    MXMGeoPoint *toP = self.toDic[@"point"];
    re.toLat = toP.latitude;
    re.toLon = toP.longitude;
    
    MXMSearchAPI *api = [[MXMSearchAPI alloc] init];
    api.delegate = self;
    [api MXMRouteSearch:re];
}

#pragma mark - getter and setter

- (void)_layoutViews
{
    MyRelativeLayout *rootLayout = [[MyRelativeLayout alloc] init];
    rootLayout.backgroundColor = [UIColor clearColor];
    rootLayout.frame = self.view.bounds;
    rootLayout.myMargin = 0;
    [self.view addSubview:rootLayout];
    
    self.mapView.myMargin = 0;
    [rootLayout addSubview:self.mapView];
    
    self.fromBtn.mySize = CGSizeMake(200, 40);
    self.fromBtn.topPos.equalTo(rootLayout.topPos).offset(20);
    self.fromBtn.leftPos.equalTo(rootLayout.leftPos).offset(10);
    [rootLayout addSubview:self.fromBtn];
    
    self.toBtn.mySize = CGSizeMake(200, 40);
    self.toBtn.topPos.equalTo(self.fromBtn.bottomPos).offset(5);
    self.toBtn.leftPos.equalTo(rootLayout.leftPos).offset(10);
    [rootLayout addSubview:self.toBtn];
    
    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showBtn.backgroundColor = [UIColor colorWithRed:72/255.0 green:209/255.0 blue:204/255.0 alpha:1];
    showBtn.layer.cornerRadius = 5;
    [showBtn setImage:[UIImage imageNamed:@"searchIcon"] forState:UIControlStateNormal];
    [showBtn addTarget:self action:@selector(showRouteAction:) forControlEvents:UIControlEventTouchUpInside];
    showBtn.leftPos.equalTo(self.fromBtn.rightPos).offset(5);
    showBtn.centerYPos.equalTo(self.fromBtn.bottomPos).offset(2.5);
    showBtn.mySize = CGSizeMake(44, 44);
    [rootLayout addSubview:showBtn];
}

- (MGLMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MGLMapView alloc] init];
        _mapView.delegate = self;
        _mapView.zoomLevel = 18;
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(22.304636500000001, 114.16299189999999);
    }
    return _mapView;
}

- (UIButton *)fromBtn
{
    if (!_fromBtn) {
        _fromBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fromBtn setTitle:@"选择起点" forState:UIControlStateNormal];
        [_fromBtn setTitle:@"请在屏幕中选择起点" forState:UIControlStateSelected];
        [_fromBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fromBtn addTarget:self action:@selector(fromBtnOnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _fromBtn.backgroundColor = [UIColor colorWithRed:100/255.0 green:149/255.0 blue:237/255.0 alpha:1];
        _fromBtn.layer.cornerRadius = 5;
        _fromBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _fromBtn;
}

- (UIButton *)toBtn
{
    if (!_toBtn) {
        _toBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toBtn setTitle:@"选择终点" forState:UIControlStateNormal];
        [_toBtn setTitle:@"请在屏幕中选择终点" forState:UIControlStateSelected];
        [_toBtn setTitleColor:[UIColor colorWithRed:100/255.0 green:149/255.0 blue:237/255.0 alpha:1] forState:UIControlStateNormal];
        [_toBtn addTarget:self action:@selector(toBtnOnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _toBtn.backgroundColor = [UIColor whiteColor];
        _toBtn.layer.cornerRadius = 5;
        _toBtn.layer.borderWidth = 2;
        _toBtn.layer.borderColor = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:0.4].CGColor;
        _toBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _toBtn;
}

- (NSMutableDictionary *)fromDic
{
    if (!_fromDic) {
        _fromDic = [NSMutableDictionary dictionary];
    }
    return _fromDic;
}

- (NSMutableDictionary *)toDic
{
    if (!_toDic) {
        _toDic = [NSMutableDictionary dictionary];
    }
    return _toDic;
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
