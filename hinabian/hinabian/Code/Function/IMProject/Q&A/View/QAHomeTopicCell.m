//
//  QAHomeTopicCell.m
//  hinabian
//
//  Created by hnbwyh on 16/7/28.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "QAHomeTopicCell.h"
#import "VerticalAligmentLabel.h"
#import "Label.h"

@implementation QAHomeTopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.recommand setImage:[UIImage imageNamed:@"tribe_top"]];
    [self.icon setImage:[UIImage imageNamed:@"index_icon_qianzheng"]];
    [self.markImg setBackgroundImage:[UIImage imageNamed:@"home_content_label"] forState:UIControlStateNormal];
    
    self.title.textColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0]; //#323232
    self.des.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]; //#666666
    self.markLabels.textColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0]; //#AAAAAA
    self.name.textColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0]; //#AAAAAA
    
    self.title.font = [UIFont systemFontOfSize:FONT_UI32PX];
    self.des.font = [UIFont systemFontOfSize:FONT_UI28PX];
    self.markLabels.font = [UIFont systemFontOfSize:FONT_UI22PX];
    self.name.font = [UIFont systemFontOfSize:FONT_UI22PX];
    self.icon.contentMode = UIViewContentModeScaleAspectFill;
    self.icon.layer.cornerRadius = (18.f / 2.0) * SCREEN_SCALE;
    self.icon.layer.masksToBounds = TRUE;
    self.des.numberOfLines = 0;
    self.des.verticalAlignment = VerticalAlignmentTop;
    
    self.contentImageView.clipsToBounds = YES;
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setQAHomeTopicCellWithModel:(QuestionIndexItem *)infoModel indexPath:(NSIndexPath *)indexPath{

    NSString *ishot = infoModel.ishot;
    if ([ishot isEqualToString:@"1"]) {
        self.recommendImgWidthConstraint.constant = 33.0;
        self.titleLeadingConstraint.constant = 50.0;
    } else {
        self.recommendImgWidthConstraint.constant = 0.1;
        self.titleLeadingConstraint.constant = 12.0;
    }
    self.title.text = infoModel.title;
    
    NSArray * tmpLabelArray = Nil;
    tmpLabelArray = [infoModel.labels componentsSeparatedByString: @","];
    NSString *labelsAndTimeString = @"";
    for (NSString * tmpString in tmpLabelArray) {
        Label * f = [Label MR_findFirstByAttribute:@"value" withValue:tmpString];
        
        if (f != nil && ![f.name isEqualToString:@"null"] && f.name != nil) {
            labelsAndTimeString = [labelsAndTimeString stringByAppendingString:[NSString stringWithFormat:@"%@  ",f.name]];
        }
    }
    if (infoModel != nil && infoModel.time != nil && ![infoModel.time isEqualToString:@"null"]) {
        labelsAndTimeString = [labelsAndTimeString stringByAppendingString:[NSString stringWithFormat:@"|  %@",infoModel.time]];
    }
    self.markLabels.text = labelsAndTimeString;//@"澳大利亚 圣基茨&尼维斯联邦 美国 | 5分钟前";
    self.name.text = infoModel.username;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.imageurl] placeholderImage:[UIImage imageNamed:@"homePage_tribe_post"]];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:infoModel.userhead_url] placeholderImage:[UIImage imageNamed:@"homePage_tribe_post"]];
    self.des.attributedText = [HNBUtils setLabelLineSpacing:5.0 labelText:infoModel.qadescription];
    [self.lookButton setTitle:[HNBUtils numConvert:infoModel.view_num] forState:UIControlStateNormal];
    [self.commentButton setTitle:[HNBUtils numConvert:infoModel.collect] forState:UIControlStateNormal];
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
