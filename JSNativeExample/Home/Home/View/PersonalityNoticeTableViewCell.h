//
//  PersonalityNoticeTableViewCell.h
//  hinabian
//
//  Created by 余坚 on 17/4/12.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * cellNibName_PersonalityNoticeTableViewCell = @"PersonalityNoticeTableViewCell";
@interface PersonalityNoticeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *noticeImage;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIButton *noticeButton;
@property (weak, nonatomic) IBOutlet UIButton *pressButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NoticeLabelCenterX;
@property (nonatomic) NSString * type;
- (void) setPersonalityNoticeItem:(NSString *)noticeString stringColor:(UIColor *)stringColor BackGroundColor:(UIColor *)backGroundColor Type:(NSString *)type;
- (void) setItemShow:(BOOL) isshow;
@end
