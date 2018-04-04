//
//  BottomReqMoreDataCell.m
//  hinabian
//
//  Created by hnbwyh on 16/11/1.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "BottomReqMoreDataCell.h"

@implementation BottomReqMoreDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _tipLabel.font = [UIFont systemFontOfSize:FONT_UI28PX];
    [_tipLabel setTextColor:[UIColor DDR51_G51_B51ColorWithalph:1.0]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
