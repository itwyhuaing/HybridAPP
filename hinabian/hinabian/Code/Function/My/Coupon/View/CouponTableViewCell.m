//
//  CouponTableViewCell.m
//  hinabian
//
//  Created by hnb on 16/4/13.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "CouponTableViewCell.h"

@implementation CouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cardBackgroundView.layer.borderWidth = 1;
    self.cardBackgroundView.layer.borderColor = [UIColor DDEdgeGray].CGColor;
    if (SCREEN_WIDTH < SCREEN_WIDTH_6) {
        [self.salesLabel setFont:[UIFont boldSystemFontOfSize:31]];
    }
}

/**
 *  设置卡卷快过期
 */
-(void) setSoonOutOfDate
{
    self.overDateImage.hidden = false;
    self.overDateImage.image = [UIImage imageNamed:@"coupon_outdate"];
}

/**
 *  设置卡卷新领取
 */
-(void) setNew
{
    self.overDateImage.hidden = false;
    self.overDateImage.image = [UIImage imageNamed:@"coupon_new"];
}

/**
 *  设置卡卷不可用
 *
 *
 */
-(void) setNotAvailable
{
    self.topImage.backgroundColor = [UIColor DDToolBarTopLine];
    self.salesLabel.textColor = [UIColor DDToolBarTopLine];
    self.iconLabel.textColor = [UIColor DDToolBarTopLine];
    self.quanTitleLabel.textColor = [UIColor DDToolBarTopLine];
    
    self.projectLabel.textColor = [UIColor DDCouponNotAvailableTextGray];
    self.useLabel.textColor = [UIColor DDCouponNotAvailableTextGray];
    self.platFormLabel.textColor = [UIColor DDCouponNotAvailableTextGray];
    self.dateLabel.textColor = [UIColor DDCouponNotAvailableTextGray];
    self.describeLabel.textColor = [UIColor DDCouponNotAvailableTextGray];
    self.overDateImage.hidden = true;
    self.goImageView.hidden = true;
}


/**
 *  设置数据
 *
 *  @param f
 */
-(void) setCouponData:(Coupon *)f
{
    self.salesLabel.text = f.quota;
    self.projectLabel.text = f.suitName;
    self.useLabel.text = f.describe;
    self.platFormLabel.text = f.platform;
    self.describeLabel.text = f.suitTitle;
    //判断是否过期
    
    if([f.expiring isEqualToString:@"1"])
    {
        [self setSoonOutOfDate];
        NSMutableAttributedString *strOne = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@到期",f.endtime]];
        [strOne addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:120.0f/255.0f green:120.0f/255.0f blue:120.0f/255.0f alpha:1.0] range:NSMakeRange(0,strOne.length)];
        NSMutableAttributedString *strTwo = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(仅剩%@天)",f.expiring_day]];
        [strTwo addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:239.0f/255.0f green:82.0f/255.0f blue:86.0f/255.0f alpha:1.0] range:NSMakeRange(0,strTwo.length)];
        
        [strOne appendAttributedString:strTwo];
        self.dateLabel.attributedText = strOne;
    }
    else
    {
        NSString * dateString;
        dateString = [NSString stringWithFormat:@"%@ - %@",f.starttime,f.endtime];
        self.dateLabel.text = dateString;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
