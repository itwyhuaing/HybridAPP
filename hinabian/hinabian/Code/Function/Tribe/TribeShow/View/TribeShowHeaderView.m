//
//  TribeShowHeaderView.m
//  hinabian
//
//  Created by hnbwyh on 16/6/7.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "TribeShowHeaderView.h"
#import "TribeShowBriefInfo.h"
#import "UILabel+YBAttributeTextTapAction.h"

@interface TribeShowHeaderView ()
@property (nonatomic,strong) TribeShowBriefInfo *currentModel;
@end

@implementation TribeShowHeaderView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    //self.tribeImgView.layer.cornerRadius = CGRectGetWidth(self.tribeImgView.frame) / 2.0;
    self.tribeImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.tribeImgView.clipsToBounds = YES;
    [self.tribeNameLabel setTextColor:[UIColor DDR51_G51_B51ColorWithalph:1.0]];
    [self.tribeNameLabel setFont:[UIFont systemFontOfSize:FONT_UI32PX]];
    
    [self.descLabel setTextColor:[UIColor DDR102_G102_B102ColorWithalph:1.0]];
    [self.descLabel setFont:[UIFont systemFontOfSize:FONT_UI28PX]];
    self.descLabel.numberOfLines = 0;
    self.careBtn.layer.cornerRadius = 6.0;
