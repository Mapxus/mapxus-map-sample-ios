//
//  SearchIntegrateCategoryCell.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/25.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "SearchIntegrateCategoryCell.h"
#import "Macro.h"
#import "UIImage+icon.h"

@interface SearchIntegrateCategoryCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *categoryLabel;
@end

@implementation SearchIntegrateCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.categoryLabel];
        
        [self.icon.widthAnchor constraintEqualToConstant:36].active = YES;
        [self.icon.heightAnchor constraintEqualToConstant:36].active = YES;
        [self.icon.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
        [self.icon.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:18].active = YES;
        
        [self.categoryLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
        [self.categoryLabel.leadingAnchor constraintEqualToAnchor:self.icon.trailingAnchor constant:16].active = YES;
        [self.categoryLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-18].active = YES;
    }
    return self;
}

- (void)refreshCategory:(NSString *)category categoryName:(NSString *)name {
    self.icon.image = [UIImage categoryIconWithType:category];
    self.categoryLabel.text = name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Lazy loading
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _icon;
}

- (UILabel *)categoryLabel {
    if (!_categoryLabel) {
        _categoryLabel = [[UILabel alloc] init];
        _categoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _categoryLabel.font = [UIFont boldSystemFontOfSize:20];
        _categoryLabel.textColor = COLOR(0x464646);
    }
    return _categoryLabel;
}

@end
