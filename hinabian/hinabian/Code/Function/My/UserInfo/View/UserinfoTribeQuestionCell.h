//
//  UserinfoTribeQuestionCell.h
//  hinabian
//
//  Created by hnbwyh on 16/7/26.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VerticalAligmentLabel;

static NSString *cellNib_UserinfoTribeQuestionCell = @"UserinfoTribeQuestionCell";
@interface UserinfoTribeQuestionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet VerticalAligmentLabel *title;
@property (weak, nonatomic) IBOutlet UIButton *markButton;
@property (weak, nonatomic) IBOutlet UILabel *markLabels;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *contentImg;
@property (weak, nonatomic) IBOutlet UIButton *lookButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;


- (void)setUserinfoTribeQuestionCellWithModel:(id)infoModel;

@end
