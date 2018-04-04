//
//  HNBHomePageManager.h
//  hinabian
//
//  Created by hnbwyh on 2017/10/18.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProjectStateModel;

/**
 * 当前网络请求结果
 */
typedef enum : NSUInteger {
    HomePage30NetReqStatusAllFailure = 60,
    HomePage30NetReqStatusPartFailure,
    HomePage30NetReqStatusAllSuccession,
} HomePage30NetReqStatus;


@class HNBHomePageManager;
@protocol HNBHomePageManagerManagerDelegate <NSObject>
@optional

/**
 * 首页上半屏数据回调 - banner 、 功能区、快讯、评估、推荐专家、海外课堂
 *
 */
- (void)homePageReqDataSucWithBannerData:(NSArray *)bannerData
                          preferredplans:(NSArray *)planData
                               funcData:(NSArray *)funcData
                          hnbServiceData:(NSArray *)hnbServiceData
                           thirdPartData:(NSArray *)thirdPartData
                             lastedNews:(NSArray *)lastedNews
                            rcmspecials:(NSArray *)rcmspecials
                             rcmActData:(id)rcmActModel
                               hotTopic:(id)topicModel
                            netReqStatus:(HomePage30NetReqStatus)netReqStatus
                                 classes:(NSArray *)classes;

/**
 * 首页下半屏数据回调 - 推荐活动 、热门话题、大咖说
 */
- (void)homePageReqDataSucWithGreatTalks:(NSArray *)greatTalks
                            editorTalks:(NSArray *)editorTalks;

/**
 * 首页最佳方案数据回调
 */
- (void)homePageReqDataSucWithPreferredplans:(NSArray *)planData;

/**
 * 首页更新用户信息回调刷新首页样式
 */
- (void)homePageUpdateUserInfoThenModifyHomePageStyle;

/**
 * 更新完毕后设置未读消息数
 */
- (void)homePageSetUnReadMessageCount;

/**
 * 显示咨询按钮
 */
- (void)showConsultingButton;

/**
 * 判断是否显示引导页
 */
- (void)isShowIMGuideView;

/**
 * 请求到数据后刷新界面
 * countString      已有多少人评估过
 * data             装载跳转移民评估页所需的一些数据
 * isAssessed       该用户是否已经评估过
 **/
- (void)completeDataThenRefreshImAssessRemindViewWithCount:(NSString *)countString isAssessed:(BOOL)isAssessed;


/**
 * 首页项目进度通知
 */
-(void)updateProjectStateNoticeThenReloadViewWithData:(ProjectStateModel *)data;

@end


@interface HNBHomePageManager : NSObject

@property (nonatomic,weak) id <HNBHomePageManagerManagerDelegate> delegate;

/**
 * 首先请求配置项
 */
- (void)homePageReqConfig;

/**
 * 首页最新数据请求
 */
- (void)homePageReqDataForLatestDataUpScreen;

/**
 * 新用户激活上报
 * 0 - 第一次打开 APP 上报
 * 1 - 打开 APP 超过三分钟 或者 打开三次
 */
- (void)homePageUploadNewUserWithType:(NSString *)type;

/**
 * 首页最佳方案
 */
- (void)homePageReqDataForPreferredPlans;

/**
 * 验证登录状态 - 及时更新个人信息
 * V3.0 针对之前 已评估过&&已登录 旧版本升级之后 进入首页及时更新个人信息选择相应首页
 */
- (void)homePageVertifyLoginStatusAndUpdateUserInfo;

/**
 * 下载闪屏图片病=并保存本地
 */
-(void)downLoadAndSaveImage;


@end
