//
//  LookAllAssessRltCell.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/26.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "LookAllAssessRltCell.h"

@implementation LookAllAssessRltCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell{
    self.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc] init];
    [self addSubview:title];
    
    title.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self)
    .topEqualToView(self);
    
    title.font = [UIFont systemFontOfSize:FONT_UI26PX];
    title.textColor = [UIColor DDR113_G113_B113ColorWithalph:1.0];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"查看全部评估结果";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
