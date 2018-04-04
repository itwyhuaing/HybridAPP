//
//  BirdRefreshTopView.h
//  hinabian
//
//  Created by 余坚 on 16/8/4.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshViewDelegate.h"
#import "GIFImage.h"
#import "GIFImageView.h"

@interface BirdRefreshTopView : UIView<RefreshViewDelegate>
@property (nonatomic,strong)UIActivityIndicatorView * activityIndicatorView;
@property (nonatomic,strong)UIImageView * imageView;
@property (nonatomic,strong)UILabel * promptLabel;
//@property (nonatomic,strong)GIFImageView * imageFlashView ;

///重新布局
- (void)resetLayoutSubViews;

///松开可刷新
- (void)canEngageRefresh;
///松开返回
- (void)didDisengageRefresh;
///开始刷新
- (void)startRefreshing;
///结束
- (void)finishRefreshing;
@end
