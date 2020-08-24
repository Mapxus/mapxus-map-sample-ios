//
//  FocusOnIndoorSceneParamViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/20.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <IQKeyboardManager/IQKeyboardManager.h>
#import "FocusOnIndoorSceneParamViewController.h"
#import "Macro.h"

@interface FocusOnIndoorSceneParamViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *buildingTip;
@property (nonatomic, strong) UITextField *buildingTextField;
@property (nonatomic, strong) UILabel *floorTip;
@property (nonatomic, strong) UITextField *floorTextField;
@property (nonatomic, strong) UILabel *zoomModelTip;
@property (nonatomic, strong) UIButton *zoomModeButton;
@property (nonatomic, strong) UILabel *edgeTip;
@property (nonatomic, strong) UILabel *edgeTopTip;
@property (nonatomic, strong) UILabel *edgeBottomTip;
@property (nonatomic, strong) UILabel *edgeLeftTip;
@property (nonatomic, strong) UILabel *edgeRightTip;
@property (nonatomic, strong) UITextField *edgeTopTextField;
@property (nonatomic, strong) UITextField *edgeBottomTextField;
@property (nonatomic, strong) UITextField *edgeLeftTextField;
@property (nonatomic, strong) UITextField *edgeRightTextField;
@property (nonatomic, strong) UIButton *createButton;
@property (nonatomic, assign) NSInteger zoomMode;
@end

@implementation FocusOnIndoorSceneParamViewController

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
            params[@"buildingID"] = weakSelf.buildingTextField.text;
            params[@"floor"] = weakSelf.floorTextField.text;
            params[@"zoomMode"] = @(self.zoomMode);
            params[@"edgeTop"] = weakSelf.edgeTopTextField.text;
            params[@"edgeBottom"] = weakSelf.edgeBottomTextField.text;
            params[@"edgeLeft"] = weakSelf.edgeLeftTextField.text;
            params[@"edgeRight"] = weakSelf.edgeRightTextField.text;
            [self.delegate completeParamConfiguration:params];
        }
    }];
}

