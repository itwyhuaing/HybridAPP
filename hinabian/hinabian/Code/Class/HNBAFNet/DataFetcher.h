//
//  DataFetcher.h
//  hinabian
//
//  Created by 余坚 on 15/6/15.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
@class HNBAssetModel;

typedef void(^DataFetchLocalCachedHandler)(id JSON);
typedef void(^DataFetchSucceedHandler)(id JSON);
typedef void(^DataFetchFailHandler)(id error);


@interface DataFetcher : NSObject

+ (void)doVcodeWithMobile: (NSString*)mobile vcode_type:(NSString*)type withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doRegisterWithMail: (NSString*)mail verifyCode:(NSString*)code password:(NSString*)password withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doVcodeWithMail: (NSString*)mail vcode_type:(NSString*)type withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doLogin:(NSString*)account password:(NSString*)password im_state:(NSString *)im_state withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doLoginWithWX: (NSString*)access_token Open_id:(NSString*)openid  withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doLoginWithQQ: (NSString*)access_token Open_id:(NSString*)openid  withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doCompleteUserInfo: (NSString*)NickName  IMNation:(NSArray*)IMNation IMState:(NSString*)IMState   withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 手动登录网易云IM
+ (void)loginNetEaseIMWithCompletion:(NETEaseLoginORLogOutComplete)completion;

#pragma mark - 手动登出网易云IM
+ (void)logOutNetEaseIMWitCompletion:(NETEaseLoginORLogOutComplete)completion;

#pragma mark - 更改用户头像
+(void) updateUserImage:(UIImage*)userImage WithSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doGetIndexMainInfo:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doLogOff:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doGetPopularPost: (int)start  GetNum:(int)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doAnswerQuestion:(NSString *) userid QID:(NSString *)qID AID:(NSString *)aID content:(NSString *)contentString withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doSubmitQuestion:(NSString *) userid Title:(NSString *)title content:(NSString *)contentString Label:(NSArray *)labels AnswerId:(NSString *)answerId  SubjectId:(NSString *)subject_id withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doUpdateUserInfo:(NSString*) userid NickName:(NSString *)nickNameString Motto:(NSString *)mottoString Indroduction:(NSString *)indroductionString Hobby:(NSString *)hobbyString Im_state:(NSString *)imStateString Im_nation:(NSArray *)imNationarry withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doChangePWD:(NSString *) userid oldPWD:(NSString*)oldPWDString newPWD:(NSString *)newPWDString confirmPWD:confirmPWDString withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doNewPWD:(NSString *)newPWDString confirmPWD:confirmPWDString withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;
#pragma mark - 忘记密码1 填写手机号 
+ (void)doForgetPWDSetpOne:(NSString *) telNum withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doForgetPWDSetpTwo:(NSString *)VcodeString TEL:(NSString *) telNum withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doForgetPWDSetpThree:(NSString *)newPwd Vcode:(NSString *)VcodeString TEL:(NSString *) telNum withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doGetAllLabels:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doGetAllTribes:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - doGetAllNotices 个人设置界面获取消息
+ (void)doGetAllNotices:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark ------ 发帖接口
+ (void)doPostTribe:(NSString *) userid TID:(NSString *)TID Title:(NSString *)titleString content:(NSString *)contentString ImageList:(NSArray*)imageArry  withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;
#pragma mark ------ 新版发帖接口
/** 新版发帖接口
 * tribeID              - 圈子ID
 * themID               - 帖子ID , 编辑已有帖子之后需要所需参数
 * titleString          - 标题
 * contentString        - 内容
 * topicID              - 话题ID , V3.0 首页增加热门话题列表中有参与讨论板块所需参数 ,该参数有则传无则空
 */
