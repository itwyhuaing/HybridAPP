//
//  CouponDiscountTableViewCell.h
//  hinabian
//
//  Created by hnb on 16/4/14.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"
static NSString * cellNibName_CouponDiscountTableViewCell = @"CouponDiscountTableViewCell";
@interface CouponDiscountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cardBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *salesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *overDateImage;
@property (weak, nonatomic) IBOutlet UILabel *quanTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectLabel;

@property (weak, nonatomic) IBOutlet UILabel *useLabel;
@property (weak, nonatomic) IBOutlet UILabel *platFormLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goImageView;

-(void) setNotAvailable;   //设置卡卷不可用
-(void) setSoonOutOfDate;  //设置快过期
-(void) setNew;            //设置新领取
-(void) setCouponData:(Coupon *)f;
@end
