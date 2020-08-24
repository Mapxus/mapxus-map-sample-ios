//
//  FeatureCollectionViewCell.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/11.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "FeatureCollectionViewCell.h"
#import "Feature.h"


@interface FeatureCollectionViewCell ()
@property (nonatomic, weak) IBOutlet UIView *boxView;
@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *subTextLabel;
@end


@implementation FeatureCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshData:(Feature *)data
{
    self.imgView.image = [UIImage imageNamed:data.imageName];
    self.nameLabel.text = data.title;
    self.subTextLabel.text = data.subTitle;
}

@end
