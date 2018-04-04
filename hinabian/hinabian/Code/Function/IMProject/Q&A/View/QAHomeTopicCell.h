//
//  QAHomeTopicCell.h
//  hinabian
//
//  Created by hnbwyh on 16/7/28.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerticalAligmentLabel.h"
#import "QuestionIndexItem.h"

static NSString *cellNib_QAHomeTopicCell = @"QAHomeTopicCell";
@interface QAHomeTopicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recommand;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet VerticalAligmentLabel *des;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vImageView;
@property (weak, nonatomic) IBOutlet UIButton *markImg;
@property (weak, nonatomic) IBOutlet UILabel *markLabels;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *lookButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recommendImgWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vImageViewLeadingUserName;

- (void)setQAHomeTopicCellWithModel:(QuestionIndexItem *)infoModel indexPath:(NSIndexPath *)indexPath;

@end
