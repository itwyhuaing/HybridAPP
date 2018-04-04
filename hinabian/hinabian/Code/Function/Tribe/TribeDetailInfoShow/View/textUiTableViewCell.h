//
//  textUiTableViewCell.h
//  hinabian
//
//  Created by 余坚 on 16/11/1.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TribeInfoByThemeIdModel.h"


@protocol textUiTableViewCellDelegate <NSObject>
@optional
- (void) attentionButtonPressed;
- (void) tribeButtonPressed;
@end
static NSString * cellNibName_textUiTableViewCellCell = @"textUiTableViewCell";
@interface textUiTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *tribeNameButton;
@property (weak, nonatomic) IBOutlet UILabel *tribeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *themeNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *pariseButton;
@property (nonatomic,weak) id<textUiTableViewCellDelegate>delegate;
- (void) setDataForTribeInfo:(TribeInfoByThemeIdModel *)f;
@end