+ (void)hnbRichTextPostTribeID:(NSString *)tribeID themID:(NSString *)themID title:(NSString *)titleString content:(NSString *)contentString topicID:(NSString *)topicID withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doReplyPost:(NSString *) userid TID:(NSString *)TID CID:(NSString *)CID content:(NSString *)contentString ImageList:(NSArray*)imageArry withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doPraiseTheme:(NSString *) userid TID:(NSString *)TID withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doCancelPraiseTheme:(NSString *) userid TID:(NSString *)TID withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doIsThemePraise:(NSString *) userid TID:(NSString *)TID withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 发帖上传图片
+(void) updatePostImage:(UIImage*)userImage WithSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;
#pragma mark - 发帖上传图片 - 新版富文本
+(void) hnbRichTextUpdatePostImage:(HNBAssetModel *)info WithSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doVerifyUserInfo:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doGetTribeIndexBaseInfo:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 获取圈子首页热门帖子
+ (void)doGetTribeIndexPost: (int)start  GetNum:(int)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doHasPWD:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)dogetVisaPayInfo:(NSString *)order_no Method:(NSString *)pay_method withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doVerifyVisaPayInfo:(NSString *)order_no PayState:(NSString *)pay_state withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doSetPushSwitch:(NSString *)typeString Switch:(NSString *)switchstring  withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

/* 意见发送接口 */
+ (void)doSetIdeaBack:(NSString *)ideaString withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

/* 华人的一天新增接口 */
+ (void)doGetIndexCODInfo:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doGetIndexActivityInfo:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doPostCOD:(NSString *)contentString ImageList:(NSArray*)imageArry NationID:(NSString *) NationID withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doGetMoreCODPage:(NSString *)t_id Num:(NSString *)numString Direction:(NSString *)directionString withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doGetAllActivityInfo:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doGetSplashScreen:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doGetGiveBirthInAmericaUrl:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doGetTribeIndexActivityInfo:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doGetVersionFromAppStore:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 显不显示赴美生子
+ (void)doShowBIA:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 设置主页功能按钮
+ (void)doSetIndexFunction:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 设置帖子详情原生或者网页
+ (void)doSetTribeInfoNativeOrWeb:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;
#pragma mark - 首页是否显示咨询按钮
+(void)doisShowConsultationInIndex:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;
#pragma mark - 合并 首页配置项接口 ： 帖子详情原生或 web , 首页是否显示咨询按钮
+(void)doGetConfigInfoHomeIndex:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;


#pragma mark - 国家选择器数据：发表我的一天
+ (void)doGetAllCODNations:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;
#pragma mark - 意向国家地区：移民评估、完善用户信息、选择意向国家
+ (void)doGetAllNations:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;
#pragma mark - 请求国家码
+ (void)dogetCountryCodes:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;
#pragma mark - 合并 三个接口
+ (void)doGetAllNationAndMobieNationAllCODNationInfo:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;


#pragma mark - 增加国家码之后的获取手机验证码
+ (void)doVcodeWithCountrycodeMobile: (NSString*)mobile vcode_type:(NSString*)type vcode_mobile_nation:(NSString *)mobilenation withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 手机注册接口,添加国家码
+ (void)doRegisterWithMobile:(NSString*)mobile vcode_mobile_nation:(NSString *)mobilenation verifyCode:(NSString*)code password:(NSString*)password withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 注册时绑定手机号 - 有国家码
+ (void)doCombineTElForRegister:(NSString *)VcodeString TEL:(NSString *)telNum vcode_mobile_nation:(NSString *)mobilenation withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 第三方登录之后绑定手机号 - 国家码
+ (void)doCombineTEl:(NSString *)VcodeString TEL:(NSString *)telNum vcode_mobile_nation:(NSString *)mobilenation withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark ------ v 2.3 手机+验证码登录接口
+ (void)doLoginWithVcode:(NSString *)vcode mobile_num:(NSString *)mobile_num mobile_nation:(NSString *)mobile_nation im_state:(NSString *)im_state withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 忘记密码第一步 ：填写手机号,新增国家码
+ (void)doForgetPWDSetpOne:(NSString *)telNum vcode_mobile_nation:(NSString *)mobilenation withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 获取优惠券
+ (void)doGetCoupon: (int)start  GetNum:(int)num Flag:(int)flag withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 他人的个人中心
+ (void)entryUserInfoWithParameter:(NSString *)personId withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 改版(2.1) - 他人的个人中心
+ (void)showPersonnalInfoWithPersonId:(NSString *)personId withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 改版(2.1) - 他人的个人中心 - TA的圈子
+ (void)doGetHisTribeDataWithPersonId:(NSString *)personId start:(NSInteger)start GetNum:(NSInteger)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 改版(2.1) - 他人的个人中心 - TA的问答
+ (void)doGetHisQADataWithPersonId:(NSString *)personId start:(NSInteger)start GetNum:(NSInteger)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 他人的个人中心操作增添关注
+ (void)addFollowWithParameter:(NSString *)parameter withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 他人的个人中心操作取消关注
+ (void)removeFollowWithParameter:(NSString *)parameter withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;
#pragma mark - 上传idfa
+ (void) doSendUserToken:(NSString *)idfaString DToken:(NSString *)dTokenString Type:(NSString *)type withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;
#pragma mark - 上报用户唯一性标识 - fidfa 
+ (void)doSendUserUniqueFlagWithType:(NSString *)type withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;


