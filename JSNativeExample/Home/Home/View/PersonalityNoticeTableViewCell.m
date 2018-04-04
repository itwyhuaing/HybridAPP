//
//  PersonalityNoticeTableViewCell.m
//  hinabian
//
//  Created by 余坚 on 17/4/12.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "PersonalityNoticeTableViewCell.h"

@implementation PersonalityNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    if (SCREEN_WIDTH <= SCREEN_WIDTH_5S) {
//        _ImageTOLeft.constant = 12.0f;
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setPersonalityNoticeItem:(NSString *)noticeString stringColor:(UIColor *)stringColor BackGroundColor:(UIColor *)backGroundColor Type:(NSString *)type
{
    if([type isEqualToString:@"0"])
    {
        if (SCREEN_WIDTH <= SCREEN_WIDTH_5S) {
            _NoticeLabelCenterX.constant  = 16.f;
        }
        else
        {
            _NoticeLabelCenterX.constant = 20.f;
        }
        [_pressButton addTarget:self action:@selector(clickTribeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([type isEqualToString:@"1"])
    {
        if (SCREEN_WIDTH <= SCREEN_WIDTH_5S) {
            _NoticeLabelCenterX.constant = 22.f;
        }
        else
        {
            _NoticeLabelCenterX.constant = 26.f;
        }
        [_pressButton addTarget:self action:@selector(clickTribeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
        if(![[HNBUtils sandBoxGetInfo:[NSString class] forKey:BINDING_PHONENUM_BACKGROUNDCOLOR] isEqualToString:@""] && [HNBUtils sandBoxGetInfo:[NSString class] forKey:BINDING_PHONENUM_BACKGROUNDCOLOR]){
            backGroundColor = [UIColor colorWithHexString:[HNBUtils sandBoxGetInfo:[NSString class] forKey:BINDING_PHONENUM_BACKGROUNDCOLOR]];
        }
        if (![[HNBUtils sandBoxGetInfo:[NSString class] forKey:BINDING_PHONENUM_TEXTCOLOR] isEqualToString:@""] && [HNBUtils sandBoxGetInfo:[NSString class] forKey:BINDING_PHONENUM_TEXTCOLOR]) {
            stringColor = [UIColor colorWithHexString:[HNBUtils sandBoxGetInfo:[NSString class] forKey:BINDING_PHONENUM_TEXTCOLOR]];
        }
        if (![[HNBUtils sandBoxGetInfo:[NSString class] forKey:BINDING_PHONENUM_CONTENT] isEqualToString:@""] && [HNBUtils sandBoxGetInfo:[NSString class] forKey:BINDING_PHONENUM_CONTENT]) {
            noticeString = [HNBUtils sandBoxGetInfo:[NSString class] forKey:BINDING_PHONENUM_CONTENT];
        }
        [self.noticeImage setImage:[UIImage imageNamed:@"person_icon_alert"]];
        if (SCREEN_WIDTH <= SCREEN_WIDTH_5S)
        {
            _NoticeLabelCenterX.constant = -5.f;
        }
        else if (SCREEN_WIDTH <= SCREEN_WIDTH_6)
        {
            _NoticeLabelCenterX.constant = -30.f;
        }
        else
        {
            _NoticeLabelCenterX.constant = -50.f;
        }
        [_pressButton addTarget:self action:@selector(clickCloseInPersonMain) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.contentView setBackgroundColor:backGroundColor                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    ];
    [self.noticeLabel setText:noticeString];
    [self.noticeLabel setTextColor:stringColor];
    _type = type;
}

- (void) setItemShow:(BOOL) isshow
{
    _noticeLabel.hidden = !isshow;
    _noticeImage.hidden = !isshow;
    _noticeButton.hidden = !isshow;
}

- (void)clickCloseInPersonMain{
    [self setItemShow:FALSE];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BINDING_PHONENUM_CANCEL object:nil];
}

- (void)clickTribeBtn:(UIButton *)btn{
    
    // NSLog(@" clickTribeBtn ------ > %ld",btn.tag);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HOME_PERSONALITY_NOTICE_CANCLE object:_type];
}

@end
