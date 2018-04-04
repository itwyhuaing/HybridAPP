//
//  PushSetTableViewCell.h
//  hinabian
//
//  Created by 余坚 on 15/12/8.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * cellNibName_PushSetTableViewCell = @"PushSetTableViewCell";

@interface PushSetTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UISwitch *choseSwitch;

-(void) setTitle:(NSString *) title;
@end
