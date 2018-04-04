//
//  UserinfoHisPostManager.h
//  hinabian
//
//  Created by 何松泽 on 16/12/20.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserinfoHisPostManager;
@protocol UserinfoHisPostManagerDelegate <NSObject>
@optional
- (void) completeThenRefreshUserinfoHisPostViewWithDataSource:(NSArray *)data;

/**
 * 网络请求失败之后 view 回调关停刷新
 */
- (void)failureThenFinishRefreshUserinfoHisPostView;

@end

@interface UserinfoHisPostManager : NSObject

@property (nonatomic,strong) id<UserinfoHisPostManagerDelegate> delegate;


/**
 * 获取个人中心 - 他的圈子
 * start                - 本次请求开始位置
 * num                  - 本次请求获取个数
 */
- (void)requestUserinfoHisPostViewDataWithStart:(NSInteger)start getCount:(NSInteger)num;

/* 设置supercontrol */
- (void)setUserinfoHisPostViewSuperControl:(UIViewController *)supercontroller personid:(NSString *)personid;

@end
