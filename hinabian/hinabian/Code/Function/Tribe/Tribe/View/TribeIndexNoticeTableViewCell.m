//
//  TribeIndexNoticeTableViewCell.m
//  hinabian
//
//  Created by 余坚 on 16/6/8.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "TribeIndexNoticeTableViewCell.h"

@implementation TribeIndexNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _TribeIndexNoticeIconImg.contentMode = UIViewContentModeRight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTribeIndexNoticeInfo:(NSString *)title HidenDesc:(BOOL)isHiden
{
    _TribeIndexNoticeTitleLabel.text = title;
    if (isHiden) {
        _TribeIndexNoticeDescLabel.hidden = TRUE;
        _TribeIndexNoticeIconImg.hidden = TRUE;
    }
    else
    {
        _TribeIndexNoticeDescLabel.hidden = FALSE;
        _TribeIndexNoticeIconImg.hidden = FALSE;
    }
}

@end
