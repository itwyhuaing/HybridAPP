//
//  UserinfoTribeAnswerCell.h
//  hinabian
//
//  Created by hnbwyh on 16/7/25.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VerticalAligmentLabel;

static NSString *cellNib_UserinfoTribeAnswerCell = @"UserinfoTribeAnswerCell";
@interface UserinfoTribeAnswerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet VerticalAligmentLabel *content;
@property (weak, nonatomic) IBOutlet UIButton *markButton;
@property (weak, nonatomic) IBOutlet UILabel *markLabels;
@property (weak, nonatomic) IBOutlet UIButton *lookButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

- (void)setUserinfoTribeAnswerCellWithModel:(id)infoModel;

@end
