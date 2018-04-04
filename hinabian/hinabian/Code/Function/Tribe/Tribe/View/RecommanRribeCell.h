//
//  RecommanRribeCell.h
//  hinabian
//
//  Created by hnbwyh on 16/6/6.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VerticalAligmentLabel;
@class HomeHotPost;
@class TribeIndexItem;
@class DetailTribeHotestitem;
@class DetailTribeLatestitem;

static NSString *cellNibName_RecommanRribeCell = @"RecommanRribeCell";
@interface RecommanRribeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UIImageView *tribeImgView;

@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet VerticalAligmentLabel *title;

@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIButton *tribeItemButton;

@property (weak, nonatomic) IBOutlet UIButton *zanButton;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet UIButton *lookButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tribeItemButtonwidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zanButtonWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentButtonWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lookButtonWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vImageViewLeadingUserName;

@property (weak, nonatomic) IBOutlet UIImageView *recommandImgView;

@property (weak, nonatomic) IBOutlet UIImageView *creamImgView;

@property (weak, nonatomic) IBOutlet UIImageView *vImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *creamImgLeadingRecommand;


- (void)setCellItemWithIndexTribeModel:(TribeIndexItem *)infoModel indexPath:(NSIndexPath *)indexPath;

// 具体一个圈子里的最热帖子
- (void)setCellItemWithDetailTribeHotestModel:(DetailTribeHotestitem *)infoModel indexPath:(NSIndexPath *)indexPath;
// 具体一个圈子里的最新帖子
- (void)setCellItemWithDetailTribeLatestModel:(DetailTribeLatestitem *)infoModel indexPath:(NSIndexPath *)indexPath;

@end
