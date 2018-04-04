//
//  QAHomeQuestionCell.m
//  hinabian
//
//  Created by hnbwyh on 16/7/22.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "QAHomeQuestionCell.h"
#import "NSAttributedString+YYText.h"
#import "Label.h"

@interface QAHomeQuestionCell ()
{
    NSInteger type;
}

@end

@implementation QAHomeQuestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    type = EN_QA_INDEX_ANSWER;
    [self.recommand setImage:[UIImage imageNamed:@"tribe_top"]];
    [self.icon setImage:[UIImage imageNamed:@"index_icon_qianzheng"]];
    [self.markImg setBackgroundImage:[UIImage imageNamed:@"home_content_label"] forState:UIControlStateNormal];
    
    self.title.textColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0]; //#323232
    
    self.des.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]; //#666666
    self.markLabels.textColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0]; //#AAAAAA
    self.name.textColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0]; //#AAAAAA
    
    
    self.title.font = [UIFont systemFontOfSize:FONT_UI32PX];
    self.markLabels.font = [UIFont systemFontOfSize:FONT_UI22PX];
    self.name.font = [UIFont systemFontOfSize:FONT_UI22PX];
    self.icon.layer.cornerRadius = (18.f / 2.0) * SCREEN_SCALE;
    self.icon.layer.masksToBounds = TRUE;
    self.icon.contentMode = UIViewContentModeScaleAspectFill;
    self.des.numberOfLines = 0;
    self.des.textVerticalAlignment = YYTextVerticalAlignmentTop;
    
//    self.title.backgroundColor = [UIColor redColor];
//    self.des.backgroundColor = [UIColor orangeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellItemWithModel:(QuestionIndexItem *)infoModel indexPath:(NSIndexPath *)indexPath Type:(NSInteger)itype{
    type = itype;
    NSString *ishot = infoModel.ishot;
    
    NSString *answerInfo_name = infoModel.answername;
    NSString *description = infoModel.qadescription;

    if ([ishot isEqualToString:@"1"]) {
        self.recommandWidthConstraint.constant = 33.0;
        self.titleLeadingConstraint.constant = 50.0;
    } else {
        self.recommandWidthConstraint.constant = 0.1;
        self.titleLeadingConstraint.constant = 12.0;
    }
    self.title.text = infoModel.title;
    self.des.attributedText = [self handleTextAuthor:answerInfo_name content:description AnswerID:infoModel.answerid];
    NSArray * tmpLabelArray = Nil;
    tmpLabelArray = [infoModel.labels componentsSeparatedByString: @","];
    NSString *labelsAndTimeString = @"";
    NSUInteger index = 0;
    for (NSString * tmpString in tmpLabelArray) {
        if (index > 2) {
            break;
        }
        Label * f = [Label MR_findFirstByAttribute:@"value" withValue:tmpString];
        if (f != nil && ![f.name isEqualToString:@"null"] && f.name != nil) {
            labelsAndTimeString = [labelsAndTimeString stringByAppendingString:[NSString stringWithFormat:@"%@  ",f.name]];
        }
        index++;
    }
    if (infoModel != nil && ![infoModel.time isEqualToString:@"null"] && infoModel.time != nil) {
        labelsAndTimeString = [labelsAndTimeString stringByAppendingString:[NSString stringWithFormat:@"|  %@",infoModel.time]];
    }
    self.markLabels.text = labelsAndTimeString;//@"澳大利亚 圣基茨&尼维斯联邦 美国 | 5分钟前";
    self.name.text =  infoModel.username;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:infoModel.userhead_url] placeholderImage:[UIImage imageNamed:@"homePage_tribe_post"]];
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

- (void)setTribeShowCellItemWithModel:(TribeShowQAModel *)infoModel indexPath:(NSIndexPath *)indexPath Type:(NSInteger)itype{

    //NSLog(@" setCellItemWithModelAtindexPath ");
    type = itype;
    
    NSString *answerInfo_name = infoModel.answername;
    NSString *description = infoModel.qadescription;
    
    self.recommandWidthConstraint.constant = 0.1;
    self.titleLeadingConstraint.constant = 12.0;
    
    self.title.text = infoModel.title;
    self.des.attributedText = [self handleTextAuthor:answerInfo_name content:description AnswerID:infoModel.answerid];
    NSString *labelsAndTimeString = @"";
    NSArray *tmp_labels = (NSArray *)infoModel.labels;
    for (NSInteger index = 0; index < tmp_labels.count; index ++) {
        NSDictionary *dict = tmp_labels[index];
        labelsAndTimeString = [labelsAndTimeString stringByAppendingString:[NSString stringWithFormat:@"%@  ",[dict valueForKey:@"name"]]];
    }
    if (infoModel != nil && ![infoModel.time isEqualToString:@"null"] && infoModel.time != nil) {
        labelsAndTimeString = [labelsAndTimeString stringByAppendingString:[NSString stringWithFormat:@"|  %@",infoModel.time]];
    }
    self.markLabels.text = labelsAndTimeString;//@"澳大利亚 圣基茨&尼维斯联邦 美国 | 5分钟前";
    
    
    self.name.text =  infoModel.username;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:infoModel.userhead_url] placeholderImage:[UIImage imageNamed:@"homePage_tribe_post"]];
    [self.lookButton setTitle:[HNBUtils numConvert:infoModel.view_num] forState:UIControlStateNormal];
    [self.commentButton setTitle:[HNBUtils numConvert:infoModel.collect] forState:UIControlStateNormal];
    
    //NSLog(@" certified :%@ ,certified_type :%@ , level : %@",infoModel.certified,infoModel.certified_type,infoModel.level);
    
    
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

// 文本处理工具
- (NSMutableAttributedString *)handleTextAuthor:(NSString *)author content:(NSString *)content AnswerID:(NSString *)answerid{

    if ([author isEqualToString:@""] || [content isEqualToString:@""]) {
        NSMutableAttributedString *defaultText = [[NSMutableAttributedString alloc] initWithString:@"暂无回答"];
        [defaultText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f] range:NSMakeRange(0, defaultText.length)];
        return defaultText;
    }
    NSString *tmpString = [NSString stringWithFormat:@"%@：%@",author,content];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:tmpString];
    text.yy_font = [UIFont systemFontOfSize:14.0];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0];
    [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f] range:NSMakeRange(author.length, content.length+1)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor DDNavBarBlue] range:NSMakeRange(0, author.length+1)];
    
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setColor:[UIColor whiteColor]];
    highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
        if (type == EN_QA_INDEX_ANSWER) {
            [[NSNotificationCenter defaultCenter] postNotificationName:QA_SELECT_ANSWER_ID object:answerid];
        }
        else if(type == EN_QA_LABELS_QUESTION_ANSWER)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:QA_LABELS_SELECT_ANSWER_ID object:answerid];
        }
        else if(type == EN_TRIBESHOW_QA_INDEX){
            NSLog(@" --EN_TRIBESHOW_QA_INDEX-- ");
            [[NSNotificationCenter defaultCenter] postNotificationName:TRIBESHOW_QA_SELECT_ANSWER_ID_NOTIFICATION object:answerid];
        }else{
        
        }
        
    };
    [text yy_setTextHighlight:highlight range:NSMakeRange(0, author.length)];
    return text;
}

@end
