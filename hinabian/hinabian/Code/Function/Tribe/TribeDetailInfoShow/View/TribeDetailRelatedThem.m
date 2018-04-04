//
//  TribeDetailRelatedThem.m
//  hinabian
//
//  Created by hnbwyh on 16/12/26.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "TribeDetailRelatedThem.h"
#import "TribeThemeModel.h"

@implementation TribeDetailRelatedThem

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_relativedThemLabel setTextColor:[UIColor DDR51_G51_B51ColorWithalph:1.f]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configContentsForCellWithDic:(TribeThemeModel *)infoDic{

    if (infoDic == nil) {
        return;
    }
//    NSString *string = nil;
//    if (infoDic != nil) {
//        string = [infoDic objectForKey:@"title"];
//    }
    [self.relativedThemLabel setText:infoDic.title];
    
}

@end
