//
//  SearchPOINearbyParamViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/22.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <IQKeyboardManager/IQKeyboardManager.h>
#import "SearchPOINearbyParamViewController.h"
#import <MapxusMapSDK/MXMDefine.h>
#import "Macro.h"

@interface SearchPOINearbyParamViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *boxView;

@property (nonatomic, strong) UILabel *keywordsTip;
@property (nonatomic, strong) UITextField *keywordsTextField;

@property (nonatomic, strong) UISegmentedControl *categoryTip;
@property (nonatomic, strong) UITextField *categoryTextField;
@property (nonatomic, strong) UILabel *categoryNoteTip;

@property (nonatomic, strong) UILabel *sortTip;
@property (nonatomic, strong) UISegmentedControl *sortButton;

@property (nonatomic, strong) UILabel *ordinalTip;
@property (nonatomic, strong) UITextField *ordinalTextField;

@property (nonatomic, strong) UILabel *centerTip;
@property (nonatomic, strong) UILabel *centerLatTip;
@property (nonatomic, strong) UILabel *centerLonTip;
@property (nonatomic, strong) UITextField *centerLatTextField;
@property (nonatomic, strong) UITextField *centerLonTextField;

@property (nonatomic, strong) UILabel *meterDistanceTip;
@property (nonatomic, strong) UITextField *meterDistanceTextField;

@property (nonatomic, strong) UILabel *offsetTip;
@property (nonatomic, strong) UITextField *offsetTextField;

@property (nonatomic, strong) UILabel *pageTip;
@property (nonatomic, strong) UITextField *pageTextField;

@property (nonatomic, strong) UIButton *createButton;
@end

@implementation SearchPOINearbyParamViewController

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
      params[@"keywords"] = weakSelf.keywordsTextField.text;
      params[@"latitude"] = weakSelf.centerLatTextField.text;
      params[@"longitude"] = weakSelf.centerLonTextField.text;
      params[@"meterDistance"] = weakSelf.meterDistanceTextField.text;
      params[@"offset"] = weakSelf.offsetTextField.text;
      params[@"page"] = weakSelf.pageTextField.text;
      
      switch (weakSelf.categoryTip.selectedSegmentIndex) {
        case 0:
          params[@"category"] = weakSelf.categoryTextField.text.length ? weakSelf.categoryTextField.text : nil;
          break;
        case 1:
        {
          NSArray *list = weakSelf.categoryTextField.text.length ? [weakSelf.categoryTextField.text componentsSeparatedByString:@","] : nil;
          params[@"excludeCategories"] = list;
        }
          break;
        default:
          break;
      }
      
      switch (self.sortButton.selectedSegmentIndex) {
        case 0:
        {
          params[@"sort"] = @(MXMSortType_ActualDistance);
          params[@"ordinal"] = weakSelf.ordinalTextField.text;
        }
          break;
        case 1:
          params[@"sort"] = @(MXMSortType_AbsoluteDistance);
          break;
        default:
          break;
      }
      [self.delegate completeParamConfiguration:params];
    }
  }];
}

- (void)changeCategoryType:(UISegmentedControl *)sender {
  switch (sender.selectedSegmentIndex) {
    case 0:
    {
      self.categoryTextField.text = @"";
      self.categoryNoteTip.text = @"Note: Please provide a single category identifier.";
    }
      break;
    case 1:
    {
      self.categoryTextField.text = @"";
      self.categoryNoteTip.text = @"Note: Multiple category identifiers can be entered, separated by half-character commas.";
    }
      break;
    default:
      break;
  }
}

- (void)changeSortType:(UISegmentedControl *)sender {
  switch (sender.selectedSegmentIndex) {
    case 0:
    {
      self.ordinalTip.textColor = nil;
      self.ordinalTextField.textColor = nil;
      self.ordinalTextField.enabled = YES;
    }
      break;
    case 1:
    case 2:
    {
      self.ordinalTip.textColor = [UIColor lightGrayColor];
      self.ordinalTextField.textColor = [UIColor lightGrayColor];
      self.ordinalTextField.enabled = NO;
    }
      break;
    default:
      break;
  }
}

