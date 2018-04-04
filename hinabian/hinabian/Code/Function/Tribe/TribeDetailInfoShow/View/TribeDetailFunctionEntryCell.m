//
//  TribeDetailFunctionEntryCell.m
//  hinabian
//
//  Created by hnbwyh on 16/12/26.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "TribeDetailFunctionEntryCell.h"

@implementation TribeDetailFunctionEntryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_functionEntryLabel setTextColor:[UIColor DDR63_G162_B255ColorWithalph:1.f]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configContentsForCellWithString:(NSString *)string{

    [self.functionEntryLabel setText:string];
    
    
}


@end
