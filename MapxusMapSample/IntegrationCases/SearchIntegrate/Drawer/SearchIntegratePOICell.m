//
//  SearchIntegratePOICell.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/25.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "SearchIntegratePOICell.h"
#import "Macro.h"
#import "UIImage+icon.h"
#import "MXMPOI+Language.h"

@interface SearchIntegratePOICell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *extLabel;
@end

@implementation SearchIntegratePOICell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.extLabel];
        
        [self.icon.widthAnchor constraintEqualToConstant:36].active = YES;
        [self.icon.heightAnchor constraintEqualToConstant:36].active = YES;
        [self.icon.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:18].active = YES;
        [self.icon.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:12].active = YES;
        
        [self.nameLabel.topAnchor constraintEqualToAnchor:self.icon.topAnchor].active = YES;
        [self.nameLabel.leadingAnchor constraintEqualToAnchor:self.icon.trailingAnchor constant:18].active = YES;
        [self.nameLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-18].active = YES;
        [self.nameLabel.heightAnchor constraintEqualToConstant:20].active = YES;
        
        [self.extLabel.leadingAnchor constraintEqualToAnchor:self.nameLabel.leadingAnchor].active = YES;
        [self.extLabel.trailingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor].active = YES;
        [self.extLabel.topAnchor constraintEqualToAnchor:self.nameLabel.bottomAnchor constant:10].active = YES;
    }
    return self;
}

- (void)refreshPOI:(MXMPOI *)poi categoryName:(NSString *)category {
    self.icon.image = [UIImage categoryIconWithType:poi.category.firstObject];
    self.nameLabel.text = [poi nameChooseBySystem];
    self.extLabel.text = [NSString stringWithFormat:@"%@ · %@", category, poi.floor];
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

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.font = [UIFont boldSystemFontOfSize:20];
        _nameLabel.textColor = COLOR(0x464646);
    }
    return _nameLabel;
}

- (UILabel *)extLabel {
    if (!_extLabel) {
        _extLabel = [[UILabel alloc] init];
        _extLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _extLabel.font = [UIFont boldSystemFontOfSize:12];
        _extLabel.textColor = COLOR(0x7F7F7F);
    }
    return _extLabel;
}

@end