//    self.careBtn.layer.borderWidth = 1.0;
//    self.careBtn.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:1.0].CGColor;
    self.careBtn.backgroundColor = [UIColor DDR63_G162_B255ColorWithalph:1.0];
    [self.careBtn.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI26PX]];
    [self.careBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.careBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.careBtn addTarget:self action:@selector(clickEventCareBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // v2.8
    self.tribeHostNames.numberOfLines = 0;
    self.tribeHostNames.font = [UIFont systemFontOfSize:FONT_UI24PX];
    self.tribeHostTitle.font = [UIFont systemFontOfSize:FONT_UI24PX];
    self.tribeHostTitle.textColor = [UIColor DDR102_G102_B102ColorWithalph:1.0];
    self.tribeHostNames.textColor = [UIColor DDNavBarBlue];
    self.gapLabel.backgroundColor = [UIColor DDR245_G245_B245ColorWithalph:1.0];
    self.backgroundColor = [UIColor whiteColor];
    
//    
//    self.tribeHostView.backgroundColor = [UIColor whiteColor];
//    self.tribeHostNames.backgroundColor = [UIColor whiteColor];
//    self.tribeHostTitle.backgroundColor = [UIColor whiteColor];
//    self.descLabel.backgroundColor = [UIColor whiteColor];
    
    
}



- (void)setViewWithInfo:(TribeShowBriefInfo *)info{
    
    _currentModel = info;
    if (info == nil) {
        return;
    }
    [self.tribeImgView sd_setImageWithURL:[NSURL URLWithString:info.img_url]];
    self.tribeNameLabel.text = _currentModel.tribe_name;
    self.descLabel.text =_currentModel.desc;
    
    [self.posts setTitle:[HNBUtils numConvert:_currentModel.theme_num] forState:UIControlStateNormal];
    [self.cares setTitle:[HNBUtils numConvert:_currentModel.follow_num] forState:UIControlStateNormal];
    
    
    if ([_currentModel.is_followed isEqualToString:@"1"]) {
        [self.careBtn setTitle:@"已关注" forState:UIControlStateNormal];
        //NSLog(@" ------ > %i ======> %i",self.careBtn.isSelected,self.careBtn.selected);
    } else {
        [self.careBtn setTitle:@"关注" forState:UIControlStateNormal];
        //NSLog(@" ------ > %i ======> %i",self.careBtn.isSelected,self.careBtn.selected);
    }
    
    // Xcode 升级 8.0 之后   解决 UIImageView 无法正常显示
    self.tribeImgView.layer.cornerRadius = self.tribeImgViewConstraint.constant / 2.0;
    
    
//    if (_currentModel.tribeHostTextHeight <= 0) {
//
//        self.tribeHostTitle.hidden = YES;
//        self.tribeHostNames.hidden = YES;
//        self.tribeHostViewHeightConstranit.constant = 0.1;
//        self.gapLabelTopSpaceConstraint.constant = 0.1;
//        
//    } else{
//        
//        if (_currentModel.tribeHostTextHeight > 20) {
//            
//            self.tribeHostViewHeightConstranit.constant = _currentModel.tribeHostTextHeight;
//            CGRect tmpRect = self.tribeHostView.frame;
//            tmpRect.size.height = _currentModel.tribeHostTextHeight;
//            [self.tribeHostView setFrame:tmpRect];
//            
//        } else {
//            
//        }
//        
//        self.tribeHostNames.enabledTapEffect = NO;
//        NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:_currentModel.tribeHostString];
//        [textString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_UI24PX] range:NSMakeRange(0, _currentModel.tribeHostString.length)];
//        [textString addAttribute:NSForegroundColorAttributeName value:[UIColor DDNavBarBlue] range:NSMakeRange(0, _currentModel.tribeHostString.length)];
//        self.tribeHostNames.attributedText = textString;
//        [self.tribeHostNames yb_addAttributeTapActionWithStrings:_currentModel.tribeHostNames tapClicked:^(NSString *string, NSRange range, NSInteger index) {
//            
//            NSDictionary *dic = _currentModel.tribeHosts[index];
//            NSString *id_string = [dic valueForKey:@"id"];
//            NSLog(@" %ld --- %@  --- name: %@ --- id :%@",(long)index,string,[dic valueForKey:@"name"],id_string);
//            [[NSNotificationCenter defaultCenter] postNotificationName:TRIBESHOW_BRIEFINFO_TRIBEHOST_USERINFO_NOTIFICATION object:id_string];
//            
//        }];
//        
//    }
    
    if (_currentModel.tribeHostTextHeight <= 0) {
        
        self.tribeHostTitle.hidden = YES;
        self.tribeHostNames.hidden = YES;
        self.tribeHostViewHeightConstranit.constant = 0.1;
        self.gapTopSpaceConstraint.constant = 0.1;
        
    } else{

        if (_currentModel.tribeHostTextHeight - 22 > 0){
            
            self.tribeHostViewHeightConstranit.constant = _currentModel.tribeHostTextHeight;
            CGRect tmpRect = self.tribeHostView.frame;
            tmpRect.size.height = _currentModel.tribeHostTextHeight;
            [self.tribeHostView setFrame:tmpRect];
            self.tribeHostTitleHeightConstraint.constant = _currentModel.tribeHostTextHeight * 0.6;
            
        }
        
        self.tribeHostNames.enabledTapEffect = NO;
        NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:_currentModel.tribeHostString];
        [textString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_UI24PX] range:NSMakeRange(0, _currentModel.tribeHostString.length)];
        [textString addAttribute:NSForegroundColorAttributeName value:[UIColor DDNavBarBlue] range:NSMakeRange(0, _currentModel.tribeHostString.length)];
        self.tribeHostNames.attributedText = textString;
        [self.tribeHostNames yb_addAttributeTapActionWithStrings:_currentModel.tribeHostNames tapClicked:^(NSString *string, NSRange range, NSInteger index) {
            
            NSDictionary *dic = _currentModel.tribeHosts[index];
            NSString *id_string = [dic valueForKey:@"id"];
            //NSLog(@" %ld --- %@  --- name: %@ --- id :%@",(long)index,string,[dic valueForKey:@"name"],id_string);
            [[NSNotificationCenter defaultCenter] postNotificationName:TRIBESHOW_BRIEFINFO_TRIBEHOST_USERINFO_NOTIFICATION object:id_string];
            
            [HNBClick event:@"103051" Content:dic];
            
        }];
        
    }
    
    
    
    
    
}


- (void)clickEventCareBtn:(UIButton *)btn{

//    if (_currentModel == nil) {
//        return;
//    }
    
    NSDictionary *info = @{
                           @"model":_currentModel,
                           @"btn":btn
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TRIBESHOW_BRIEFINFO_CAREBUTTON_NOTIFICATION object:info];
    
}

@end
