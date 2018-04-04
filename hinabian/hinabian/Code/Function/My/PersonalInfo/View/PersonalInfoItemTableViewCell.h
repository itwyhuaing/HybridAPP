//
//  PersonalInfoItemTableViewCell.h
//  hinabian
//
//  Created by 余坚 on 15/7/2.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * cellNibName_PersonalInfoItemTableViewCell = @"PersonalInfoItemTableViewCell";
@interface PersonalInfoItemTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelTrailingConstraint;


-(void) setTitleAndContent:(NSString *)titleString content:(NSString *)contentString;

@end
