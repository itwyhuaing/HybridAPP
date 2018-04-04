//
//  ChineseOneDayCell.m
//  hinabian
//
//  Created by hnbwyh on 16/5/24.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//


#import "ChineseOneDayCell.h"
#import "HomeHotPost.h"

@interface ChineseOneDayCell ()
@property (nonatomic,strong) HomeHotPost *curModel;
@end

@implementation ChineseOneDayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self modifyCell];
}

- (void)modifyCell{

    self.userName.font = [UIFont systemFontOfSize:FONT_UI18PX];
    self.userName.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0];
    
    self.title.font = [UIFont systemFontOfSize:FONT_UI28PX];
    self.title.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.0];
    
    self.time.font = [UIFont systemFontOfSize:FONT_UI18PX];
    self.time.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0];
    
    self.icon.clipsToBounds = YES;
    self.firstImageView.clipsToBounds = YES;
    self.secondImageView.clipsToBounds = YES;
    self.thirdImageView.clipsToBounds = YES;
//    self.icon.layer.cornerRadius = CGRectGetHeight(self.icon.frame) / 2.0;
    /*不能直接取头像的Frame，暂且为固定值*/
    self.icon.layer.cornerRadius = 18.f / 2.0;
    self.firstImageView.layer.cornerRadius = RRADIUS_LAYERCORNE;
    self.secondImageView.layer.cornerRadius = RRADIUS_LAYERCORNE;
    self.thirdImageView.layer.cornerRadius = RRADIUS_LAYERCORNE;
    
    self.chineseOneDayButton.layer.borderWidth = 0.5;
    self.chineseOneDayButton.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:1.0].CGColor;
    [self.chineseOneDayButton setTitleColor:[UIColor DDR63_G162_B255ColorWithalph:1.0] forState:UIControlStateNormal];
    /*不能直接取头像的Frame，暂且为固定值*/
    self.chineseOneDayButton.layer.cornerRadius = 15.f / 2.0;
    self.chineseOneDayButton.titleLabel.font = [UIFont systemFontOfSize:FONT_UI18PX];
    [self.chineseOneDayButton addTarget:self action:@selector(clickChineseOneDayBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)setCellItemWithModel:(HomeHotPost *)infoModel indexPath:(NSIndexPath *)indexPath{
    
    // 按钮事件
    self.chineseOneDayButton.tag = 30 + indexPath.row;
    self.curModel = infoModel;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:infoModel.head_url]];
    [self.userName setText:infoModel.user_name];
    [self.title setText:infoModel.title];
    [self.time setText:infoModel.formated_time];
    [self.lookButton setTitle:[HNBUtils numConvert:infoModel.view_num] forState:UIControlStateNormal];
    [self.commentButton setTitle:[HNBUtils numConvert:infoModel.comment_num] forState:UIControlStateNormal];
    [self.zanButton setTitle:[HNBUtils numConvert:infoModel.collect] forState:UIControlStateNormal];

    // 修改按钮长度
    NSString *chineseText = @"华人的一天";
    CGSize chineseBtnSize = [chineseText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_UI18PX]}];
    self.chineseOneDayButton_W.constant = chineseBtnSize.width + CGRectGetHeight(self.chineseOneDayButton.frame);
    
    // 图片赋值
    NSString *img_urls = infoModel.img_list;
    NSArray *img_url_arr = [img_urls componentsSeparatedByString:@"&"];
    NSMutableArray *imgNames = [[NSMutableArray alloc] init];
    for (NSString *imgURLString in img_url_arr) {
        
        if (![imgURLString isEqualToString:@""]) {
            
            [imgNames addObject:imgURLString];

        }
 
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
    
    // 约束更新
    if (imgNames.count == 1) {
        [self reloadConstrainsOneImages];
        [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:imgNames[0]] placeholderImage:[UIImage imageNamed:@"homePage_chineseDay_one"]];
    } else if (imgNames.count == 2){
        [self reloadConstrainsTwoImages];
        [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:imgNames[0]] placeholderImage:[UIImage imageNamed:@"homePage_chineseDay_two"]];
        [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:imgNames[1]] placeholderImage:[UIImage imageNamed:@"homePage_chineseDay_two"]];
    }else if(imgNames.count >= 3){
        [self reloadConstrainsThreeImages];
        [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:imgNames[0]] placeholderImage:[UIImage imageNamed:@"homePage_chineseDay_three1"]];
        [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:imgNames[1]] placeholderImage:[UIImage imageNamed:@"homePage_chineseDay_three2"]];
        [self.thirdImageView sd_setImageWithURL:[NSURL URLWithString:imgNames[2]] placeholderImage:[UIImage imageNamed:@"homePage_chineseDay_three2"]];
    }else{
        [self reloadConstrainsOneImages];
        [self.firstImageView setImage:[UIImage imageNamed:@"homePage_chineseDay_one"]];
    }

}

- (void)reloadConstrainsOneImages{
    
    self.firstImageViewWidth.constant = SCREEN_WIDTH - 20.0;
    self.firstImageViewHeight.constant = 110.0 * SCREEN_SCALE;
    
    self.secondImageViewWidth.constant = 0;
    self.secondImageViewHeight.constant = 0;
    
    self.thirdImageViewWidth.constant = 0;
    self.thirdImageViewHeight.constant = 0;
    
}

- (void)reloadConstrainsTwoImages{
    
    self.firstImageViewWidth.constant = (SCREEN_WIDTH - 26.0) / 2.0;
    self.firstImageViewHeight.constant = 110.0 * SCREEN_SCALE;
    
    self.secondImageViewWidth.constant = self.firstImageViewWidth.constant;
    self.secondImageViewHeight.constant = self.firstImageViewHeight.constant;
    
    self.thirdImageViewWidth.constant = 0;
    self.thirdImageViewHeight.constant = 0;
    
}

- (void)reloadConstrainsThreeImages{
    
    self.firstImageViewWidth.constant = 180 * SCREEN_SCALE;
    self.firstImageViewHeight.constant = 110.0 * SCREEN_SCALE;
    
    self.secondImageViewWidth.constant = 115 * SCREEN_SCALE;
    self.secondImageViewHeight.constant = 52.0 * SCREEN_SCALE;
    
    self.thirdImageViewWidth.constant = self.secondImageViewWidth.constant;
    self.thirdImageViewHeight.constant = self.secondImageViewHeight.constant;
    
}

- (void)clickChineseOneDayBtn:(UIButton *)btn{

    NSLog(@" clickChineseOneDayBtn ------ > %ld",btn.tag);
    [[NSNotificationCenter defaultCenter] postNotificationName:HOMEPAGE_HOME_CHINESEONEDAY_BTN_NOTIFICATION object:self.curModel.tribe_id];
    
}

- (void)setColor{

    self.icon.backgroundColor = [UIColor redColor];
    self.userName.backgroundColor = [UIColor greenColor];
    //self.chineseOneDayButton.backgroundColor = [UIColor orangeColor];
    self.title.backgroundColor = [UIColor orangeColor];
    self.time.backgroundColor = [UIColor purpleColor];
    
    self.zanButton.backgroundColor = [UIColor redColor];
    self.commentButton.backgroundColor = [UIColor greenColor];
    self.lookButton.backgroundColor = [UIColor blueColor];
    
    self.firstImageView.backgroundColor = [UIColor redColor];
    self.secondImageView.backgroundColor = [UIColor yellowColor];
    self.thirdImageView.backgroundColor = [UIColor blueColor];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
