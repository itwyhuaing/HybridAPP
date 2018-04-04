//
//  BubbleLabel.m
//  hinabian
//
//  Created by 何松泽 on 2018/1/3.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "BubbleLabel.h"
#import "UIView+BubbleBadge.h"

@implementation BubbleLabel

+ (instancetype)defaultLabel
{
    return [[BubbleLabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.textColor = [UIColor whiteColor];
    self.font = [UIFont systemFontOfSize:FONT_UI28PX];
    self.textAlignment = NSTextAlignmentCenter;
    self.layer.cornerRadius = self.b_height * 0.5;
    self.layer.masksToBounds = YES;
    
    self.backgroundColor = [UIColor colorWithRed:1.00 green:0.17 blue:0.15 alpha:1.00];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    // 根据内容调整label的宽度
    CGFloat stringWidth = [self widthForString:text font:self.font height:self.b_height];
    if (self.b_height > stringWidth + self.b_height*10/18) {
        self.b_width = self.b_height;
        return;
    }
    self.b_width = self.b_height*5/18/*left*/ + stringWidth + self.b_height*5/18/*right*/;
}

- (CGFloat)widthForString:(NSString *)string font:(UIFont *)font height:(CGFloat)height
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.width;
}

@end
