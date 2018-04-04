//
//  RefreshBackFooter.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/31.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "RefreshBackFooter.h"
#import "GIFImageView.h"
#import "GIFImage.h"

@interface RefreshBackFooter ()

@property (weak, nonatomic) UILabel *msgLabel;
@property (weak, nonatomic) GIFImageView *gifImageV;

@end


@implementation RefreshBackFooter

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 48.0;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.msgLabel = label;
    
    // 添加 gif
    GIFImageView *gif = [[GIFImageView alloc] initWithImage:[GIFImage imageNamed:@"loading.gif"]];
    [self addSubview:gif];
    self.gifImageV = gif;
    
    
//self.backgroundColor = [UIColor greenColor];
//    self.msgLabel.backgroundColor = [UIColor redColor];
//    self.gifImageV.hidden = TRUE;
//    self.gifImageV.backgroundColor = [UIColor redColor];
//    self.msgLabel.hidden = TRUE;
    
    
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.msgLabel.frame = self.bounds;
    CGRect rect = CGRectZero;
    rect.size = CGSizeMake(30.0, 30.0);
    [self.gifImageV setFrame:rect];
    self.gifImageV.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5);
    
    self.msgLabel.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.0];
    self.msgLabel.font = [UIFont systemFontOfSize:FONT_UI28PX];
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.msgLabel.text = @"上拉刷新";
            break;
        case MJRefreshStatePulling:
            self.msgLabel.text = @"松开即可刷新";
            break;
        case MJRefreshStateRefreshing:
            self.msgLabel.text = @"正在努力加载中";
            break;
        case MJRefreshStateWillRefresh:
            NSLog(@" footer MJRefreshStateWillRefresh -");
            self.msgLabel.text = @"即将刷新";
            break;
        case MJRefreshStateNoMoreData:
            NSLog(@" footer MJRefreshStateNoMoreData - ");
            self.msgLabel.text = @"已加载更多数据";
            break;
            
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    // 1.0 0.5 0.0
    // 0.5 0.0 0.5
    CGFloat red = 1.0 - pullingPercent * 0.5;
    CGFloat green = 0.5 - 0.5 * pullingPercent;
    CGFloat blue = 0.5 * pullingPercent;
    self.msgLabel.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

#pragma mark ------ private method

- (void)modifyLableMsg:(NSString *)msg hidden:(BOOL)hs{
    self.msgLabel.hidden = hs;
    if(msg != nil || msg.length > 0){
        self.msgLabel.text = msg;
    }
}

- (void)modifyGifHidden:(BOOL)hs{
    self.gifImageV.hidden = hs;
}


@end
