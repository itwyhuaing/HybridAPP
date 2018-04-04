//
//  PersonalHeadImageItemTableViewCell.h
//  hinabian
//
//  Created by 余坚 on 15/7/2.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString * cellNibName_PersonalHeadImageItemTableViewCell = @"PersonalHeadImageItemTableViewCell";
@interface PersonalHeadImageItemTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;

-(void) setImageView:(UIImage *)headImage;

@end
