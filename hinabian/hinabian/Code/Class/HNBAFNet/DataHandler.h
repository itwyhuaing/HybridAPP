//
//  DataHandler.h
//  hinabian
//
//  Created by hnbwyh on 16/5/11.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DataHandlerComplete)(id info);

@interface DataHandler : NSObject

+ (void)doLoginHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

#pragma mark ------ 手机验证码登录
+ (void)doLoginWithVcodeHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doLoginWithQQHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doLoginWithWXHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doLogOffHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doRegisterWithMobileHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doVcodeWithMobileHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doRegisterWithMailHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doVcodeWithMailHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)updateUserImageHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetIndexMainInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetPopularPostHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetAllNationsHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetAllLabelsHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetAllTribesHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doVerifyUserInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetTribeIndexBaseInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetTribeIndexPostHandleData:(id)responseObject start:(int)start complete:(DataHandlerComplete)completion;

+ (void)doGetIndexCODInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetIndexActivityInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetAllActivityInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetAllCODNationsHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)dogetCountryCodesHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetAllNationAndMobieNationAllCODNationInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doCombineTElForRegisterHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doCombineTElHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetCouponHandleData:(id)responseObject tmpFlag:(NSString *)tmpFlag complete:(DataHandlerComplete)completion;

+ (void)entryUserInfoWithParameterHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)showPersonnalInfoWithPersonIdHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetHisTribeDataWithPersonIdHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetHisQADataWithPersonIdHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetHisReplyDataWithPersonIdHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetHisPostDataWithPersonIdHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetNewIndexMainInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetHomeTribesOrChineseDayInfoHandleData:(id)responseObject pageNum:(NSInteger)page complete:(DataHandlerComplete)completion;

+ (void)doGetNewsCenterDataHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetStateForProjectShowONHomeHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetTribeInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetTribeDetailInfoHandleData:(id)responseObject sort_type:(NSString *)sort complete:(DataHandlerComplete)completion;

+ (void)doGetHotTribesInTribeIndexInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetHotPostInTribeIndexsInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetCommentInDetailThemPageWithThemIDHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetCommentDetailWithCommentIdHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetQAIndexQuestionList:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetSpecialistsList:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetQAQuestionListByLabels:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetTribeInfoWithThemeIdHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetActivityIndexHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetActivityTotalHandleDataByType:(NSString *)type responseObject:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetContryAndProjectHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetTabInIMProjectHome:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)getInfoByTabInIMProjectHome:(id)responseObject complete:(DataHandlerComplete)completion;

+ (void)doGetHotImmigrantProjectsHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

#pragma mark - 统一微信、QQ第三方登录接口
+ (void)doLoginWithThirdPartHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

#pragma mark ------------------------------------------ app 3.0 版本接口


+ (void)doSetIndexFunctionHandleData:(id)responseObject complete:(DataHandlerComplete)completion;


// 最佳方案
+ (void)doGetHomePage30PreferredPlanHandleData:(id)responseObject complete:(DataHandlerComplete)completion;
// 首页 Banner 功能区 快讯
+ (void)doGetHomePage30BannerFuntionsLatestNewsHandleData:(id)responseObject complete:(DataHandlerComplete)completion;
// 首页 推荐专家 推荐活动 热门话题
+ (void)doGetHomePage30RcmdSpecialRcmdActivityHotTopicHandleData:(id)responseObject complete:(DataHandlerComplete)completion;
// 首页 大咖说 小边说
+ (void)doGetHomePage30GreatTalkHnbEditorTalkHandleData:(id)responseObject complete:(DataHandlerComplete)completion;
// 引导页 移民评估题目选项
+ (void)doGetIMAssessItemsHandleData:(id)responseObject complete:(DataHandlerComplete)completion;

// 最新资讯列表
+ (void)doGetListLatestNewsHandleData:(id)responseObject start:(NSInteger)start complete:(DataHandlerComplete)completion;
// 专家列表
+ (void)doGetListSpecialHandleData:(id)responseObject complete:(DataHandlerComplete)completion;
// 大咖说列表
+ (void)doGetListGreatTalkHandleData:(id)responseObject complete:(DataHandlerComplete)completion;
// 小边说列表
+ (void)doGetListHnbEditorTalkHandleData:(id)responseObject complete:(DataHandlerComplete)completion;
// 海外课堂列表
+ (void)doGetListOverSeaClassHandleData:(id)responseObject complete:(DataHandlerComplete)completion;
// 通知数据
+ (void)doGetIMNotificationWithHandlerData:(id)responseObject complete:(DataHandlerComplete)completion;
//首页全部服务列表页
+ (void)doGetAllShowServiceListWithHandlerData:(id)responseObject complete:(DataHandlerComplete)completion;
// 海外服务
+ (void)doGetOverSeaServiceListWithHandlerData:(id)responseObject complete:(DataHandlerComplete)completion;

@end
