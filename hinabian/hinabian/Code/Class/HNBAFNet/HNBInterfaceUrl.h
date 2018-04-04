//
//  HNBInterfaceUrl.h
//  hinabian
//
//  Created by hnbwyh on 2017/8/25.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#ifndef HNBInterfaceUrl_h
#define HNBInterfaceUrl_h

/**
 * 接口配置
 */
#define InterfaceConfig @"config/symbol?configName="

/** v3.0
 * 首页相关接口
 */
// 首页 Banner
#define HomePage30Banner @"newhomebanner"
// 首页 快讯
#define HomePage30LatestNews @"newhomelatestnews"
// 首页 功能区
#define HomePage30Functions @"newhomefunctions"
// 首页 推荐专家 - 专家列表
#define HomePage30RcmdSpecial @"newhomerecommandspecial"
// 首页 推荐活动
#define HomePage30RcmdActivity @"newhomerecommandactivity"
// 首页 热门话题
#define HomePage30HotTopic @"newhomehottopic"
// 首页 大咖说 - 大咖说列表
#define HomePage30GreatTalk @"newhomegreattalk"
// 首页 小边说 - 小边说列表
#define HomePage30HnbEditorTalk @"newhomehnbeditortalk"


// 最新资讯列表
#define ListLatestNews @"theme/news_flash_list"

// Tab_国家项目 热门活动列表 v3.0
#define ListTabRcmHotAct @"newhomerecommandactivitylist"


/** 首页整合之后的接口 */
// 首页 Banner 功能区 快讯
#define HomePage30BannerLatestNewsFunctions @"Api_Config/banner_navi_flash.html?ver=3.0.0"//@"index/banner_navi_flash"
// 首页 推荐专家 推荐活动 热门话题
#define HomePage30RcmdSpecialRcmdActivityHotTopic @"Api_Config/specialist_activity_topic.html?ver=3.0.0"//@"index/specialist_activity_topic"
// 首页 大咖说 小边说
#define HomePage30GreatTalkHnbEditorTalk @"Api_Config/bigShot_editor.html?ver=3.0.0"//@"index/bigShot_editor"
// 首页 最佳方案
#define HomePage30PreferredPlan @"assess/getBestCase"
// 引导页 移民评估题目以及选项
#define GuideImassessItems @"Api_Bootpage/data.html?ver=3.0.0"
// 引导页 生成移民方案
#define GuideImassessCase @"assess/generatePlan.html"
// 引导页 移民目的列表页（H5非接口）
#define GuideImassessList @"assess/list.html"
// 登录成功后更新已移民用户所在的城市和国家
#define UpdateNationCity @"api_user/updateCountryAndCity"
// 海外课堂列表
#define OverSeaClassListURL @"api_config/classroom"
// v3.1 通知 通知数据
#define NotificationData @"Api_Notice/data.html"
// v3.1 通知 通知设置已读
#define NotificationHasRead @"Api_Notice/set.html"
// v3.1 关注接口 用户对用户
#define PersonaIsFollow @"personal_follow/isFollow"
// v3.2 全部服务列表 接口
#define AllServiceList @"appconfig/Appicon/getList"

// V3.2 海外服务 - 海外银行、海外公司 服务信息列表
#define OverseaServiceList @"/project/Overseaservice/getList"

// 话题列表
#define HomePage30HotTopicList @"native/topicDiscuss/?id="
// 快讯详情
#define LatestNewsDetail @"native/news/detail?theme_id="
// v3.0 首页 移民项目
#define HomePage30ImmigrantProject @"native/project/countrys"


/** 项目详情参考链接
https://m.hinabian.com/project/detail?project_id=12021074
https://m.hinabian.com/native/project/detail?project_id=12021074
**/
#define IMProjectDetail_Native @"native/project/detail"

/** 签证详情参考链接
 https://m.hinabian.com/visa/detail.html?project_id=15002067
 https://m.hinabian.com/native/visa/detail.html?project_id=15002067
 **/
#define VisaDetail_Native @"native/visa/detail"

/**
 * 个人 -> 在办项目
 */ 
#define TheURLForProjectOnHandling @"Personal_Migrant/transact.html"

/**
 * 个人 -> 我的关注
 */
#define TheURLForMyAttention @"personal_follow.html"

/**
 * 个人 -> 我的收藏
 */
#define TheURLForMyCollection @"personal_favorite/?tag=theme"

/**
 * 个人 -> 推荐有礼
 */
#define TheURLForgiftOfRecommand @"Activity_Oldtakenew"

/**
 * 个人 -> 我的评估
 */
#define TheURLForMyAssession @"assess/myAssess.html"

/**
 * 海那边授权 
 */
#define TheURLForAuthorizationOfHinabian @"https://auth.hinabian.com/about/mianze.html"


#endif /* HNBInterfaceUrl_h */
