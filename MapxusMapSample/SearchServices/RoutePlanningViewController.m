//
//  RoutePlanningViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/10.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "RoutePlanningViewController.h"
#import "ArrowPointAnnotation.h"
#import "UIImage+Rotate.h"
@import ProgressHUD;

@import Mapbox;
@import MapxusMapSDK;

@interface RoutePlanningViewController () <MapxusMapDelegate, MXMSearchDelegate, MGLMapViewDelegate>

@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *map;
@property (nonatomic, strong) NSArray *pathList;
@property (nonatomic, weak) MXMStep *fristStep;
@property (nonatomic, weak) MXMStep *lastStep;

@end

@implementation RoutePlanningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.nameStr;
    self.mapView.zoomLevel = 18;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(22.304636500000001, 114.16299189999999);
    
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
    self.map.delegate = self;
    
    [ProgressHUD show];
    MXMRouteSearchRequest *re = [[MXMRouteSearchRequest alloc] init];
    re.fromBuilding = @"elements_hk_dc005f";
    re.fromFloor = @"G";
    re.fromLat = 22.304636500000001;
    re.fromLon = 114.16299189999999;
    re.toBuilding = @"elements_hk_dc005f";
    re.toFloor = @"L2";
    re.toLat = 22.304689;
    re.toLon = 114.16220269999999;

    MXMSearchAPI *api = [[MXMSearchAPI alloc] init];
    api.delegate = self;
    [api MXMRouteSearch:re];
}

- (void)mapViewDidFinishLoadingMap:(MGLMapView *)mapView
{
    if (self.fristStep) {
        [self.map selectFloor:self.fristStep.floor];
    }
}

- (UIColor *)mapView:(MGLMapView *)mapView strokeColorForShapeAnnotation:(MGLShape *)annotation
{
    return [UIColor blueColor];
}

