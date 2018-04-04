//
//  PersonalHeadImageItemTableViewCell.m
//  hinabian
//
//  Created by 余坚 on 15/7/2.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "PersonalHeadImageItemTableViewCell.h"

@implementation PersonalHeadImageItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.headImageView.layer.cornerRadius = self.headImageView.bounds.size.width / 2;
    self.headImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setImageView:(UIImage *)headImage
{
    self.imageView.image = headImage;
}

@end
