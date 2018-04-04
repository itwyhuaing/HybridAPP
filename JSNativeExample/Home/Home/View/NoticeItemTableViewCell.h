//
//  NoticeItemTableViewCell.h
//  hinabian
//
//  Created by 余坚 on 15/10/8.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * cellNibName_NoticeItemTableViewCell = @"NoticeItemTableViewCell";
@interface NoticeItemTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *NoticeIconImage;
@property (strong, nonatomic) IBOutlet UILabel *NoticeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *NoticeFunctionLabel;
@property (strong, nonatomic) IBOutlet UIButton *NoticePressButton;
@property (weak, nonatomic) UIViewController * superController;
-(void) setNoticeItem:(NSString *) imageName  Title:(NSString *)titleString FunctionString:(NSString*)functionString Type:(int) intType;
@end
