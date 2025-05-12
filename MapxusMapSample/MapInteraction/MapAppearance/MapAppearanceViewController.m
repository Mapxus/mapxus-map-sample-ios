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
#import "SelectedBuildingOutlineViewController.h"
#import "Macro.h"
#import "Param.h"

@interface MapAppearanceViewController () <MGLMapViewDelegate, Param>
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *mapxusMap;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *hiddenTip;
@property (nonatomic, strong) UISwitch *hiddenSwitch;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIButton *styleButton;
@property (nonatomic, strong) UIButton *languageButton;
@property (nonatomic, strong) UIButton *outLineButton;

@end

@implementation MapAppearanceViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self layoutUI];
  MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
  configuration.defaultStyle = MXMStyleMAPXUS;
  self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapView configuration:configuration];
}

- (void)changeHiddenStatu:(UISwitch *)sender {
  if (sender.isOn) {
    // Hidden outdoor map information
    self.mapxusMap.outdoorHidden = YES;
  } else {
    // Show outdoor map information
    self.mapxusMap.outdoorHidden = NO;
  }
}

- (void)changeStyle:(UIButton *)sender {
  __weak typeof(self) weakSelf = self;
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
  UIAlertAction *common = [UIAlertAction actionWithTitle:NSLocalizedString(@"COMMON", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    // Use COMMON map style
    [weakSelf.mapxusMap setMapSytle:(MXMStyleCOMMON)];
  }];
  UIAlertAction *christmas = [UIAlertAction actionWithTitle:NSLocalizedString(@"CHRISTMAS", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    // Use CHRISTMAS map style
    [weakSelf.mapxusMap setMapSytle:(MXMStyleCHRISTMAS)];
  }];
  UIAlertAction *hallowmas = [UIAlertAction actionWithTitle:NSLocalizedString(@"HALLOWMAS", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    // Use HALLOWMAS map style
    [weakSelf.mapxusMap setMapSytle:(MXMStyleHALLOWMAS)];
  }];
  UIAlertAction *mappybee = [UIAlertAction actionWithTitle:NSLocalizedString(@"MAPPYBEE", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    // Use MAPPYBEE map style
    [weakSelf.mapxusMap setMapSytle:(MXMStyleMAPPYBEE)];
  }];
  UIAlertAction *mapxus = [UIAlertAction actionWithTitle:NSLocalizedString(@"MAPXUS", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    // Use MAPXUS map style
    [weakSelf.mapxusMap setMapSytle:(MXMStyleMAPXUS)];
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
    [weakSelf.mapxusMap setMapLanguage:@"default"];
  }];
  UIAlertAction *enAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"en", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    // Display English marks on the map
    [weakSelf.mapxusMap setMapLanguage:@"en"];
  }];
  UIAlertAction *zhHantAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"zh-Hant", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    // Display Traditional Chinese marks on the map
    [weakSelf.mapxusMap setMapLanguage:@"zh-Hant"];
  }];
  UIAlertAction *zhHantTWAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"zh-Hant-TW", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    // Display Taiwan Traditional Chinese marks on the map
    [weakSelf.mapxusMap setMapLanguage:@"zh-Hant-TW"];
  }];
  UIAlertAction *zhHansAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"zh-Hans", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    // Display Simplified Chinese marks on the map
    [weakSelf.mapxusMap setMapLanguage:@"zh-Hans"];
  }];
  UIAlertAction *jaAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ja", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    // Display Japanese marks on the map
    [weakSelf.mapxusMap setMapLanguage:@"ja"];
  }];
  UIAlertAction *koAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ko", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    // Display Korean marks on the map
    [weakSelf.mapxusMap setMapLanguage:@"ko"];
  }];
  UIAlertAction *filAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"fil", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    // Display Korean marks on the map
    [weakSelf.mapxusMap setMapLanguage:@"fil"];
  }];
  UIAlertAction *idAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"id", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    // Display Korean marks on the map
    [weakSelf.mapxusMap setMapLanguage:@"id"];
  }];
  UIAlertAction *ptAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"pt", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    // Display Korean marks on the map
    [weakSelf.mapxusMap setMapLanguage:@"pt"];
  }];
  UIAlertAction *thAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"th", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    // Display Korean marks on the map
    [weakSelf.mapxusMap setMapLanguage:@"th"];
  }];
  UIAlertAction *viAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"vi", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    // Display Korean marks on the map
    [weakSelf.mapxusMap setMapLanguage:@"vi"];
  }];
  UIAlertAction *arAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ar", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    // Display Korean marks on the map
    [weakSelf.mapxusMap setMapLanguage:@"ar"];
  }];
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:(UIAlertActionStyleCancel) handler:nil];
  
  [alert addAction:defaultAction];
  [alert addAction:enAction];
  [alert addAction:zhHantAction];
  [alert addAction:zhHantTWAction];
  [alert addAction:zhHansAction];
  [alert addAction:jaAction];
  [alert addAction:koAction];
  [alert addAction:filAction];
  [alert addAction:idAction];
  [alert addAction:ptAction];
  [alert addAction:thAction];
  [alert addAction:viAction];
  [alert addAction:arAction];
  [alert addAction:cancelAction];
  
  if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    UIPopoverPresentationController *popoverPresentCtr = alert.popoverPresentationController;
    popoverPresentCtr.sourceView = sender;
  }
  [self presentViewController:alert animated:YES completion:nil];
}