- (void)changeZoomMode {
    self.zoomMode = (self.zoomMode+1)%3;
    switch (self.zoomMode) {
        case 0:
            [self.zoomModeButton setTitle:@"MXMZoomDisable" forState:UIControlStateNormal];
            break;
        case 1:
            [self.zoomModeButton setTitle:@"MXMZoomAnimated" forState:UIControlStateNormal];
            break;
        case 2:
            [self.zoomModeButton setTitle:@"MXMZoomDirect" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)layoutUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.boxView];
    [self.boxView addSubview:self.buildingTip];
    [self.boxView addSubview:self.buildingTextField];
    [self.boxView addSubview:self.floorTip];
    [self.boxView addSubview:self.floorTextField];
    [self.boxView addSubview:self.zoomModelTip];
    [self.boxView addSubview:self.zoomModeButton];
    [self.boxView addSubview:self.edgeTip];
    [self.boxView addSubview:self.edgeTopTip];
    [self.boxView addSubview:self.edgeTopTextField];
    [self.boxView addSubview:self.edgeBottomTip];
    [self.boxView addSubview:self.edgeBottomTextField];
    [self.boxView addSubview:self.edgeLeftTip];
    [self.boxView addSubview:self.edgeLeftTextField];
    [self.boxView addSubview:self.edgeRightTip];
    [self.boxView addSubview:self.edgeRightTextField];
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

    [self.buildingTip.topAnchor constraintEqualToAnchor:self.boxView.topAnchor constant:moduleSpace].active = YES;
    [self.buildingTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.buildingTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    
    [self.buildingTextField.topAnchor constraintEqualToAnchor:self.buildingTip.bottomAnchor constant:innerSpace].active = YES;
    [self.buildingTextField.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.buildingTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    [self.buildingTextField.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.floorTip.topAnchor constraintEqualToAnchor:self.buildingTextField.bottomAnchor constant:moduleSpace].active = YES;
    [self.floorTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.floorTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    
    [self.floorTextField.topAnchor constraintEqualToAnchor:self.floorTip.bottomAnchor constant:innerSpace].active = YES;
    [self.floorTextField.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.floorTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    [self.floorTextField.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.zoomModelTip.topAnchor constraintEqualToAnchor:self.floorTextField.bottomAnchor constant:moduleSpace].active = YES;
    [self.zoomModelTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.zoomModelTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    
    [self.zoomModeButton.topAnchor constraintEqualToAnchor:self.zoomModelTip.bottomAnchor constant:innerSpace].active = YES;
    [self.zoomModeButton.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.zoomModeButton.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    [self.zoomModeButton.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.edgeTip.topAnchor constraintEqualToAnchor:self.zoomModeButton.bottomAnchor constant:moduleSpace].active = YES;
    [self.edgeTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.edgeTip.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    
    [self.edgeTopTip.topAnchor constraintEqualToAnchor:self.edgeTip.bottomAnchor constant:innerSpace].active = YES;
    [self.edgeTopTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.edgeTopTip.widthAnchor constraintEqualToConstant:100].active = YES;
    [self.edgeTopTip.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.edgeTopTextField.topAnchor constraintEqualToAnchor:self.edgeTopTip.topAnchor].active = YES;
    [self.edgeTopTextField.leadingAnchor constraintEqualToAnchor:self.edgeTopTip.trailingAnchor constant:5].active = YES;
    [self.edgeTopTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    [self.edgeTopTextField.heightAnchor constraintEqualToConstant:44].active = YES;

    [self.edgeBottomTip.topAnchor constraintEqualToAnchor:self.edgeTopTip.bottomAnchor constant:innerSpace].active = YES;
    [self.edgeBottomTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.edgeBottomTip.widthAnchor constraintEqualToConstant:100].active = YES;
    [self.edgeBottomTip.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.edgeBottomTextField.topAnchor constraintEqualToAnchor:self.edgeBottomTip.topAnchor].active = YES;
    [self.edgeBottomTextField.leadingAnchor constraintEqualToAnchor:self.edgeBottomTip.trailingAnchor constant:5].active = YES;
    [self.edgeBottomTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    [self.edgeBottomTextField.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.edgeLeftTip.topAnchor constraintEqualToAnchor:self.edgeBottomTip.bottomAnchor constant:innerSpace].active = YES;
    [self.edgeLeftTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.edgeLeftTip.widthAnchor constraintEqualToConstant:100].active = YES;
    [self.edgeLeftTip.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.edgeLeftTextField.topAnchor constraintEqualToAnchor:self.edgeLeftTip.topAnchor].active = YES;
    [self.edgeLeftTextField.leadingAnchor constraintEqualToAnchor:self.edgeLeftTip.trailingAnchor constant:5].active = YES;
    [self.edgeLeftTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    [self.edgeLeftTextField.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.edgeRightTip.topAnchor constraintEqualToAnchor:self.edgeLeftTip.bottomAnchor constant:innerSpace].active = YES;
    [self.edgeRightTip.leadingAnchor constraintEqualToAnchor:self.boxView.leadingAnchor constant:leadingSpace].active = YES;
    [self.edgeRightTip.widthAnchor constraintEqualToConstant:100].active = YES;
    [self.edgeRightTip.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.edgeRightTextField.topAnchor constraintEqualToAnchor:self.edgeRightTip.topAnchor].active = YES;
    [self.edgeRightTextField.leadingAnchor constraintEqualToAnchor:self.edgeRightTip.trailingAnchor constant:5].active = YES;
    [self.edgeRightTextField.trailingAnchor constraintEqualToAnchor:self.boxView.trailingAnchor constant:-trailingSpace].active = YES;
    [self.edgeRightTextField.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.createButton.widthAnchor constraintEqualToConstant:150].active = YES;
    [self.createButton.heightAnchor constraintEqualToConstant:44].active = YES;
    [self.createButton.centerXAnchor constraintEqualToAnchor:self.boxView.centerXAnchor].active = YES;
    [self.createButton.topAnchor constraintEqualToAnchor:self.edgeRightTextField.bottomAnchor constant:40].active = YES;
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

- (UILabel *)buildingTip {
    if (!_buildingTip) {
        _buildingTip = [[UILabel alloc] init];
        _buildingTip.translatesAutoresizingMaskIntoConstraints = NO;
        _buildingTip.text = @"buildingId *";
    }
    return _buildingTip;
}

- (UITextField *)buildingTextField {
    if (!_buildingTextField) {
        _buildingTextField = [[UITextField alloc] init];
        _buildingTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _buildingTextField.borderStyle = UITextBorderStyleRoundedRect;
        _buildingTextField.text = @"harbourcity_hk_8b580b";
        _buildingTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _buildingTextField.delegate = self;
    }
    return _buildingTextField;
}

- (UILabel *)floorTip {
    if (!_floorTip) {
        _floorTip = [[UILabel alloc] init];
        _floorTip.translatesAutoresizingMaskIntoConstraints = NO;
        _floorTip.text = @"floor";
    }
    return _floorTip;
}

- (UITextField *)floorTextField {
    if (!_floorTextField) {
        _floorTextField = [[UITextField alloc] init];
        _floorTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _floorTextField.text = @"L3";
        _floorTextField.borderStyle = UITextBorderStyleRoundedRect;
        _floorTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _floorTextField.delegate = self;
    }
    return _floorTextField;
}

- (UILabel *)zoomModelTip {
    if (!_zoomModelTip) {
        _zoomModelTip = [[UILabel alloc] init];
        _zoomModelTip.translatesAutoresizingMaskIntoConstraints = NO;
        _zoomModelTip.text = @"zoomMode";
    }
    return _zoomModelTip;
}

- (UIButton *)zoomModeButton {
    if (!_zoomModeButton) {
        _zoomModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _zoomModeButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_zoomModeButton setTitle:@"MXMZoomDisable" forState:UIControlStateNormal];
        [_zoomModeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _zoomModeButton.backgroundColor = [UIColor colorWithRed:80/255.0 green:175/255.0 blue:243/255.0 alpha:1.0];
        [_zoomModeButton addTarget:self action:@selector(changeZoomMode) forControlEvents:UIControlEventTouchUpInside];
        _zoomModeButton.layer.cornerRadius = 5;
    }
    return _zoomModeButton;
}

- (UILabel *)edgeTip {
    if (!_edgeTip) {
        _edgeTip = [[UILabel alloc] init];
        _edgeTip.translatesAutoresizingMaskIntoConstraints = NO;
        _edgeTip.text = @"zoomInsets";
    }
    return _edgeTip;
}

- (UILabel *)edgeTopTip {
    if (!_edgeTopTip) {
        _edgeTopTip = [[UILabel alloc] init];
        _edgeTopTip.translatesAutoresizingMaskIntoConstraints = NO;
        _edgeTopTip.text = @"Top";
    }
    return _edgeTopTip;
}

- (UILabel *)edgeBottomTip {
    if (!_edgeBottomTip) {
        _edgeBottomTip = [[UILabel alloc] init];
        _edgeBottomTip.translatesAutoresizingMaskIntoConstraints = NO;
        _edgeBottomTip.text = @"bottom";
    }
    return _edgeBottomTip;
}

- (UILabel *)edgeLeftTip {
    if (!_edgeLeftTip) {
        _edgeLeftTip = [[UILabel alloc] init];
        _edgeLeftTip.translatesAutoresizingMaskIntoConstraints = NO;
        _edgeLeftTip.text = @"left";
    }
    return _edgeLeftTip;
}

- (UILabel *)edgeRightTip {
    if (!_edgeRightTip) {
        _edgeRightTip = [[UILabel alloc] init];
        _edgeRightTip.translatesAutoresizingMaskIntoConstraints = NO;
        _edgeRightTip.text = @"right";
    }
    return _edgeRightTip;
}

- (UITextField *)edgeTopTextField {
    if (!_edgeTopTextField) {
        _edgeTopTextField = [[UITextField alloc] init];
        _edgeTopTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _edgeTopTextField.text = @"0";
        _edgeTopTextField.placeholder = @"please enter number";
        _edgeTopTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _edgeTopTextField.borderStyle = UITextBorderStyleRoundedRect;
        _edgeTopTextField.delegate = self;
    }
    return _edgeTopTextField;
}

- (UITextField *)edgeBottomTextField {
    if (!_edgeBottomTextField) {
        _edgeBottomTextField = [[UITextField alloc] init];
        _edgeBottomTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _edgeBottomTextField.text = @"0";
        _edgeBottomTextField.placeholder = @"please enter number";
        _edgeBottomTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _edgeBottomTextField.borderStyle = UITextBorderStyleRoundedRect;
        _edgeBottomTextField.delegate = self;
    }
    return _edgeBottomTextField;
}

- (UITextField *)edgeLeftTextField {
    if (!_edgeLeftTextField) {
        _edgeLeftTextField = [[UITextField alloc] init];
        _edgeLeftTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _edgeLeftTextField.text = @"0";
        _edgeLeftTextField.placeholder = @"please enter number";
        _edgeLeftTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _edgeLeftTextField.borderStyle = UITextBorderStyleRoundedRect;
        _edgeLeftTextField.delegate = self;
    }
    return _edgeLeftTextField;
}

- (UITextField *)edgeRightTextField {
    if (!_edgeRightTextField) {
        _edgeRightTextField = [[UITextField alloc] init];
        _edgeRightTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _edgeRightTextField.text = @"0";
        _edgeRightTextField.placeholder = @"please enter number";
        _edgeRightTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _edgeRightTextField.borderStyle = UITextBorderStyleRoundedRect;
        _edgeRightTextField.delegate = self;
    }
    return _edgeRightTextField;
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
