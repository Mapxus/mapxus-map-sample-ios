//
//  CategoryInBoundResultCell.m
//  MapxusMapSample
//
//  Created by guochenghao on 2024/9/4.
//  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "CategoryInBoundResultCell.h"
#import "Macro.h"

@interface CategoryInBoundResultCell ()
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *enLabel;
@property (nonatomic, strong) UILabel *zhLabel;
@property (nonatomic, strong) UILabel *cnLabel;
@property (nonatomic, strong) UILabel *venueLabel;
@end

@implementation CategoryInBoundResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self.contentView addSubview:self.categoryLabel];
    [self.contentView addSubview:self.enLabel];
    [self.contentView addSubview:self.zhLabel];
    [self.contentView addSubview:self.cnLabel];
    [self.contentView addSubview:self.venueLabel];
    
    [self.categoryLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:moduleSpace].active = YES;
    [self.categoryLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:leadingSpace].active = YES;
    [self.categoryLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-trailingSpace].active = YES;
    
    [self.enLabel.topAnchor constraintEqualToAnchor:self.categoryLabel.bottomAnchor constant:innerSpace].active = YES;
    [self.enLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:leadingSpace].active = YES;
    [self.enLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-trailingSpace].active = YES;
    
    [self.zhLabel.topAnchor constraintEqualToAnchor:self.enLabel.bottomAnchor constant:innerSpace].active = YES;
    [self.zhLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:leadingSpace].active = YES;
    [self.zhLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-trailingSpace].active = YES;
    
    [self.cnLabel.topAnchor constraintEqualToAnchor:self.zhLabel.bottomAnchor constant:innerSpace].active = YES;
    [self.cnLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:leadingSpace].active = YES;
    [self.cnLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-trailingSpace].active = YES;
    
    [self.venueLabel.topAnchor constraintEqualToAnchor:self.cnLabel.bottomAnchor constant:innerSpace].active = YES;
    [self.venueLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:leadingSpace].active = YES;
    [self.venueLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-trailingSpace].active = YES;
  }
  return self;
}

- (void)refreshData:(MXMPoiCategoryVenueInfoEx *)data {
  self.categoryLabel.text = [NSString stringWithFormat:@"category: %@", data.category.category];
  self.enLabel.text = [NSString stringWithFormat:@"title_en: %@", data.category.titleMap.en];
  self.zhLabel.text = [NSString stringWithFormat:@"title_zh: %@", data.category.titleMap.zh_Hant];
  self.cnLabel.text = [NSString stringWithFormat:@"title_cn: %@", data.category.titleMap.zh_Hans];
  self.venueLabel.text = [NSString stringWithFormat:@"venue: %@", data.venueNameMap.Default];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

#pragma mark - Lazy loading
- (UILabel *)categoryLabel {
  if (!_categoryLabel) {
    _categoryLabel = [[UILabel alloc] init];
    _categoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _categoryLabel.text = @"category: ";
  }
  return _categoryLabel;
}

- (UILabel *)enLabel {
  if (!_enLabel) {
    _enLabel = [[UILabel alloc] init];
    _enLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _enLabel.text = @"title_en: ";
  }
  return _enLabel;
}

- (UILabel *)zhLabel {
  if (!_zhLabel) {
    _zhLabel = [[UILabel alloc] init];
    _zhLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _zhLabel.text = @"title_zh: ";
  }
  return _zhLabel;
}

- (UILabel *)cnLabel {
  if (!_cnLabel) {
    _cnLabel = [[UILabel alloc] init];
    _cnLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _cnLabel.text = @"title_cn: ";
  }
  return _cnLabel;
}

- (UILabel *)venueLabel {
  if (!_venueLabel) {
    _venueLabel = [[UILabel alloc] init];
    _venueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _venueLabel.text = @"venue: ";
  }
  return _venueLabel;
}
@end
