//
//  CountDownTimeView.m
//  hinabian
//
//  Created by hnbwyh on 16/5/26.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "CountDownTimeView.h"

@interface CountDownTimeView ()
@property (nonatomic) CGSize selSize;
@end

@implementation CountDownTimeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        
    }
    return self;
}

- (void)setViewType:(TipViewType)type disPlay:(NSDictionary *)info{
    self.backgroundColor = [UIColor DDR0_G0_B0ColorWithalph:0.4];
    [self positRadiusCorners];
    
    _selSize = self.frame.size;
    if (type == CountDownTimer) {
        [self setCountDowmTimeView];
    } else {
        [self setActivityStateView:type];
    }
}

- (void)setCountDowmTimeView{

    CGRect rect = CGRectZero;
    rect.size.height = _selSize.height;
    rect.size.width = 31;
    self.timeTitle = [[UILabel alloc] initWithFrame:rect];
    [self addSubview:self.timeTitle];
    
    rect.origin.y = 3;
    rect.origin.x = CGRectGetMaxX(self.timeTitle.frame);
    rect.size.width = 13;
    rect.size.height = _selSize.height - 2.0 * rect.origin.y;
    self.hour = [[UILabel alloc] initWithFrame:rect];
    [self addSubview:self.hour];
    
    rect.origin.x = CGRectGetMaxX(self.hour.frame);
    rect.size.width = 6;
    self.hm_gapFlag = [[UILabel alloc] initWithFrame:rect];
    [self addSubview:self.hm_gapFlag];
    
    rect.origin.x = CGRectGetMaxX(self.hm_gapFlag.frame);
    rect.size.width = 13;
    self.min = [[UILabel alloc] initWithFrame:rect];
    [self addSubview:self.min];
    
    rect.origin.x = CGRectGetMaxX(self.min.frame);
    rect.size.width = 6;
    self.ms_gapFlag = [[UILabel alloc] initWithFrame:rect];
    [self addSubview:self.ms_gapFlag];
    
    rect.origin.x = CGRectGetMaxX(self.ms_gapFlag.frame);
    rect.size.width = 13;
    self.second = [[UILabel alloc] initWithFrame:rect];
    [self addSubview:self.second];
    
    self.timeTitle.backgroundColor = [UIColor clearColor];
    self.hour.backgroundColor = [UIColor whiteColor];
    self.min.backgroundColor = [UIColor whiteColor];
    self.second.backgroundColor = [UIColor whiteColor];
    self.timeTitle.textColor = [UIColor whiteColor];
    self.hm_gapFlag.textColor = [UIColor whiteColor];
    self.ms_gapFlag.textColor = [UIColor whiteColor];
    self.hour.textColor = [UIColor blackColor];
    self.min.textColor = [UIColor blackColor];
    self.second.textColor = [UIColor blackColor];
    self.timeTitle.font = [UIFont systemFontOfSize:FONT_UI18PX];
    self.hour.font = [UIFont systemFontOfSize:FONT_UI18PX];
    self.min.font = [UIFont systemFontOfSize:FONT_UI18PX];
    self.second.font = [UIFont systemFontOfSize:FONT_UI18PX];
    self.hm_gapFlag.font = [UIFont systemFontOfSize:FONT_UI18PX];
    self.ms_gapFlag.font = [UIFont systemFontOfSize:FONT_UI18PX];
    self.timeTitle.textAlignment = NSTextAlignmentCenter;
    self.hour.textAlignment = NSTextAlignmentCenter;
    self.hm_gapFlag.textAlignment = NSTextAlignmentCenter;
    self.min.textAlignment = NSTextAlignmentCenter;
    self.ms_gapFlag.textAlignment = NSTextAlignmentCenter;
    self.second.textAlignment = NSTextAlignmentCenter;
    
    self.timeTitle.text = @"倒计时";
    self.hm_gapFlag.text = @":";
    self.ms_gapFlag.text = @":";
    
}


- (void)uPDateDisplayView:(CountDownTimeView *)tipView seconds:(NSInteger)sec{

    NSString *h = [NSString stringWithFormat:@"%ld",sec / 3600];
    NSString *m = [NSString stringWithFormat:@"%ld",(sec % 3600) / 60];
    NSString *s = [NSString stringWithFormat:@"%ld",sec % 60];
    self.hour.text = [self keepTwoBit:h];
    self.min.text = [self keepTwoBit:m];
    self.second.text = [self keepTwoBit:s];
}

- (void)setActivityStateView:(TipViewType)type{

    CGRect rect = CGRectZero;
    rect.size = _selSize;
    self.timeTitle = [[UILabel alloc] initWithFrame:rect];
    [self addSubview:self.timeTitle];
    self.timeTitle.textColor = [UIColor whiteColor];
    self.timeTitle.backgroundColor = [UIColor clearColor];
    self.timeTitle.font = [UIFont systemFontOfSize:FONT_UI18PX];
    self.timeTitle.textAlignment = NSTextAlignmentCenter;
    [self uPDateDisplayActivityState:type];
}

// 活动处于不同状态
- (void)uPDateDisplayActivityState:(TipViewType)type{
    
    switch (type) {
        case ActivityStateStart:
        {
            
        }
            break;
        case ActivityStateOn:
        {
            self.timeTitle.text = @"进行中，赶快来围观";
        }
            break;
        case ActivityStateEnd:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

// 保证时间是 两位 数字显示
- (NSString *)keepTwoBit:(NSString *)realStr{
    
     NSString *tmp = nil;
    if (realStr.length  == 1) {
        tmp = [NSString stringWithFormat:@"0%@",realStr];
    } else {
        tmp = realStr;
    }
    return tmp;
}

- (void)positRadiusCorners{

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(RRADIUS_LAYERCORNE, RRADIUS_LAYERCORNE)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
}


@end
