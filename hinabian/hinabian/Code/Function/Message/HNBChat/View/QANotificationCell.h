//
//  QANotificationCell.h
//  hinabian
//
//  Created by hnbwyh on 16/6/6.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *cellNibName_QANotificationCell = @"QANotificationCell";
@interface QANotificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *user;

@property (weak, nonatomic) IBOutlet UILabel *question;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *questionDesc;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userWidth;

- (void)setCellItem:(NSString *)time desc:(NSString *)desc;

@end
