//
//  UserinfoTribeAnswerCell.m
//  hinabian
//
//  Created by hnbwyh on 16/7/25.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "UserinfoTribeAnswerCell.h"
#import "VerticalAligmentLabel.h"
#import "UserInfoHisTribePost.h"

@implementation UserinfoTribeAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.title setTextColor:[UIColor DDR51_G51_B51ColorWithalph:1.0]]; // #333333
    self.title.font = [UIFont systemFontOfSize:FONT_UI32PX];
    
    self.bgView.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:0.2]; // #d8d8d8_0.2
    [self.content setTextColor:[UIColor DDR102_G102_B102ColorWithalph:1.0]]; //#666666
    self.content.font = [UIFont systemFontOfSize:FONT_UI28PX];
    self.content.verticalAlignment = VerticalAlignmentTop;
    self.content.numberOfLines = 0;
    
    [self.markLabels setTextColor:[UIColor colorWithRed:255.0/255.0 green:119.0/255.0 blue:66.0/255.0 alpha:1.0]]; // #ff7742
    [self.markLabels setFont:[UIFont systemFontOfSize:FONT_UI24PX]];
    
    [self.time setTextColor:[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0]]; // #aaaaaa
    [self.time setFont:[UIFont systemFontOfSize:FONT_UI22PX]];
    
    self.contentImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImgView.clipsToBounds = YES;
    
    //[self setColor];
}

-(void)setUserinfoTribeAnswerCellWithModel:(id)infoModel{

    UserInfoHisTribePost *f = (UserInfoHisTribePost *)infoModel;
    
    NSInteger tmpLen = f.comment_brief.length > 30 ? 30 : f.comment_brief.length;
    NSString *tmpString = [f.comment_brief substringWithRange:NSMakeRange(0, tmpLen)];
    
    [self.title setText:tmpString];
    [self.content setText:f.title];
    [self.markButton setBackgroundImage:[UIImage imageNamed:@"userinfo_mark_img"] forState:UIControlStateNormal];
    [self.markLabels setText:[NSString stringWithFormat:@"%@",f.tribe_name]];
    [self.contentImgView sd_setImageWithURL:[NSURL URLWithString:f.ess_img] placeholderImage:[UIImage imageNamed:@"homePage_tribe_post"]];
    [self.time setText:[NSString stringWithFormat:@"%@  评论",f.formated_time]];
    [self.lookButton setTitle:f.formated_view_num forState:UIControlStateNormal];
    [self.commentButton setTitle:f.comment_num forState:UIControlStateNormal];

}

- (void)setColor{
    
    self.title.backgroundColor = [UIColor purpleColor];
    self.markButton.backgroundColor = [UIColor purpleColor];
    self.markLabels.backgroundColor = [UIColor purpleColor];
    self.time.backgroundColor = [UIColor purpleColor];
    self.self.contentImgView.backgroundColor = [UIColor redColor];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
