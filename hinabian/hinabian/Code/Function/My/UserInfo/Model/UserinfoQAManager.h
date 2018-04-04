//
//  UserinfoQAManager.h
//  hinabian
//
//  Created by hnbwyh on 16/7/27.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserinfoQAManager;
@protocol UserinfoQAManagerDelegate <NSObject>
@optional
- (void) completeThenRefreshUserinfoQAWithDataSource:(NSArray *)data;

/**
 * 网络请求失败之后 view 回调关停刷新
 */
- (void)failureThenFinishRefreshUserinfoQA;

@end

@interface UserinfoQAManager : NSObject

@property (nonatomic,strong) id<UserinfoQAManagerDelegate> delegate;


/**
 * 获取个人中心 - 他的问答
 * start                - 本次请求开始位置
 * num                  - 本次请求获取个数
 */
- (void)requestUserinfoQADataWithStart:(NSInteger)start getCount:(NSInteger)num;

/* 设置supercontrol */
- (void)setUserinfoQASuperControl:(UIViewController *)supercontroller personid:(NSString *)personid;

@end
