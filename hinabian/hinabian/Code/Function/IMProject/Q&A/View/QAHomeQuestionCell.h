//
//  QAHomeQuestionCell.h
//  hinabian
//
//  Created by hnbwyh on 16/7/22.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionIndexItem.h"
#import "TribeShowQAModel.h"
#import "YYText.h"

static NSString *cellNilName_QAHomeQuestionCell = @"QAHomeQuestionCell";
static NSString *cellNilName_QAHomeQuestionCell_TribeShow = @"QAHomeQuestionCell_tribeshow";
@interface QAHomeQuestionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recommand;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet YYLabel *des;

@property (weak, nonatomic) IBOutlet UIButton *markImg;

@property (weak, nonatomic) IBOutlet UILabel *markLabels;

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIButton *lookButton;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recommandWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeadingConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vImageViewLeadingUserName;

@property (weak, nonatomic) IBOutlet UIImageView *vImageView;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;

// 问答首页
- (void)setCellItemWithModel:(QuestionIndexItem *)infoModel indexPath:(NSIndexPath *)indexPath  Type:(NSInteger)itype;

// 具体圈子 - 问答
- (void)setTribeShowCellItemWithModel:(TribeShowQAModel *)infoModel indexPath:(NSIndexPath *)indexPath Type:(NSInteger)itype;

@end
