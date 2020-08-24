//
//  SearchIntegratePOIDetailBaseCell.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/25.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "SearchIntegratePOIDetailBaseCell.h"
#import "Macro.h"

@interface SearchIntegratePOIDetailBaseCell ()
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@end

@implementation SearchIntegratePOIDetailBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.tipLabel];
        [self.contentView addSubview:self.valueLabel];
        
        [self.tipLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:18].active = YES;
        [self.tipLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:16].active = YES;
        [self.tipLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:18].active = YES;
        [self.tipLabel.heightAnchor constraintEqualToConstant:20].active = YES;
        
        [self.valueLabel.leadingAnchor constraintEqualToAnchor:self.tipLabel.leadingAnchor].active = YES;
        [self.valueLabel.topAnchor constraintEqualToAnchor:self.tipLabel.bottomAnchor constant:2].active = YES;
        [self.valueLabel.trailingAnchor constraintEqualToAnchor:self.tipLabel.trailingAnchor].active = YES;
        [self.valueLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-18].active = YES;
    }
    return self;
}

- (void)refreshData:(NSDictionary *)data {
    self.tipLabel.text = data[@"tip"];
    self.valueLabel.text = data[@"value"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Lazy loading
- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _tipLabel.font = [UIFont systemFontOfSize:16];
        _tipLabel.textColor = COLOR(0x464646);
    }
    return _tipLabel;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _valueLabel.font = [UIFont systemFontOfSize:12];
        _valueLabel.textColor = COLOR(0x7F7F7F);
        _valueLabel.numberOfLines = 0;
    }
    return _valueLabel;
}

@end
