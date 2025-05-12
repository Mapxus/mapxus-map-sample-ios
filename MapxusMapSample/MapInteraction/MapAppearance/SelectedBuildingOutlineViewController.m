//
//  SelectedBuildingOutlineViewController.m
//  MapxusMapSample
//
//  Created by guochenghao on 2023/6/19.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <IQKeyboardManager/IQKeyboardManager.h>
#import "SelectedBuildingOutlineViewController.h"
#import "Macro.h"

@interface SelectedBuildingOutlineViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *opacityTip;
@property (nonatomic, strong) UITextField *opacityTextField;
@property (nonatomic, strong) UILabel *colorTip;
@property (nonatomic, strong) UITextField *colorTextField;
@property (nonatomic, strong) UILabel *lineWidthTip;
@property (nonatomic, strong) UITextField *lineWidthTextField;
@property (nonatomic, strong) UILabel *lineOffsetTip;
@property (nonatomic, strong) UITextField *lineOffsetTextField;
@property (nonatomic, strong) UIButton *createButton;

@end

@implementation SelectedBuildingOutlineViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self layoutUI];
  [self addGestureRecognizer];
}

-(void)addGestureRecognizer
{
  UITapGestureRecognizer *sigleTap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                            action:@selector(handleTapGesture)];
  sigleTap.numberOfTapsRequired = 1;
  [self.view addGestureRecognizer:sigleTap];
}

-(void)handleTapGesture
{
  [self.view endEditing:YES];
}

- (void)createButtonAction {
  [self.view endEditing:YES];
  __weak typeof(self) weakSelf = self;
  [self dismissViewControllerAnimated:YES completion:^{
    if (self.delegate && [self.delegate respondsToSelector:@selector(completeParamConfiguration:)]) {
      NSMutableDictionary *params = [NSMutableDictionary dictionary];
      params[@"lineOpacity"] = weakSelf.opacityTextField.text;
      params[@"lineColor"] = weakSelf.colorTextField.text;
      params[@"lineWidth"] = weakSelf.lineWidthTextField.text;
      params[@"lineOffset"] = weakSelf.lineOffsetTextField.text;
      [self.delegate completeParamConfiguration:params];
    }
  }];
}

- (void)layoutUI {
  [self.view addSubview:self.opacityTip];
  [self.view addSubview:self.opacityTextField];
  [self.view addSubview:self.colorTip];
  [self.view addSubview:self.colorTextField];
  [self.view addSubview:self.lineWidthTip];
  [self.view addSubview:self.lineWidthTextField];
  [self.view addSubview:self.lineOffsetTip];
  [self.view addSubview:self.lineOffsetTextField];
  [self.view addSubview:self.createButton];
  
  [self.opacityTip.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:moduleSpace].active = YES;
  [self.opacityTip.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:leadingSpace].active = YES;
  [self.opacityTip.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.opacityTextField.topAnchor constraintEqualToAnchor:self.opacityTip.bottomAnchor constant:innerSpace].active = YES;
  [self.opacityTextField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:leadingSpace].active = YES;
  [self.opacityTextField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-trailingSpace].active = YES;
  [self.opacityTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.colorTip.topAnchor constraintEqualToAnchor:self.opacityTextField.bottomAnchor constant:moduleSpace].active = YES;
  [self.colorTip.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:leadingSpace].active = YES;
  [self.colorTip.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.colorTextField.topAnchor constraintEqualToAnchor:self.colorTip.bottomAnchor constant:innerSpace].active = YES;
  [self.colorTextField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:leadingSpace].active = YES;
  [self.colorTextField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-trailingSpace].active = YES;
  [self.colorTextField.heightAnchor constraintEqualToConstant:44].active = YES;

  [self.lineWidthTip.topAnchor constraintEqualToAnchor:self.colorTextField.bottomAnchor constant:moduleSpace].active = YES;
  [self.lineWidthTip.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:leadingSpace].active = YES;
  [self.lineWidthTip.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.lineWidthTextField.topAnchor constraintEqualToAnchor:self.lineWidthTip.bottomAnchor constant:innerSpace].active = YES;
  [self.lineWidthTextField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:leadingSpace].active = YES;
  [self.lineWidthTextField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-trailingSpace].active = YES;
  [self.lineWidthTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.lineOffsetTip.topAnchor constraintEqualToAnchor:self.lineWidthTextField.bottomAnchor constant:moduleSpace].active = YES;
  [self.lineOffsetTip.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:leadingSpace].active = YES;
  [self.lineOffsetTip.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.lineOffsetTextField.topAnchor constraintEqualToAnchor:self.lineOffsetTip.bottomAnchor constant:innerSpace].active = YES;
  [self.lineOffsetTextField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:leadingSpace].active = YES;
  [self.lineOffsetTextField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-trailingSpace].active = YES;
  [self.lineOffsetTextField.heightAnchor constraintEqualToConstant:44].active = YES;

  [self.createButton.widthAnchor constraintEqualToConstant:150].active = YES;
  [self.createButton.heightAnchor constraintEqualToConstant:44].active = YES;
  [self.createButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
  [self.createButton.topAnchor constraintEqualToAnchor:self.lineOffsetTextField.bottomAnchor constant:40].active = YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[IQKeyboardManager sharedManager] goNext];
    return YES;
}