#pragma mark - 获取新版本首页信息 - 移民百问 、 移民攻略 、 滚动视图
+ (void)doGetNewIndexMainInfo:(NSDictionary *)parameter withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 改版首页获取首页信息 － 华人的一天 、 帖子
+ (void)doGetHomeTribesOrChineseDayInfo:(NSInteger)page withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 首页消息中心
+ (void)doGetNewsCenterData:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 首页项目进度通知弹框
+ (void)doGetStateForProjectShowONHome:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;


#pragma mark - 首页移民评估引导弹框
+ (void)doGetImAssessRemindViewShowONHome:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;
#pragma mark - 首页移民评估引导弹框 - 请求接口询问用户是否评估过
+ (void)doGetUserInfoAboutImassessionWithUserId:(NSString *)userID success:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;
#pragma mark ------  合并 移民评估弹框 ：人数 与 移民状态
+ (void)doGetInfoAboutImassessionWithUserId:(NSString *)userID success:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark ------  添加 fidfa 参数之后的首页移民弹框接口
+ (void)doGetInfoAboutImassessionAlertWithUserId:(NSString *)userID success:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;


#pragma mark - 首页关闭项目进度通知弹框
+ (void)doCloseViewForProjectShowONHomeWithUserProjectID:(NSString *)parameter succeedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 上报pv
+ (void)doSendPVInfo:(NSArray *)pvArray Count:(NSString *)count Time:(NSString *)time withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 上报pvTime
+ (void)doSendPVTimeInfo:(NSArray *)pvArray Count:(NSString *)count Time:(NSString *)time withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 上报InterfaceTime
+ (void)doSendInterfaceTimeInfo:(NSArray *)interFaceArray Count:(NSString *)count withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 上报click事件
+ (void)doSendClickInfo:(NSArray *)clickArray Count:(NSString *)count withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 上报app开机时间
+ (void)doSendAppOpenTimeInfo:(NSArray *)openArray Count:(NSString *)count Time:(NSString *)time withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 上报 web 打开失败
+ (void)doSendWebOpenFailureWithErrorURLStr:(NSString *)errurlstr error:(NSError *)err errDes:(NSString *)errDes;


