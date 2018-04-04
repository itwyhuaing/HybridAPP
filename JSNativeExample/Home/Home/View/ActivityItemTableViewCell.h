//
//  ActivityItemTableViewCell.h
//  hinabian
//
//  Created by 余坚 on 15/10/8.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * cellNibName_ActivityItemTableViewCell = @"ActivityItemTableViewCell";
@interface ActivityItemTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *ActivityMainImage;
@property (strong, nonatomic) IBOutlet UIImageView *IsNewImage;
@property (strong, nonatomic) IBOutlet UILabel *ActivityTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *ActivitySeeButton;
@property (strong, nonatomic) IBOutlet UIButton *ActivityPressedButton;

@property (weak, nonatomic) UIViewController * superController;

-(void) setActivityItem:(NSString *) imageUrl  Title:(NSString *)titleString isNew:(BOOL)isNew See:(NSString *) seeNum Url:(NSString *)urlString;

@end
