/*
 耗时操作一般都是网络请求。
 第一步：耗时操作开始前(网络请求前)添加 loading 相应参数按要求传入
 [[HNBLoadingMask shareManager] loadingMaskWithSuperView:<#(UIView *)#> loadingMaskType:<#(LoadingMaskType)#> yoffset:<#(CGFloat)#>];
 
 第二步：耗时操作结束后（网络请求结束后成功或失败）移除 loading 
 [[HNBLoadingMask shareManager] dismiss];
 
 */
//
//  HNBLoadingMask.h
//  hinabian
//
//  Created by hnbwyh on 16/7/12.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

typedef enum : NSUInteger {
    LoadingMaskTypeNormal = 10,
    LoadingMaskTypeExtendNavBar,
    LoadingMaskTypeExtendTabBar,
    LoadingMaskTypeExtendNavBarAndTabBar
} LoadingMaskType;

#import <UIKit/UIKit.h>

@interface HNBLoadingMask : UIView

/** 指示 loading 当前的状态 
 * TRUE - 展示 , FALSE - 消失
 */
@property (nonatomic,assign) BOOL isStatus;

/**
 * 单例对象
 */
+ (instancetype)shareManager;

/**
 * 添加 loading
 * superV   - 父视图
 * type     - 是否覆盖导航栏 、状态栏及底部标签栏
 * yoffset  - 顶部偏移
 */
- (void)loadingMaskWithSuperView:(UIView *)superV loadingMaskType:(LoadingMaskType)type yoffset:(CGFloat)yoffset;

/**
 * 移除 loading
 */
- (void)dismiss;

@end
