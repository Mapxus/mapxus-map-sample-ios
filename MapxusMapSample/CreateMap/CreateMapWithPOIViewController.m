//
//  CreateMapWithPOIViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/16.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "CreateMapWithPOIViewController.h"
#import "CreateMapWithPOIResultViewController.h"
#import "Macro.h"

@interface CreateMapWithPOIViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *POITip;
@property (nonatomic, strong) UITextField *POITextField;
@property (nonatomic, strong) UILabel *zoomLevelTip;
@property (nonatomic, strong) UITextField *zoomLevelTextField;
@property (nonatomic, strong) UIButton *createButton;
@end

@implementation CreateMapWithPOIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];
    [self addGestureRecognizer];
}

-(void)addGestureRecognizer
{
    UITapGestureRecognizer *sigleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture)];
    sigleTap.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:sigleTap];
}

-(void)handleTapGesture
{
    [self.view endEditing:YES];
}

- (void)createButtonAction {
    CreateMapWithPOIResultViewController *vc = [[CreateMapWithPOIResultViewController alloc] init];
    [vc setTitle:self.title];
    // Set the initial POI ID
    vc.POIID = self.POITextField.text;
    // Set the map scale level
    vc.zoomLevel = self.zoomLevelTextField.text.doubleValue;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)layoutUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.boxView];
    [self.boxView addSubview:self.POITip];
    [self.boxView addSubview:self.POITextField];
    [self.boxView addSubview:self.zoomLevelTip];
    [self.boxView addSubview:self.zoomLevelTextField];
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
    
    [self.POITip.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:moduleSpace].active = YES;
    [self.POITip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.POITip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    
    [self.POITextField.topAnchor constraintEqualToAnchor:self.POITip.bottomAnchor constant:innerSpace].active = YES;
    [self.POITextField.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.POITextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    [self.POITextField.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.zoomLevelTip.topAnchor constraintEqualToAnchor:self.POITextField.bottomAnchor constant:moduleSpace].active = YES;
    [self.zoomLevelTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.zoomLevelTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    
    [self.zoomLevelTextField.topAnchor constraintEqualToAnchor:self.zoomLevelTip.bottomAnchor constant:innerSpace].active = YES;
    [self.zoomLevelTextField.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.zoomLevelTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    [self.zoomLevelTextField.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.createButton.widthAnchor constraintEqualToConstant:150].active = YES;
    [self.createButton.heightAnchor constraintEqualToConstant:44].active = YES;
    [self.createButton.centerXAnchor constraintEqualToAnchor:self.boxView.centerXAnchor].active = YES;
    [self.createButton.topAnchor constraintEqualToAnchor:self.zoomLevelTextField.bottomAnchor constant:40].active = YES;
    [self.createButton.bottomAnchor constraintEqualToAnchor:self.boxView.bottomAnchor constant:-40].active = YES;
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

- (UILabel *)POITip {
    if (!_POITip) {
        _POITip = [[UILabel alloc] init];
        _POITip.translatesAutoresizingMaskIntoConstraints = NO;
        _POITip.text = @"poiId *";
    }
    return _POITip;
}

- (UITextField *)POITextField {
    if (!_POITextField) {
        _POITextField = [[UITextField alloc] init];
        _POITextField.translatesAutoresizingMaskIntoConstraints = NO;
        _POITextField.borderStyle = UITextBorderStyleRoundedRect;
        _POITextField.text = @"12586";
        _POITextField.keyboardType = UIKeyboardTypeNumberPad;
        _POITextField.delegate = self;
    }
    return _POITextField;
}

- (UILabel *)zoomLevelTip {
    if (!_zoomLevelTip) {
        _zoomLevelTip = [[UILabel alloc] init];
        _zoomLevelTip.translatesAutoresizingMaskIntoConstraints = NO;
        _zoomLevelTip.text = @"zoomLevel";
    }
    return _zoomLevelTip;
}

- (UITextField *)zoomLevelTextField {
    if (!_zoomLevelTextField) {
        _zoomLevelTextField = [[UITextField alloc] init];
        _zoomLevelTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _zoomLevelTextField.text = @"20";
        _zoomLevelTextField.borderStyle = UITextBorderStyleRoundedRect;
        _zoomLevelTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _zoomLevelTextField.delegate = self;
    }
    return _zoomLevelTextField;
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
