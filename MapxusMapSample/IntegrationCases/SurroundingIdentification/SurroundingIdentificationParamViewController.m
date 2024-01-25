//
//  SurroundingIdentificationParamViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/22.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <IQKeyboardManager/IQKeyboardManager.h>
#import "SurroundingIdentificationParamViewController.h"
#import "Macro.h"

@interface SurroundingIdentificationParamViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *locationTip;
@property (nonatomic, strong) UILabel *latTip;
@property (nonatomic, strong) UILabel *lonTip;
@property (nonatomic, strong) UILabel *ordinalTip;
@property (nonatomic, strong) UILabel *distanceTip;
@property (nonatomic, strong) UILabel *searchTypeTip;
@property (nonatomic, strong) UITextField *latTextField;
@property (nonatomic, strong) UITextField *lonTextField;
@property (nonatomic, strong) UITextField *ordinalTextField;
@property (nonatomic, strong) UITextField *distanceTextField;
@property (nonatomic, strong) UISegmentedControl *searchTypeButton;
@property (nonatomic, strong) UILabel *searchScopeTip;
@property (nonatomic, strong) UISegmentedControl *searchScopeControl;
@property (nonatomic, strong) UIButton *createButton;
@end

@implementation SurroundingIdentificationParamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];
}

- (void)createButtonAction {
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(completeParamConfiguration:)]) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"latitude"] = weakSelf.latTextField.text;
            params[@"longitude"] = weakSelf.lonTextField.text;
            params[@"ordinal"] = weakSelf.ordinalTextField.text;
            params[@"distance"] = weakSelf.distanceTextField.text;
          switch (weakSelf.searchTypeButton.selectedSegmentIndex) {
            case 0:
            {
              params[@"distanceSearchType"] = @"Polygon";
            }
              break;
            case 1:
            {
              params[@"distanceSearchType"] = @"Point";
            }
              break;
            case 2:
            {
              params[@"distanceSearchType"] = @"Gate";
            }
              break;
            default:
              break;
          }

          switch (weakSelf.searchScopeControl.selectedSegmentIndex) {
            case 1:
              params[@"searchScope"] = @"buildingId";
              break;
            case 2:
              params[@"searchScope"] = @"floorOrdinal";
              break;
            case 0:
            default:
              params[@"searchScope"] = @"floorId";
              break;
          }
            [self.delegate completeParamConfiguration:params];
        }
    }];
}

