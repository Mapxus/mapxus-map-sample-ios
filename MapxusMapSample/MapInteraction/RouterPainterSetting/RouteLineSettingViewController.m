//
//  RouteLineSettingViewController.m
//  MapxusMapSample
//
//  Created by guochenghao on 2024/11/12.
//  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <IQKeyboardManager/IQKeyboardManager.h>
#import "RouteLineSettingViewController.h"
#import "Macro.h"

@interface RouteLineSettingViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *opacityTip;
@property (nonatomic, strong) UITextField *opacityTextField;
@property (nonatomic, strong) UILabel *indoorLineColorTip;
@property (nonatomic, strong) UITextField *indoorLineColorTextField;
@property (nonatomic, strong) UILabel *outdoorLineColorTip;
@property (nonatomic, strong) UITextField *outdoorLineColorTextField;
@property (nonatomic, strong) UILabel *dashLineColorTip;
@property (nonatomic, strong) UITextField *dashLineColorTextField;
@property (nonatomic, strong) UILabel *lineWidthTip;
@property (nonatomic, strong) UITextField *lineWidthTextField;
@property (nonatomic, strong) UILabel *dashLineWidthTip;
@property (nonatomic, strong) UITextField *dashLineWidthTextField;

@property (nonatomic, strong) UIButton *createButton;
@end

@implementation RouteLineSettingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self layoutUI];
}

- (void)createButtonAction {
  __weak typeof(self) weakSelf = self;
  [self dismissViewControllerAnimated:YES completion:^{
    if (self.delegate && [self.delegate respondsToSelector:@selector(completeParamConfiguration:)]) {
      NSMutableDictionary *params = [NSMutableDictionary dictionary];
      params[@"inactiveLineOpacity"] = weakSelf.opacityTextField.text;
      params[@"indoorLineColor"] = weakSelf.indoorLineColorTextField.text;
      params[@"outdoorLineColor"] = weakSelf.outdoorLineColorTextField.text;
      params[@"dashLineColor"] = weakSelf.dashLineColorTextField.text;
      params[@"lineWidth"] = weakSelf.lineWidthTextField.text;
      params[@"dashLineWidth"] = weakSelf.dashLineWidthTextField.text;
      
      [self.delegate completeParamConfiguration:params];
    }
  }];
}

