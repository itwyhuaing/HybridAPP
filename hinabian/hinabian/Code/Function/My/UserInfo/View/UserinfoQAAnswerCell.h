//
//  UserinfoQAAnswerCell.h
//  hinabian
//
//  Created by hnbwyh on 16/7/26.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *cellNib_UserinfoQAAnswerCell = @"UserinfoQAAnswerCell";
@interface UserinfoQAAnswerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *anwser;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *lookButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;


- (void)setUserinfoQAAnswerCellWithModel:(id)infoModel;

@end
