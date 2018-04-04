//
//  UserinfoQAAnswerCell.m
//  hinabian
//
//  Created by hnbwyh on 16/7/26.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "UserinfoQAAnswerCell.h"
#import "UserInfoHisQAPost.h"

@interface UserinfoQAAnswerCell ()

@property (nonatomic,strong) UserInfoHisQAPost *currentModel;

@end

@implementation UserinfoQAAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.title setTextColor:[UIColor DDR51_G51_B51ColorWithalph:1.0]]; // #333333
    [self.title setFont:[UIFont systemFontOfSize:FONT_UI32PX]];
    
    [self.anwser setTextColor:[UIColor DDR102_G102_B102ColorWithalph:1.0]]; //#666666
    self.anwser.font = [UIFont systemFontOfSize:FONT_UI28PX];
    
    [self.time setTextColor:[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0]]; // #aaaaaa
    [self.time setFont:[UIFont systemFontOfSize:FONT_UI22PX]];
}

-(void)setUserinfoQAAnswerCellWithModel:(id)infoModel{

    UserInfoHisQAPost *f = (UserInfoHisQAPost *)infoModel;
    _currentModel = f;
    
    self.title.text = f.title;
    [self.lookButton setTitle:f.view_num forState:UIControlStateNormal];
    [self.commentButton setTitle:f.answer_num forState:UIControlStateNormal];
    
    if ([f.type isEqualToString:@"answer"]) {
        
        self.anwser.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:0.2]; // #D8d8d8_0.2
        self.anwser.text = [NSString stringWithFormat:@"  %@",f.comment_brief];
        self.time.text = [NSString stringWithFormat:@"%@  回答",f.formated_time];
        
    } else {
        
        self.anwser.backgroundColor = [UIColor whiteColor];
        self.anwser.text = f.content;
        self.time.text = [NSString stringWithFormat:@"%@  提问",f.formated_time];
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
