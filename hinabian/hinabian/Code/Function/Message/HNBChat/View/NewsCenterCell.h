//
//  NewsCenterCell.h
//  hinabian
//
//  Created by hnbwyh on 16/6/3.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsCenterModel;

static NSString *cellNibName_NewsCenterCell = @"NewsCenterCell";
@interface NewsCenterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;

@property (weak, nonatomic) IBOutlet UILabel *itemTitle;

@property (weak, nonatomic) IBOutlet UILabel *newsDesc;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *newsNum;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newsNumWidth;

- (void)setCellItemWithInfoModel:(NewsCenterModel *)infoModel;

@end
