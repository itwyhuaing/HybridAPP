//
//  BigShotCell.m
//  hinabian
//
//  Created by 何松泽 on 2017/10/20.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "BigShotCell.h"
#import "GreatTalkModel.h"

@interface BigShotCell()

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation BigShotCell

- (void)setModel:(id)model {
    
    if (model) {
        GreatTalkModel *f = (GreatTalkModel *)model;
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:f.greatImage_url]];
        self.titleLabel.text = f.title;
    }
}


- (UIImageView *)headImage {
    
    if (!_headImage) {
        _headImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headImage.layer.cornerRadius = 6.f;
        _headImage.clipsToBounds = NO;
        _headImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_headImage];
        _headImage.sd_layout
        .topSpaceToView(self.contentView, 0)
        .leftSpaceToView(self.contentView, 0)
        .widthIs(self.width)
        .heightIs(130.f);
    }
    return _headImage;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.0f];
        _titleLabel.font = [UIFont boldSystemFontOfSize:FONT_UI30PX];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.sd_layout
        .topSpaceToView(self.headImage, 10)
        .leftSpaceToView(self.contentView, 0)
        .widthIs(self.width)
        .heightIs(15.f);
    }
    return _titleLabel;
}

@end
