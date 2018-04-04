//
//  TribeItemCell.h
//  hinabian
//
//  Created by hnbwyh on 16/5/25.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerticalAligmentLabel.h"

@class HomeHotPost;

static NSString *cellNibName_TribeItemCell = @"TribeItemCell";
@interface TribeItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UIImageView *tribeImgView;

@property (weak, nonatomic) IBOutlet UIImageView *vImageView;

@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;

@property (weak, nonatomic) IBOutlet UIImageView *creamImgView;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet VerticalAligmentLabel *title;

@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIButton *tribeItemButton;

@property (weak, nonatomic) IBOutlet UIButton *zanButton;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet UIButton *lookButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vImageViewLeadingUserName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tribeItemButtonwidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zanButtonWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentButtonWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lookButtonWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightConstraint;


- (void)setCellItemWithModel:(HomeHotPost *)infoModel indexPath:(NSIndexPath *)indexPath;

@end
