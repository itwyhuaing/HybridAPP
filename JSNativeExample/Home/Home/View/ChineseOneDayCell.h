//
//  ChineseOneDayCell.h
//  hinabian
//
//  Created by hnbwyh on 16/5/24.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeHotPost;

static NSString *cellNibName_ChineseOneDayCell = @"ChineseOneDayCell";
@interface ChineseOneDayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UIImageView *vImageView;

@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIButton *zanButton;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet UIButton *lookButton;

@property (weak, nonatomic) IBOutlet UIButton *chineseOneDayButton;

@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;

@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;

@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vImageViewLeadingUserName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstImageViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstImageViewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondImageViewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondImageViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdImageViewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdImageViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *icon_H;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *icon_W;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userName_H;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userName_W;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *title_H;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *time_H;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *time_W;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chineseOneDayButton_W;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chineseOneDayButton_H;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zanButtonWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentButtonWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lookButtonWidth;


- (void)setCellItemWithModel:(HomeHotPost *)infoModel  indexPath:(NSIndexPath *)indexPath;

@end
