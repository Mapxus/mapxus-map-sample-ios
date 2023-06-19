//
//  VenueIDCell.m
//  MapxusMapSample
//
//  Created by guochenghao on 2023/6/7.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "VenueIDCell.h"
#import "Macro.h"

@interface VenueIDCell () <UITextFieldDelegate>
@property (nonatomic, strong) UILabel *IDTip;
@property (nonatomic, strong) UITextField *IDTextField;
@end

@implementation VenueIDCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.IDTip];
        [self.contentView addSubview:self.IDTextField];
        
        [self.IDTip.widthAnchor constraintEqualToConstant:80].active = YES;
        [self.IDTip.heightAnchor constraintEqualToConstant:44].active = YES;
        [self.IDTip.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:leadingSpace].active = YES;
        [self.IDTip.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
        
        [self.IDTextField.leadingAnchor constraintEqualToAnchor:self.IDTip.trailingAnchor constant:innerSpace].active = YES;
        [self.IDTextField.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-trailingSpace].active = YES;
        [self.IDTextField.heightAnchor constraintEqualToConstant:44].active = YES;
        [self.IDTextField.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)refreshData:(NSString *)data {
    self.IDTextField.text = data;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.endEditBlock) {
        self.endEditBlock(self, textField.text);
    }
}

#pragma mark - Lazy loading
- (UILabel *)IDTip {
    if (!_IDTip) {
        _IDTip = [[UILabel alloc] init];
        _IDTip.translatesAutoresizingMaskIntoConstraints = NO;
        _IDTip.text = @"venueId";
    }
    return _IDTip;
}

- (UITextField *)IDTextField {
    if (!_IDTextField) {
        _IDTextField = [[UITextField alloc] init];
        _IDTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _IDTextField.delegate = self;
        _IDTextField.keyboardType = UIKeyboardTypeDefault;
        _IDTextField.borderStyle = UITextBorderStyleRoundedRect;
        _IDTextField.returnKeyType = UIReturnKeyDone;
    }
    return _IDTextField;
}

@end
