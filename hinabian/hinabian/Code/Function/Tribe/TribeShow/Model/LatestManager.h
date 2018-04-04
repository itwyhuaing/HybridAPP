//
//  LatestManager.h
//  hinabian
//
//  Created by hnbwyh on 16/6/22.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LatestManager;
@protocol LatestManagerDelegate <NSObject>
@optional
- (void) completeThenRefreshViewWithDataSource:(NSArray *)data;



/**
 * 网络请求失败之后 view 回调关停刷新
 */
- (void)failureThenFinishRefresh;
@end

@interface LatestManager : NSObject

@property (nonatomic,weak) id<LatestManagerDelegate> delegate;

/**
 * 获取最新帖子
 * start                - 本次请求开始位置
 * num                  - 本次请求获取个数
 */
- (void)requestLatestViewDataWithStart:(NSInteger)start getCount:(NSInteger)num;

/* 设置supercontrol */
- (void) setSuperControl:(UIViewController *)supercontroller tribe:(NSString *)tribeId;

@end
