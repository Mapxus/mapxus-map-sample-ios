//
//  DisplayLocationViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "DisplayLocationViewController.h"
@import Mapbox;
@import MapxusMapSDK;

@interface DisplayLocationViewController () <MGLMapViewDelegate>

@property (nonatomic, strong) MapxusMap *map;
@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *latLabel;
@property (weak, nonatomic) IBOutlet UILabel *lonLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;
@property (weak, nonatomic) IBOutlet UIButton *trackBtn;
@property (nonatomic, assign) int times;

@end

@implementation DisplayLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.times = 0;
    self.title = self.nameStr;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(22.304716516178253, 114.16186609400843);
    self.mapView.zoomLevel = 16;
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
    self.mapView.showsUserLocation = YES;
}

- (IBAction)changeTrack:(UIButton *)sender {
    self.times = (self.times+1)%3;
    switch (self.times) {
        case 0:
        {
            [self.mapView setUserTrackingMode:MGLUserTrackingModeNone animated:YES];
        }
            break;
        case 1:
        {
            [self.mapView setUserTrackingMode:MGLUserTrackingModeFollow animated:YES];
        }
            break;
        case 2:
        {
            [self.mapView setUserTrackingMode:MGLUserTrackingModeFollowWithHeading animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(MGLUserLocation *)userLocation
{
    self.latLabel.text = [NSString stringWithFormat:@"lat:%f", userLocation.location.coordinate.latitude];
    self.lonLabel.text = [NSString stringWithFormat:@"lon:%f", userLocation.location.coordinate.longitude];
    self.floorLabel.text = [NSString stringWithFormat:@"floor:%ld", userLocation.location.floor.level];
    self.accuracyLabel.text = [NSString stringWithFormat:@"accuracy:%f", userLocation.location.horizontalAccuracy];
}

- (void)mapView:(MGLMapView *)mapView didChangeUserTrackingMode:(MGLUserTrackingMode)mode animated:(BOOL)animated
{
    switch (mode) {
        case MGLUserTrackingModeNone:
            [self.trackBtn setTitle:@"None" forState:UIControlStateNormal];
            break;
        case MGLUserTrackingModeFollow:
            [self.trackBtn setTitle:@"Follow" forState:UIControlStateNormal];
            break;
        case MGLUserTrackingModeFollowWithHeading:
            [self.trackBtn setTitle:@"Heading" forState:UIControlStateNormal];
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