- (CGFloat)mapView:(MGLMapView *)mapView lineWidthForPolylineAnnotation:(MGLPolyline *)annotation
{
    return 1;
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation
{
    if ([annotation isKindOfClass:[ArrowPointAnnotation class]]) {
        ArrowPointAnnotation *a = (ArrowPointAnnotation *)annotation;
        if (a.type == 0) {
            UIImage *img = [[UIImage imageNamed:@"arrow"] imageRotatedByDegrees:a.angle];
            NSString *str = [NSString stringWithFormat:@"test%f", a.angle];
            MGLAnnotationImage *imgAnn = [MGLAnnotationImage annotationImageWithImage:img reuseIdentifier:str];
            return imgAnn;
        } else if (a.type == 1) {
            UIImage *img = [UIImage imageNamed:@"ic_start_point"];
            MGLAnnotationImage *imgAnn = [MGLAnnotationImage annotationImageWithImage:img reuseIdentifier:@"ic_start_point"];
            return imgAnn;
        } else if (a.type == 2) {
            UIImage *img = [UIImage imageNamed:@"ic_end_point"];
            MGLAnnotationImage *imgAnn = [MGLAnnotationImage annotationImageWithImage:img reuseIdentifier:@"ic_end_point"];
            return imgAnn;
        } else if (a.type == 3) {
            UIImage *img = [[UIImage imageNamed:@"ic_path_start_point"] imageRotatedByDegrees:a.angle];
            NSString *str = [NSString stringWithFormat:@"test%f", a.angle];
            MGLAnnotationImage *imgAnn = [MGLAnnotationImage annotationImageWithImage:img reuseIdentifier:str];
            return imgAnn;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (void)BEMSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [ProgressHUD showError:NSLocalizedString(@"We can't find the route", nil)];
}

- (void)onRouteSearchDone:(MXMRouteSearchRequest *)request response:(MXMRouteSearchResponse *)response
{
    MXMPath *path = response.routes.firstObject;
    self.pathList = path.coordinates;
    self.fristStep = self.pathList.firstObject;
    self.lastStep = self.pathList.lastObject;
    
    [ProgressHUD dismiss];
}

- (void)mapView:(MapxusMap *)mapView didChangeFloor:(NSString *)floorName atBuilding:(MXMGeoBuilding *)building
{
    NSMutableArray *list = [NSMutableArray array];
    for (MXMStep *s in self.pathList) {
        if ([s.buildingId isEqualToString:building.identifier] && [s.floor isEqualToString:floorName]) {
            [list addObject:s];
        }
    }
    [self mapAddLine:list];
}

- (void)mapAddLine:(NSArray *)subPath
{
    if (self.mapView.annotations.count) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    if (!subPath.count) {
        return;
    }
    
    BOOL subFrist = YES;
    
    MXMStep *subFristStep = subPath.firstObject;
    MXMStep *subLastStep = subPath.lastObject;
    
    if (self.fristStep.lat == subFristStep.lat &&
        self.fristStep.lon == subFristStep.lon &&
        [self.fristStep.floor isEqualToString:subFristStep.floor]) {
        ArrowPointAnnotation *fristAnn = [[ArrowPointAnnotation alloc] init];
        fristAnn.coordinate = CLLocationCoordinate2DMake(subFristStep.lat, subFristStep.lon);
        fristAnn.type = 1;
        [self.mapView addAnnotation:fristAnn];
        subFrist = NO;
    }
    if (self.lastStep.lat == subLastStep.lat &&
        self.lastStep.lon == subLastStep.lon &&
        [self.lastStep.floor isEqualToString:subLastStep.floor]) {
        ArrowPointAnnotation *lastAnn = [[ArrowPointAnnotation alloc] init];
        lastAnn.coordinate = CLLocationCoordinate2DMake(subLastStep.lat, subLastStep.lon);
        lastAnn.type = 2;
        [self.mapView addAnnotation:lastAnn];
    }
    
    
    CLLocationCoordinate2D coordinates[subPath.count]; // 线记录
    NSMutableArray *annotationst = [NSMutableArray array];
    MXMStep *step = subPath.firstObject;
    coordinates[0] = CLLocationCoordinate2DMake(step.lat, step.lon);
    for (int i=1; i<subPath.count; i++) {
        MXMStep *nextStep = subPath[i];
        coordinates[i] = CLLocationCoordinate2DMake(nextStep.lat, nextStep.lon);
        ArrowPointAnnotation *arrowAnn = [[ArrowPointAnnotation alloc] init];
        arrowAnn.coordinate = CLLocationCoordinate2DMake(step.lat, step.lon);
        arrowAnn.angle = [self getBearingWithLatA:step.lat whitLngA:step.lon whitLatB:nextStep.lat whitLngB:nextStep.lon];
        if (subFrist) {
            arrowAnn.type = 3;
            subFrist = NO;
        }
        [annotationst addObject:arrowAnn];
        step = nextStep;
    }
    
    NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);

    MGLPolyline *polyline = [MGLPolyline polylineWithCoordinates:coordinates count:numberOfCoordinates];
    
    [self.mapView addAnnotation:polyline];
    [self.mapView addAnnotations:annotationst];
}



//根据角度计算弧度
-(double)radian:(double)d {
    return d * M_PI/180.0;
}

-(double)getBearingWithLatA:(double)latA whitLngA:(double)lngA whitLatB:(double)latB whitLngB:(double)lngB {
    
    static double Rc=6378137;
    static double Rj=6356725;
    
    // 计算点A的Ec,Ed
    double m_RadLoA=lngA*M_PI/180.;
    double m_RadLaA=latA*M_PI/180.;
    double EcA=Rj+(Rc-Rj)*(90.-latA)/90.;
    double EdA=EcA*cos(m_RadLaA);
    
    // 计算点B的Ec,Ed
    double m_RadLoB=lngB*M_PI/180.;
    double m_RadLaB=latB*M_PI/180.;    
    
    double dx=(m_RadLoB-m_RadLoA)*EdA;
    double dy=(m_RadLaB-m_RadLaA)*EcA;
    double angle=0.0;
    angle= atan(ABS(dx/dy))*180./M_PI;
    double dLo=lngB-lngA;
    double dLa=latB-latA;
    if(dLo>0&&dLa<=0){
        angle=(90.-angle)+90;
    }
    else if(dLo<=0&&dLa<0){
        angle=angle+180.;
    }else if(dLo<0&&dLa>=0){
        angle= (90.-angle)+270;
    }
    return angle;
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
