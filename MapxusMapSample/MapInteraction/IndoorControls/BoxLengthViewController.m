//
//  BoxLengthViewController.m
//  MapxusMapSample
//
//  Created by guochenghao on 2023/6/19.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <IQKeyboardManager/IQKeyboardManager.h>
#import "BoxLengthViewController.h"
#import "Macro.h"

@interface BoxLengthViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *maxTip;
@property (nonatomic, strong) UITextField *maxTextField;
@property (nonatomic, strong) UIButton *createButton;

@end

@implementation BoxLengthViewController

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
          params[@"maxLength"] = weakSelf.maxTextField.text;
          [self.delegate completeParamConfiguration:params];
      }
  }];
}

- (void)layoutUI {
  [self.view addSubview:self.maxTip];
  [self.view addSubview:self.maxTextField];
  [self.view addSubview:self.createButton];
    
  [self.maxTip.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:moduleSpace].active = YES;
  [self.maxTip.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:leadingSpace].active = YES;
  [self.maxTip.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.maxTextField.topAnchor constraintEqualToAnchor:self.maxTip.bottomAnchor constant:innerSpace].active = YES;
  [self.maxTextField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:leadingSpace].active = YES;
  [self.maxTextField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-trailingSpace].active = YES;
  [self.maxTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.createButton.widthAnchor constraintEqualToConstant:150].active = YES;
  [self.createButton.heightAnchor constraintEqualToConstant:44].active = YES;
  [self.createButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
  [self.createButton.topAnchor constraintEqualToAnchor:self.maxTextField.bottomAnchor constant:40].active = YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self.view endEditing:YES];
  return YES;
}

- (UILabel *)maxTip {
  if (!_maxTip) {
    _maxTip = [[UILabel alloc] init];
    _maxTip.translatesAutoresizingMaskIntoConstraints = NO;
    _maxTip.text = @"Maximum number of visible floors";
  }
  return _maxTip;
}

- (UITextField *)maxTextField {
  if (!_maxTextField) {
    _maxTextField = [[UITextField alloc] init];
    _maxTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _maxTextField.borderStyle = UITextBorderStyleRoundedRect;
    _maxTextField.text = @"5";
    _maxTextField.keyboardType = UIKeyboardTypeNumberPad;
    _maxTextField.delegate = self;
  }
  return _maxTextField;
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
