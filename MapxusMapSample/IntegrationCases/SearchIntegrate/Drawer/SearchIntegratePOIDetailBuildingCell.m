//
//  SearchIntegratePOIDetailBuildingCell.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/25.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "SearchIntegratePOIDetailBuildingCell.h"
#import "Macro.h"
#import "UIImage+icon.h"

@interface SearchIntegratePOIDetailBuildingCell ()
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@end

@implementation SearchIntegratePOIDetailBuildingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.tipLabel];
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.addressLabel];
        
        [self.tipLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:18].active = YES;
        [self.tipLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8].active = YES;

        [self.icon.widthAnchor constraintEqualToConstant:36].active = YES;
        [self.icon.heightAnchor constraintEqualToConstant:36].active = YES;
        [self.icon.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:18].active = YES;
        [self.icon.topAnchor constraintEqualToAnchor:self.tipLabel.bottomAnchor constant:18].active = YES;

        [self.nameLabel.topAnchor constraintEqualToAnchor:self.icon.topAnchor].active = YES;
        [self.nameLabel.leadingAnchor constraintEqualToAnchor:self.icon.trailingAnchor constant:18].active = YES;
        [self.nameLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-18].active = YES;

        [self.addressLabel.leadingAnchor constraintEqualToAnchor:self.nameLabel.leadingAnchor].active = YES;
        [self.addressLabel.trailingAnchor constraintEqualToAnchor:self.addressLabel.trailingAnchor].active = YES;
        [self.addressLabel.topAnchor constraintEqualToAnchor:self.nameLabel.bottomAnchor constant:2].active = YES;
        [self.addressLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-15].active = YES;
    }
    return self;
}

- (void)refreshData:(NSDictionary *)data {
    self.icon.image = [UIImage buildingIconWithType:data[@"type"]];
    self.nameLabel.text = data[@"name"];
    self.addressLabel.text = data[@"address"];
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
        _tipLabel.text = @"Located Inside";
        _tipLabel.textColor = COLOR(0x464646);
    }
    return _tipLabel;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _icon;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.font = [UIFont boldSystemFontOfSize:20];
        _nameLabel.textColor = COLOR(0x464646);
    }
    return _nameLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _addressLabel.font = [UIFont systemFontOfSize:12];
        _addressLabel.textColor = COLOR(0x7F7F7F);
    }
    return _addressLabel;
}

@end
