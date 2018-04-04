//
//  TribeIndexMainManager.h
//  hinabian
//
//  Created by 余坚 on 16/6/8.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RefreshControl;
@protocol TribeIndexMainManagerDelegate;
@interface TribeIndexMainManager : NSObject
@property (weak, nonatomic) UIViewController * superController;

/*
 从服务器获取所有信息 - 下拉加载时同样调用该接口
 */
- (void)getAllInfoInTribeIndex:(RefreshControl *)refreshControll;
/* 上拉加载更多数据 -  帖子 */
- (void)getDataThenReload:(RefreshControl *)refreshControll;

@property (nonatomic, weak) id<TribeIndexMainManagerDelegate> delegate;
@end

@protocol TribeIndexMainManagerDelegate <NSObject>
@optional
-(void) completeDateThenReload;

/**
 * 携带总数 与 当前数据库数据
 *
 */
-(void) completeDateThenReloadWithIndexPosts:(NSArray *)tribes totalPostCount:(NSInteger)totalPostCount hotTribesReqStatus:(BOOL)hotTribesReqStatus hotPostReqStatus:(BOOL)hotPostReqStatus;

/**
 * 携带数据 - 请求状态
 */
-(void) completeDataThenReloadWithIndexTribes:(NSArray *)tribes tribePosts:(NSArray *)posts hotTribesReqStatus:(BOOL)hotTribesReqStatus hotPostReqStatus:(BOOL)hotPostReqStatus;


/**
 * 更新热门圈子信息
 */
- (void)updateHotTribesWithHotTribesReqStatus:(BOOL)reqStatus;

/**
 * 上拉请求帖子完毕
 *
 */
-(void) completePostDateThenReloadWithBottomPostsWithReqStatus:(BOOL)reqStatus;

/**
 * 网络请求失败，回调关闭刷新
 *
 */
- (void)failReqDataTribeThenEndRefreshWithReqStatus:(BOOL)reqStatus;

@end
