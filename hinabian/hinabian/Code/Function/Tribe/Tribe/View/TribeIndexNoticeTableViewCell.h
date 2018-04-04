//
//  TribeIndexNoticeTableViewCell.h
//  hinabian
//
//  Created by 余坚 on 16/6/8.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString * cellNibName_TribeIndexNoticeCell = @"TribeIndexNoticeTableViewCell";
@interface TribeIndexNoticeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TribeIndexNoticeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *TribeIndexNoticeDescLabel;
@property (weak, nonatomic) IBOutlet UIImageView *TribeIndexNoticeIconImg;

- (void) setTribeIndexNoticeInfo:(NSString *)title HidenDesc:(BOOL)isHiden;
@end
