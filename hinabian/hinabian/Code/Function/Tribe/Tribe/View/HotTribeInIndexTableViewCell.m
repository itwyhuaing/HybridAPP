//
//  HotTribeInIndexTableViewCell.m
//  hinabian
//
//  Created by 余坚 on 16/6/8.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "HotTribeInIndexTableViewCell.h"
#import "TribeIndexHotTribe.h"

#define HOT_TRIBE_BASE_TAG  30

@implementation HotTribeInIndexTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _FirstImage.clipsToBounds = YES;
    _FirstImage.layer.cornerRadius = CGRectGetHeight(_FirstImage.frame) / 2.0;
    
    _SecondImage.clipsToBounds = YES;
    _SecondImage.layer.cornerRadius = CGRectGetHeight(_SecondImage.frame) / 2.0;
    
    _ThirdImage.clipsToBounds = YES;
    _ThirdImage.layer.cornerRadius = CGRectGetHeight(_ThirdImage.frame) / 2.0;
    
    _FourthImage.clipsToBounds = YES;
    _FourthImage.layer.cornerRadius = CGRectGetHeight(_FourthImage.frame) / 2.0;
    
    _FifthImage.clipsToBounds = YES;
    _FifthImage.layer.cornerRadius = CGRectGetHeight(_FifthImage.frame) / 2.0;
    
    _SixthImage.clipsToBounds = YES;
    _SixthImage.layer.cornerRadius = CGRectGetHeight(_SixthImage.frame) / 2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/* 设置数据 */
- (void) setHotTirbeInfo:(NSArray *)tribeInfoArray
{
        if (tribeInfoArray != NULL) {
            if (tribeInfoArray.count < 5) {
                return;
            }
            TribeIndexHotTribe * first = tribeInfoArray[0];
            [_FirstImage sd_setImageWithURL:[NSURL URLWithString:first.img_url] placeholderImage:[UIImage imageNamed:@"loading_image"]];
            _FirstTitleLabel.text = first.name;
            [_FirstThemeNum setTitle:first.theme_num forState:UIControlStateNormal];
            [_FirstFollowNum setTitle:first.follow_num forState:UIControlStateNormal];
    
            TribeIndexHotTribe * second = tribeInfoArray[1];
            [_SecondImage sd_setImageWithURL:[NSURL URLWithString:second.img_url] placeholderImage:[UIImage imageNamed:@"loading_image"]];
            _SecondTitleLabel.text = second.name;
            [_SecondThemeNum setTitle:second.theme_num forState:UIControlStateNormal];
            [_SecondFollowNum setTitle:second.follow_num forState:UIControlStateNormal];
    
            TribeIndexHotTribe * third = tribeInfoArray[2];
            [_ThirdImage sd_setImageWithURL:[NSURL URLWithString:third.img_url] placeholderImage:[UIImage imageNamed:@"loading_image"]];
            _ThirdTitleLabel.text = third.name;
            [_ThirdThemeNum setTitle:third.theme_num forState:UIControlStateNormal];
            [_ThirdFollowNum setTitle:third.follow_num forState:UIControlStateNormal];
    
            TribeIndexHotTribe * fourth = tribeInfoArray[3];
            [_FourthImage sd_setImageWithURL:[NSURL URLWithString:fourth.img_url] placeholderImage:[UIImage imageNamed:@"loading_image"]];
            _FourthTitleLabel.text = fourth.name;
            [_FourthThemeNum setTitle:fourth.theme_num forState:UIControlStateNormal];
            [_FourthFollowNum setTitle:fourth.follow_num forState:UIControlStateNormal];
    
            TribeIndexHotTribe * fifth = tribeInfoArray[4];
            [_FifthImage sd_setImageWithURL:[NSURL URLWithString:fifth.img_url] placeholderImage:[UIImage imageNamed:@"loading_image"]];
            _FifthTitleLabel.text = fifth.name;
            [_FifthThemeNum setTitle:fifth.theme_num forState:UIControlStateNormal];
            [_FifthFollowNum setTitle:fifth.follow_num forState:UIControlStateNormal];
            
            [_FirstTribeButton addTarget:self action:@selector(tribeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_SecondTribeButton addTarget:self action:@selector(tribeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_ThirdTribeButton addTarget:self action:@selector(tribeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_FourthTribeButton addTarget:self action:@selector(tribeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_FifthTribeButton addTarget:self action:@selector(tribeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_SixthTribeButton addTarget:self action:@selector(tribeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
        }
}

-(void) tribeButtonPressed:(UIButton *)sender
{
    NSInteger tag =  sender.tag - HOT_TRIBE_BASE_TAG;
    [[NSNotificationCenter defaultCenter] postNotificationName:TRIBE_INDEX_HOT_TRIBE_NOTIFICATION object:[NSString stringWithFormat:@"%ld",(long)tag]];
}

@end