- (void)layoutUI {
  [self.view addSubview:self.scrollView];
  [self.scrollView addSubview:self.boxView];
  [self.boxView addSubview:self.keywordsTip];
  [self.boxView addSubview:self.keywordsTextField];
  [self.boxView addSubview:self.categoryTip];
  [self.boxView addSubview:self.categoryTextField];
  [self.boxView addSubview:self.categoryNoteTip];
  [self.boxView addSubview:self.sortTip];
  [self.boxView addSubview:self.sortButton];
  [self.boxView addSubview:self.ordinalTip];
  [self.boxView addSubview:self.ordinalTextField];
  [self.boxView addSubview:self.centerTip];
  [self.boxView addSubview:self.centerLatTip];
  [self.boxView addSubview:self.centerLonTip];
  [self.boxView addSubview:self.centerLatTextField];
  [self.boxView addSubview:self.centerLonTextField];
  [self.boxView addSubview:self.meterDistanceTip];
  [self.boxView addSubview:self.meterDistanceTextField];
  [self.boxView addSubview:self.offsetTip];
  [self.boxView addSubview:self.offsetTextField];
  [self.boxView addSubview:self.pageTip];
  [self.boxView addSubview:self.pageTextField];
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
  
  [self.categoryTip.topAnchor constraintEqualToAnchor:self.keywordsTextField.bottomAnchor constant:moduleSpace].active = YES;
  [self.categoryTip.centerXAnchor constraintEqualToAnchor:self.boxView.centerXAnchor].active = YES;
  [self.categoryTip.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.categoryTextField.topAnchor constraintEqualToAnchor:self.categoryTip.bottomAnchor constant:innerSpace].active = YES;
  [self.categoryTextField.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.categoryTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.categoryTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.categoryNoteTip.topAnchor constraintEqualToAnchor:self.categoryTextField.bottomAnchor constant:innerSpace].active = YES;
  [self.categoryNoteTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.categoryNoteTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.sortTip.topAnchor constraintEqualToAnchor:self.categoryNoteTip.bottomAnchor constant:moduleSpace].active = YES;
  [self.sortTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.sortTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.sortButton.topAnchor constraintEqualToAnchor:self.sortTip.bottomAnchor constant:innerSpace].active = YES;
  [self.sortButton.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.sortButton.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.sortButton.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.ordinalTip.topAnchor constraintEqualToAnchor:self.sortButton.bottomAnchor constant:moduleSpace].active = YES;
  [self.ordinalTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.ordinalTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.ordinalTextField.topAnchor constraintEqualToAnchor:self.ordinalTip.bottomAnchor constant:innerSpace].active = YES;
  [self.ordinalTextField.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.ordinalTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.ordinalTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.centerTip.topAnchor constraintEqualToAnchor:self.ordinalTextField.bottomAnchor constant:moduleSpace].active = YES;
  [self.centerTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.centerTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.centerLatTip.topAnchor constraintEqualToAnchor:self.centerTip.bottomAnchor constant:innerSpace].active = YES;
  [self.centerLatTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.centerLatTip.widthAnchor constraintEqualToConstant:100].active = YES;
  [self.centerLatTip.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.centerLatTextField.topAnchor constraintEqualToAnchor:self.centerLatTip.topAnchor].active = YES;
  [self.centerLatTextField.leadingAnchor constraintEqualToAnchor:self.centerLatTip.trailingAnchor constant:5].active = YES;
  [self.centerLatTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.centerLatTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.centerLonTip.topAnchor constraintEqualToAnchor:self.centerLatTip.bottomAnchor constant:innerSpace].active = YES;
  [self.centerLonTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.centerLonTip.widthAnchor constraintEqualToConstant:100].active = YES;
  [self.centerLonTip.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.centerLonTextField.topAnchor constraintEqualToAnchor:self.centerLonTip.topAnchor].active = YES;
  [self.centerLonTextField.leadingAnchor constraintEqualToAnchor:self.centerLonTip.trailingAnchor constant:5].active = YES;
  [self.centerLonTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.centerLonTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.meterDistanceTip.topAnchor constraintEqualToAnchor:self.centerLonTextField.bottomAnchor constant:moduleSpace].active = YES;
  [self.meterDistanceTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.meterDistanceTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.meterDistanceTextField.topAnchor constraintEqualToAnchor:self.meterDistanceTip.bottomAnchor constant:innerSpace].active = YES;
  [self.meterDistanceTextField.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.meterDistanceTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.meterDistanceTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.offsetTip.topAnchor constraintEqualToAnchor:self.meterDistanceTextField.bottomAnchor constant:moduleSpace].active = YES;
  [self.offsetTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.offsetTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.offsetTextField.topAnchor constraintEqualToAnchor:self.offsetTip.bottomAnchor constant:innerSpace].active = YES;
  [self.offsetTextField.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.offsetTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.offsetTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.pageTip.topAnchor constraintEqualToAnchor:self.offsetTextField.bottomAnchor constant:moduleSpace].active = YES;
  [self.pageTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.pageTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  
  [self.pageTextField.topAnchor constraintEqualToAnchor:self.pageTip.bottomAnchor constant:innerSpace].active = YES;
  [self.pageTextField.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
  [self.pageTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
  [self.pageTextField.heightAnchor constraintEqualToConstant:44].active = YES;
  
  [self.createButton.widthAnchor constraintEqualToConstant:150].active = YES;
  [self.createButton.heightAnchor constraintEqualToConstant:44].active = YES;
  [self.createButton.centerXAnchor constraintEqualToAnchor:self.boxView.centerXAnchor].active = YES;
  [self.createButton.topAnchor constraintEqualToAnchor:self.pageTextField.bottomAnchor constant:40].active = YES;
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
    _keywordsTip.text = @"keywords";
  }
  return _keywordsTip;
}

- (UILabel *)centerTip {
  if (!_centerTip) {
    _centerTip = [[UILabel alloc] init];
    _centerTip.translatesAutoresizingMaskIntoConstraints = NO;
    _centerTip.text = @"center";
  }
  return _centerTip;
}

- (UILabel *)centerLatTip {
  if (!_centerLatTip) {
    _centerLatTip = [[UILabel alloc] init];
    _centerLatTip.translatesAutoresizingMaskIntoConstraints = NO;
    _centerLatTip.text = @"latitude";
  }
  return _centerLatTip;
}

- (UILabel *)centerLonTip {
  if (!_centerLonTip) {
    _centerLonTip = [[UILabel alloc] init];
    _centerLonTip.translatesAutoresizingMaskIntoConstraints = NO;
    _centerLonTip.text = @"longitude";
  }
  return _centerLonTip;
}

- (UILabel *)ordinalTip {
  if (!_ordinalTip) {
    _ordinalTip = [[UILabel alloc] init];
    _ordinalTip.translatesAutoresizingMaskIntoConstraints = NO;
    _ordinalTip.text = @"ordinal";
  }
  return _ordinalTip;
}

- (UILabel *)sortTip {
  if (!_sortTip) {
    _sortTip = [[UILabel alloc] init];
    _sortTip.translatesAutoresizingMaskIntoConstraints = NO;
    _sortTip.text = @"sort";
  }
  return _sortTip;
}

- (UISegmentedControl *)categoryTip {
  if (!_categoryTip) {
    _categoryTip = [[UISegmentedControl alloc] initWithItems:@[@"category", @"excludeCategories"]];
    _categoryTip.translatesAutoresizingMaskIntoConstraints = NO;
    _categoryTip.selectedSegmentIndex = 0;
    [_categoryTip addTarget:self action:@selector(changeCategoryType:) forControlEvents:UIControlEventValueChanged];
  }
  return _categoryTip;
}

- (UILabel *)categoryNoteTip {
  if (!_categoryNoteTip) {
    _categoryNoteTip = [[UILabel alloc] init];
    _categoryNoteTip.translatesAutoresizingMaskIntoConstraints = NO;
    _categoryNoteTip.font = [UIFont systemFontOfSize:12];
    _categoryNoteTip.textColor = [UIColor grayColor];
    _categoryNoteTip.numberOfLines = 0;
    _categoryNoteTip.text = @"Note: Please provide a single category identifier.";
  }
  return _categoryNoteTip;
}

- (UILabel *)meterDistanceTip {
  if (!_meterDistanceTip) {
    _meterDistanceTip = [[UILabel alloc] init];
    _meterDistanceTip.translatesAutoresizingMaskIntoConstraints = NO;
    _meterDistanceTip.text = @"meterDistance(≤ 10000)";
  }
  return _meterDistanceTip;
}

- (UILabel *)offsetTip {
  if (!_offsetTip) {
    _offsetTip = [[UILabel alloc] init];
    _offsetTip.translatesAutoresizingMaskIntoConstraints = NO;
    _offsetTip.text = @"offset (≤ 100)";
  }
  return _offsetTip;
}

- (UILabel *)pageTip {
  if (!_pageTip) {
    _pageTip = [[UILabel alloc] init];
    _pageTip.translatesAutoresizingMaskIntoConstraints = NO;
    _pageTip.text = @"page";
  }
  return _pageTip;
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

- (UITextField *)centerLatTextField {
  if (!_centerLatTextField) {
    _centerLatTextField = [[UITextField alloc] init];
    _centerLatTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _centerLatTextField.text = PARAMCONFIGINFO.search_nearby.latitude;
    _centerLatTextField.placeholder = @"please enter number";
    _centerLatTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _centerLatTextField.borderStyle = UITextBorderStyleRoundedRect;
    _centerLatTextField.delegate = self;
  }
  return _centerLatTextField;
}

- (UITextField *)centerLonTextField {
  if (!_centerLonTextField) {
    _centerLonTextField = [[UITextField alloc] init];
    _centerLonTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _centerLonTextField.text = PARAMCONFIGINFO.search_nearby.longitude;
    _centerLonTextField.placeholder = @"please enter number";
    _centerLonTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _centerLonTextField.borderStyle = UITextBorderStyleRoundedRect;
    _centerLonTextField.delegate = self;
  }
  return _centerLonTextField;
}

- (UITextField *)ordinalTextField {
  if (!_ordinalTextField) {
    _ordinalTextField = [[UITextField alloc] init];
    _ordinalTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _ordinalTextField.text = @"0";
    _ordinalTextField.placeholder = @"please enter number";
    _ordinalTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _ordinalTextField.borderStyle = UITextBorderStyleRoundedRect;
    _ordinalTextField.delegate = self;
  }
  return _ordinalTextField;
}

- (UISegmentedControl *)sortButton {
  if (!_sortButton) {
    _sortButton = [[UISegmentedControl alloc] initWithItems:@[@"ActualDistance", @"AbsoluteDistance"]];
    _sortButton.translatesAutoresizingMaskIntoConstraints = NO;
    _sortButton.selectedSegmentIndex = 0;
    [_sortButton addTarget:self action:@selector(changeSortType:) forControlEvents:UIControlEventValueChanged];
  }
  return _sortButton;
}

- (UITextField *)categoryTextField {
  if (!_categoryTextField) {
    _categoryTextField = [[UITextField alloc] init];
    _categoryTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _categoryTextField.delegate = self;
    _categoryTextField.keyboardType = UIKeyboardTypeDefault;
    _categoryTextField.borderStyle = UITextBorderStyleRoundedRect;
  }
  return _categoryTextField;
}

- (UITextField *)meterDistanceTextField {
  if (!_meterDistanceTextField) {
    _meterDistanceTextField = [[UITextField alloc] init];
    _meterDistanceTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _meterDistanceTextField.text = @"10";
    _meterDistanceTextField.placeholder = @"please enter number";
    _meterDistanceTextField.keyboardType = UIKeyboardTypeNumberPad;
    _meterDistanceTextField.borderStyle = UITextBorderStyleRoundedRect;
    _meterDistanceTextField.delegate = self;
  }
  return _meterDistanceTextField;
}

- (UITextField *)offsetTextField {
  if (!_offsetTextField) {
    _offsetTextField = [[UITextField alloc] init];
    _offsetTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _offsetTextField.delegate = self;
    _offsetTextField.text = @"10";
    _offsetTextField.placeholder = @"please enter number";
    _offsetTextField.keyboardType = UIKeyboardTypeNumberPad;
    _offsetTextField.borderStyle = UITextBorderStyleRoundedRect;
    
  }
  return _offsetTextField;
}

- (UITextField *)pageTextField {
  if (!_pageTextField) {
    _pageTextField = [[UITextField alloc] init];
    _pageTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _pageTextField.delegate = self;
    _pageTextField.text = @"1";
    _pageTextField.placeholder = @"please enter number";
    _pageTextField.keyboardType = UIKeyboardTypeNumberPad;
    _pageTextField.borderStyle = UITextBorderStyleRoundedRect;
  }
  return _pageTextField;
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
