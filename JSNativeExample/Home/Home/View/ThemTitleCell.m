//
//  ThemTitleCell.m
//  hinabian
//
//  Created by hnbwyh on 16/5/24.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "ThemTitleCell.h"

@implementation ThemTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleIcon.contentMode = UIViewContentModeCenter;
    
    self.arrowImageView.contentMode = UIViewContentModeRight;
    self.titleIcon.clipsToBounds = YES;
    
    self.titleLabel.font = [UIFont systemFontOfSize:FONT_UI24PX];
    self.detailTitleLabel.font = [UIFont systemFontOfSize:FONT_UI18PX];
    
    self.titleLabel.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.0];
    self.detailTitleLabel.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0];
    
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.detailTitleLabel.textAlignment = NSTextAlignmentRight;
    
}



- (void)setcellIcon:(NSString *)themIcon title:(NSString *)title detailTitle:(NSString *)detailTitle arrow:(NSString *)arrow{

    [self.titleIcon setImage:[UIImage imageNamed:themIcon]];
    [self.titleLabel setText:title];
    [self.detailTitleLabel setText:detailTitle];
    [self.arrowImageView setImage:[UIImage imageNamed:arrow]];//
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