- (void)layoutUI {
  [self.view addSubview:self.scrollView];
  [self.scrollView addSubview:self.boxView];
  [self.boxView addSubview:self.opacityTip];
  [self.boxView addSubview:self.opacityTextField];
  [self.boxView addSubview:self.indoorLineColorTip];
  [self.boxView addSubview:self.indoorLineColorTextField];
  [self.boxView addSubview:self.outdoorLineColorTip];
  [self.boxView addSubview:self.outdoorLineColorTextField];
  [self.boxView addSubview:self.dashLineColorTip];
  [self.boxView addSubview:self.dashLineColorTextField];
  [self.boxView addSubview:self.lineWidthTip];
  [self.boxView addSubview:self.lineWidthTextField];
  [self.boxView addSubview:self.dashLineWidthTip];
  [self.boxView addSubview:self.dashLineWidthTextField];
  [self.boxView addSubview:self.createButton];
  
  if (@available(iOS 11.0, *)) {
    [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
    [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
    [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
  } else {
    [self.scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
  }
  
  [self.boxView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor].active = YES;
  [self.boxView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor].active = YES;
  [self.boxView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor].active = YES;
  [self.boxView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor].active = YES;
  [self.boxView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor].active = YES;
  
  [self.opacityTip.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:moduleSpace].active = YES;
  [self.opacityTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.opacityTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.opacityTextField.topAnchor constraintEqualToAnchor:self.opacityTip.bottomAnchor constant:innerSpace].active = YES;
  [self.opacityTextField.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.opacityTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.opacityTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.indoorLineColorTip.topAnchor constraintEqualToAnchor:self.opacityTextField.bottomAnchor constant:moduleSpace].active = YES;
  [self.indoorLineColorTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.indoorLineColorTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.indoorLineColorTextField.topAnchor constraintEqualToAnchor:self.indoorLineColorTip.bottomAnchor constant:innerSpace].active = YES;
  [self.indoorLineColorTextField.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.indoorLineColorTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.indoorLineColorTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.outdoorLineColorTip.topAnchor constraintEqualToAnchor:self.indoorLineColorTextField.bottomAnchor constant:moduleSpace].active = YES;
  [self.outdoorLineColorTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.outdoorLineColorTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.outdoorLineColorTextField.topAnchor constraintEqualToAnchor:self.outdoorLineColorTip.bottomAnchor constant:innerSpace].active = YES;
  [self.outdoorLineColorTextField.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.outdoorLineColorTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.outdoorLineColorTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.dashLineColorTip.topAnchor constraintEqualToAnchor:self.outdoorLineColorTextField.bottomAnchor constant:moduleSpace].active = YES;
  [self.dashLineColorTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.dashLineColorTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.dashLineColorTextField.topAnchor constraintEqualToAnchor:self.dashLineColorTip.bottomAnchor constant:innerSpace].active = YES;
  [self.dashLineColorTextField.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.dashLineColorTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.dashLineColorTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.lineWidthTip.topAnchor constraintEqualToAnchor:self.dashLineColorTextField.bottomAnchor constant:moduleSpace].active = YES;
  [self.lineWidthTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.lineWidthTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.lineWidthTextField.topAnchor constraintEqualToAnchor:self.lineWidthTip.bottomAnchor constant:innerSpace].active = YES;
  [self.lineWidthTextField.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.lineWidthTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.lineWidthTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.dashLineWidthTip.topAnchor constraintEqualToAnchor:self.lineWidthTextField.bottomAnchor constant:moduleSpace].active = YES;
  [self.dashLineWidthTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.dashLineWidthTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.dashLineWidthTextField.topAnchor constraintEqualToAnchor:self.dashLineWidthTip.bottomAnchor constant:innerSpace].active = YES;
  [self.dashLineWidthTextField.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.dashLineWidthTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.dashLineWidthTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.createButton.widthAnchor constraintEqualToConstant:150].active = YES;
  [self.createButton.heightAnchor constraintEqualToConstant:44].active = YES;
  [self.createButton.centerXAnchor constraintEqualToAnchor:self.boxView.centerXAnchor].active = YES;
  [self.createButton.topAnchor constraintEqualToAnchor:self.dashLineWidthTextField.bottomAnchor constant:40].active = YES;
  [self.createButton.bottomAnchor constraintEqualToAnchor:self.boxView.bottomAnchor constant:-40].active = YES;
  
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [[IQKeyboardManager sharedManager] goNext];
  return YES;
}

#pragma mark - Lazy loading
- (UIScrollView *)scrollView {
  if (!_scrollView) {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _scrollView;
}

- (UIView *)boxView {
  if (!_boxView) {
    _boxView = [[UIView alloc] init];
    _boxView.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _boxView;
}

- (UILabel *)opacityTip {
  if (!_opacityTip) {
    _opacityTip = [[UILabel alloc] init];
    _opacityTip.translatesAutoresizingMaskIntoConstraints = NO;
    _opacityTip.text = @"Inactive Route Opacity (From 0 to 1)";
  }
  return _opacityTip;
}

- (UITextField *)opacityTextField {
  if (!_opacityTextField) {
    _opacityTextField = [[UITextField alloc] init];
    _opacityTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _opacityTextField.delegate = self;
    _opacityTextField.keyboardType = UIKeyboardTypeDefault;
    _opacityTextField.borderStyle = UITextBorderStyleRoundedRect;
    _opacityTextField.text = @"0.5";
  }
  return _opacityTextField;
}

- (UILabel *)indoorLineColorTip {
  if (!_indoorLineColorTip) {
    _indoorLineColorTip = [[UILabel alloc] init];
    _indoorLineColorTip.translatesAutoresizingMaskIntoConstraints = NO;
    _indoorLineColorTip.text = @"Indoor Route Color (HEX)";
  }
  return _indoorLineColorTip;
}

- (UITextField *)indoorLineColorTextField {
  if (!_indoorLineColorTextField) {
    _indoorLineColorTextField = [[UITextField alloc] init];
    _indoorLineColorTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _indoorLineColorTextField.delegate = self;
    _indoorLineColorTextField.text = @"F9D60D";
    _indoorLineColorTextField.placeholder = @"please enter a 6-digit hex color code";
    _indoorLineColorTextField.borderStyle = UITextBorderStyleRoundedRect;
    
  }
  return _indoorLineColorTextField;
}

- (UILabel *)outdoorLineColorTip {
  if (!_outdoorLineColorTip) {
    _outdoorLineColorTip = [[UILabel alloc] init];
    _outdoorLineColorTip.translatesAutoresizingMaskIntoConstraints = NO;
    _outdoorLineColorTip.text = @"Outdoor Route Color (HEX)";
  }
  return _outdoorLineColorTip;
}

- (UITextField *)outdoorLineColorTextField {
  if (!_outdoorLineColorTextField) {
    _outdoorLineColorTextField = [[UITextField alloc] init];
    _outdoorLineColorTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _outdoorLineColorTextField.delegate = self;
    _outdoorLineColorTextField.text = @"2181D0";
    _outdoorLineColorTextField.placeholder = @"please enter a 6-digit hex color code";
    _outdoorLineColorTextField.borderStyle = UITextBorderStyleRoundedRect;
  }
  return _outdoorLineColorTextField;
}

- (UILabel *)dashLineColorTip {
  if (!_dashLineColorTip) {
    _dashLineColorTip = [[UILabel alloc] init];
    _dashLineColorTip.translatesAutoresizingMaskIntoConstraints = NO;
    _dashLineColorTip.text = @"Dash Route Color (HEX)";
  }
  return _dashLineColorTip;
}

- (UITextField *)dashLineColorTextField {
  if (!_dashLineColorTextField) {
    _dashLineColorTextField = [[UITextField alloc] init];
    _dashLineColorTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _dashLineColorTextField.delegate = self;
    _dashLineColorTextField.text = @"000000";
    _dashLineColorTextField.placeholder = @"please enter a 6-digit hex color code";
    _dashLineColorTextField.borderStyle = UITextBorderStyleRoundedRect;
  }
  return _dashLineColorTextField;
}

- (UILabel *)lineWidthTip {
  if (!_lineWidthTip) {
    _lineWidthTip = [[UILabel alloc] init];
    _lineWidthTip.translatesAutoresizingMaskIntoConstraints = NO;
    _lineWidthTip.text = @"Route Line Width (Pixel)";
  }
  return _lineWidthTip;
}

- (UITextField *)lineWidthTextField {
  if (!_lineWidthTextField) {
    _lineWidthTextField = [[UITextField alloc] init];
    _lineWidthTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _lineWidthTextField.delegate = self;
    _lineWidthTextField.text = @"5";
    _lineWidthTextField.placeholder = @"please enter number";
    _lineWidthTextField.keyboardType = UIKeyboardTypeNumberPad;
    _lineWidthTextField.borderStyle = UITextBorderStyleRoundedRect;
  }
  return _lineWidthTextField;
}

- (UILabel *)dashLineWidthTip {
  if (!_dashLineWidthTip) {
    _dashLineWidthTip = [[UILabel alloc] init];
    _dashLineWidthTip.translatesAutoresizingMaskIntoConstraints = NO;
    _dashLineWidthTip.text = @"Dash Line Width (Pixel)";
  }
  return _dashLineWidthTip;
}

- (UITextField *)dashLineWidthTextField {
  if (!_dashLineWidthTextField) {
    _dashLineWidthTextField = [[UITextField alloc] init];
    _dashLineWidthTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _dashLineWidthTextField.delegate = self;
    _dashLineWidthTextField.text = @"5";
    _dashLineWidthTextField.placeholder = @"please enter number";
    _dashLineWidthTextField.keyboardType = UIKeyboardTypeNumberPad;
    _dashLineWidthTextField.borderStyle = UITextBorderStyleRoundedRect;
  }
  return _dashLineWidthTextField;
}

- (UIButton *)createButton {
  if (!_createButton) {
    _createButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _createButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_createButton setTitle:@"Create" forState:UIControlStateNormal];
    [_createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _createButton.backgroundColor = [UIColor colorWithRed:80/255.0 green:175/255.0 blue:243/255.0 alpha:1.0];
    [_createButton addTarget:self action:@selector(createButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _createButton.layer.cornerRadius = 5;
  }
  return _createButton;
}

@end
