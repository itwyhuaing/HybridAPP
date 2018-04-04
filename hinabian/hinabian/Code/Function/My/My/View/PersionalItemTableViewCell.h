//
//  PersionalItemTableViewCell.h
//  hinabian
//
//  Created by 余坚 on 15/6/15.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString * cellNibName_PersonalItemCell = @"PersionalItemTableViewCell";
@interface PersionalItemTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeLabelWidth;


-(void) setDataForItem:(NSString *)titleString IconImage:(NSString *) image hideNotice:(NSString *)noticeString;
@end
