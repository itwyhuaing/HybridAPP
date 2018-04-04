//
//  EditorViewCell.m
//  hinabian
//
//  Created by 何松泽 on 2017/6/6.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "EditorViewCell.h"
#import "PersonInfoModel.h"
#import "HNBClick.h"

@interface EditorViewCell ()

@property (nonatomic,strong) PersonInfoModel *currentModel;

@end

@implementation EditorViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.vImageView.hidden = YES;
    /*不能直接取头像的Frame,100.f为头像的直径，暂且为固定值*/
    self.headIcon.layer.cornerRadius = 40.f/2;
    self.headIcon.layer.masksToBounds = YES;
    self.headIcon.layer.borderWidth = 0.5f;
    self.headIcon.layer.borderColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:0.5].CGColor;
    self.headIcon.clipsToBounds = YES;
    self.headIcon.layer.shouldRasterize = YES;
    self.headIcon.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.careButton.layer.cornerRadius = 4.f;
    self.careButton.layer.masksToBounds = YES;
    self.careButton.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    self.careButton.layer.borderWidth = 0.5;
    self.careButton.tag = CareBtnTag;
    [self.careButton setTitleColor:[UIColor DDNavBarBlue] forState:UIControlStateNormal];
    [self.careButton addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headBtn.tag = HeadIconBtnTag;
    [self.headBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    self.contentLabel.textColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:0.5];
    
    self.vImageView.hidden = TRUE;
    self.careButton.hidden = TRUE;
    self.headIcon.hidden   = TRUE;
    self.headBtn.hidden    = TRUE;
    self.nameLabel.hidden  = TRUE;
    self.contentLabel.hidden = TRUE;
    self.levelImage.hidden = TRUE;
    self.vImageView.hidden = TRUE;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setViewWithPersonInfo:(id)info
{
    PersonInfoModel *f = (PersonInfoModel *)info;
    _currentModel = f;
    //用户头像与用户名
    if (f.head_url.length != 0) {
        [self.headIcon sd_setImageWithURL:[NSURL URLWithString:f.head_url]];
    }
    if (f.name.length == 0) {
        self.nameLabel.text = @"";
    }else{
        self.nameLabel.text = f.name;
    }
    
    //用户关注
    if ([f.isFollow isEqualToString:@"1"]) {
        [self.careButton setTitle:@"已关注" forState:UIControlStateNormal];
        [self.careButton setTitleColor:[UIColor DDR102_G102_B102ColorWithalph:1.0f] forState:UIControlStateNormal];
        self.careButton.layer.borderColor = [UIColor DDR102_G102_B102ColorWithalph:1.0].CGColor;
    }else{
        [self.careButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.careButton setTitleColor:[UIColor DDNavBarBlue] forState:UIControlStateNormal];
        self.careButton.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    }
    
    //等级
    if (f.level) {
        [self.levelImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"LV%@",f.level]]];
    }
    
    //个人介绍
    self.contentLabel.text = f.introduceForTribe;
    CGRect rect = [self.contentLabel.text boundingRectWithSize:CGSizeMake(self.contentLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_UI24PX]} context:nil];
    CGSize textSize = [self.contentLabel.text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FONT_UI24PX]}];
    NSUInteger textRow = (NSUInteger)(rect.size.height / textSize.height);
    if (textRow >= 2) {
        [self setContentWhileLongText];
    }
    
    //判断用户身份
    if ([f.type isEqualToString:@"special"]) {
        [self.vImageView setImage:[UIImage imageNamed:@"specialist"]];
        self.vImageView.hidden = NO;
        self.levelTrailingToView.constant = 30.f;
    }else{
        if (f.certified.length != 0){
            //认证用户
            if ([f.certified_type isEqualToString:@"authority"]) {
                [self.vImageView setImage:[UIImage imageNamed:@"authority"]];
            }else{
                [self.vImageView setImage:[UIImage imageNamed:@"tribe_talent"]];
            }
            self.vImageView.hidden = NO;
            self.levelTrailingToView.constant = 30.f;
        }else{
            //普通用户
            self.vImageView.hidden = YES;
            //不显示身份标签改变约束
            self.levelTrailingToView.constant = 5.f;
        }
    }
    
}

- (void)setContentWhileLongText
{
    self.contentLabel.numberOfLines = 2;
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
}

//- (void)modifyButton:(UIButton *)btn image:(UIImage *)image{
//    
//    [btn setAdjustsImageWhenHighlighted:NO];
//    [btn setBackgroundImage:[UIColor createImageWithColor:[UIColor DDR81_G197_B241ColorWithalph:1.f]] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIColor createImageWithColor:[UIColor DDR59_G189_B239ColorWithalph:1.f]] forState:UIControlStateHighlighted];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:FONT_UI28PX];
////    [btn setImage:image forState:UIControlStateNormal];
////    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 0)];
//    [btn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
//}

-(void)clickEvent:(UIButton *)btn
{
    if (_currentModel) {
        if (btn.tag == CareBtnTag) {
            
            [HNBClick event:@"107061" Content:nil];
            
            NSDictionary *info = @{
                                   @"btn":btn,
                                   @"model":_currentModel
                                   };
            [[NSNotificationCenter defaultCenter] postNotificationName:USERINFO_CAREBUTTON object:info];
            
            
        }else if (btn.tag == HeadIconBtnTag){
            
            [HNBClick event:@"107062" Content:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:USERINFO_HEADBUTTON object:_currentModel];
            
            
        }
    }else{
        return;
    }
    
}

-(void)setCellHidden:(BOOL)isHidden
{
    self.vImageView.hidden = isHidden;
    self.careButton.hidden = isHidden;
    self.headIcon.hidden   = isHidden;
    self.headBtn.hidden    = isHidden;
    self.nameLabel.hidden  = isHidden;
    self.contentLabel.hidden = isHidden;
    self.levelImage.hidden = isHidden;
    self.vImageView.hidden = isHidden;
}

@end
