//
//  PromotionCell.h
//  hinabian
//
//  Created by hnbwyh on 16/6/1.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeHotPost;

static NSString *cellNibName_PromotionCell = @"PromotionCell";
@interface PromotionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIImageView *promotionImgView;

@property (weak, nonatomic) IBOutlet UILabel *promotion;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promotionImgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promotionLabelHeight;

//@property (weak, nonatomic) IBOutlet UIImageView *icon;
//@property (weak, nonatomic) IBOutlet UILabel *userName;
//@property (weak, nonatomic) IBOutlet UILabel *desc;

- (void)setCellItemWithModel:(HomeHotPost *)infoModel indexPath:(NSIndexPath *)indexPath;

@end
