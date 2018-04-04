//
//  TribeShowQAManager.h
//  hinabian
//
//  Created by hnbwyh on 17/4/17.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TribeShowQAManager;
@protocol TribeShowQAManagerDelegate <NSObject>
@optional
- (void) completeThenRefreshViewWithDataSource:(NSArray *)data;


/**
 * 网络请求失败之后 view 回调关停刷新
 */
- (void)failureThenFinishRefresh;

@end

@interface TribeShowQAManager : NSObject

@property (nonatomic,strong) id<TribeShowQAManagerDelegate> delegate;

/**
 * 获取问答
 * start                - 本次请求开始位置
 * num                  - 本次请求获取个数
 */
- (void)requestTribeShowQAViewDataWithStart:(NSInteger)start getCount:(NSInteger)num;

/* 设置supercontrol */
- (void) setSuperControl:(UIViewController *)supercontroller tribe:(NSString *)tribeId;

@end
