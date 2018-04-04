//
//  TribeShowMainManager.h
//  hinabian
//
//  Created by hnbwyh on 16/6/12.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TribeShowBriefInfo;

@class TribeShowMainManager;
@protocol TribeShowMainManagerDelegate <NSObject>
@optional
//@property (nonatomic) BOOL tribeInfoReqStatus; // 圈子详情
//@property (nonatomic) BOOL hotestPostInfoReqStatus; // 最热帖子
/**
 * 网络请求(不含上拉刷新)之后的 view 回调
 * model - 具体圈子头部信息
 * data  - 表格数据源 
 */
-(void) completeDateThenRefreshViewWithHeadModel:(TribeShowBriefInfo *)model dataSource:(NSArray *)data tribeInfoReqStatus:(BOOL)tribeInfoReqStatus hotestPostInfoReqStatus:(BOOL)hotestPostInfoReqStatus;

/** v2.8 Tab 依据数据判断是否显示 问答 与 项目
 * 网络请求(不含上拉刷新)之后的 view 回调
 **/
-(void) completeDateThenRefreshViewWithHeadModel:(TribeShowBriefInfo *)model
                                    qaDataSource:(NSArray *)qaData
                                    proDataSource:(NSArray *)proData
                                   hotDataSource:(NSArray *)hotData
                              qaReqStatus:(BOOL)qaReqStatus
                              proReqStatus:(BOOL)proReqStatus
                              tribeInfoReqStatus:(BOOL)tribeInfoReqStatus
                         hotestPostInfoReqStatus:(BOOL)hotestPostInfoReqStatus;


/**
 * 更新圈子简介回调
 **/
-(void) completeDateThenRefreshHeaderViewWithHeadModel:(TribeShowBriefInfo *)model tribeInfoReqStatus:(BOOL)tribeInfoReqStatus;


/**
 * 更新圈子简介失败回调
 **/
- (void)failReqHeaderViewDataWithTribeInfoReqStatus:(BOOL)tribeInfoReqStatus;

/**
 * Tab 下内容数据回调
 **/
- (void)reqFirstPageDagta:(NSArray *)dataArr reqStatus:(BOOL)reqStatus tabIndex:(NSString *)tabIndex;

@end

@interface TribeShowMainManager : NSObject

@property (nonatomic,weak) id<TribeShowMainManagerDelegate> delegate;


/* 设置supercontrol */
- (void) setSuperControl:(UIViewController *)supercontroller entryTribe:(NSString *)tribeId;

/**
 * 第一次进入圈子信息简介 及 最热 数据
 * num       - 取得的信息条数
 * tribeID   - 圈子标识
 ****/
- (void)requestDataWithGetCount:(NSInteger)num tribeId:(NSString *)tribeID;

/**
 * 界面的每次出现都要更新界面
 **/
- (void)requestHeaderDataWithTribeId:(NSString *)tribeID;

@end
