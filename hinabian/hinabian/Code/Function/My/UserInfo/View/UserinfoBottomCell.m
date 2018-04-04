//
//  UserinfoBottomCell.m
//  hinabian
//
//  Created by hnbwyh on 16/7/27.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "UserinfoBottomCell.h"

@implementation UserinfoBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.tipLabel setTextColor:[UIColor DDR102_G102_B102ColorWithalph:1.0]]; //#666666
    self.tipLabel.font = [UIFont systemFontOfSize:FONT_UI28PX];
    self.tipLabel.backgroundColor = [UIColor DDR245_G245_B245ColorWithalph:1.0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
