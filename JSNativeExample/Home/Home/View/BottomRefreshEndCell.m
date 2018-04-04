//
//  BottomRefreshEndCell.m
//  hinabian
//
//  Created by hnbwyh on 16/6/1.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "BottomRefreshEndCell.h"

@implementation BottomRefreshEndCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.bottomImageView.clipsToBounds = YES;
}


-(void)setCellItem{

    [self.bottomImageView setImage:[UIImage imageNamed:@"home_bottom_endRefresh"]];
    self.bottomImageViewWidth.constant = 110 * SCREEN_WIDTHRATE_6; // 110 104
    self.bottomImageViewHeight.constant = 104 * SCREEN_WIDTHRATE_6;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
