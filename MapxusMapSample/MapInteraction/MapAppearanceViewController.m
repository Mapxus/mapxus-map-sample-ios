//
//  MapAppearanceViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/17.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MapxusMapSDK.h>
#import "MapAppearanceViewController.h"
#import "Macro.h"

@interface MapAppearanceViewController () <MGLMapViewDelegate>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapPlugin;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *hiddenTip;
@property (nonatomic, strong) UISwitch *hiddenSwitch;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIButton *styleButton;
@property (nonatomic, strong) UIButton *languageButton;

@end

@implementation MapAppearanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];
    self.mapPlugin = [[MapxusMap alloc] initWithMapView:self.mapView];
}

- (void)changeHiddenStatu:(UISwitch *)sender {
    if (sender.isOn) {
        // Hidden outdoor map information
        self.mapPlugin.outdoorHidden = YES;
    } else {
        // Show outdoor map information
        self.mapPlugin.outdoorHidden = NO;
    }
}

- (void)changeStyle:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *common = [UIAlertAction actionWithTitle:NSLocalizedString(@"COMMON", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        // Use COMMON map style
        [weakSelf.mapPlugin setMapSytle:(MXMStyleCOMMON)];
    }];
    UIAlertAction *christmas = [UIAlertAction actionWithTitle:NSLocalizedString(@"CHRISTMAS", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        // Use CHRISTMAS map style
        [weakSelf.mapPlugin setMapSytle:(MXMStyleCHRISTMAS)];
    }];
    UIAlertAction *hallowmas = [UIAlertAction actionWithTitle:NSLocalizedString(@"HALLOWMAS", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        // Use HALLOWMAS map style
        [weakSelf.mapPlugin setMapSytle:(MXMStyleHALLOWMAS)];
    }];
    UIAlertAction *mappybee = [UIAlertAction actionWithTitle:NSLocalizedString(@"MAPPYBEE", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        // Use MAPPYBEE map style
        [weakSelf.mapPlugin setMapSytle:(MXMStyleMAPPYBEE)];
    }];
    UIAlertAction *mapxus = [UIAlertAction actionWithTitle:NSLocalizedString(@"MAPXUS", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        // Use MAPXUS map style
        [weakSelf.mapPlugin setMapSytle:(MXMStyleMAPXUS)];
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
        popoverPresentCtr.sourceView = sender;
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)changeLanguage:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"default", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        // Display default marks on the map
        [weakSelf.mapPlugin setMapLanguage:@"default"];
    }];
    UIAlertAction *enAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"en", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        // Display English marks on the map
        [weakSelf.mapPlugin setMapLanguage:@"en"];
    }];
    UIAlertAction *zhHantAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"zh-Hant", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        // Display Traditional Chinese marks on the map
        [weakSelf.mapPlugin setMapLanguage:@"zh-Hant"];
    }];
    UIAlertAction *zhHansAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"zh-Hans", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        // Display Simplified Chinese marks on the map
        [weakSelf.mapPlugin setMapLanguage:@"zh-Hans"];
    }];
    UIAlertAction *jaAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ja", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        // Display Japanese marks on the map
        [weakSelf.mapPlugin setMapLanguage:@"ja"];
    }];
    UIAlertAction *koAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ko", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        // Display Korean marks on the map
        [weakSelf.mapPlugin setMapLanguage:@"ko"];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:(UIAlertActionStyleCancel) handler:nil];
    
    [alert addAction:defaultAction];
    [alert addAction:enAction];
    [alert addAction:zhHantAction];
    [alert addAction:zhHansAction];
    [alert addAction:jaAction];
    [alert addAction:koAction];
    [alert addAction:cancelAction];
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        UIPopoverPresentationController *popoverPresentCtr = alert.popoverPresentationController;
        popoverPresentCtr.sourceView = sender;
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)layoutUI {
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.boxView];
    [self.boxView addSubview:self.hiddenSwitch];
    [self.boxView addSubview:self.hiddenTip];
    [self.boxView addSubview:self.stackView];
    [self.stackView addArrangedSubview:self.styleButton];
    [self.stackView addArrangedSubview:self.languageButton];
    
    [self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.mapView.bottomAnchor constraintEqualToAnchor:self.boxView.topAnchor].active = YES;
    
    [self.boxView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.boxView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.boxView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    if (@available(iOS 11.0, *)) {
        [self.boxView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-130].active = YES;
    } else {
        [self.boxView.topAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-130].active = YES;
    }
    
    [self.hiddenSwitch.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.hiddenSwitch.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:moduleSpace].active = YES;
    
    [self.hiddenTip.leadingAnchor constraintEqualToAnchor:self.hiddenSwitch.trailingAnchor constant:innerSpace].active = YES;
    [self.hiddenTip.centerYAnchor constraintEqualToAnchor:self.hiddenSwitch.centerYAnchor].active = YES;
    
    [self.stackView.topAnchor constraintEqualToAnchor:self.hiddenSwitch.bottomAnchor constant:moduleSpace].active = YES;
    [self.stackView.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.stackView.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    [self.stackView.heightAnchor constraintEqualToConstant:40].active = YES;
}

#pragma mark - Lazy loading
- (MGLMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MGLMapView alloc] init];
        _mapView.translatesAutoresizingMaskIntoConstraints = NO;
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(22.370587, 114.111375);
        _mapView.zoomLevel = 17;
        _mapView.delegate = self;
    }
    return _mapView;
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _boxView;
}

- (UILabel *)hiddenTip {
    if (!_hiddenTip) {
        _hiddenTip = [[UILabel alloc] init];
        _hiddenTip.translatesAutoresizingMaskIntoConstraints = NO;
        _hiddenTip.text = @"isOutdoorHidden";
    }
    return _hiddenTip;
}

- (UISwitch *)hiddenSwitch {
    if (!_hiddenSwitch) {
        _hiddenSwitch = [[UISwitch alloc] init];
        _hiddenSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        [_hiddenSwitch addTarget:self action:@selector(changeHiddenStatu:) forControlEvents:UIControlEventValueChanged];
    }
    return _hiddenSwitch;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.spacing = moduleSpace;
    }
    return _stackView;
}

- (UIButton *)styleButton {
    if (!_styleButton) {
        _styleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _styleButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_styleButton setTitle:@"Style" forState:UIControlStateNormal];
        [_styleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _styleButton.backgroundColor = [UIColor colorWithRed:80/255.0 green:175/255.0 blue:243/255.0 alpha:1.0];
        [_styleButton addTarget:self action:@selector(changeStyle:) forControlEvents:UIControlEventTouchUpInside];
        _styleButton.layer.cornerRadius = 5;
    }
    return _styleButton;
}

- (UIButton *)languageButton {
    if (!_languageButton) {
        _languageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _languageButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_languageButton setTitle:@"Language" forState:UIControlStateNormal];
        [_languageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _languageButton.backgroundColor = [UIColor colorWithRed:80/255.0 green:175/255.0 blue:243/255.0 alpha:1.0];
        [_languageButton addTarget:self action:@selector(changeLanguage:) forControlEvents:UIControlEventTouchUpInside];
        _languageButton.layer.cornerRadius = 5;
    }
    return _languageButton;
}

@end
