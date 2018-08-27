//
//  DefaultStylesViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/11.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "DefaultStylesViewController.h"
@import MapxusMapSDK;
@import Mapbox;

@interface DefaultStylesViewController () <MGLMapViewDelegate>

@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *map;

@end

@implementation DefaultStylesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.nameStr;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Style", nil) style:(UIBarButtonItemStylePlain) target:self action:@selector(chooseStyle)];
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(22.304716516178253, 114.16186609400843);
    self.mapView.zoomLevel = 16;
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
}

- (void)chooseStyle
{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *common = [UIAlertAction actionWithTitle:NSLocalizedString(@"COMMON", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.map setMapSytle:(MXMStyleCOMMON)];
    }];
    UIAlertAction *christmas = [UIAlertAction actionWithTitle:NSLocalizedString(@"CHRISTMAS", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.map setMapSytle:(MXMStyleCHRISTMAS)];
    }];
    UIAlertAction *hallowmas = [UIAlertAction actionWithTitle:NSLocalizedString(@"HALLOWMAS", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.map setMapSytle:(MXMStyleHALLOWMAS)];
    }];
    UIAlertAction *mappybee = [UIAlertAction actionWithTitle:NSLocalizedString(@"MAPPYBEE", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.map setMapSytle:(MXMStyleMAPPYBEE)];
    }];
    UIAlertAction *mapxus = [UIAlertAction actionWithTitle:NSLocalizedString(@"MAPXUS", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.map setMapSytle:(MXMStyleMAPXUS)];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:(UIAlertActionStyleCancel) handler:nil];
    
    [alert addAction:common];
    [alert addAction:christmas];
    [alert addAction:hallowmas];
    [alert addAction:mappybee];
    [alert addAction:mapxus];
    [alert addAction:cancel];
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        UIPopoverPresentationController *popoverPresentCtr = alert.popoverPresentationController;
        popoverPresentCtr.barButtonItem = self.navigationItem.rightBarButtonItem;
    }
    [self presentViewController:alert animated:YES completion:nil];
        
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
