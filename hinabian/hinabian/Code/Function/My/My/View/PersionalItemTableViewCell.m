//
//  PersionalItemTableViewCell.m
//  hinabian
//
//  Created by 余坚 on 15/6/15.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "PersionalItemTableViewCell.h"

@implementation PersionalItemTableViewCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.size.width / 2;
    self.iconImageView.clipsToBounds = YES;
    
    [self.titleLabel setTextColor:[UIColor blackColor]];
    [self.noticeLabel setTextColor:[UIColor whiteColor]];
    
    self.titleLabel.font = [UIFont systemFontOfSize:FONT_UI32PX];
}

-(void) setDataForItem:(NSString *)titleString IconImage:(NSString *) imageName hideNotice:(NSString *)noticeString
{
    self.noticeLabel.layer.cornerRadius = CGRectGetHeight(self.noticeLabel.frame) / 2;
    self.noticeLabel.layer.masksToBounds = YES;

    //
    if (noticeString.length > 2) {
        NSUInteger tmp = noticeString.length - 2;
        self.noticeLabelWidth.constant = 22.f + (CGFloat)(tmp * 8.f);
    } else {
        self.noticeLabelWidth.constant = 22.f;
    }
    
    
    self.titleLabel.text = titleString;
    [self.iconImageView setImage:[UIImage imageNamed:imageName]];

    if (noticeString != nil) {
        self.noticeLabel.hidden = FALSE;
        self.noticeLabel.text = noticeString;
    }
    else
    {
        self.noticeLabel.hidden = TRUE;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
