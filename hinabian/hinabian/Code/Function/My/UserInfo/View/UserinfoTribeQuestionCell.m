//
//  UserinfoTribeQuestionCell.m
//  hinabian
//
//  Created by hnbwyh on 16/7/26.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "UserinfoTribeQuestionCell.h"
#import "VerticalAligmentLabel.h"
#import "UserInfoHisTribePost.h"

@implementation UserinfoTribeQuestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title.verticalAlignment = VerticalAlignmentTop;
    [self.title setTextColor:[UIColor DDR51_G51_B51ColorWithalph:1.0]]; // #333333
    [self.title setFont:[UIFont systemFontOfSize:FONT_UI28PX]]; // FONT_UI32PX
    self.title.verticalAlignment = VerticalAlignmentTop;
    self.title.numberOfLines = 0;
    
    [self.markLabels setTextColor:[UIColor colorWithRed:255.0/255.0 green:119.0/255.0 blue:66.0/255.0 alpha:1.0]]; // #ff7742
    [self.markLabels setFont:[UIFont systemFontOfSize:FONT_UI24PX]];
    
    [self.markButton setBackgroundImage:[UIImage imageNamed:@"userinfo_mark_img"] forState:UIControlStateNormal];
    
    [self.time setTextColor:[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0]]; // #aaaaaa
    [self.time setFont:[UIFont systemFontOfSize:FONT_UI22PX]];
    
    self.contentImg.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImg.clipsToBounds = YES;

}
 
-(void)setUserinfoTribeQuestionCellWithModel:(id)infoModel{

    UserInfoHisTribePost *f = (UserInfoHisTribePost *)infoModel;

    [self.title setText:f.title];
    [self.time setText:[NSString stringWithFormat:@"%@  发表",f.formated_time]];
    [self.markLabels setText:[NSString stringWithFormat:@"%@",f.tribe_name]];
    [self.lookButton setTitle:f.formated_view_num forState:UIControlStateNormal];
    [self.commentButton setTitle:f.comment_num forState:UIControlStateNormal];
    [self.contentImg sd_setImageWithURL:[NSURL URLWithString:f.ess_img] placeholderImage:[UIImage imageNamed:@"homePage_tribe_post"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
