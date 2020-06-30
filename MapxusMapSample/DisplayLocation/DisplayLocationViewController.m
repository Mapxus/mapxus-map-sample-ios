//
//  DisplayLocationViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

@import Mapbox;
@import MapxusMapSDK;

#import "DisplayLocationViewController.h"
#import "MBXCustomLocationManager.h"

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
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(22.370787, 114.111375);
    self.mapView.zoomLevel = 16;
    self.mapView.locationManager = [[MBXCustomLocationManager alloc] init];
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
    self.mapView.showsUserHeadingIndicator = YES;
    self.mapView.showsUserLocation = YES;
}

- (IBAction)changeTrack:(UIButton *)sender {
    self.times = (self.times+1)%3;
    if (self.times) {
        CLAuthorizationStatus s = [CLLocationManager authorizationStatus];
        if (s != kCLAuthorizationStatusAuthorizedAlways &&
            s != kCLAuthorizationStatusAuthorizedWhenInUse) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Open location service" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];

        }
    }
    
    switch (self.times) {
        case 0:
        {
            [self.mapView setUserTrackingMode:MGLUserTrackingModeNone animated:YES completionHandler:nil];
        }
            break;
        case 1:
        {
            [self.mapView setUserTrackingMode:MGLUserTrackingModeFollow animated:YES completionHandler:nil];
        }
            break;
        case 2:
        {
            [self.mapView setUserTrackingMode:MGLUserTrackingModeFollowWithHeading animated:YES completionHandler:nil];
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
    if (userLocation.location.floor) {
        self.floorLabel.text = [NSString stringWithFormat:@"floor:%ld", (long)userLocation.location.floor.level];
    } else {
        self.floorLabel.text = @"floor:N/A";
    }
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
