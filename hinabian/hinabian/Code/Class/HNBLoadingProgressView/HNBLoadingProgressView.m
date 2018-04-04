//
//  HNBLoadingProgressView.m
//  hinabian
//
//  Created by 何松泽 on 2017/11/7.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "HNBLoadingProgressView.h"

static const CGFloat HLoadingProgressViewItemMargin = 15;
static const CGFloat HLoadingProgressViewBorderLineWidth = 6;

@implementation HNBLoadingProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    if (progress >= 1.0f) {
        [self removeFromSuperview];
    }else {
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //获取中心点
    CGFloat centerX = rect.size.width * 0.5;
    CGFloat centerY = rect.size.height * 0.5;
    
    //设置线宽
    CGContextSetLineWidth(context, HLoadingProgressViewBorderLineWidth);
    
    //设置目标角度
    CGFloat to = M_PI * 2 * _progress;
    CGFloat radius = MIN(centerX, centerY) - HLoadingProgressViewItemMargin;
    
    //添加路径
    CGContextAddArc(context, centerX, centerY, radius, 0, to, 0);
    //设置填充颜色
    [[UIColor DDNavBarBlue] set];
    CGContextStrokePath(context);
    
    //添加路径2
    CGContextAddArc(context, centerX, centerY, radius, to, M_PI * 2, 0);
    [[UIColor whiteColor] set];
    CGContextStrokePath(context);
    
    //加载时显示的文字
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:FONT_UI40PX];
    
    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    NSInteger p = _progress * 100;
    NSString *showText = [NSString stringWithFormat:@"%ld",(long)p];
    showText = [showText stringByAppendingString:@"%"];
    [self setCenterProgressText:showText withAttributes:attributes];
}

#pragma mark 设置加载时显示的文字
- (void)setCenterProgressText:(NSString *)text withAttributes:(NSDictionary *)attributes
{
    CGFloat centerX = self.frame.size.width * 0.5;
    CGFloat centerY = self.frame.size.height * 0.5;
    
    CGSize strSize;
    NSAttributedString *attrStr = nil;
    if (attributes[NSFontAttributeName]) {
        strSize = [text sizeWithAttributes:@{NSFontAttributeName:attributes[NSFontAttributeName]}];
        attrStr = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    } else {
        strSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontSize]]}];
        attrStr = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]}];
    }
    
    CGFloat strX = centerX - strSize.width * 0.5;
    CGFloat strY = centerY - strSize.height * 0.5;
    
    [attrStr drawAtPoint:CGPointMake(strX, strY)];
}

#pragma mark 清除指示器
- (void)dismiss
{
    self.progress = 1.0f;
}

+ (id)progressView
{
    return [[self alloc] init];
}

@end
