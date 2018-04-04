//
//  TribeItemCell.m
//  hinabian
//
//  Created by hnbwyh on 16/5/25.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "TribeItemCell.h"
#import "HomeHotPost.h"

@interface TribeItemCell ()
@property (nonatomic,strong) HomeHotPost *curModel;
@end

@implementation TribeItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self modifyCell];
    
    //[self setColor];
    
}

- (void)modifyCell{

    self.userName.font = [UIFont systemFontOfSize:FONT_UI20PX];
    self.userName.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0];
    
    self.title.font = [UIFont systemFontOfSize:FONT_UI32PX];
    self.title.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.0];
    self.title.numberOfLines = 0;
    self.title.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.subTitle.font = [UIFont systemFontOfSize:FONT_UI24PX];
    self.subTitle.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0];
    self.subTitle.numberOfLines = 0;
    
    self.time.font = [UIFont systemFontOfSize:FONT_UI18PX];
    self.time.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0];
    self.tribeImgView.layer.cornerRadius = RRADIUS_LAYERCORNE;
    self.tribeImgView.clipsToBounds = YES;
    self.tribeItemButton.layer.borderWidth = 0.5;
    self.tribeItemButton.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:1.0].CGColor;
    [self.tribeItemButton setTitleColor:[UIColor DDR63_G162_B255ColorWithalph:1.0] forState:UIControlStateNormal];
    /*不能直接取头像的Frame，暂且为固定值*/
    self.tribeItemButton.layer.cornerRadius = 15.f / 2.0;
    self.tribeItemButton.titleLabel.font = [UIFont systemFontOfSize:FONT_UI18PX];
    [self.tribeItemButton addTarget:self action:@selector(clickTribeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.icon.clipsToBounds = YES;
    /*不能直接取头像的Frame，暂且为固定值*/
    self.icon.layer.cornerRadius = 18.f / 2.0;
}


- (void)setCellItemWithModel:(HomeHotPost *)infoModel indexPath:(NSIndexPath *)indexPath{
    // 按钮 tag 
    self.tribeItemButton.tag = 40 + indexPath.row;
    self.curModel = infoModel;
    
    // 按钮长度
    NSString *tribeItemButtonText = infoModel.tribe_name;
    CGSize tribeSize = [tribeItemButtonText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_UI18PX]}];
    /*不能直接取头像的Frame，暂且为固定值*/
    self.tribeItemButtonwidth.constant = tribeSize.width + 15.f;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:infoModel.head_url]];
    [self.tribeItemButton setTitle:infoModel.tribe_name forState:UIControlStateNormal];
    [self.userName setText:infoModel.user_name];
    
    // 文本位置 修改
    [self reloadFrameWithTitle:infoModel.title xoffSet:0.0];
    [self.title setText:infoModel.title];
    [self.subTitle setText:infoModel.desc];
    [self.time setText:infoModel.formated_time];
    [self.zanButton setTitle:[HNBUtils numConvert:infoModel.collect] forState:UIControlStateNormal];
    [self.commentButton setTitle:[HNBUtils numConvert:infoModel.comment_num] forState:UIControlStateNormal];
    [self.lookButton setTitle:[HNBUtils numConvert:infoModel.view_num] forState:UIControlStateNormal];
    
    NSString *img_url_string = infoModel.img_list;
    NSArray *img_url_arr = [img_url_string componentsSeparatedByString:@"&"];
    NSString *img_url= [img_url_arr firstObject];
    if (![img_url isEqualToString:@""]) {
        [self.tribeImgView sd_setImageWithURL:[NSURL URLWithString:img_url] placeholderImage:[UIImage imageNamed:@"homePage_tribe_post"]];
        //[self.tribeImgView setImage:[UIImage imageNamed:@"homePage_tribe_post"]];
    }
    
    /*
     1、加精
     2、非加精
     */
    self.creamImgView.hidden = ![infoModel.essence isEqualToString:@"1"];
    [self.creamImgView setImage:[UIImage imageNamed:@"tribe_cream"]];
    if ([infoModel.essence isEqualToString:@"1"]) {
        
        [self reloadFrameWithTitle:infoModel.title xoffSet:18.0];// 重新约束文本
        
        [self.title setText:[NSString stringWithFormat:@"     %@",infoModel.title]];
    }
    else {
        
        [self reloadFrameWithTitle:infoModel.title xoffSet:0.0];// 重新约束文本
        
        [self.title setText:[NSString stringWithFormat:@"%@",infoModel.title]];
    }
    
    /*认证V*/
    if ([infoModel.certified_type isEqualToString:@"specialist"]) {
        //专家
        self.vImageView.hidden = NO;
        self.levelImageView.hidden = YES;
        [self.vImageView setImage:[UIImage imageNamed:@"specialist"]];
        self.vImageViewLeadingUserName.constant = 5.f;
        
    }else if ([infoModel.certified_type isEqualToString:@"authority"]){
        //官方
        self.vImageView.hidden = NO;
        self.levelImageView.hidden = YES;
        [self.vImageView setImage:[UIImage imageNamed:@"authority"]];
        self.vImageViewLeadingUserName.constant = 5.f;
        
    }else{
        if (infoModel.certified.length != 0) {
            //达人
            self.vImageView.hidden = NO;
            self.levelImageView.hidden = NO;
            [self.vImageView setImage:[UIImage imageNamed:@"tribe_talent"]];
            self.vImageViewLeadingUserName.constant = 30.f;
        }else{
            //普通用户
            self.levelImageView.hidden = NO;
            self.vImageView.hidden = YES;
        }
    }
    /*判断用户等级*/
    if (infoModel.level) {
        [self.levelImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"LV%@",infoModel.level]]];
    }
}


- (void)clickTribeBtn:(UIButton *)btn{
    
   // NSLog(@" clickTribeBtn ------ > %ld",btn.tag);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HOMEPAGE_HOME_COMMONTRIBE_BTN_NOTIFICATION object:self.curModel.tribe_id];
}

- (void)setColor{
    
    self.icon.backgroundColor = [UIColor redColor];
    self.userName.backgroundColor = [UIColor greenColor];
    self.tribeItemButton.backgroundColor = [UIColor orangeColor];
    self.title.backgroundColor = [UIColor orangeColor];
    self.subTitle.backgroundColor = [UIColor redColor];
    self.tribeImgView.backgroundColor = [UIColor greenColor];
    self.time.backgroundColor = [UIColor purpleColor];
    
    self.zanButton.backgroundColor = [UIColor redColor];
    self.commentButton.backgroundColor = [UIColor greenColor];
    self.lookButton.backgroundColor = [UIColor blueColor];
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark ------ toolMethod

// 126.0 - 约束之后 title 文本控件的宽度   ， 39.0 - title 文本控件的高度
- (void)reloadFrameWithTitle:(NSString *)title xoffSet:(CGFloat)xoffset{
    
    CGSize labelSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_UI32PX]}];
    CGFloat actualWidth = labelSize.width + xoffset;
    
    if ((actualWidth < (SCREEN_WIDTH - 126.0) && actualWidth > 0)) {
        
        self.titleHeightConstraint.constant = labelSize.height;
        
    }else{
        
        self.titleHeightConstraint.constant = 39.0;
        
    }
    
}


@end
