//
//  UIView+BubbleBadge.h
//  hinabian
//
//  Created by 何松泽 on 2018/1/3.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BubbleLabel;
@interface UIView (BubbleBadge)

@property (nonatomic, readonly) NSString *bubble_value;

/**
 * pagram(text) 设置badge文本
 */
- (void) setBubbleBadgeWithText:(NSString *)text;

/**
 * pagram(number) 设置badge数字（建议使用，便于使用加减方法）
 */
- (void) setBubbleBadgeWithNumber:(NSInteger)number;

/**
 * pagram(color) 设置badge颜色
 */
- (void) setBubbleBadgeWithColor:(UIColor *)color;

/**
 * pagram(font) 设置badge字体
 */
- (void)setBubbleFont:(UIFont *)font;

/**
 * pagram(attributedString) 设置bubble样式
 */
- (void) setBubbleAttributes:(NSAttributedString *)attributedString;

/**
 设置Bubble的高度,因为Bubble宽度是动态可变的,通过改变Bubble高度,其宽度也按比例变化,方便布局
 
 (注意: 此方法需要将Bubble初始化后再调用!!!)
 
 * pagram(points) 高度大小
 */
- (void) setBubbleHeightPoint:(CGFloat)points;

/**
 设置Bubble的偏移量, Bubble中心点默认为其父视图的右上角
 
 Set Badge offset, Badge center point defaults to the top right corner of its parent view
 
 @param x X轴偏移量 (x<0: 左移, x>0: 右移) axis offset (x <0: left, x> 0: right)
 @param y Y轴偏移量 (y<0: 上移, y>0: 下移) axis offset ( Y <0: up, y> 0: down)
 */
- (void) moveBadgeWithX:(CGFloat)x Y:(CGFloat)y;

// 手动隐藏badge
- (void)hideBadge;
// 手动显示badge
- (void)showBadge;

#pragma mark -- 仅适用于设置badge数字下

/**
 * pagram(number) 设置加的数字
 */
- (void)increase;
- (void)increaseBy:(NSInteger)number;

/**
 * pagram(number) 设置减的数字
 */
- (void)decrease;
- (void)decreaseBy:(NSInteger)number;

@end


@interface UIView (BubbleFrame)
@property (nonatomic, assign) CGFloat b_x;
@property (nonatomic, assign) CGFloat b_y;
@property (nonatomic, assign) CGFloat b_right;
@property (nonatomic, assign) CGFloat b_bottom;
@property (nonatomic, assign) CGFloat b_width;
@property (nonatomic, assign) CGFloat b_height;
@property (nonatomic, assign) CGFloat b_centerX;
@property (nonatomic, assign) CGFloat b_centerY;
@end