- (void)clickToChangeBuildingOutLine {
  SelectedBuildingOutlineViewController *vc = [[SelectedBuildingOutlineViewController alloc] init];
  vc.delegate = self;
  [self presentViewController:vc animated:YES completion:nil];
}

- (void)layoutUI {
  [self.view addSubview:self.mapView];
  [self.view addSubview:self.boxView];
  [self.boxView addSubview:self.hiddenSwitch];
  [self.boxView addSubview:self.hiddenTip];
  [self.boxView addSubview:self.stackView];
  [self.stackView addArrangedSubview:self.styleButton];
  [self.stackView addArrangedSubview:self.languageButton];
  [self.boxView addSubview:self.outLineButton];
  
  [self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
  [self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
  [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
  [self.mapView.bottomAnchor constraintEqualToAnchor:self.boxView.topAnchor].active = YES;
  
  [self.boxView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
  [self.boxView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
  [self.boxView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
  if (@available(iOS 11.0, *)) {
    [self.boxView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-190].active = YES;
  } else {
    [self.boxView.topAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-190].active = YES;
  }
  
  [self.hiddenSwitch.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.hiddenSwitch.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:moduleSpace].active = YES;
  
  [self.hiddenTip.leadingAnchor constraintEqualToAnchor:self.hiddenSwitch.trailingAnchor constant:innerSpace].active = YES;
  [self.hiddenTip.centerYAnchor constraintEqualToAnchor:self.hiddenSwitch.centerYAnchor].active = YES;
  
  [self.stackView.topAnchor constraintEqualToAnchor:self.hiddenSwitch.bottomAnchor constant:moduleSpace].active = YES;
  [self.stackView.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.stackView.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.stackView.heightAnchor constraintEqualToConstant:40].active = YES;
  
  [self.outLineButton.topAnchor constraintEqualToAnchor:self.stackView.bottomAnchor constant:moduleSpace].active = YES;
  [self.outLineButton.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.outLineButton.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.outLineButton.heightAnchor constraintEqualToConstant:40].active = YES;
}

#pragma mark - Param

- (void)completeParamConfiguration:(NSDictionary *)param {
  MXMBorderStyle *style = [[MXMBorderStyle alloc] init];
  if(![param[@"lineWlineOpacityidth"] isEqualToString:@""])
  {
    float lineOpacity = ([param[@"lineOpacity"] floatValue] > 1.0) ? 1.0 : [param[@"lineOpacity"] floatValue];
    style.lineOpacity = [NSExpression expressionForConstantValue:@(lineOpacity)];
  }
  if(![param[@"lineColor"] isEqualToString:@""])
  {
    style.lineColor = [NSExpression expressionForConstantValue:[self ColorwithHexString:param[@"lineColor"]]];
  }
  if(![param[@"lineWidth"] isEqualToString:@""])
  {
    float lineWidth = ([param[@"lineWidth"] floatValue] < 0.0) ? 0 : [param[@"lineWidth"] floatValue];
    style.lineWidth = [NSExpression expressionForConstantValue:@(lineWidth)];
  }
  if(![param[@"lineOffset"] isEqualToString:@""]){
    style.lineOffset = [NSExpression expressionForConstantValue:@( [param[@"lineOffset"] floatValue])];
  }
  
  self.mapxusMap.selectedBuildingBorderStyle = style;
}

- (UIColor *)ColorwithHexString:(NSString *)color {
  NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
  // String should be 6 or 8 characters
  if ([cString length] < 6) {
    return [UIColor clearColor];
  }
  
  // strip 0X if it appears
  if ([cString hasPrefix:@"0X"])
    cString = [cString substringFromIndex:2];
  if ([cString hasPrefix:@"#"])
    cString = [cString substringFromIndex:1];
  if ([cString length] != 8 && [cString length]!=6)
    return [UIColor clearColor];
  
  // Separate into r, g, b substrings
  NSRange range;
  range.length = 2;
  
  //r
  range.location = 0;
  NSString *rString = [cString substringWithRange:range];
  
  //g
  range.location = 2;
  NSString *gString = [cString substringWithRange:range];
  
  //b
  range.location = 4;
  NSString *bString = [cString substringWithRange:range];
  
  // Scan values
  unsigned int r, g, b;
  [[NSScanner scannerWithString:rString] scanHexInt:&r];
  [[NSScanner scannerWithString:gString] scanHexInt:&g];
  [[NSScanner scannerWithString:bString] scanHexInt:&b];
  
  return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0];
}

#pragma mark - Lazy loading
- (MGLMapView *)mapView {
  if (!_mapView) {
    _mapView = [[MGLMapView alloc] init];
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(PARAMCONFIGINFO.center_latitude, PARAMCONFIGINFO.center_longitude);
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

- (UIButton *)outLineButton {
  if (!_outLineButton) {
    _outLineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _outLineButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_outLineButton setTitle:@"Actived Building Outline" forState:UIControlStateNormal];
    [_outLineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _outLineButton.backgroundColor = [UIColor colorWithRed:80/255.0 green:175/255.0 blue:243/255.0 alpha:1.0];
    [_outLineButton addTarget:self action:@selector(clickToChangeBuildingOutLine) forControlEvents:UIControlEventTouchUpInside];
    _outLineButton.layer.cornerRadius = 5;
  }
  return _outLineButton;
}
@end