- (void)layoutUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.boxView];
    [self.boxView addSubview:self.locationTip];
    [self.boxView addSubview:self.latTip];
    [self.boxView addSubview:self.latTextField];
    [self.boxView addSubview:self.lonTip];
    [self.boxView addSubview:self.lonTextField];
    [self.boxView addSubview:self.ordinalTip];
    [self.boxView addSubview:self.ordinalTextField];
    [self.boxView addSubview:self.distanceTip];
    [self.boxView addSubview:self.distanceTextField];
    [self.boxView addSubview:self.searchTypeTip];
    [self.boxView addSubview:self.searchTypeButton];
    [self.boxView addSubview:self.searchScopeTip];
    [self.boxView addSubview:self.searchScopeControl];
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
    
    [self.locationTip.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:moduleSpace].active = YES;
    [self.locationTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.locationTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    
    [self.latTip.topAnchor constraintEqualToAnchor:self.locationTip.bottomAnchor constant:innerSpace].active = YES;
    [self.latTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.latTip.widthAnchor constraintEqualToConstant:100].active = YES;
    [self.latTip.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.latTextField.topAnchor constraintEqualToAnchor:self.latTip.topAnchor].active = YES;
    [self.latTextField.leadingAnchor constraintEqualToAnchor:self.latTip.trailingAnchor constant:5].active = YES;
    [self.latTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    [self.latTextField.heightAnchor constraintEqualToConstant:44].active = YES;

    [self.lonTip.topAnchor constraintEqualToAnchor:self.latTip.bottomAnchor constant:innerSpace].active = YES;
    [self.lonTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.lonTip.widthAnchor constraintEqualToConstant:100].active = YES;
    [self.lonTip.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.lonTextField.topAnchor constraintEqualToAnchor:self.lonTip.topAnchor].active = YES;
    [self.lonTextField.leadingAnchor constraintEqualToAnchor:self.lonTip.trailingAnchor constant:5].active = YES;
    [self.lonTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    [self.lonTextField.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.ordinalTip.topAnchor constraintEqualToAnchor:self.lonTip.bottomAnchor constant:innerSpace].active = YES;
    [self.ordinalTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.ordinalTip.widthAnchor constraintEqualToConstant:100].active = YES;
    [self.ordinalTip.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.ordinalTextField.topAnchor constraintEqualToAnchor:self.ordinalTip.topAnchor].active = YES;
    [self.ordinalTextField.leadingAnchor constraintEqualToAnchor:self.ordinalTip.trailingAnchor constant:5].active = YES;
    [self.ordinalTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    [self.ordinalTextField.heightAnchor constraintEqualToConstant:44].active = YES;

    [self.distanceTip.topAnchor constraintEqualToAnchor:self.ordinalTip.bottomAnchor constant:moduleSpace].active = YES;
    [self.distanceTip.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:leadingSpace].active = YES;
    [self.distanceTip.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-trailingSpace].active = YES;
    
    [self.distanceTextField.topAnchor constraintEqualToAnchor:self.distanceTip.bottomAnchor constant:innerSpace].active = YES;
    [self.distanceTextField.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.distanceTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    [self.distanceTextField.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.searchTypeTip.topAnchor constraintEqualToAnchor:self.distanceTextField.bottomAnchor constant:moduleSpace].active = YES;
    [self.searchTypeTip.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:leadingSpace].active = YES;
    [self.searchTypeTip.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-trailingSpace].active = YES;
    
    [self.searchTypeButton.topAnchor constraintEqualToAnchor:self.searchTypeTip.bottomAnchor constant:innerSpace].active = YES;
    [self.searchTypeButton.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.searchTypeButton.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    [self.searchTypeButton.heightAnchor constraintEqualToConstant:44].active = YES;
  
    [self.searchScopeTip.topAnchor constraintEqualToAnchor:self.searchTypeButton.bottomAnchor constant:moduleSpace].active = YES;
    [self.searchScopeTip.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:leadingSpace].active = YES;
    [self.searchScopeTip.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-trailingSpace].active = YES;
  
    [self.searchScopeControl.topAnchor constraintEqualToAnchor:self.searchScopeTip.bottomAnchor constant:innerSpace].active = YES;
    [self.searchScopeControl.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.searchScopeControl.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    [self.searchScopeControl.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.createButton.widthAnchor constraintEqualToConstant:150].active = YES;
    [self.createButton.heightAnchor constraintEqualToConstant:44].active = YES;
    [self.createButton.centerXAnchor constraintEqualToAnchor:self.boxView.centerXAnchor].active = YES;
    [self.createButton.topAnchor constraintEqualToAnchor:self.searchScopeControl.bottomAnchor constant:40].active = YES;
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

- (UILabel *)locationTip {
    if (!_locationTip) {
        _locationTip = [[UILabel alloc] init];
        _locationTip.translatesAutoresizingMaskIntoConstraints = NO;
        _locationTip.text = @"location";
    }
    return _locationTip;
}

- (UILabel *)latTip {
    if (!_latTip) {
        _latTip = [[UILabel alloc] init];
        _latTip.translatesAutoresizingMaskIntoConstraints = NO;
        _latTip.text = @"latitude";
    }
    return _latTip;
}

- (UILabel *)lonTip {
    if (!_lonTip) {
        _lonTip = [[UILabel alloc] init];
        _lonTip.translatesAutoresizingMaskIntoConstraints = NO;
        _lonTip.text = @"longitude";
    }
    return _lonTip;
}

- (UILabel *)ordinalTip {
    if (!_ordinalTip) {
        _ordinalTip = [[UILabel alloc] init];
        _ordinalTip.translatesAutoresizingMaskIntoConstraints = NO;
        _ordinalTip.text = @"ordinal";
    }
    return _ordinalTip;
}

- (UILabel *)distanceTip {
    if (!_distanceTip) {
        _distanceTip = [[UILabel alloc] init];
        _distanceTip.translatesAutoresizingMaskIntoConstraints = NO;
        _distanceTip.text = @"distance(≤ 100)";
    }
    return _distanceTip;
}

- (UILabel *)searchTypeTip {
    if (!_searchTypeTip) {
        _searchTypeTip = [[UILabel alloc] init];
        _searchTypeTip.translatesAutoresizingMaskIntoConstraints = NO;
        _searchTypeTip.text = @"distanceSearchType";
    }
    return _searchTypeTip;
}

- (UITextField *)latTextField {
    if (!_latTextField) {
        _latTextField = [[UITextField alloc] init];
        _latTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _latTextField.text = PARAMCONFIGINFO.search_nearby.latitude;
        _latTextField.placeholder = @"please enter number";
        _latTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _latTextField.borderStyle = UITextBorderStyleRoundedRect;
        _latTextField.delegate = self;
    }
    return _latTextField;
}

- (UITextField *)lonTextField {
    if (!_lonTextField) {
        _lonTextField = [[UITextField alloc] init];
        _lonTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _lonTextField.text = PARAMCONFIGINFO.search_nearby.longitude;
        _lonTextField.placeholder = @"please enter number";
        _lonTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _lonTextField.borderStyle = UITextBorderStyleRoundedRect;
        _lonTextField.delegate = self;
    }
    return _lonTextField;
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

- (UITextField *)distanceTextField {
    if (!_distanceTextField) {
        _distanceTextField = [[UITextField alloc] init];
        _distanceTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _distanceTextField.text = @"30";
        _distanceTextField.placeholder = @"please enter number";
        _distanceTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _distanceTextField.borderStyle = UITextBorderStyleRoundedRect;
        _distanceTextField.delegate = self;
    }
    return _distanceTextField;
}

- (UISegmentedControl *)searchTypeButton {
  if (!_searchTypeButton) {
    _searchTypeButton = [[UISegmentedControl alloc] initWithItems:@[@"Polygon", @"Point", @"Gate"]];
    _searchTypeButton.translatesAutoresizingMaskIntoConstraints = NO;
    _searchTypeButton.selectedSegmentIndex = 0;
  }
  return _searchTypeButton;
}

- (UILabel *)searchScopeTip {
    if (!_searchScopeTip) {
      _searchScopeTip = [[UILabel alloc] init];
      _searchScopeTip.translatesAutoresizingMaskIntoConstraints = NO;
      _searchScopeTip.text = @"search scope";
    }
    return _searchScopeTip;
}

- (UISegmentedControl *)searchScopeControl {
  if (!_searchScopeControl) {
    _searchScopeControl = [[UISegmentedControl alloc] initWithItems:@[@"floorId", @"buildingId", @"floorOrdinal"]];
    _searchScopeControl.translatesAutoresizingMaskIntoConstraints = NO;
    _searchScopeControl.selectedSegmentIndex = 0;
  }
  return _searchScopeControl;
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
