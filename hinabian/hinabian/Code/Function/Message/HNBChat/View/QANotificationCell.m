//
//  QANotificationCell.m
//  hinabian
//
//  Created by hnbwyh on 16/6/6.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "QANotificationCell.h"

@implementation QANotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setColor];
    
    [self modifyCell];
    
}


- (void)modifyCell{

    [self.user setTextColor:[UIColor DDR255_G138_B93ColorWithalph:1.0]];
    [self.user setFont:[UIFont systemFontOfSize:FONT_UI28PX]];
    
    [self.question setTextColor:[UIColor DDR153_G153_B153ColorWithalph:1.0]];
    [self.question setFont:[UIFont systemFontOfSize:FONT_UI28PX]];
    
    [self.time setTextColor:[UIColor DDR153_G153_B153ColorWithalph:1.0]];
    [self.time setFont:[UIFont systemFontOfSize:FONT_UI20PX]];
    self.time.textAlignment = NSTextAlignmentRight;
    
    [self.questionDesc setTextColor:[UIColor DDR51_G51_B51ColorWithalph:1.0]];
    [self.questionDesc setFont:[UIFont systemFontOfSize:FONT_UI32PX]];
    
}


- (void)setCellItem:(NSString *)time desc:(NSString *)desc{

    [self.user setText:@"欧阳李军"];
    [self.question setText:@"回答了该问题"];
    [self.time setText:time];
    [self.questionDesc setText:desc];
    
    // 拿到名字，修改长度
    CGSize userSize = [self.user.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_UI28PX]}];
    self.userWidth.constant = userSize.width;
}



- (void)setColor{

    self.user.backgroundColor = [UIColor greenColor];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
