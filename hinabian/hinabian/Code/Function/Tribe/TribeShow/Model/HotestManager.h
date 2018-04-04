//
//  HotestManager.h
//  hinabian
//
//  Created by hnbwyh on 16/6/22.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HotestManager;
@protocol HotestManagerDelegate <NSObject>
@optional
- (void) completeThenRefreshViewWithDataSource:(NSArray *)data;


/**
 * 网络请求失败之后 view 回调关停刷新
 */
- (void)failureThenFinishRefresh;

@end


@interface HotestManager : NSObject


@property (nonatomic,strong) id<HotestManagerDelegate> delegate;

/**
 * 获取最热
 * start                - 本次请求开始位置
 * num                  - 本次请求获取个数
 */
- (void)requestHotViewDataWithStart:(NSInteger)start getCount:(NSInteger)num;

/* 设置supercontrol */
- (void) setSuperControl:(UIViewController *)supercontroller tribe:(NSString *)tribeId;

@end
