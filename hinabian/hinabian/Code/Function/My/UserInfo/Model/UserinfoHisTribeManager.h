//
//  UserinfoHisTribeManager.h
//  hinabian
//
//  Created by hnbwyh on 16/7/27.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserinfoHisTribeManager;
@protocol UserinfoHisTribeManagerDelegate <NSObject>
@optional
- (void) completeThenRefreshUserinfoHisTribeViewWithDataSource:(NSArray *)data;

/**
 * 网络请求失败之后 view 回调关停刷新
 */
- (void)failureThenFinishRefreshUserinfoHisTribeView;

@end

@interface UserinfoHisTribeManager : NSObject

@property (nonatomic,strong) id<UserinfoHisTribeManagerDelegate> delegate;


/**
 * 获取个人中心 - 他的圈子
 * start                - 本次请求开始位置
 * num                  - 本次请求获取个数
 */
- (void)requestUserinfoHisTribeViewDataWithStart:(NSInteger)start getCount:(NSInteger)num;

/* 设置supercontrol */
- (void)setUserinfoHisTribeViewSuperControl:(UIViewController *)supercontroller personid:(NSString *)personid;

@end