#pragma mark - 获取圈子首页热门圈子
+ (void)doGetHotTribesInTribeIndex:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 获取圈子简介数据
+ (void)doGetTribeInfoWithTribeID:(NSString *)tribe_id withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 具体圈子增添关注
+ (void)addFollowTribeWithParameter:(NSString *)parameter withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 具体圈子取消关注
+ (void)removeFollowTribeWithParameter:(NSString *)parameter withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 获取圈子详情页帖子
+ (void)doGetTribeDetailInfoWithTribeID:(NSString *)tribe_id sortType:(NSString *)sort_type start:(NSInteger)start GetNum:(NSInteger)num withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 获取圈子首页热门帖子数据
+ (void)doGetHotPostInTribeIndex:(NSInteger)start  GetNum:(NSInteger)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 帖子详情 - 回复部分原生化 - 回复数据接口
+ (void)doGetCommentInDetailThemPageWithThemID:(NSString *)theme_id pageNum:(NSInteger)pageNum withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 帖子详情 - 回复部分原生化 - 楼主回复数据接口
+(void)doGetLZCommentInDetailThemPageWithThemID:(NSString *)theme_id pageNum:(NSInteger)pageNum withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 帖子详情 - 回复部分原生化 - 根据帖子Id获取圈子信息
+(void)doGetTribeInfoWithThemeId:(NSString *)theme_id withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;
#pragma mark - 帖子详情 - 举报
+ (void)doReportWithType:(NSString *)reportType reportId:(NSString *)reportId desc:(NSString *)desc withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 帖子详情 - 点赞楼层
+(void)doZanCommentWithId:(NSString *)comment_id withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 帖子详情 - 回复详情获取全部针对楼层的回复数据
+(void)doGetCommentDetailWithCommentId:(NSString *)comment_id withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 搜索词汇关联
+ (void)doGetSearchRelationWords:(NSString *)word  withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 问答搜索词汇关联
+ (void)doGetQASearchRelationWords:(NSString *)word  withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 问答首页列表
+ (void)doGetQAIndexQuestionList:(NSInteger)start  GetNum:(NSInteger)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 更具标签列表获取问答列表
+ (void)doGetQAQuestionListByLabels:(NSString *)labels shoudInDatabase:(BOOL)inDatabase Start:(NSInteger)start  GetNum:(NSInteger)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 获取专家列表
+ (void)doGetSpecialistsList:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 提问关联问题列表
+ (void)doGetQAQustionRelationWords:(NSString *)word withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 问题收藏
+ (void) doGetCollectQuestion:(NSString *)q_id CanceleOrCollect:(BOOL) isCollect  withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 问题收藏
+ (void) doGetCollectTheme:(NSString *)t_id CanceleOrCollect:(BOOL) isCollect  withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 预约咨询手机号码上传
+(void)doSendAppointmentPhoneNum:(NSString *)phone withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 下载页面HTML
+(void)doGetPageHTML:(NSString *)url MD5:(NSString *)md5String withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 抛弃所有没发出的请求
+(void)cancleAllRequest;

#pragma mark - 提交优惠码接口
+ (void)doSendCouponCode:(NSString *)code withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 改版(2.6) - 他人的个人中心 - 回帖
+ (void)doGetHisReplyDataWithPersonId:(NSString *)personId start:(NSInteger)start GetNum:(NSInteger)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 改版(2.6) - 他人的个人中心 - 发帖
+ (void)doGetHisPostDataWithPersonId:(NSString *)personId start:(NSInteger)start GetNum:(NSInteger)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 分页(2.6) - 移民攻略
+ (void)doGetActivityIndexWithType:(NSString *)type start:(NSInteger)start GetNum:(NSInteger)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

+ (void)doGetActivityIndexwithType:(NSString *)type SucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 新页(2.8.4) - 获取项目的大洲与国家
+ (void)doGetContryAndProject:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;
+ (void)doGetContryAndProjectWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes succeedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 新增(2.8.4) - 首页是否显示条件测试cell
+ (void)doGetIsShowConditionTest:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 修改(2.8.7)首次进入 - 活动列表
+ (void)dogetActivityIndexFirstWithType:(NSString *)type start:(NSInteger)start GetNum:(NSInteger)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 删除帖子(2.9,0)帖子详情
+ (void)deleteThemeWithThemeID:(NSString *)themeID withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 获取帖子内容(2.9.0)编辑帖子
+ (void)getThemeInfoWithThemeID:(NSString *)themeID withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 获取项目首页项目国家列表(2.9.0) tab
+ (void)gettabInIMProjectHomewithSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;
+ (void)gettabInIMProjectHomeWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes succeedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 获取项目首页项目国家详情信息(2.9.0)
+ (void)getInfoByTabInIMProjectHomeWithID:(NSString *)ID withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 获取项目首页项目国家详情信息(3.0.0)
+ (void)doGetHotImmigrantProjectsWithSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

/*
 绑定三部曲
 type:"weixin" or "qq"
 */
