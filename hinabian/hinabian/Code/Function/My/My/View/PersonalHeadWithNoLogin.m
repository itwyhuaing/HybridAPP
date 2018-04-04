//
//  PersonalHeadTableViewCell.m
//  hinabian
//
//  Created by 余坚 on 15/7/2.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "PersonalHeadWithNoLogin.h"
#import "UIImageView+AFNetworking.h"
#import "UIFont+Fonts.h"
#import "PersonalInfoItemTableViewCell.h"
#import "LoginViewController.h"
#import "PersonalInfoViewController.h"


@implementation PersonalHeadWithNoLogin

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    [self.backgroundImageView setImage:[UIImage imageNamed:@"person_header_backImg"]];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_UI28PX];
    self.btnLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_UI28PX];
    self.btnLabel.textColor = [UIColor DDNavBarBlue];
    self.btnLabel.layer.cornerRadius = 4.f;
    self.btnLabel.clipsToBounds = YES;
    
    [self.loginBtn addTarget:self action:@selector(editPersonalInfo) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) editPersonalInfo
{
    [HNBClick event:@"102035" Content:nil];
    
    if (![HNBUtils isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.superController.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        PersonalInfoViewController * vc = [[PersonalInfoViewController alloc] init];
        [self.superController.navigationController pushViewController:vc animated:YES];
    }
}

-(void)didScroll:(CGFloat)offset
{
    if(offset<=0){
        CGFloat newHeight = [PersonalHeadWithNoLogin getHeight] - offset;
        CGFloat scale = newHeight / [PersonalHeadWithNoLogin getHeight];
        CGFloat newWidth = [UIScreen mainScreen].bounds.size.width *scale;
        CGFloat newX = ([UIScreen mainScreen].bounds.size.width - newWidth)/2;
        
        CGFloat imageScale = ([PersonalHeadWithNoLogin getHeight] - offset*0.6) / [PersonalHeadWithNoLogin getHeight];
        CGAffineTransform transfer = CGAffineTransformMakeScale(imageScale, imageScale);
        transfer = CGAffineTransformTranslate(transfer, 0, offset * 0.6);

        self.titleLabel.transform = transfer;
        self.titleLabel.transform = CGAffineTransformMakeTranslation(0, offset * 0.4);
        self.btnLabel.transform = transfer;
        self.btnLabel.transform = CGAffineTransformMakeTranslation(0, offset * 0.4);
        
        self.backgroundImageView.frame = CGRectMake(newX, offset, newWidth, newHeight);
    }
    else{
        self.backgroundImageView.transform = CGAffineTransformIdentity;
        self.titleLabel.transform = CGAffineTransformIdentity;
        self.btnLabel.transform = CGAffineTransformIdentity;
    }

}

+(CGFloat )getHeight
{
    return 170;
    //return 200;
}

@end