#pragma mark - Lazy loading
- (UILabel *)opacityTip {
  if (!_opacityTip) {
    _opacityTip = [[UILabel alloc] init];
    _opacityTip.translatesAutoresizingMaskIntoConstraints = NO;
    _opacityTip.text = @"Opacity (from 0 to 1)";
  }
  return _opacityTip;
}

- (UITextField *)opacityTextField {
  if (!_opacityTextField) {
    _opacityTextField = [[UITextField alloc] init];
    _opacityTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _opacityTextField.borderStyle = UITextBorderStyleRoundedRect;
    _opacityTextField.text = @"1";
    _opacityTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _opacityTextField.delegate = self;
  }
  return _opacityTextField;
}

- (UILabel *)colorTip {
  if (!_colorTip) {
    _colorTip = [[UILabel alloc] init];
    _colorTip.translatesAutoresizingMaskIntoConstraints = NO;
    _colorTip.text = @"color (Hex)";
  }
  return _colorTip;
}

- (UITextField *)colorTextField {
  if (!_colorTextField) {
    _colorTextField = [[UITextField alloc] init];
    _colorTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _colorTextField.borderStyle = UITextBorderStyleRoundedRect;
    _colorTextField.text = @"F56004";
    _colorTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _colorTextField.delegate = self;
  }
  return _colorTextField;
}

- (UILabel *)lineWidthTip {
  if (!_lineWidthTip) {
    _lineWidthTip = [[UILabel alloc] init];
    _lineWidthTip.translatesAutoresizingMaskIntoConstraints = NO;
    _lineWidthTip.text = @"line width";
  }
  return _lineWidthTip;
}

- (UITextField *)lineWidthTextField {
  if (!_lineWidthTextField) {
    _lineWidthTextField = [[UITextField alloc] init];
    _lineWidthTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _lineWidthTextField.borderStyle = UITextBorderStyleRoundedRect;
    _lineWidthTextField.text = @"5";
    _lineWidthTextField.keyboardType = UIKeyboardTypeNumberPad;
    _lineWidthTextField.delegate = self;
  }
  return _lineWidthTextField;
}

- (UILabel *)lineOffsetTip {
  if (!_lineOffsetTip) {
    _lineOffsetTip = [[UILabel alloc] init];
    _lineOffsetTip.translatesAutoresizingMaskIntoConstraints = NO;
    _lineOffsetTip.text = @"line offset";
  }
  return _lineOffsetTip;
}

- (UITextField *)lineOffsetTextField {
  if (!_lineOffsetTextField) {
    _lineOffsetTextField = [[UITextField alloc] init];
    _lineOffsetTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _lineOffsetTextField.borderStyle = UITextBorderStyleRoundedRect;
    _lineOffsetTextField.text = @"-2.5";
    _lineOffsetTextField.keyboardType = UIKeyboardTypeNumberPad;
    _lineOffsetTextField.delegate = self;
  }
  return _lineOffsetTextField;
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
