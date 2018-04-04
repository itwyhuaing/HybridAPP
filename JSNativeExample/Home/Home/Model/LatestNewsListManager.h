//
//  LatestNewsListManager.h
//  hinabian
//
//  Created by hnbwyh on 2017/10/18.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CountDataPerReq 20

@class LatestNewsListManager;
@protocol LatestNewsListManagerDelegate <NSObject>
@optional
/**
 *
 *  dataSource : 数据
 *  br : TRUE - 底部上拉刷新。   FALSE  - 顶部下拉刷新
 *  total : 列表一共有多少
 *  isSame: 更新最新数据时前后两次是否一样
 ***/
- (void)latestNewsListReqNetSucWithDataSource:(id)dataSource
                                        total:(NSInteger)total
                                       isSame:(BOOL)isSame
                              isBottomRefresh:(BOOL)br;

- (void)latestNewsListReqNetFailWithError:(NSError *)error reqStatus:(BOOL)rs;

@end

@interface LatestNewsListManager : NSObject

@property (nonatomic,weak) id <LatestNewsListManagerDelegate> delegate;

- (void)reqLatestNewsListDataStart:(NSInteger)start count:(NSInteger)count;

@end
