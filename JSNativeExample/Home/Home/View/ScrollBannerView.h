//
//  ScrollBannerView.h
//  YHScrollBannerView
//
//  Created by wangyinghua on 2017/5/12.
//  Copyright © 2017年 wangyinghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollBannerView;
@protocol ScrollBannerViewDelegate <NSObject>
@optional
- (void)scrollBannerView:(ScrollBannerView *)banner didSelectedImageViewAtIndex:(NSInteger)index;

@end


@interface ScrollBannerView : UIView

@property (nonatomic,weak) id<ScrollBannerViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame autoPlayTimeInterval:(NSTimeInterval)ti;

- (void)reFreshBannerViewWithDataSource:(NSArray *)dataSource;

@end
