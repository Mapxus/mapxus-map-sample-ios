//
//  SearchCategoryInBoundParamViewController.m
//  MapxusMapSample
//
//  Created by guochenghao on 2024/9/4.
//  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <IQKeyboardManager/IQKeyboardManager.h>
#import "SearchCategoryInBoundParamViewController.h"
#import "Macro.h"

@interface SearchCategoryInBoundParamViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *keywordsTip;
@property (nonatomic, strong) UITextField *keywordsTextField;
@property (nonatomic, strong) UILabel *bboxTip;
@property (nonatomic, strong) UILabel *minLatTip;
@property (nonatomic, strong) UILabel *minLonTip;
@property (nonatomic, strong) UILabel *maxLatTip;
@property (nonatomic, strong) UILabel *maxLonTip;
@property (nonatomic, strong) UITextField *minLatTextField;
@property (nonatomic, strong) UITextField *minLonTextField;
@property (nonatomic, strong) UITextField *maxLatTextField;
@property (nonatomic, strong) UITextField *maxLonTextField;
@property (nonatomic, strong) UIButton *createButton;
@end

@implementation SearchCategoryInBoundParamViewController

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
      params[@"keyword"] = weakSelf.keywordsTextField.text;
      params[@"min_latitude"] = weakSelf.minLatTextField.text;
      params[@"min_longitude"] = weakSelf.minLonTextField.text;
      params[@"max_latitude"] = weakSelf.maxLatTextField.text;
      params[@"max_longitude"] = weakSelf.maxLonTextField.text;
      [self.delegate completeParamConfiguration:params];
    }
  }];
}

