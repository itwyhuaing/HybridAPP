//
//  PersonalInfoItemTableViewCell.m
//  hinabian
//
//  Created by 余坚 on 15/7/2.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "PersonalInfoItemTableViewCell.h"

@implementation PersonalInfoItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setTitleAndContent:(NSString *)titleString content:(NSString *)contentString
{
    if (SCREEN_WIDTH == SCREEN_WIDTH_5S) {
    
        self.contentLabel.font = [UIFont systemFontOfSize:FONT_UI30PX];
    
    }else{
    
        self.contentLabel.font = [UIFont systemFontOfSize:FONT_UI32PX];
    
    }
    self.contentLabelTrailingConstraint.constant = 10.0;
    
    self.titleLabel.text = titleString;
    self.contentLabel.text = contentString;
    
    //NSLog(@" ------ > %@ ------ > %@",contentString,titleString);
    
}

@end