#pragma mark -First- 第三方登录接口：QQ、微信合并（2.9.1）
+ (void)doLoginWithThirdPartWithType:(NSString *)type Access_Token:(NSString*)access_token Open_ID:(NSString*)open_id im_state:(NSString *)im_state withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;
#pragma mark -Second- 第三方登录后绑定手机号前先验证手机号是否有绑定  （2.9.1）
+ (void)requestPhoneNumIsBindWithType:(NSString *)type TEL:(NSString *)telNum mobile_nation:(NSString *)mobilenation withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;
#pragma mark -Third- 第三方登录后必须绑定手机号 （2.9.1）
+ (void)doBindPhoneWithThirdPartType:(NSString *)type vCode:(NSString *)VcodeString TEL:(NSString *)telNum vcode_mobile_nation:(NSString *)mobilenation im_state:(NSString *)im_state withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark - 新的意见反馈，允许传图 （2.9.1）
+(void)doIdeaBackWithContent:(NSString *)contentString ImageList:(NSArray*)imageArry withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark ------------------------------------------ app 3.0 版本接口

/**
 doGetHomePage30LatestNews 首页 快讯
 doGetHomePage30RcmdSpecial 首页 推荐专家
 doGetHomePage30RcmdActivity 首页 推荐活动
 doGetHomePage30HotTopic 首页 热门话题
 doGetHomePage30GreatTalk 首页 大咖说
 doGetHomePage30HnbEditorTalk 首页 小边说
 */

// 最佳方案
+ (void)doGetHomePage30PreferredPlan:(NSDictionary *)parameter withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;
+ (void)doGetHomePage30PreferredPlanWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes para:(NSDictionary *)parameter withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

// 首页 Banner 功能区 快讯
+ (void)doGetHomePage30BannerFuntionsLatestNewsWithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;
+ (void)doGetHomePage30BannerFuntionsLatestNewsWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes succeedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

// 首页 推荐专家 推荐活动 热门话题
+ (void)doGetHomePage30RcmdSpecialRcmdActivityHotTopicWithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;
+ (void)doGetHomePage30RcmdSpecialRcmdActivityHotTopicWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes succeedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

// 首页 大咖说 小边说
+ (void)doGetHomePage30GreatTalkHnbEditorTalkWithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;
+ (void)doGetHomePage30GreatTalkHnbEditorTalkWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes succeedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

// 最新资讯列表
+ (void)doGetListLatestNewsWithParameterStart:(NSInteger)start count:(NSInteger)count withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;
// 专家列表
+ (void)doGetListSpecialWithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;
+ (void)doGetListSpecialWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes succeedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

// 大咖说列表
+ (void)doGetListGreatTalkWithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;
+ (void)doGetListGreatTalkWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes succeedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

// 小边说列表
+ (void)doGetListHnbEditorTalkWithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;
+ (void)doGetListHnbEditorTalkWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes succeedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

// 移民评估题目选项请求
+ (void)doGetIMAssessItemsWithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

// 移民评估验证码请求
+ (void)doGetIMAssessVCodeWithmobilePhoneNum:(NSString *)mobilePhoneNum SucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

// 生成移民方案
+ (void)doGetIMAssessCaseWithUserInfoData:(NSDictionary *)userInfoData SucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

// 已移民状态同步所在国家城市
+ (void)updateIMEDNationCityWithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

#pragma mark ------------------------------------------ app web 加载重构上报 URL
+ (void)uploadWebURLString:(NSString *)URLString withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

// 海外课堂列表
+ (void)doGetListOverSeaClassWithType:(NSString *)type page:(NSString *)page num:(NSString *)num WithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;
+ (void)doGetListOverSeaClassWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes type:(NSString *)type page:(NSString *)page num:(NSString *)num WithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

// IM通知接口
+ (void)doGetIMNotificationWithStart:(NSString *)start num:(NSString *)num WithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

// IM通知已读接口
+ (void)doSetIMNotificationHasReadWithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

// 获取关注状态接口（登录有效）
+ (void)doGetPersonalIsFollow:(NSString *)u_id WithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

// 获取全部展示列表页的数据
+ (void)doGetAllShowServiceListWithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;
+ (void)doGetAllShowServiceListWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes succeedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;

// 获取海外服务信息列表
+ (void)doGetOverSeaServiceListWithType:(NSString *)type start:(NSInteger)start num:(NSInteger)num succeedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler;


@end

