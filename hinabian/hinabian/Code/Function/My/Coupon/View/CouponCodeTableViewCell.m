//
//  CouponCodeTableViewCell.m
//  hinabian
//
//  Created by 余坚 on 16/12/28.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "CouponCodeTableViewCell.h"

@implementation CouponCodeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.WhiteBackGroundImageView.layer.masksToBounds = YES;
    self.WhiteBackGroundImageView.layer.borderWidth = 0.7f;
    self.WhiteBackGroundImageView.layer.borderColor = [UIColor colorWithRed:211.0/255.0f green:211.0/255.0f blue:211.0/255.0f alpha:1.0f].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
