//
//  PlusIMHundredConsultCell.m
//  hinabian
//
//  Created by hnbwyh on 16/6/29.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "PlusIMHundredConsultCell.h"
#import "HomeQA.h"
#import "HomeQASpecial.h"
#import "HotPoint+CoreDataClass.h"

@implementation PlusIMHundredConsultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
     // 点击事件
    [self modifyItemEvent:self.firstButton imgView:self.firstImageView firstTitle:self.firsttitle1Label secondTitle:self.firsttitle2Label thirdTitle:self.firsttitle3Label];
    [self modifyItemEvent:self.secondButton imgView:self.secondImageView firstTitle:self.secondtitle1Label secondTitle:self.secondtitle2Label thirdTitle:self.secondtitle3Label];
    [self modifyItemEvent:self.thirdButton imgView:self.thirdImageView firstTitle:self.thirdtitle1Label secondTitle:self.thirdtitle2Label thirdTitle:self.thirdtitle3Label];
    [self modifyItemEvent:self.fourthButton imgView:self.fourthImageView firstTitle:self.fourthtitle1Label secondTitle:self.fourthtitle2Label thirdTitle:self.fourthtitle3Label];
    self.firstButton.tag = PlusIMHundredConsult_FirstBtn_Tag;
    self.secondButton.tag = PlusIMHundredConsult_SecondBtn_Tag;
    self.thirdButton.tag = PlusIMHundredConsult_ThirdBtn_Tag;
    self.fourthButton.tag = PlusIMHundredConsult_FourthBtn_Tag;
    
    // 十 字交叉线
    self.horizonLineLabel.backgroundColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor];
    self.vLineLabel.backgroundColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor];
    
     // 我要提问
//    self.iaskButton.layer.cornerRadius = CGRectGetHeight(self.iaskButton.frame) / 2.0;
//    self.iaskButton.layer.borderWidth = 0.75;
//    self.iaskButton.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:1.0].CGColor;
//    [self.iaskButton setTitleColor:[UIColor DDR63_G162_B255ColorWithalph:1.0] forState:UIControlStateNormal];
//    self.iaskButton.titleLabel.font = [UIFont systemFontOfSize:FONT_UI20PX];
    
    //self.fourthtitle1Label.textColor = [UIColor DDR255_G138_B93ColorWithalph:1.0];
}


- (void)modifyItemEvent:(UIButton *)btn imgView:(UIImageView *)imgView firstTitle:(UILabel *)firstTitle secondTitle:(UILabel *)secondTitle thirdTitle:(UILabel *)thirdTitle{
    
    self.freeImageView.clipsToBounds = YES;
    imgView.clipsToBounds = YES;
    thirdTitle.font = [UIFont systemFontOfSize:FONT_UI20PX];
    thirdTitle.textColor = [UIColor DDR255_G138_B93ColorWithalph:1.0];
    secondTitle.font = [UIFont systemFontOfSize:FONT_UI20PX];
    secondTitle.textColor = [UIColor DDR102_G102_B102ColorWithalph:1.0];
    firstTitle.font = [UIFont systemFontOfSize:FONT_UI26PX];
    firstTitle.textColor = [UIColor DDR0_G0_B0ColorWithalph:1.0];
    
    [btn addTarget:self action:@selector(clickBtnPlus:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setCellItem:(NSArray *)infos{
    
    NSArray *questions = [infos firstObject];
//    NSArray *specials = [infos lastObject];
    
    NSArray *qimgViews = @[self.firstImageView,self.secondImageView,self.thirdImageView,self.fourthImageView];
    NSArray *qfirstLabels = @[self.firsttitle1Label,self.secondtitle1Label,self.thirdtitle1Label,self.fourthtitle1Label];
    NSArray *qsecondLabels = @[self.firsttitle2Label,self.secondtitle2Label,self.thirdtitle2Label,self.fourthtitle2Label];
    NSArray *qthirdLabels = @[self.firsttitle3Label,self.secondtitle3Label,self.thirdtitle3Label,self.fourthtitle3Label];
    
//    NSArray *simgViews = @[self.fourthImageView];
//    NSArray *sfirstLabels = @[self.fourthtitle1Label];
//    NSArray *ssecondLabels = @[self.fourthtitle2Label];
//    NSArray *sthirdLabels = @[self.fourthtitle3Label];
    
    if (questions.count > 0) {
        
        for (NSInteger cou1 = 0; cou1 < questions.count; cou1 ++) {
            
            HotPoint *f = questions[cou1];
            
            UIImageView *imgView = qimgViews[cou1];
            [imgView sd_setImageWithURL:[NSURL URLWithString:f.f_img]];
            
            UILabel *fLabel = qfirstLabels[cou1];
            [fLabel setText:f.f_title];
            
            UILabel *sLabel = qsecondLabels[cou1];
            [sLabel setText:f.f_sub_title];
            
            UILabel *tLabel = qthirdLabels[cou1];
            [tLabel setText:[NSString stringWithFormat:@"%@",f.f_follow_num]];
            
        }
    }
//    if (specials.count > 0) {
//        
//        for (NSInteger cou2 = 0; cou2 < 1; cou2 ++) {
//            HomeQASpecial *f = specials[cou2];
//            
//            UIImageView *imgView = simgViews[0];
//            [imgView sd_setImageWithURL:[NSURL URLWithString:f.head_url] placeholderImage:[UIImage imageNamed:@"homePage_tribe_post"]];
//            
//            UILabel *fLabel = sfirstLabels[cou2];
//            [fLabel setText:f.title];
//            
//            UILabel *sLabel = ssecondLabels[cou2];
//            [sLabel setText:f.desc];
//            
//            UILabel *tLabel = sthirdLabels[cou2];
//            [tLabel setText:@"200人关注"];
//            //[tBtn setTitle:@"我要提问" forState:UIControlStateNormal];
//            
//        }
//    }
    
    [self.freeImageView setImage:[UIImage imageNamed:@"home_question_free"]];
}

- (void)clickBtnPlus:(UIButton *)btn{

    NSLog(@" clickBtnPlus ----- > %ld",btn.tag);
    [[NSNotificationCenter defaultCenter] postNotificationName:HOMEPAGE_QUESTION_NOTIFICATION object:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
