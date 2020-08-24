//
//  MenuTableViewCell.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/4/26.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MenuTableViewCell.h"


@interface MenuTableViewCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@end


@implementation MenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
        [self.nameLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:19].active = YES;
        [self.nameLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
        [self.nameLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10].active = YES;
    }
    return self;
}

- (void)refreshData:(NSString *)data
{
    self.nameLabel.text = data;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.nameLabel.textColor = [UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1/1.0];
    } else {
        self.nameLabel.textColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1/1.0];
    }
}

#pragma mark - Lazy loading
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _nameLabel.textColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1/1.0];
    }
    return _nameLabel;
}

@end
