//
//  textUiTableViewCell.m
//  hinabian
//
//  Created by 余坚 on 16/11/1.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "textUiTableViewCell.h"

@implementation textUiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _pariseButton.layer.cornerRadius = 5;
    //_pariseButton.layer.masksToBounds = YES;
    _pariseButton.layer.borderWidth = 1.0f;
    _pariseButton.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    _pariseButton.layer.masksToBounds = YES;
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - 1, SCREEN_WIDTH, 0.8f);
    bottomBorder.backgroundColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
    [self.layer addSublayer:bottomBorder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setDataForTribeInfo:(TribeInfoByThemeIdModel *)f
{
    _tribeNameLabel.text = f.tribeName;
    _userNumLabel.text = [NSString stringWithFormat:@"关注 %@",f.userNum];
    _themeNumLabel.text = [NSString stringWithFormat:@"帖子 %@",f.themeNum];
    //NSLog(@"%@  %@  %@  %@  %@ ",f.triebId,f.tribeName,f.themeNum,f.userNum,f.statue);
    [_tribeNameButton addTarget:self action:@selector(tribeNameButtonBeenPressed) forControlEvents:UIControlEventTouchUpInside];
    [_pariseButton addTarget:self action:@selector(attentionButtonBeenPressed) forControlEvents:UIControlEventTouchUpInside];
    
    if (!f.statue) {
        [_pariseButton setTitle:@"关注" forState:UIControlStateNormal];
        [_pariseButton setTitleColor:[UIColor DDNavBarBlue] forState:UIControlStateNormal];
        _pariseButton.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    }
    else
    {
        [_pariseButton setTitle:@"已关注" forState:UIControlStateNormal];
        [_pariseButton setTitleColor:[UIColor DDCouponTextGray] forState:UIControlStateNormal];
        _pariseButton.layer.borderColor = [UIColor DDCouponTextGray].CGColor;
    }
}

- (void) tribeNameButtonBeenPressed
{
    if ([_delegate respondsToSelector:@selector(tribeButtonPressed)]) {
        [_delegate tribeButtonPressed];
        
        // 统计代码
        [HNBClick event:@"107057" Content:nil];
        
    }
}

- (void) attentionButtonBeenPressed
{
    if ([_delegate respondsToSelector:@selector(attentionButtonPressed)]) {
        [_delegate attentionButtonPressed];
    }
    
    [HNBClick event:@"107048" Content:nil];
}

@end