- (void)layoutUI {
  [self.view addSubview:self.scrollView];
  [self.scrollView addSubview:self.boxView];
  [self.boxView addSubview:self.keywordsTip];
  [self.boxView addSubview:self.keywordsTextField];
  [self.boxView addSubview:self.bboxTip];
  [self.boxView addSubview:self.minLatTip];
  [self.boxView addSubview:self.minLonTip];
  [self.boxView addSubview:self.maxLatTip];
  [self.boxView addSubview:self.maxLonTip];
  [self.boxView addSubview:self.minLatTextField];
  [self.boxView addSubview:self.minLonTextField];
  [self.boxView addSubview:self.maxLatTextField];
  [self.boxView addSubview:self.maxLonTextField];
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
  
  [self.keywordsTip.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:moduleSpace].active = YES;
  [self.keywordsTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.keywordsTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.keywordsTextField.topAnchor constraintEqualToAnchor:self.keywordsTip.bottomAnchor constant:innerSpace].active = YES;
  [self.keywordsTextField.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.keywordsTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.keywordsTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.bboxTip.topAnchor constraintEqualToAnchor:self.keywordsTextField.bottomAnchor constant:moduleSpace].active = YES;
  [self.bboxTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.bboxTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.minLatTip.topAnchor constraintEqualToAnchor:self.bboxTip.bottomAnchor constant:innerSpace].active = YES;
  [self.minLatTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.minLatTip.widthAnchor constraintEqualToConstant:150].active = YES;
  [self.minLatTip.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.minLatTextField.topAnchor constraintEqualToAnchor:self.minLatTip.topAnchor].active = YES;
  [self.minLatTextField.leadingAnchor constraintEqualToAnchor:self.minLatTip.trailingAnchor constant:5].active = YES;
  [self.minLatTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.minLatTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.minLonTip.topAnchor constraintEqualToAnchor:self.minLatTip.bottomAnchor constant:innerSpace].active = YES;
  [self.minLonTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.minLonTip.widthAnchor constraintEqualToConstant:150].active = YES;
  [self.minLonTip.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.minLonTextField.topAnchor constraintEqualToAnchor:self.minLonTip.topAnchor].active = YES;
  [self.minLonTextField.leadingAnchor constraintEqualToAnchor:self.minLonTip.trailingAnchor constant:5].active = YES;
  [self.minLonTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.minLonTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.maxLatTip.topAnchor constraintEqualToAnchor:self.minLonTip.bottomAnchor constant:innerSpace].active = YES;
  [self.maxLatTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.maxLatTip.widthAnchor constraintEqualToConstant:150].active = YES;
  [self.maxLatTip.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.maxLatTextField.topAnchor constraintEqualToAnchor:self.maxLatTip.topAnchor].active = YES;
  [self.maxLatTextField.leadingAnchor constraintEqualToAnchor:self.maxLatTip.trailingAnchor constant:5].active = YES;
  [self.maxLatTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.maxLatTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.maxLonTip.topAnchor constraintEqualToAnchor:self.maxLatTip.bottomAnchor constant:innerSpace].active = YES;
  [self.maxLonTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.maxLonTip.widthAnchor constraintEqualToConstant:150].active = YES;
  [self.maxLonTip.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.maxLonTextField.topAnchor constraintEqualToAnchor:self.maxLonTip.topAnchor].active = YES;
  [self.maxLonTextField.leadingAnchor constraintEqualToAnchor:self.maxLonTip.trailingAnchor constant:5].active = YES;
  [self.maxLonTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.maxLonTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.createButton.widthAnchor constraintEqualToConstant:150].active = YES;
  [self.createButton.heightAnchor constraintEqualToConstant:44].active = YES;
  [self.createButton.centerXAnchor constraintEqualToAnchor:self.boxView.centerXAnchor].active = YES;
  [self.createButton.topAnchor constraintEqualToAnchor:self.maxLonTextField.bottomAnchor constant:40].active = YES;
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

- (UILabel *)keywordsTip {
  if (!_keywordsTip) {
    _keywordsTip = [[UILabel alloc] init];
    _keywordsTip.translatesAutoresizingMaskIntoConstraints = NO;
    _keywordsTip.text = @"keyword";
  }
  return _keywordsTip;
}

- (UITextField *)keywordsTextField {
  if (!_keywordsTextField) {
    _keywordsTextField = [[UITextField alloc] init];
    _keywordsTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _keywordsTextField.delegate = self;
    _keywordsTextField.keyboardType = UIKeyboardTypeDefault;
    _keywordsTextField.borderStyle = UITextBorderStyleRoundedRect;
  }
  return _keywordsTextField;
}

- (UILabel *)bboxTip {
  if (!_bboxTip) {
    _bboxTip = [[UILabel alloc] init];
    _bboxTip.translatesAutoresizingMaskIntoConstraints = NO;
    _bboxTip.text = @"bbox";
  }
  return _bboxTip;
}

- (UILabel *)minLatTip {
  if (!_minLatTip) {
    _minLatTip = [[UILabel alloc] init];
    _minLatTip.translatesAutoresizingMaskIntoConstraints = NO;
    _minLatTip.text = @"min_latitude";
  }
  return _minLatTip;
}

- (UILabel *)minLonTip {
  if (!_minLonTip) {
    _minLonTip = [[UILabel alloc] init];
    _minLonTip.translatesAutoresizingMaskIntoConstraints = NO;
    _minLonTip.text = @"min_longitude";
  }
  return _minLonTip;
}

- (UILabel *)maxLatTip {
  if (!_maxLatTip) {
    _maxLatTip = [[UILabel alloc] init];
    _maxLatTip.translatesAutoresizingMaskIntoConstraints = NO;
    _maxLatTip.text = @"max_latitude";
  }
  return _maxLatTip;
}

- (UILabel *)maxLonTip {
  if (!_maxLonTip) {
    _maxLonTip = [[UILabel alloc] init];
    _maxLonTip.translatesAutoresizingMaskIntoConstraints = NO;
    _maxLonTip.text = @"max_longitude";
  }
  return _maxLonTip;
}

- (UITextField *)minLatTextField {
  if (!_minLatTextField) {
    _minLatTextField = [[UITextField alloc] init];
    _minLatTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _minLatTextField.text = PARAMCONFIGINFO.specified_area.min_latitude;
    _minLatTextField.placeholder = @"please enter number";
    _minLatTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _minLatTextField.borderStyle = UITextBorderStyleRoundedRect;
    _minLatTextField.delegate = self;
  }
  return _minLatTextField;
}

- (UITextField *)minLonTextField {
  if (!_minLonTextField) {
    _minLonTextField = [[UITextField alloc] init];
    _minLonTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _minLonTextField.text = PARAMCONFIGINFO.specified_area.min_longitude;
    _minLonTextField.placeholder = @"please enter number";
    _minLonTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _minLonTextField.borderStyle = UITextBorderStyleRoundedRect;
    _minLonTextField.delegate = self;
  }
  return _minLonTextField;
}

- (UITextField *)maxLatTextField {
  if (!_maxLatTextField) {
    _maxLatTextField = [[UITextField alloc] init];
    _maxLatTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _maxLatTextField.text = PARAMCONFIGINFO.specified_area.max_latitude;
    _maxLatTextField.placeholder = @"please enter number";
    _maxLatTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _maxLatTextField.borderStyle = UITextBorderStyleRoundedRect;
    _maxLatTextField.delegate = self;
  }
  return _maxLatTextField;
}

- (UITextField *)maxLonTextField {
  if (!_maxLonTextField) {
    _maxLonTextField = [[UITextField alloc] init];
    _maxLonTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _maxLonTextField.text = PARAMCONFIGINFO.specified_area.max_longitude;
    _maxLonTextField.placeholder = @"please enter number";
    _maxLonTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _maxLonTextField.borderStyle = UITextBorderStyleRoundedRect;
    _maxLonTextField.delegate = self;
  }
  return _maxLonTextField;
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
