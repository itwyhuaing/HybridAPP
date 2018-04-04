//
//  UIView+BubbleBadge.m
//  hinabian
//
//  Created by 何松泽 on 2018/1/3.
//  Cobyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "UIView+BubbleBadge.h"
#import "BubbleLabel.h"
#import <objc/runtime.h>

static NSString *const kBubbleLabel = @"kBubbleLabel";

@interface UIView ()

@property (nonatomic, strong) BubbleLabel *bubbleLabel;

@end

@implementation UIView (BubbleBadge)

- (void)setBubbleBadgeWithText:(NSString *)text
{
    [self lazyLoadBubbleLabel];
    [self showBadge];
    self.bubbleLabel.text = text;
}

- (void)setBubbleBadgeWithNumber:(NSInteger)number
{
    if (number <= 0) {
        [self hideBadge];
        return;
    }else if (number >= 99) {
        [self setBubbleBadgeWithText:[NSString stringWithFormat:@"99+"]];
        [self showBadge];
        return;
    }else {
        [self setBubbleBadgeWithText:[NSString stringWithFormat:@"%ld",(long)number]];
        [self showBadge];
        return;
    }
}

- (void)setBubbleBadgeWithColor:(UIColor *)color
{
    [self setBubbleBadgeWithText:nil];
    [self setBubbleHeightPoint:12];
    if (color) {
        self.bubbleLabel.backgroundColor = color;
    }
}

- (void)setBubbleFont:(UIFont *)font
{
    [self.bubbleLabel setFont:font];
}

- (void)setBubbleAttributes:(NSAttributedString *)attributedString
{
    [self.bubbleLabel setAttributedText:attributedString];
}

- (void)moveBadgeWithX:(CGFloat)x Y:(CGFloat)y
{
    [self lazyLoadBubbleLabel];
    
    /**
     如果通过badge的center来调整其在父视图的位置, 在给badge赋值不同长度的内容时
     会导致badge会以中心点向两边调整其自身宽度,如果badge过长会遮挡部分父视图, 所以
     正确的方式是以badge的x坐标为起点,其宽度向x轴正方向增加/x轴负方向减少
     */
    self.bubbleLabel.b_x = (self.b_width - self.bubbleLabel.b_height*0.5)/*badge的x坐标*/ + x;
    self.bubbleLabel.b_y = -self.bubbleLabel.b_height*0.5/*badge的y坐标*/ + y;
}

- (void)setBubbleHeightPoint:(CGFloat)points
{
    CGFloat scale = points/self.bubbleLabel.b_height;
    self.bubbleLabel.transform = CGAffineTransformScale(self.bubbleLabel.transform, scale, scale);
}

- (void)showBadge
{
    self.bubbleLabel.hidden = NO;
}

- (void)hideBadge
{
    self.bubbleLabel.hidden = YES;
}

- (void)increase
{
    [self increaseBy:1];
}

- (void)increaseBy:(NSInteger)number
{
    NSInteger result = self.bubbleLabel.text.integerValue + number;
    if (result > 0) {
        [self showBadge];
    }
    self.bubbleLabel.text = [NSString stringWithFormat:@"%ld",result];
}

- (void)decrease
{
    [self decreaseBy:1];
}

- (void)decreaseBy:(NSInteger)number
{
    NSInteger result = self.bubbleLabel.text.integerValue - number;
    if (result <= 0) {
        [self hideBadge];
        self.bubbleLabel.text = @"0";
        return;
    }
    self.bubbleLabel.text = [NSString stringWithFormat:@"%ld",result];
}

- (void)lazyLoadBubbleLabel
{
    if (!self.bubbleLabel) {
        self.bubbleLabel = [BubbleLabel defaultLabel];
        self.bubbleLabel.center = CGPointMake(self.b_width, 0);
        [self addSubview:self.bubbleLabel];
        [self bringSubviewToFront:self.bubbleLabel];
    }
}

#pragma mark - setter/getter方法(category中要使用关联对象)
- (BubbleLabel *)bubbleLabel
{
    return objc_getAssociatedObject(self,&kBubbleLabel);
}

- (void)setBubbleLabel:(BubbleLabel *)bubbleLabel
{
    objc_setAssociatedObject(self, &kBubbleLabel, bubbleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)bubble_value
{
    return self.bubbleLabel.text;
}

@end


@implementation UIView (BubbleFrame)

- (CGFloat)b_x
{
    return self.frame.origin.x;
}
- (void)setB_x:(CGFloat)b_x
{
    CGRect frame = self.frame;
    frame.origin.x = b_x;
    self.frame = frame;
}

- (CGFloat)b_y
{
    return self.frame.origin.y;
}
- (void)setB_y:(CGFloat)b_y
{
    CGRect frame = self.frame;
    frame.origin.y = b_y;
    self.frame = frame;
}

- (CGFloat)b_right
{
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setB_right:(CGFloat)b_right
{
    CGRect frame = self.frame;
    frame.origin.x = b_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)b_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setB_bottom:(CGFloat)b_bottom
{
    CGRect frame = self.frame;
    frame.origin.y = b_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)b_width
{
    return self.frame.size.width;
}
- (void)setB_width:(CGFloat)b_width
{
    CGRect frame = self.frame;
    frame.size.width = b_width;
    self.frame = frame;
}

- (CGFloat)b_height
{
    return self.frame.size.height;
}
- (void)setB_height:(CGFloat)b_height
{
    CGRect frame = self.frame;
    frame.size.height = b_height;
    self.frame = frame;
}

- (CGFloat)b_centerX
{
    return self.center.x;
}
- (void)setB_centerX:(CGFloat)b_centerX
{
    self.center = CGPointMake(b_centerX, self.center.y);
}

- (CGFloat)b_centerY
{
    return self.center.y;
}
- (void)setB_centerY:(CGFloat)b_centerY
{
    self.center = CGPointMake(self.center.x, b_centerY);
}
@end
