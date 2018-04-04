//
//  NoticeItemTableViewCell.m
//  hinabian
//
//  Created by 余坚 on 15/10/8.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "NoticeItemTableViewCell.h"
#import "RDVTabBarController.h"

@implementation NoticeItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/* type 0 for activity  1 for tribe */
-(void) setNoticeItem:(NSString *) imageName  Title:(NSString *)titleString FunctionString:(NSString*)functionString Type:(int) intType;
{
    [_NoticeIconImage setImage:[UIImage imageNamed:imageName]];
    [_NoticeTitleLabel setText:titleString];
    [_NoticeFunctionLabel setText:functionString];

    
}


@end
