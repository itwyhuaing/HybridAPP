//
//  PushSetTableViewCell.m
//  hinabian
//
//  Created by 余坚 on 15/12/8.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "PushSetTableViewCell.h"

@implementation PushSetTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

-(void) setTitle:(NSString *) title
{
    self.nameLabel.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
