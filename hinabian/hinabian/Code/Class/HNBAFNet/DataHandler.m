//
//  DataHandler.m
//  hinabian
//
//  Created by hnbwyh on 16/5/11.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "DataHandler.h"
#import <NIMSDK/NIMSDK.h>
#import "PersonalInfo.h"
#import "ActivityInfo.h"
#import "HouseInfo.h"
//#import "ShufflingInfo.h"
#import "PopularPost.h"
#import "NationCode.h"
#import "Label.h"
#import "Tribe.h"
#import "LabelCate.h"
#import "TribeHotPost.h"
#import "HotTribeInfo.h"
#import "TopThemeInfo.h"
#import "CODInfo.h"
#import "CODActivityInfo.h"
#import "CODNation.h"
#import "CODActivityClassifyInfo.h"
#import "TelCountryCode.h"
#import "Coupon.h"
// 新版首页
#import "NewActivityInfo.h"
#import "HomeQA.h"
#import "HomeQASpecial.h"
#import "ShufflingInfo.h"
#import "HomeHotPost.h"
#import "TribeIndexHotTribe.h"
#import "TribeIndexItem.h"
#import "DetailTribeHotestitem.h"
#import "DetailTribeLatestitem.h"
#import "TribeShowQAModel.h"
#import "TribeShowBriefInfo.h"
#import "ProjectStateModel.h"
#import "NewsCenterModel.h"
// 问答改版新增
#import "QuestionIndexItem.h"
#import "PersonInfoModel.h"
#import "QASpecialList.h"
#import "QuestionFilterItem.h"
#import "UserInfoHisTribePost.h"
#import "UserInfoHisQAPost.h"
// 为解决 他人的个人中心循环退出然后后退过程中因数据库共用导致的显示异常问题手动创建数据模型
#import "UserInfoHisTribePostModel.h"
#import "UserInfoHisQAPostModel.h"
// v2.4 帖子详情回帖评论功能原生化 接口
#import "TribeDetailInfoCellManager.h"
#import "FloorCommentModel.h"
#import "FloorCommentUserInfoModel.h"
#import "FloorCommentReplyModel.h"
#import "TFHpple.h"
#import "HTMLContentModel.h"
#import "TribeInfoByThemeIdModel.h"
// v2.6他的个人中心回帖、发帖
#import "UserInfoTribeReplyModel.h"
#import "UserInfoTribePostModel.h"
#import "HotPoint+CoreDataClass.h"

#import "CODActivityIndex.h"
#import "TribeShowProjectModel.h"

#import "ProjectContientModel.h"
#import "ProjectNationsModel.h"
#import "ProjectItemModel.h"
#import "IMHomeNationTabModel.h"
#import "IMHomeProjModel.h"
#import "IMHomeVisaModel.h"
#import "IMHomeBannerModel.h"

// 网络数据缓存
#import "NetDataCacheHandler.h"
#import "HNBFileManager.h"

// v3.0 首页
#import "HomeBannerModel.h"
#import "FunctionModel.h"
#import "IndexFunctionStatus.h"
#import "LatestNewsModel.h"
#import "RcmdSpecialModel.h"
#import "RcmdActivityModel.h"
#import "GreatTalkModel.h"
#import "HnbEditorTalkModel.h"
#import "HotTopicModel.h"
#import "PreferredPlanModel.h"
// v3.0 引导页
#import "IMNationCityModel.h"
#import "IMAssessItemsModel.h"

#import "HotIMProjectModel.h"
#import "OverSeaClassModel.h"
#import "IMNotificationModel.h"
#import "ShowAllServicesModel.h"
#import "CardTableDataModel.h"


@implementation DataHandler

+(void)doLoginHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    [PersonalInfo MR_truncateAll];
    id json1 = [responseObject returnValueWithKey:@"data"];
    if (![[json1 objectForKey:@"im_nation"] isEqualToString:@""]) {
        [HNBUtils sandBoxSaveInfo:[json1 objectForKey:@"im_nation"] forKey:IM_NATION_LOCAL];
    }
    if (![[json1 objectForKey:@"im_state"] isEqualToString:@""]) {
        [HNBUtils sandBoxSaveInfo:[json1 objectForKey:@"im_state"] forKey:IM_INTENTION_LOCAL];
    }
    [HNBUtils resetPersonalityNotice];
    PersonalInfo *f = [PersonalInfo MR_createEntity];
    [f MR_importValuesForKeysWithObject:json1];
    [HNBUtils sandBoxSaveInfo:@"1" forKey:personal_is_login];
    [HNBUtils sandBoxSaveInfo:f.is_assess forKey:USER_ASSESSED_IMMIGRANT];
//    [HNBUtils loginNetEaseIMWithLoginAcount:f.netease_im_id loginToken:f.netease_im_token completion:^(id error) {
//        if (!error) {
//            completion(NETEASE_LOGIN_SUCCESS);
//        }else {
//            completion(NETEASE_LOGIN_FAIL);
//        }
//    }];
    [HNBUtils sandBoxSaveInfo:@"1" forKey:IMGuide_hasBeen_Logined];
    if(completion){
        completion(responseObject);
    }
    
}

#pragma mark ------ 手机验证码登录
+ (void)doLoginWithVcodeHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    [PersonalInfo MR_truncateAll];
    NSDictionary *json = [responseObject returnValueWithKey:@"data"];

    if (![[json objectForKey:@"im_nation"] isEqualToString:@""]) {
        [HNBUtils sandBoxSaveInfo:[json objectForKey:@"im_nation"] forKey:IM_NATION_LOCAL];
    }
    if (![[json objectForKey:@"im_state"] isEqualToString:@""]) {
        [HNBUtils sandBoxSaveInfo:[json objectForKey:@"im_state"] forKey:IM_INTENTION_LOCAL];
    }
    
    PersonalInfo *f = [PersonalInfo MR_createEntity];
    [f MR_importValuesForKeysWithObject:json];
    [HNBUtils sandBoxSaveInfo:@"1" forKey:personal_is_login];
    [HNBUtils sandBoxSaveInfo:f.is_assess forKey:USER_ASSESSED_IMMIGRANT];
//    [HNBUtils loginNetEaseIMWithLoginAcount:f.netease_im_id loginToken:f.netease_im_token completion:^(id error) {
//        if (!error) {
//            completion(NETEASE_LOGIN_SUCCESS);
//        }else {
//            completion(NETEASE_LOGIN_FAIL);
//        }
//    }];
    [HNBUtils sandBoxSaveInfo:@"1" forKey:IMGuide_hasBeen_Logined];
    if(completion){
        completion(responseObject);
    }
}

+(void)doLoginWithQQHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    [PersonalInfo MR_truncateAll];
    id json1 = [responseObject returnValueWithKey:@"data"];
    if (![[json1 objectForKey:@"im_nation"] isEqualToString:@""]) {
        [HNBUtils sandBoxSaveInfo:[json1 objectForKey:@"im_nation"] forKey:IM_NATION_LOCAL];
    }
    if (![[json1 objectForKey:@"im_state"] isEqualToString:@""]) {
        [HNBUtils sandBoxSaveInfo:[json1 objectForKey:@"im_state"] forKey:IM_INTENTION_LOCAL];
    }
    [HNBUtils resetPersonalityNotice];
    PersonalInfo *f = [PersonalInfo MR_createEntity];
    [f MR_importValuesForKeysWithObject:json1];
    [HNBUtils sandBoxSaveInfo:@"1" forKey:personal_is_login];
    [HNBUtils sandBoxSaveInfo:f.is_assess forKey:USER_ASSESSED_IMMIGRANT];
//    [HNBUtils loginNetEaseIMWithLoginAcount:f.netease_im_id loginToken:f.netease_im_token completion:^(id error) {
//        if (!error) {
//            completion(NETEASE_LOGIN_SUCCESS);
//        }else {
//            completion(NETEASE_LOGIN_FAIL);
//        }
//    }];
    [HNBUtils sandBoxSaveInfo:@"1" forKey:IMGuide_hasBeen_Logined];
    if(completion){
        completion(responseObject);
    }
}

+(void)doLoginWithWXHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    [PersonalInfo MR_truncateAll];
    id json1 = [responseObject returnValueWithKey:@"data"];

    if (![[json1 objectForKey:@"im_nation"] isEqualToString:@""]) {
        [HNBUtils sandBoxSaveInfo:[json1 objectForKey:@"im_nation"] forKey:IM_NATION_LOCAL];
    }
    if (![[json1 objectForKey:@"im_state"] isEqualToString:@""]) {
        [HNBUtils sandBoxSaveInfo:[json1 objectForKey:@"im_state"] forKey:IM_INTENTION_LOCAL];
    }
    [HNBUtils resetPersonalityNotice];
    PersonalInfo *f = [PersonalInfo MR_createEntity];
    [f MR_importValuesForKeysWithObject:json1];
    [HNBUtils sandBoxSaveInfo:@"1" forKey:personal_is_login];
    [HNBUtils sandBoxSaveInfo:f.is_assess forKey:USER_ASSESSED_IMMIGRANT];
//    [HNBUtils loginNetEaseIMWithLoginAcount:f.netease_im_id loginToken:f.netease_im_token completion:^(id error) {
//        if (!error) {
//            completion(NETEASE_LOGIN_SUCCESS);
//        }else {
//            completion(NETEASE_LOGIN_FAIL);
//        }
//    }];
    [HNBUtils sandBoxSaveInfo:@"1" forKey:IMGuide_hasBeen_Logined];
    if(completion){
        completion(responseObject);
    }
}

+(void)doLogOffHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    /* 请除用户信息 */
    [PersonalInfo MR_truncateAll];
    /* 清除登录标示 */
    [HNBUtils sandBoxSaveInfo:@"0" forKey:personal_is_login];
}

+(void)doRegisterWithMobileHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    [PersonalInfo MR_truncateAll];
    id json1 = [responseObject returnValueWithKey:@"data"];
    if (![[json1 objectForKey:@"im_nation"] isEqualToString:@""]) {
        [HNBUtils sandBoxSaveInfo:[json1 objectForKey:@"im_nation"] forKey:IM_NATION_LOCAL];
    }
    if (![[json1 objectForKey:@"im_state"] isEqualToString:@""]) {
        [HNBUtils sandBoxSaveInfo:[json1 objectForKey:@"im_state"] forKey:IM_INTENTION_LOCAL];
    }
    [HNBUtils resetPersonalityNotice];
    PersonalInfo *f = [PersonalInfo MR_createEntity];
    [f MR_importValuesForKeysWithObject:json1];
    [HNBUtils sandBoxSaveInfo:@"1" forKey:personal_is_login];
    [HNBUtils sandBoxSaveInfo:f.is_assess forKey:USER_ASSESSED_IMMIGRANT];
//    [HNBUtils loginNetEaseIMWithLoginAcount:f.netease_im_id loginToken:f.netease_im_token completion:^(id error) {
//        if (!error) {
//            completion(NETEASE_LOGIN_SUCCESS);
//        }else {
//            completion(NETEASE_LOGIN_FAIL);
//        }
//    }];
    [HNBUtils sandBoxSaveInfo:@"1" forKey:IMGuide_hasBeen_Logined];
    if(completion){
        completion(responseObject);
    }
}

+(void)doVcodeWithMobileHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

}

+(void)doRegisterWithMailHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    [PersonalInfo MR_truncateAll];
    id json1 = [responseObject returnValueWithKey:@"data"];
    PersonalInfo *f = [PersonalInfo MR_createEntity];
    [f MR_importValuesForKeysWithObject:json1];
    //NSLog(@"successed");
    [HNBUtils sandBoxSaveInfo:@"1" forKey:personal_is_login];
//    [HNBUtils loginNetEaseIMWithLoginAcount:f.netease_im_id loginToken:f.netease_im_token completion:^(id error) {
//        if (!error) {
//            completion(NETEASE_LOGIN_SUCCESS);
//        }else {
//            completion(NETEASE_LOGIN_FAIL);
//        }
//    }];
    [HNBUtils sandBoxSaveInfo:@"1" forKey:IMGuide_hasBeen_Logined];
    if(completion){
        completion(responseObject);
    }
}

+(void)doVcodeWithMailHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

}

+(void)updateUserImageHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    id json1 = [responseObject returnValueWithKey:@"data"];
    NSArray * tmpPersonalInfoArray = [PersonalInfo MR_findAll];
    PersonalInfo * f = [tmpPersonalInfoArray objectAtIndex:0];
    f.head_url = [json1 returnValueWithKey:@"real_url"];

}

+(void)doGetIndexMainInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    id jsonMain = [responseObject returnValueWithKey:@"data"];
    
    [HouseInfo MR_truncateAll];
    id jsonHouse = [jsonMain returnValueWithKey:@"house_info"];
    NSMutableArray * HouseArray = [jsonHouse objectForKey:@"item"];
    NSInteger countHouse = [HouseArray count];
    for(int i =0; i<countHouse; i++)
    {
        id tmpJson = HouseArray[i];
        NSDictionary *jsontmp = [self setTimestampDic:tmpJson];

        HouseInfo * f = [HouseInfo MR_createEntity];
        [f MR_importValuesForKeysWithObject:jsontmp];
         //NSLog(@"HouseInfo %@====== >%@",f.title,f);
    }
    
    
    [ActivityInfo MR_truncateAll];
    id jsonActivity = [jsonMain returnValueWithKey:@"activity_info"];
    NSMutableArray * ActivityArray = [jsonActivity objectForKey:@"item"];
    NSInteger countActivity = [ActivityArray count];
    for(int i =0; i<countActivity; i++)
    {
        id tmpJson = ActivityArray[i];
        NSDictionary *jsontmp = [self setTimestampDic:tmpJson];
        ActivityInfo * f = [ActivityInfo MR_createEntity];
        [f MR_importValuesForKeysWithObject:jsontmp];
         //NSLog(@"ActivityInfo %@====== >%@",f.title,f);
    }
    
    
    [ShufflingInfo MR_truncateAll];
    NSMutableArray * ShufflingArray = [jsonMain returnValueWithKey:@"shuffling_info"];
    //NSMutableArray * ShufflingArray = [jsonShuffling objectForKey:@"item"];
    NSInteger countShuffling = [ShufflingArray count];
    for(int i =0; i<countShuffling; i++)
    {
        id tmpJson = ShufflingArray[i];
        NSDictionary *jsontmp = [self setTimestampDic:tmpJson];
        ShufflingInfo * f = [ShufflingInfo MR_createEntity];
        [f MR_importValuesForKeysWithObject:jsontmp];
        
    }
    
}

+ (void)doGetNewIndexMainInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion
{
    id jsonMain = [responseObject returnValueWithKey:@"data"];
    //activitynum
    NSString * tmpActivityNum = [jsonMain returnValueWithKey:@"allRaidersNumInfo"];
    [HNBUtils sandBoxSaveInfo:tmpActivityNum forKey:INDEX_ACTIVITY_LABEL];
    // activity
    [NewActivityInfo MR_truncateAll];
    NSMutableArray *activity = [jsonMain returnValueWithKey:@"activity"];
    for (NSInteger cou = 0; cou < activity.count; cou ++) {
        id tmpJson = activity[cou];
        
        NSDictionary *jsonTmp = [self setTimestampDic:tmpJson];
        NewActivityInfo *f = [NewActivityInfo MR_createEntity];
        [f MR_importValuesForKeysWithObject:jsonTmp];
    }
    
    // hotpoint
    [HotPoint MR_truncateAll];
    NSMutableArray *hotpoints = [jsonMain returnValueWithKey:@"hotpoint"];
    for (NSInteger cou = 0; cou < hotpoints.count; cou ++) {
        id tmpJson = hotpoints[cou];
        
        NSDictionary *jsonTmp = [self setTimestampDic:tmpJson];
        HotPoint *f = [HotPoint MR_createEntity];
        [f MR_importValuesForKeysWithObject:jsonTmp];
    }
    // qa
    [HomeQA MR_truncateAll];
    NSDictionary *qa = [jsonMain returnValueWithKey:@"qa"];
    NSMutableArray *questions = [qa returnValueWithKey:@"questions"];

    for (NSInteger cou = 0; cou < questions.count; cou ++) {
        id tmpJson = questions[cou];
        
        NSDictionary *jsonTmp = [self setTimestampDic:tmpJson];
        HomeQA *f = [HomeQA MR_createEntity];
        [f MR_importValuesForKeysWithObject:jsonTmp];
        
        if (![[tmpJson valueForKey:@"labelGroup"] isKindOfClass:[NSNull class]]) {
        
            // 拼接 labelGroup
            NSMutableString *tmpString = [[NSMutableString alloc] init];
            NSArray *labelGroups = [tmpJson valueForKey:@"labelGroup"];
            for (NSInteger ct = 0; ct < labelGroups.count; ct ++) {
                if (ct != 0) {
                    [tmpString appendString:@","];
                }
                [tmpString appendFormat:@"%@",labelGroups[ct]];
            }
            f.labelGroup = tmpString;
            
        } else {
            
            f.labelGroup = nil;
            
        }

        
    }
    
    [HomeQASpecial MR_truncateAll];
    NSDictionary *special = [qa returnValueWithKey:@"special"];
    NSDictionary *specialInfo = [special returnValueWithKey:@"specialInfo"];
    NSString *desc = [special returnValueWithKey:@"desc"];
    NSString *head_url = [specialInfo returnValueWithKey:@"head_url"];
    NSString *special_id = [specialInfo returnValueWithKey:@"id"];
    NSString *title = [special returnValueWithKey:@"title"];
    
    HomeQASpecial *fSpecial = [HomeQASpecial MR_createEntity];
    fSpecial.desc = desc;
    fSpecial.head_url = head_url;
    fSpecial.id = special_id;
    fSpecial.title = title;
    
    // shuffling_info
    [ShufflingInfo MR_truncateAll];
    NSMutableArray *shuffling_info = [jsonMain returnValueWithKey:@"shuffling_info"];
    for (NSInteger cou = 0; cou < shuffling_info.count; cou ++) {
        id tmpJson = shuffling_info[cou];
        NSDictionary *jsonTmp = [self setTimestampDic:tmpJson];
        ShufflingInfo *f = [ShufflingInfo MR_createEntity];
        [f MR_importValuesForKeysWithObject:jsonTmp];
    }
}

#pragma mark - 改版首页测试
+ (void)doGetHomeTribesOrChineseDayInfoHandleData:(id)responseObject pageNum:(NSInteger)page complete:(DataHandlerComplete)completion{

    NSDictionary *dataDic = [responseObject returnValueWithKey:@"data"];
    NSArray *dataArr = [dataDic returnValueWithKey:@"pageInfo"];
    
    NSString *total = [dataDic returnValueWithKey:@"total"];
    NSString *page_num = [dataDic returnValueWithKey:@"page_num"]; // 每页规定最多的个数
    [HNBUtils sandBoxSaveInfo:total forKey:homepage3_total_commonTribes_chineseOneDay_promotion];
    [HNBUtils sandBoxSaveInfo:page_num forKey:homepage3_postCountPerPage_commonTribes_chineseOneDay_promotion];
    
    if (page == 1) { // 加载第一页之前清空缓存
        [HomeHotPost MR_truncateAll];
    }
    
    for (NSInteger cou = 0; cou < dataArr.count; cou ++) {

        NSDictionary *infoDic = dataArr[cou];
        NSDictionary *detail_info = [infoDic returnValueWithKey:@"detail_info"];
        
        NSDictionary *user_info = [infoDic returnValueWithKey:@"user_info"];
        NSDictionary *level_info = [user_info returnValueWithKey:@"levelInfo"];
        
        // 查重操作
        NSString *tmpID = [detail_info returnValueWithKey:@"id"];
        NSArray *tmpArr = [HomeHotPost MR_findByAttribute:@"detail_id" withValue:tmpID];
        
        if (tmpArr == nil || tmpArr.count == 0) {
            // 创建实体并保存
            HomeHotPost *f = [HomeHotPost MR_createEntity];
            // 数据导入
            [f MR_importValuesForKeysWithObject:infoDic];
            [f MR_importValuesForKeysWithObject:user_info];
            [f MR_importValuesForKeysWithObject:detail_info];
            // 数据处理后更新
            f.detail_id = [detail_info returnValueWithKey:@"id"];
            f.essence = [detail_info returnValueWithKey:@"essence"];
            f.user_id = [user_info returnValueWithKey:@"id"];
            f.user_name = [user_info returnValueWithKey:@"name"];
            f.title = [infoDic returnValueWithKey:@"title"];
            f.level = [level_info returnValueWithKey:@"level"];
            f.certified = [user_info returnValueWithKey:@"certified"];
            f.certified_type = [user_info returnValueWithKey:@"certified_type"];
            
            NSArray *img_lists = [infoDic returnValueWithKey:@"img_list"];
            NSMutableString *img_listString = [[NSMutableString alloc] init];
            for (NSInteger cou = 0; cou < img_lists.count; cou ++) {
                [img_listString appendFormat:@"%@&",img_lists[cou]];
            }
            f.img_list = img_listString;
            NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval timeInterval = [dat timeIntervalSince1970];
            NSString *dateTime = [NSString stringWithFormat:@"%f",timeInterval];
            f.timestamp = dateTime;
             //NSLog(@" page = %ld --------- > f.detail_id = %@",page,f.detail_id);
        }
       //NSLog(@" tmpArr = %@ --------- > total = %@",tmpArr,total);
        
    }
    
    if (completion) {
        completion(responseObject);
    }
    
}

+ (void)doGetNewsCenterDataHandleData:(id)responseObject complete:(DataHandlerComplete)completion{


    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    NSArray *titles = @[@"问答通知",@"私信通知",@"在办项目通知"];
    NSArray *icons = @[@"newsCenter_qa_notice",@"newsCenter_personalMsg_notice",@"newsCenter_goonProject_notice"];
    NSArray *descs = @[@"提问有回复立即通知您",@"私信来了通知您",@"办理的项目有进展及时通知您"];
    
    NSDictionary *data = [responseObject returnValueWithKey:@"data"];
    NSArray *keys = @[@"qa",@"message",@"project"];

    for (NSInteger cou = 0; cou < keys.count; cou ++) {
        
        NSString *key = keys[cou];
        NSDictionary *dic = [data returnValueWithKey:key];
        NewsCenterModel *f = [[NewsCenterModel alloc] init];
        f.title = titles[cou];
        f.imgName = icons[cou];
        f.noctice_num = [dic returnValueWithKey:@"noctice_num"];
        
        if ([f.noctice_num isEqualToString:@"0"]) {
            f.desc = descs[cou];
            f.formated_time = nil;
        }else{
            f.desc = [dic returnValueWithKey:@"desc"];
            f.formated_time = [dic returnValueWithKey:@"formated_time"];
        }
        
        [dataArr addObject:f];
    }
    
    if (completion) {
        completion(dataArr);
    }
    
}

#pragma mark - 改版项目进度通知

+(void)doGetStateForProjectShowONHomeHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    //NSLog(@"responseObject ------>  %@",responseObject);
    ProjectStateModel *f = [[ProjectStateModel alloc] init];
    int errCode = [[responseObject returnValueWithKey:@"state"] intValue];
    if (errCode == 0) {
    
        NSDictionary *data = [responseObject returnValueWithKey:@"data"];
        NSDictionary *msg = [data returnValueWithKey:@"msg"];
        
        f.user_project_id = [data returnValueWithKey:@"id"];
//        if (![[msg valueForKey:@"userStep"] isKindOfClass:[NSNull class]]) {
//            
//            f.userSteps = [msg valueForKey:@"userStep"];
//            
//        }else{
//            
//            f.userSteps = nil;
//            
//        }
        f.userSteps = [msg returnValueWithKey:@"userStep"];
        f.projectName = [msg returnValueWithKey:@"project_name"];
        f.lookLink = [data returnValueWithKey:@"murl"];
        f.specialName = [data returnValueWithKey:@"wenan"];
        f.isShow = @"1";
        
        
    }else{
    
        f.isShow = @"0";
        
    }
    
    if (completion) {
        completion(f);
    }
    
}

#pragma mark - 改版具体圈子简介接口

+(void)doGetTribeInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    NSDictionary *data = [responseObject returnValueWithKey:@"data"];
    TribeShowBriefInfo *f = [[TribeShowBriefInfo alloc] init];
    f.tribe_id = [data returnValueWithKey:@"tribe_id"];
    f.tribe_name = [data returnValueWithKey:@"tribe_name"];
    f.desc = [data returnValueWithKey:@"desc"];
    f.follow_num = [data returnValueWithKey:@"follow_num"];
    f.img_url = [data returnValueWithKey:@"img_url"];
    f.theme_num = [data returnValueWithKey:@"theme_num"];
    f.is_followed = [data returnValueWithKey:@"is_followed"];
    
    id tmp_arr = [data returnValueWithKey:@"u_info"];
    f.tribeHostString = @"";
    f.tribeHostTextHeight = 0.f;
    
//    tmp_arr = @[
//                @{@"name":@"孙少平",@"id":@"2001321"},
//                @{@"name":@"孙少安",@"id":@"2001321"},
//                @{@"name":@"田润叶",@"id":@"2001321"},
//                @{@"name":@"田晓霞",@"id":@"2001321"},
//                @{@"name":@"郝红梅",@"id":@"2001321"},
//                @{@"name":@"路遥",@"id":@"2001321"},
//                @{@"name":@"John",@"id":@"2001321"},
//                @{@"name":@"HongLong",@"id":@"2001321"},
//                @{@"name":@"CTM",@"id":@"2001321"}
//                ];
//    if ([f.tribe_name isEqualToString:@"加拿大移民"]) {
//        tmp_arr = @[];
//    }else if ([f.tribe_name isEqualToString:@"美国移民"]){
//        tmp_arr = @[
//                    @{@"name":@"孙少平",@"id":@"2001321"},
//                    @{@"name":@"孙少安",@"id":@"2001321"},
//                    @{@"name":@"田润叶",@"id":@"2001321"}
//                    ];
//    }
    if (tmp_arr != nil && [tmp_arr isKindOfClass:[NSArray class]]) {
        f.tribeHosts = (NSArray *)tmp_arr;
        if (f.tribeHosts.count > 0) {
            
            NSMutableString *tribeHostString = [[NSMutableString alloc] init];
            NSMutableArray *tmp_names = [[NSMutableArray alloc] init];
            for (NSInteger cou = 0; cou < f.tribeHosts.count; cou ++) {
                [tmp_names addObject:[f.tribeHosts[cou] returnValueWithKey:@"name"]];
                [tribeHostString appendString:[f.tribeHosts[cou] returnValueWithKey:@"name"]];
                if (cou != f.tribeHosts.count - 1) {
                    [tribeHostString appendString:@"  "];
                }
            }
            f.tribeHostString = tribeHostString;
            f.tribeHostNames = tmp_names;
            CGRect textRect = [f.tribeHostString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 10000)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_UI24PX]}
                                                              context:nil];
            f.tribeHostTextHeight = textRect.size.height + 5.f;
            //NSLog(@" 圈子详情页 版主所需高度 --- > h: %f  --- w:%f",f.tribeHostTextHeight,textRect.size.width);

        }
    }
    
    
    if (completion) {
        completion(f);
    }
    
}

#pragma mark - 改版具体圈子详情接口数据

+(void)doGetTribeDetailInfoHandleData:(id)responseObject sort_type:(NSString *)sort complete:(DataHandlerComplete)completion{

    NSDictionary *data = [responseObject returnValueWithKey:@"data"];
    NSString *total = [data returnValueWithKey:@"total"];
    NSArray *infoList = [data returnValueWithKey:@"infoList"];

    if ([sort isEqualToString:TRIBE_HOTEST]) { // 最热
        
        [HNBUtils sandBoxSaveInfo:total forKey:tribeshow_total_hotestitems_count];
        
    } else if([sort isEqualToString:TRIBE_LATEST]){ // 最新
        
        [HNBUtils sandBoxSaveInfo:total forKey:tribeshow_total_latestitems_count];
    }else if([sort isEqualToString:TRIBE_QATHEM]){ // 问答
        
        [HNBUtils sandBoxSaveInfo:total forKey:tribeshow_total_qaitems_count];
        //NSLog(@" -问答- ");
        
    }else if([sort isEqualToString:TRIBE_PROTHEM]){ // 项目
        
        [HNBUtils sandBoxSaveInfo:total forKey:tribeshow_total_proitems_count];
        //NSLog(@" -项目- ");
    }
    
    NSMutableArray *proItems = [[NSMutableArray alloc] init];
    NSMutableArray *qaItems = [[NSMutableArray alloc] init];
    for (NSInteger cou = 0; cou < infoList.count; cou ++) {
        
        // 创建实体并保存
        if ([sort isEqualToString:TRIBE_HOTEST]) { // 最热
            
            NSDictionary *infoDic = infoList[cou];
            NSDictionary *detail_info = [infoDic returnValueWithKey:@"detail_info"];
            NSDictionary *user_info = [infoDic returnValueWithKey:@"user_info"];
            NSDictionary *level_info = [user_info returnValueWithKey:@"levelInfo"];
            NSString* searchId =  [detail_info returnValueWithKey:@"id"];
            
            // 查重
            NSArray *idArry = [DetailTribeHotestitem MR_findByAttribute:@"detail_id" withValue:searchId];
            if (idArry == nil || idArry.count == 0)
            {
                DetailTribeHotestitem *f = [DetailTribeHotestitem MR_createEntity];
                // 数据导入
                [f MR_importValuesForKeysWithObject:infoDic];
                [f MR_importValuesForKeysWithObject:user_info];
                [f MR_importValuesForKeysWithObject:detail_info];
                // 数据处理后更新
                f.level  = [level_info returnValueWithKey:@"level"];
                f.user_id = [user_info returnValueWithKey:@"id"];
                f.detail_id = [detail_info returnValueWithKey:@"id"];
                f.user_name = [user_info returnValueWithKey:@"name"];
                f.certified = [user_info returnValueWithKey:@"certified"];
                f.certified_type = [user_info returnValueWithKey:@"certified_type"];
                
                NSArray *img_lists = [infoDic returnValueWithKey:@"img_list"];
                NSMutableString *img_listString = [[NSMutableString alloc] init];
                for (NSInteger cou = 0; cou < img_lists.count; cou ++) {
                    [img_listString appendFormat:@"%@&",img_lists[cou]];
                }
                f.img_list = img_listString;
                NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval timeInterval = [dat timeIntervalSince1970];
                NSString *dateTime = [NSString stringWithFormat:@"%f",timeInterval];
                f.timestamp = dateTime;
                
                //NSLog(@" 最热 f.title    id : %@------ > %@",f.title,f.tribe_id);
                
            }
            
        } else if([sort isEqualToString:TRIBE_LATEST]){ // 最新
            
            NSDictionary *infoDic = infoList[cou];
            NSDictionary *detail_info = [infoDic returnValueWithKey:@"detail_info"];
            NSDictionary *user_info = [infoDic returnValueWithKey:@"user_info"];
            NSDictionary *level_info = [user_info returnValueWithKey:@"levelInfo"];
            NSString* searchId =  [detail_info returnValueWithKey:@"id"];
            
            // 查重
            NSArray *idArry = [DetailTribeLatestitem MR_findByAttribute:@"detail_id" withValue:searchId];
            if (idArry == nil || idArry.count == 0)
            {
                DetailTribeLatestitem *f = [DetailTribeLatestitem MR_createEntity];
                // 数据导入
                [f MR_importValuesForKeysWithObject:infoDic];
                [f MR_importValuesForKeysWithObject:user_info];
                [f MR_importValuesForKeysWithObject:detail_info];
                // 数据处理后更新
                f.level  = [level_info returnValueWithKey:@"level"];
                f.detail_id = [detail_info returnValueWithKey:@"id"];
                f.user_id = [user_info returnValueWithKey:@"id"];
                f.user_name = [user_info returnValueWithKey:@"name"];
                f.certified = [user_info returnValueWithKey:@"certified"];
                f.certified_type = [user_info returnValueWithKey:@"certified_type"];
                
                NSArray *img_lists = [infoDic returnValueWithKey:@"img_list"];
                NSMutableString *img_listString = [[NSMutableString alloc] init];
                for (NSInteger cou = 0; cou < img_lists.count; cou ++) {
                    [img_listString appendFormat:@"%@&",img_lists[cou]];
                }
                f.img_list = img_listString;
                NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval timeInterval = [dat timeIntervalSince1970];
                NSString *dateTime = [NSString stringWithFormat:@"%f",timeInterval];
                f.timestamp = dateTime;
                
                //NSLog(@" 最新 f.title    id : %@------ > %@",f.title,f.tribe_id);
                
            }
            
            
        }else if ([sort isEqualToString:TRIBE_QATHEM]){
        
            NSDictionary *infoDic = infoList[cou];
            NSDictionary *hot_answer_info = [infoDic valueForKey:@"hot_answer_info"];
            NSDictionary *u_info = [infoDic valueForKey:@"u_info"];
            
            //NSString *searchId =  [infoDic returnValueWithKey:@"id"];
            /*// 查重
            NSArray *tmpArr = [DetailTribeQAitem MR_findByAttribute:@"questionid" withValue:searchId];
            if (tmpArr == nil || tmpArr.count == 0) {
            
                DetailTribeQAitem *f = [DetailTribeQAitem MR_createEntity];
                [f MR_importValuesForKeysWithObject:infoDic];
                f.time = [infoDic returnValueWithKey:@"famat_time"];
            
                NSLog(@" --- > %@",f.time);
            
                f.questionid = [infoDic returnValueWithKey:@"id"];
                f.collect = [infoDic returnValueWithKey:@"answer_num"];
                if (hot_answer_info != nil) {
                    NSDictionary *anserInfo = [hot_answer_info valueForKey:@"u_info"];
                    f.answerid = [anserInfo returnValueWithKey:@"id"];
                    f.answername = [anserInfo returnValueWithKey:@"name"];
                    f.qadescription = [hot_answer_info returnValueWithKey:@"content"];
                }else{
                    f.answerid = @"";
                    f.answername = @"";
                    f.qadescription = @"";
                }
                f.labels = [infoDic valueForKey:@"label_info"];
                f.userid = [u_info returnValueWithKey:@"id"];
                f.username = [u_info returnValueWithKey:@"name"];
                f.userhead_url = [u_info returnValueWithKey:@"head_url"];
                f.certified_type = [u_info returnValueWithKey:@"certified_type"];
                f.certified = [u_info returnValueWithKey:@"certified"];
                
                NSDictionary *levelInfo = [u_info valueForKey:@"levelInfo"];
                f.userid = [levelInfo returnValueWithKey:@"level"];
                
                // 时间戳
                NSDictionary *jsonTmp = [self setTimestampDic:infoDic];
                f.timestamp = [jsonTmp returnValueWithKey:@"timestamp"];
                
            }*/
            
            TribeShowQAModel *f = [TribeShowQAModel mj_objectWithKeyValues:infoDic];
            f.time = [infoDic returnValueWithKey:@"formated_create_time"];
            f.questionid = [infoDic returnValueWithKey:@"id"];
            f.collect = [infoDic returnValueWithKey:@"answer_num"];
            if (hot_answer_info != nil) {
                NSDictionary *anserInfo = [hot_answer_info valueForKey:@"u_info"];
                f.answerid = [anserInfo returnValueWithKey:@"id"];
                f.answername = [anserInfo returnValueWithKey:@"name"];
                f.qadescription = [hot_answer_info returnValueWithKey:@"content_for_app"];
            }else{
                f.answerid = @"";
                f.answername = @"";
                f.qadescription = @"";
            }
            f.labels = [infoDic valueForKey:@"label_info"];
            f.userid = [u_info returnValueWithKey:@"id"];
            f.username = [u_info returnValueWithKey:@"name"];
            f.userhead_url = [u_info returnValueWithKey:@"head_url"];
            f.certified_type = [u_info returnValueWithKey:@"certified_type"];
            f.certified = [u_info returnValueWithKey:@"certified"];
            
            NSDictionary *levelInfo = [u_info valueForKey:@"levelInfo"];
            f.level = [levelInfo returnValueWithKey:@"level"];
            // 时间戳
            NSDictionary *jsonTmp = [self setTimestampDic:infoDic];
            f.timestamp = [jsonTmp returnValueWithKey:@"timestamp"];
            [qaItems addObject:f];
            
            //NSLog(@" certified :%@ ,certified_type :%@ , level : %@",f.certified,f.certified_type,f.level);
            
            //NSLog(@" 圈子问答 ");
            
        }else if ([sort isEqualToString:TRIBE_PROTHEM]){
            
            NSDictionary *infoDic = infoList[cou];
            TribeShowProjectModel *f = [TribeShowProjectModel mj_objectWithKeyValues:infoDic];
            f.proID = [infoDic returnValueWithKey:@"id"];
            
            // 计算高度值
//            f.recommended_reason2 = @"留学+移民，无排期无名额限制，专业学习申达股份第三个是大法官发生的故事发电公司梵蒂冈";
//            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//            [paragraphStyle setLineSpacing:TRIBESHOW_PROITEM_LINESPACE];
            CGRect textRect = [f.recommended_reason2 boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - HORIZON_GAP * 2.0 - TRIBESHOW_ADVANTAGE_ITEM_WIDTH, 10000)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{
                                                                        NSFontAttributeName:[UIFont systemFontOfSize:FONT_UI24PX]
                                                                        }
                                                              context:nil];
            f.advantageHeight = textRect.size.height;
            [proItems addObject:f];
            //NSLog(@" 圈子项目 h: %f --- w: %f",textRect.size.height,textRect.size.width);
            
        }
    }
    
    
    if (completion) {
     
        if ([sort isEqualToString:TRIBE_PROTHEM]) {
            completion(proItems);
        } else if ([sort isEqualToString:TRIBE_QATHEM]){
            completion(qaItems);
        }else {
            completion(responseObject);
        }
        
    }

}

#pragma mark --- 热门圈子

+ (void)doGetHotTribesInTribeIndexInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion
{
    
//    NSString *lastStrTag = [HNBUtils sandBoxGetInfo:[NSString class] forKey:tribe_index_hot_tribes_info_tag];
//    NSArray *dataArr = [responseObject returnValueWithKey:@"data"];
//    
//    NSMutableString *newStrTag = [[NSMutableString alloc] init];
//    for (NSDictionary *dict in dataArr) {
//        
//        [newStrTag appendFormat:@"%@%@%@%@%@",
//         [dict returnValueWithKey:@"theme_num"],
//         [dict returnValueWithKey:@"id"],
//         [dict returnValueWithKey:@"name"],
//         [dict returnValueWithKey:@"follow_num"],
//         [dict returnValueWithKey:@"img_url"]];
//        
//    }
//    
//    //NSLog(@" 热门圈子 lastStrTag %@ --- newStrTag  %@ ",lastStrTag,newStrTag);
//    BOOL isChanged = NO;
//    if (![lastStrTag isEqualToString:newStrTag]) {
//    
//        [TribeIndexHotTribe MR_truncateAll];
//        for (NSInteger cou = 0; cou < dataArr.count; cou ++) {
//            id tmpJson = dataArr[cou];
//            NSDictionary *jsonTmp = [self setTimestampDic:tmpJson];
//            TribeIndexHotTribe *f = [TribeIndexHotTribe MR_createEntity];
//            [f MR_importValuesForKeysWithObject:jsonTmp];
//        }
//        [HNBUtils sandBoxSaveInfo:newStrTag forKey:tribe_index_hot_tribes_info_tag];
//        isChanged = YES;
//    }
//
//    [NetDataCacheHandler writeHotTribesInTribeIndexInfo:dataArr cacheKey:tribe_index_hot_tribes_info];
//    
//    if (completion) {
//        completion(@(isChanged));
//    }
    
    NSArray *dataArr = [responseObject returnValueWithKey:@"data"];
    [TribeIndexHotTribe MR_truncateAll];
    for (NSInteger cou = 0; cou < dataArr.count; cou ++) {
        id tmpJson = dataArr[cou];
        NSDictionary *jsonTmp = [self setTimestampDic:tmpJson];
        TribeIndexHotTribe *f = [TribeIndexHotTribe MR_createEntity];
        [f MR_importValuesForKeysWithObject:jsonTmp];
    }
    [NetDataCacheHandler writeHotTribesInTribeIndexInfo:dataArr cacheKey:tribe_index_hot_tribes_info];
    
    if (completion) {
        completion(responseObject);
    }
    

}

+ (void)doGetHotPostInTribeIndexsInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion
{
    id jsonMain = [responseObject returnValueWithKey:@"data"];
    NSArray *dataArr = [jsonMain returnValueWithKey:@"infoList"];
//    NSString *total = [NSString stringWithFormat:@"%@",[jsonMain valueForKey:@"total"]];
    for (NSInteger cou = 0; cou < dataArr.count; cou ++) {
        
        NSDictionary *infoDic = dataArr[cou];
        NSDictionary *detail_info = [infoDic returnValueWithKey:@"detail_info"];
        NSDictionary *user_info = [infoDic returnValueWithKey:@"user_info"];
        NSDictionary *level_info = [user_info returnValueWithKey:@"levelInfo"];
        NSString* searchId =  [detail_info returnValueWithKey:@"id"];
        NSArray *idArry = [TribeIndexItem MR_findByAttribute:@"detail_id" withValue:searchId];
        if (idArry == nil || idArry.count == 0)
        {
            // 创建实体并保存
            TribeIndexItem *f = [TribeIndexItem MR_createEntity];
            // 数据导入
            [f MR_importValuesForKeysWithObject:infoDic];
            [f MR_importValuesForKeysWithObject:user_info];
            [f MR_importValuesForKeysWithObject:detail_info];
            // 数据处理后更新
            
            f.detail_id = [detail_info returnValueWithKey:@"id"];
            
//            id tmp_userinfoID = [user_info returnValueWithKey:@"id"];
//            if (tmp_userinfoID != [NSNull null]) {
//                f.user_id = [user_info valueForKey:@"id"];
//            }
            
            f.user_id   = [user_info returnValueWithKey:@"id"];
            f.user_name = [user_info returnValueWithKey:@"name"];
            f.certified = [user_info returnValueWithKey:@"certified"];
            f.certified_type = [user_info returnValueWithKey:@"certified_type"];
            f.level     = [level_info returnValueWithKey:@"level"];
            
            NSArray *img_lists = [infoDic returnValueWithKey:@"img_list"];
            NSMutableString *img_listString = [[NSMutableString alloc] init];
            for (NSInteger cou = 0; cou < img_lists.count; cou ++) {
                [img_listString appendFormat:@"%@&",img_lists[cou]];
            }
            f.img_list = img_listString;
            NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval timeInterval = [dat timeIntervalSince1970];
            NSString *dateTime = [NSString stringWithFormat:@"%f",timeInterval];
            f.timestamp = dateTime;
            
            //NSLog(@" 数组总数:%ld   total : %@  存储起来的数据模型 f.detail_id : %@  f.name:%@",dataArr.count,total,f.detail_id,f.title);
            
        }else{
        
             //NSLog(@" 查重操作去除的 searchId : %@",searchId);
            
        }
    }
    
}

#pragma mark ------ 帖子详情 ，圈子信息
+ (void)doGetTribeInfoWithThemeIdHandleData:(id)responseObject complete:(DataHandlerComplete)completion
{
    TribeInfoByThemeIdModel * f = [[TribeInfoByThemeIdModel alloc] init];
    id jsonMain = [responseObject returnValueWithKey:@"data"];
    f.tribeName = [jsonMain returnValueWithKey:@"name"];
    f.triebId = [jsonMain returnValueWithKey:@"id"];
    f.userNum = [jsonMain returnValueWithKey:@"user_num"];
    f.themeNum = [jsonMain returnValueWithKey:@"theme_num"];
    f.country = [jsonMain returnValueWithKey:@"country"];
    NSString* isFollowed = [NSString stringWithFormat:@"%@",[jsonMain returnValueWithKey:@"followed"]];
    if ([isFollowed isEqualToString:@"1"]) {
        f.statue = TRUE;
    }
    else
    {
        f.statue = FALSE;
    }
    
//    NSLog(@"f.statue = %d",f.statue);
    if (completion) {
        
        completion(f);
        
    }
}

#pragma mark ------ 帖子详情 ，楼层回复及评论

+ (void)doGetCommentInDetailThemPageWithThemIDHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    NSMutableArray *tmpData = [[NSMutableArray alloc] init];
    NSDictionary *dataDic = [responseObject returnValueWithKey:@"data"];
    // 存总页数 
    NSInteger totalPageNum = [self caculateTotalPageNumWithResponse:dataDic];
    [HNBUtils sandBoxSaveInfo:[NSString stringWithFormat:@"%ld",(long)totalPageNum] forKey:tribe_detailThem_comments_totalPages];
    
    // 楼层数据 
    NSArray *infoListArr = [dataDic returnValueWithKey:@"infoList"];
    for (NSInteger cou = 0; cou < infoListArr.count; cou ++) {
        
        NSDictionary *infoDic = infoListArr[cou];

        [FloorCommentModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            
            return @{
                     @"floorId":@"id"
                     };
            
        }];
        FloorCommentModel *fCommentModel = [FloorCommentModel mj_objectWithKeyValues:infoDic];
        
        // 组装针对楼层评论的数据数组
        fCommentModel.reply_infoArr = [[NSMutableArray alloc] init];
        NSDictionary *replyDic = [infoDic returnValueWithKey:@"total_relpy"]; //  reply
        NSArray *reply_infoListArr = [replyDic returnValueWithKey:@"infoList"];
        for (NSInteger tmp = 0; tmp < reply_infoListArr.count; tmp ++) {
            
            NSDictionary *tmpDict = reply_infoListArr[tmp];
            
            [FloorCommentReplyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"replyModel_id":@"id"
                         };
            }];
            FloorCommentReplyModel *fReplyModel = [FloorCommentReplyModel mj_objectWithKeyValues:tmpDict];
            [fReplyModel.replyContentArr addObjectsFromArray:[self parseHTMLContents:fReplyModel.content_for_app flag:nil]];
            [fCommentModel.reply_infoArr addObject:fReplyModel];
            
        }
        // 记录 每一个楼层下的回复总数
        fCommentModel.replyTotal_UnderFloor = [replyDic returnValueWithKey:@"total"];
        
        // 解析 HTML 数据 保存数组
        fCommentModel.floorContentArr = [self parseHTMLContents:fCommentModel.content_for_app flag:@"Floor"];
        
        // 数据组装
        TribeDetailInfoCellManager *manager = [[TribeDetailInfoCellManager alloc] init];
        manager.model = fCommentModel;
        [tmpData addObject:manager];
        
    }
    
    if (completion) {
        
        completion(tmpData);
        
    }
    
}

#pragma mark ------ 帖子详情 - 回复详情数据接口

+(void)doGetCommentDetailWithCommentIdHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    NSDictionary *dataDic = [responseObject valueForKey:@"data"];
    NSDictionary *replyDic = [dataDic valueForKey:@"reply"];
    NSArray *infoList = [replyDic valueForKey:@"infoList"];
    
    [FloorCommentModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"floorId":@"id"
                 };
        
    }];
    
    FloorCommentModel *fCommentModel = [FloorCommentModel mj_objectWithKeyValues:dataDic];
    
    if (infoList != nil && infoList.count > 0) {
    
        for (NSInteger cou = 0; cou < infoList.count;cou ++) {
            
            NSDictionary *tmpDict = infoList[cou];
            
            [FloorCommentReplyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"replyModel_id":@"id"
                         };
            }];
            FloorCommentReplyModel *fReplyModel = [FloorCommentReplyModel mj_objectWithKeyValues:tmpDict];
            [fReplyModel.replyContentArr addObjectsFromArray:[self parseHTMLContents:fReplyModel.content_for_app flag:nil]];
            [fCommentModel.reply_infoArr addObject:fReplyModel];
            
        }
        
    }
    
    fCommentModel.replyTotal_UnderFloor = [replyDic returnValueWithKey:@"total"];
    
    fCommentModel.floorContentArr = [self parseHTMLContents:fCommentModel.content_for_app flag:@"Floor"];
    
    TribeDetailInfoCellManager *manager = [[TribeDetailInfoCellManager alloc] init];
    manager.model = fCommentModel;
    
    if (completion) {
        completion(manager);
    }
    
}

+(void)doGetPopularPostHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    id jsonMain = [responseObject returnValueWithKey:@"data"];
    [HNBUtils sandBoxSaveInfo:[jsonMain objectForKey:@"total"] forKey:index_popularpost_all_count];
    NSMutableArray * PostArray = [jsonMain objectForKey:@"themeList"];
    NSInteger countPost = [PostArray count];
    for(int i =0; i<countPost; i++)
    {
        id tmpJson = PostArray[i];
        NSDictionary *jsontmp = [self setTimestampDic:tmpJson];
        
        PopularPost * f = [PopularPost MR_createEntity];
        [f MR_importValuesForKeysWithObject:jsontmp];
        f.ess_img = [jsontmp objectForKey:@"ess_img_410"];
        //NSLog(@"PopularPost ====== >%@",f.title);
    }
    
}

+(void)doGetAllLabelsHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    [Label MR_truncateAll];
    [LabelCate MR_truncateAll];
    
    id jsonMain = [responseObject returnValueWithKey:@"data"];
    NSMutableArray * LabelCateArry = [jsonMain objectForKey:@"cate"];
    for (int i = 0; i < LabelCateArry.count; i++) {
        LabelCate *f = [LabelCate MR_createEntity];
        f.catename = LabelCateArry[i];
        NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval timeInterval = [dat timeIntervalSince1970];
        NSString *dateTime = [NSString stringWithFormat:@"%f",timeInterval];
        f.timestamp = dateTime;
    }
    NSMutableArray * Labels = [jsonMain objectForKey:@"tag"];
    NSInteger countLabels = [Labels count];
    for(int i =0; i<countLabels; i++)
    {
        id tmpJson = Labels[i];
        NSDictionary *jsontmp = [self setTimestampDic:tmpJson];
        Label * f = [Label MR_createEntity];
        [f MR_importValuesForKeysWithObject:jsontmp];
    }

}


+ (void)doGetAllTribesHandleData:(id)responseObject complete:(DataHandlerComplete)completion{


    [Tribe MR_truncateAll];
    NSMutableArray * Tribes = [responseObject returnValueWithKey:@"data"];
    
    NSInteger countLabels = 0;
    if ([Tribes isKindOfClass:[NSArray class]] && Tribes) {
        countLabels = Tribes.count;
    }
    
    for(int i =0; i<countLabels; i++)
    {
        id tmpJson = Tribes[i];
        NSDictionary *jsontmp = [self setTimestampDic:tmpJson];
        Tribe * f = [Tribe MR_createEntity];
        [f MR_importValuesForKeysWithObject:jsontmp];
        //NSLog(@"Tribe ====== >%@",f.name);
    }
    
}

+(void)doVerifyUserInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    /* 跟新用户信息 */
    [PersonalInfo MR_truncateAll];
    id json1 = [responseObject returnValueWithKey:@"data"];
    PersonalInfo *f = [PersonalInfo MR_createEntity];
    [f MR_importValuesForKeysWithObject:json1];
    
    [HNBUtils sandBoxSaveInfo:json1 forKey:PERSONAL_LOCAL_INFO];
//    __block NSString *loginRlt = NETEASE_LOGIN_FAIL;
//    if (![[NIMSDK sharedSDK].loginManager isLogined]) {
//        //如果没有登录网易云IM则自动登录
//        if (f) {
//            NSString *loginAccount = f.netease_im_id;
//            NSString *loginToken = f.netease_im_token;
//            [HNBUtils loginNetEaseIMWithLoginAcount:loginAccount loginToken:loginToken completion:^(id error) {
//                if (!error) {
//                    loginRlt = NETEASE_LOGIN_SUCCESS;
//                }
//                completion(loginRlt);
//            }];
//        }else{
//            completion(loginRlt);
//        }
//
//    }else{
//        completion(loginRlt);
//    }
    if(completion){
        completion(responseObject);
    }
    
}

+(void)doGetTribeIndexBaseInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    id jsonMain = [responseObject returnValueWithKey:@"data"];
    
    /* HotTribeInfo */
    NSMutableArray * TribeInfoArry = [jsonMain returnValueWithKey:@"hotTribeInfo"];
    NSInteger count = TribeInfoArry.count;
    [HotTribeInfo MR_truncateAll];
    for (int i =0; i<count; i++ ) {
        id tmpJson = TribeInfoArry[i];
        NSDictionary *jsontmp = [self setTimestampDic:tmpJson];
        
        HotTribeInfo * f;
        f = [HotTribeInfo MR_createEntity];
        f.name = [jsontmp objectForKey:@"name"];
        f.logo = [jsontmp objectForKey:@"logo"];
        NSNumber * tmpNum = [jsontmp objectForKey:@"comment_num"];
        NSString * tmpString = [NSString stringWithFormat:@"%@",tmpNum];
        f.comment_num = tmpString;
        f.url = [jsontmp objectForKey:@"url"];
        f.timestamp = [jsontmp objectForKey:@"timestamp"];
        //NSLog(@"HotTribeInfo ====== >%@",f.name);
    }
    
    NSMutableArray * TopTribeInfoArry = [jsonMain returnValueWithKey:@"topThemeList"];
    NSInteger TopCount = TopTribeInfoArry.count;
    [TopThemeInfo MR_truncateAll];
    for (int i =0; i<TopCount; i++ ) {
        id tmpJson = TopTribeInfoArry[i];
        NSDictionary *jsontmp = [self setTimestampDic:tmpJson];
        
        TopThemeInfo * f;
        f= [TopThemeInfo MR_createEntity];
        f.title = [jsontmp objectForKey:@"title"];
        f.id = [jsontmp objectForKey:@"id"];
        f.timestamp = [jsontmp objectForKey:@"timestamp"];
        //NSLog(@"TopThemeInfo ====== >%@",f.title);
    }
    
}

+(void)doGetTribeIndexPostHandleData:(id)responseObject start:(int)start complete:(DataHandlerComplete)completion{

    id jsonMain = [responseObject returnValueWithKey:@"data"];
    [HNBUtils sandBoxSaveInfo:[jsonMain objectForKey:@"total"] forKey:tirbe_index_post_all_count];
    [HNBUtils sandBoxSaveInfo:[NSString stringWithFormat:@"%d",0] forKey:tirbe_index_post_this_count];
    
    NSMutableArray * PostArray = [jsonMain objectForKey:@"infoList"];
    NSInteger countPost = [PostArray count];
    NSInteger coutThisPost = 0;
    for(int i =0; i<countPost; i++)
    {
        // 添加时间戳 - 处理网络数据
        id tmpJson = PostArray[i];
        NSDictionary *jsontmp = [self setTimestampDic:tmpJson];
        
        NSString * tmpTribeId = [jsontmp objectForKey:@"id"];
        //帖子查重++++
        NSArray *idArry = [TribeHotPost MR_findByAttribute:@"id" withValue:tmpTribeId];
        if (idArry == nil || idArry.count == 0 || start == 0) {
            TribeHotPost * f;
            f = [TribeHotPost MR_createEntity];
            f.collect = [jsontmp objectForKey:@"collect"];
            f.comment_num = [jsontmp objectForKey:@"comment_num"];
            f.id = [jsontmp objectForKey:@"id"];
            NSArray * tmpPic = [jsontmp objectForKey:@"image_list_370"];
            if (tmpPic.count > 0) {
                NSString * tmpPicStr = [tmpPic componentsJoinedByString:@","];
                f.image_list = tmpPicStr;
            }
            else
            {
                f.image_list = @"NULL";
            }
            f.show_time = [jsontmp objectForKey:@"show_time"];
            f.title = [jsontmp objectForKey:@"title"];
            id tmp = [jsontmp objectForKey:@"view_num"];
            if (tmp != [NSNull null]) {
                f.view_num = [jsontmp objectForKey:@"view_num"];
            }
            
            
            id jsonUser = [jsontmp objectForKey:@"u_info"];
            f.username = [jsonUser objectForKey:@"name"];
            
            id jsonTribe = [jsontmp objectForKey:@"tribeInfo"];
            f.tribeid = [jsonTribe objectForKey:@"id"];
            f.tribename = [jsonTribe objectForKey:@"name"];
            
            f.timestamp = [jsontmp objectForKey:@"timestamp"];
            coutThisPost++;
            //NSLog(@"存帖子 f.timestamp %@ ====== > f.title %@",f.timestamp,f.title);
        }
    }
    
    [HNBUtils sandBoxSaveInfo:[NSString stringWithFormat:@"%ld",(long)coutThisPost] forKey:tirbe_index_post_this_count];
    
}

+(void)doGetIndexCODInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    [CODInfo MR_truncateAll];
    NSMutableArray * CODInfoArray = [responseObject returnValueWithKey:@"data"];
    NSInteger countCOD = [CODInfoArray count];
    for(int i =0; i<countCOD; i++)
    {
        id tmpJson = CODInfoArray[i];
        
        /*
         timestamp － skiplow 用于获取帖子的发表时间
         timestamp2 － rain 用于处理数据库的顺序 ， 取的时候可以以该字段升序或降序排列
         */
        NSMutableDictionary *jsontmp = [[NSMutableDictionary  alloc] init];
        NSDictionary *dict = (NSDictionary *)tmpJson;
        [jsontmp setDictionary:dict];
        NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval timeInterval = [dat timeIntervalSince1970];
        NSString *dateTime = [NSString stringWithFormat:@"%f",timeInterval];
        [jsontmp setValue:dateTime forKey:@"timestamp2"];
        
        CODInfo * f = [CODInfo MR_createEntity];
        [f MR_importValuesForKeysWithObject:jsontmp];
        //NSLog(@"CODInfo ====== >%@",f.title);
    }
    
}

+ (void)doGetIndexActivityInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion{
    
    [CODActivityInfo MR_truncateAll];
    NSMutableArray * CODActivityInfoArray = [responseObject returnValueWithKey:@"data"];
    NSInteger countCODActivity = [CODActivityInfoArray count];
    for(int i =0; i<countCODActivity; i++)
    {
        id tmpJson = CODActivityInfoArray[i];
        NSDictionary *jsontmp = [self setTimestampDic:tmpJson];
        
        CODActivityInfo * f;
        f = [CODActivityInfo MR_createEntity];
        [f MR_importValuesForKeysWithObject:jsontmp];
        //NSLog(@"CODActivityInfo ====== >%@",f.title);
    }
    
    //NSLog(@"successed");
    
}

+ (void)doGetAllActivityInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    [CODActivityClassifyInfo MR_truncateAll];
    NSMutableArray * CODActivityInfoArray = [responseObject returnValueWithKey:@"data"];
    NSInteger countCODActivity = [CODActivityInfoArray count];
    for(int i =0; i<countCODActivity; i++)
    {
        id tmpJson = CODActivityInfoArray[i];
        NSDictionary *jsontmp = [self setTimestampDic:tmpJson];
        
        CODActivityClassifyInfo * f;
        f = [CODActivityClassifyInfo MR_createEntity];
        [f MR_importValuesForKeysWithObject:jsontmp];
        //NSLog(@"CODActivityClassifyInfo ====== >%@",f.title);
    }

}

+ (void)doGetAllCODNationsHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    [CODNation MR_truncateAll];
    NSMutableArray * nations = [responseObject objectForKey:@"data"];
    NSInteger countNations = [nations count];
    for(int i =0; i<countNations; i++)
    {
        id tmpJson = nations[i];
        NSDictionary *jsontmp = [self setTimestampDic:tmpJson];
        
        CODNation * f;
        f = [CODNation MR_createEntity];
        [f MR_importValuesForKeysWithObject:jsontmp];
        //NSLog(@"CODNation ====== >%@",f.name);
    }


}

+(void)doGetAllNationsHandleData:(id)responseObject complete:(DataHandlerComplete)completion{
    
    //NSLog(@"%@",[responseObject objectForKey:@"data"]);
    [NationCode MR_truncateAll];
    NSMutableArray * nations = [responseObject objectForKey:@"data"];
    NSInteger countNations = [nations count];
    for(int i =0; i<countNations; i++)
    {
        id tmpJson = nations[i];
        NSDictionary *jsontmp = [self setTimestampDic:tmpJson];
        NationCode *f = [NationCode MR_createEntity];
        [f MR_importValuesForKeysWithObject:jsontmp];
        //NSLog(@"NationCode %@====== >%@",f.title,f);
    }
    
}

+ (void)dogetCountryCodesHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

//    // 取上一次的IdStr
//    NSString *oldIdStr = [HNBUtils sandBoxGetInfo:[NSString class] forKey:home_user_tel_country_code_idstr];
//    // 生成本次IdStr
//    NSMutableString *idStrs = [[NSMutableString alloc] init];
    NSDictionary *data = [responseObject returnValueWithKey:@"data"];
    NSArray *country_telids = [data returnValueWithKey:@"country_telid"];
//    for (NSDictionary *dict in country_telids) {
//        NSValue *idvalue = [dict valueForKey:@"id"];
//        NSString *idStr = [NSString stringWithFormat:@"%@",idvalue];
//        [idStrs appendString:idStr];
//    }
//    NSString *newIdStr = [NSString stringWithString:idStrs];
//    // 比对两次IdStr，若不同则更新数据库与IdStr ，若相同则不操作数据库
//    if (![newIdStr isEqualToString:oldIdStr]) {
        [TelCountryCode MR_truncateAll];
        for (NSDictionary *infodic in country_telids) {
            NSDictionary *jsontmp = [self setTimestampDic:infodic];
            
            TelCountryCode *f = [TelCountryCode MR_createEntity];
            f.telcountrycodeid = [NSString stringWithFormat:@"%@",[jsontmp returnValueWithKey:@"id"]];
            f.showstring = [jsontmp returnValueWithKey:@"showstring"];
            f.timestamp = [jsontmp returnValueWithKey:@"timestamp"];
            //NSLog(@"%@ =g国家码数据库存数据= > %@",f.telcountrycodeid,f.showstring);
        }
       // [HNBUtils sandBoxSaveInfo:newIdStr forKey:home_user_tel_country_code_idstr];
    //}

}

+ (void)doGetAllNationAndMobieNationAllCODNationInfoHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    NSDictionary *dataDic = [responseObject valueForKey:@"data"];
    NSArray *allCODNationArr = [dataDic returnValueWithKey:@"allCODNation"];
    NSArray *allNationArr = [dataDic returnValueWithKey:@"allNation"];
    NSDictionary *mobileNationDic = [dataDic returnValueWithKey:@"mobileNation"];
    
    [CODNation MR_truncateAll];
    NSInteger allCODcount = [allCODNationArr count];
    for(int i =0; i< allCODcount; i++)
    {
        id tmpJson = allCODNationArr[i];
        NSDictionary *jsontmp = [self setTimestampDic:tmpJson];
        
        CODNation * f;
        f = [CODNation MR_createEntity];
        [f MR_importValuesForKeysWithObject:jsontmp];
        //NSLog(@"CODNation ====== >%@",f.name);
    }
    
    [NationCode MR_truncateAll];
    NSInteger allNationcount = [allNationArr count];
    for(int i =0; i< allNationcount; i++)
    {
        id tmpJson = allNationArr[i];
        NSDictionary *jsontmp = [self setTimestampDic:tmpJson];
        NationCode *f = [NationCode MR_createEntity];
        [f MR_importValuesForKeysWithObject:jsontmp];
        //NSLog(@"NationCode %@====== >%@",f.title,f);
    }
    

    NSArray *country_telids = [mobileNationDic returnValueWithKey:@"country_telid"];
    [TelCountryCode MR_truncateAll];
    for (NSDictionary *infodic in country_telids) {
        NSDictionary *jsontmp = [self setTimestampDic:infodic];
        
        TelCountryCode *f = [TelCountryCode MR_createEntity];
        f.telcountrycodeid = [NSString stringWithFormat:@"%@",[jsontmp returnValueWithKey:@"id"]];
        f.showstring = [jsontmp returnValueWithKey:@"showstring"];
        f.timestamp = [jsontmp returnValueWithKey:@"timestamp"];
        //NSLog(@"%@ =g国家码数据库存数据= > %@",f.telcountrycodeid,f.showstring);
    }
   
    
}

+ (void)doCombineTElForRegisterHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    [PersonalInfo MR_truncateAll];
    id json1 = [responseObject returnValueWithKey:@"data"];
    PersonalInfo *f = [PersonalInfo MR_createEntity];
    [f MR_importValuesForKeysWithObject:json1];
    [HNBUtils sandBoxSaveInfo:@"1" forKey:personal_is_login];
//    [HNBUtils loginNetEaseIMWithLoginAcount:f.netease_im_id loginToken:f.netease_im_token completion:^(id error) {
//        if (!error) {
//            completion(NETEASE_LOGIN_SUCCESS);
//        }else {
//            completion(NETEASE_LOGIN_FAIL);
//        }
//    }];
    [HNBUtils sandBoxSaveInfo:@"1" forKey:IMGuide_hasBeen_Logined];
    if(completion){
        completion(responseObject);
    }
}

+ (void)doCombineTElHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    [PersonalInfo MR_truncateAll];
    id json1 = [responseObject returnValueWithKey:@"data"];
    PersonalInfo *f = [PersonalInfo MR_createEntity];
    [f MR_importValuesForKeysWithObject:json1];
    [HNBUtils sandBoxSaveInfo:@"1" forKey:personal_is_login];
//    [HNBUtils loginNetEaseIMWithLoginAcount:f.netease_im_id loginToken:f.netease_im_token completion:^(id error) {
//        if (!error) {
//            completion(NETEASE_LOGIN_SUCCESS);
//        }else {
//            completion(NETEASE_LOGIN_FAIL);
//        }
//    }];
    [HNBUtils sandBoxSaveInfo:@"1" forKey:IMGuide_hasBeen_Logined];
    if(completion){
        completion(responseObject);
    }

}

+ (void)doGetCouponHandleData:(id)responseObject tmpFlag:(NSString *)tmpFlag complete:(DataHandlerComplete)completion{

    id json1 = [responseObject returnValueWithKey:@"data"];
    NSMutableArray * couponArray = [json1 objectForKey:@"data"];
    for (int index = 0; index < couponArray.count; index++) {
        id tmpJson = couponArray[index];
        NSDictionary *json = [self setTimestampDic:tmpJson];
        NSString *tmpID = [json returnValueWithKey:@"id"];
        NSArray *idArry = [Coupon MR_findByAttribute:@"id" withValue:tmpID];
        if (nil == idArry || 0 == idArry.count)    //查重
        {
            Coupon *f = [Coupon MR_createEntity];
            [f MR_importValuesForKeysWithObject:json];
            f.flag = tmpFlag;
            
            //NSLog(@"测试时间戳 f.timestamp ======= 》 %@",f.timestamp);
            
            
        }
        
    }
    
}

+ (void)entryUserInfoWithParameterHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    NSDictionary *responseDic = (NSDictionary *)responseObject;
    NSDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSDictionary *dataDic = [responseDic objectForKey:@"data"];
    NSDictionary *personInfoDic = [dataDic objectForKey:@"personInfo"];
    NSDictionary *onedayDic = [dataDic objectForKey:@"oneday"];
    NSDictionary *qaDic = [dataDic objectForKey:@"qa"];
    
    NSString *bg_url = [personInfoDic objectForKey:@"bg_url"];
    NSInteger tribeNum = [[dataDic objectForKey:@"tribe"] integerValue];
    NSString *tribeCount = [NSString stringWithFormat:@"%ld",tribeNum];
    NSNumber *isFollowedNum = [dataDic objectForKey:@"isFollowed"];
    NSString *isFollowed = [NSString stringWithFormat:@"%@",isFollowedNum];
    NSInteger onedayNum = [[onedayDic objectForKey:@"total"] integerValue];
    NSString *oneDayCount = [NSString stringWithFormat:@"%ld",onedayNum];
    NSDictionary *latestDic = [onedayDic objectForKey:@"latest"];
    NSString *create_time = [latestDic objectForKey:@"create_time"]; // 当前帖子的创建时间
    NSString *his_id = [latestDic objectForKey:@"id"];
    NSArray *image_list_100 = [latestDic objectForKey:@"image_list_100"];
    NSInteger qaNum = [[qaDic objectForKey:@"qaNum"] integerValue];
    NSString *qaCount = [NSString stringWithFormat:@"%ld",qaNum];
    
    NSString *phead_url = [personInfoDic objectForKey:@"head_url"];
    NSString *pname = [personInfoDic objectForKey:@"name"];
    NSString *pim_state_cn = [personInfoDic objectForKey:@"im_state_cn"];
    NSString *pim_nation_cn = [personInfoDic objectForKey:@"im_nation_cn"];
    NSString *pmotto = [personInfoDic objectForKey:@"motto"];
    //
    if ([pname isEqualToString:@""]) {
        pname = @"--";
    }
    if ([pim_state_cn isEqualToString:@""]) {
        pim_state_cn = @"--";
    }
    if ([pim_nation_cn isEqualToString:@""]) {
        pim_nation_cn = @"--";
    }
    if ([pmotto isEqualToString:@""]) {
        pmotto = @"Ta很懒，没写签名！";
    }
    // 封装结果数据
    [resultDic setValue:phead_url forKey:@"head_url"];
    [resultDic setValue:pname forKey:@"name"];
    [resultDic setValue:pim_state_cn forKey:@"im_state_cn"];
    [resultDic setValue:pim_nation_cn forKey:@"im_nation_cn"];
    [resultDic setValue:pmotto forKey:@"motto"];
    //            [resultDic setValue:p forKey:@"p"];
    [resultDic setValue:bg_url forKey:@"bg_url"];
    [resultDic setValue:isFollowed forKey:@"isFollowed"];
    [resultDic setValue:oneDayCount forKey:@"oneDayCount"];
    [resultDic setValue:image_list_100 forKey:@"image_list_100"];
    [resultDic setValue:tribeCount forKey:@"tribeCount"];
    [resultDic setValue:qaCount forKey:@"qaCount"];
    [resultDic setValue:his_id forKey:@"his_id"];
    [resultDic setValue:create_time forKey:@"create_time"];
    
    completion(resultDic);
}

+(void)showPersonnalInfoWithPersonIdHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    NSDictionary *responseDic = (NSDictionary *)responseObject;
    int errorCode = [[responseDic returnValueWithKey:@"state"] intValue];
    PersonInfoModel *f = [[PersonInfoModel alloc] init];
    if (errorCode == 0) {
        
        NSDictionary *dataDic       = [responseDic returnValueWithKey:@"data"];
        NSDictionary *personDic     = [dataDic returnValueWithKey:@"personInfo"];
        NSDictionary *level_Info    = [personDic returnValueWithKey:@"levelInfo"];
        NSDictionary *specialInfoDic= [dataDic returnValueWithKey:@"specialInfo"];
        
        f.tribenum      = [dataDic returnValueWithKey:@"tribenum"];
        f.qanum         = [dataDic returnValueWithKey:@"qanum"];
        f.type          = [dataDic returnValueWithKey:@"type"];
        f.level         = [level_Info returnValueWithKey:@"level"];
        f.personID      = [personDic returnValueWithKey:@"id"];
        f.name          = [personDic returnValueWithKey:@"name"];
        f.certified     = [personDic returnValueWithKey:@"certified"];
        f.certified_type= [personDic returnValueWithKey:@"certified_type"];
        f.isFollow      = [NSString stringWithFormat:@"%@",[dataDic returnValueWithKey:@"follow"]];
        f.moderator     = [dataDic returnValueWithKey:@"moderator"];
        f.errrormsg     = nil;
        f.introduceForTribe = [personDic returnValueWithKey:@"indroduction"];
        f.netEase_ID    = [personDic returnValueWithKey:@"netease_im_id"];
        f.netEase_token = [personDic returnValueWithKey:@"netease_im_token"];
        f.is_Need_Follow      = [NSString stringWithFormat:@"%@",[dataDic returnValueWithKey:@"is_need_follow"]];
        
        if ([f.type isEqualToString:@"normal"]) {
            NSString *introduce;
            if (f.certified.length != 0) {
                introduce = [specialInfoDic returnValueWithKey:@"signature"];
            }else{
                introduce = [personDic returnValueWithKey:@"motto"];
            }
            
            f.bg_url    = [personDic returnValueWithKey:@"bg_url"];
            f.head_url  = [personDic returnValueWithKey:@"head_url"];
            f.leftText  = [personDic returnValueWithKey:@"im_state_cn"];
            f.rightText = [personDic returnValueWithKey:@"im_nation_cn"];
            f.introduce = introduce;
            
        } else if ([f.type isEqualToString:@"special"]){
            
            f.leftText  = [specialInfoDic returnValueWithKey:@"expertLabel"];
            f.rightText = [specialInfoDic returnValueWithKey:@"rate"];
            f.head_url  = [specialInfoDic returnValueWithKey:@"head_url"];
            f.introduce = [specialInfoDic returnValueWithKey:@"signature"];
        }
        
    } else {
       
        f.errrormsg = @"用户可能不存在";
        
    }
    
    if (completion) {
        completion(f);
        // NSLog(@"他人的个人中心  f.tribenum : %@ ------ f.qanum : %@",f.tribenum,f.qanum);
    }
    
}


+(void)doGetHisTribeDataWithPersonIdHandleData:(id)responseObject complete:(DataHandlerComplete)completion{
    
    
    NSDictionary *responseDic = (NSDictionary *)responseObject;
    int errorCode = [[responseDic returnValueWithKey:@"state"] intValue];
    
    NSMutableArray *models = [[NSMutableArray alloc] init];
    if (errorCode == 0) {
        
        NSDictionary *dataDic = [responseObject returnValueWithKey:@"data"];
        NSArray *listArr = [dataDic returnValueWithKey:@"list"];
        NSString *total = [dataDic returnValueWithKey:@"totle"];

        NSString *postNum = [dataDic returnValueWithKey:@"themeNum"];
//        NSString *replyNum = [dataDic returnValueWithKey:@"CommentNum"];
        [HNBUtils sandBoxSaveInfo:total forKey:userinfo_histribe_total_post];
        
        for (NSInteger cou = 0; cou < listArr.count; cou ++) {
            
            NSDictionary *tmpDic = listArr[cou];
            NSDictionary *mDic = [self setTimestampDic:tmpDic];
            
            //            UserInfoHisTribePost *f = [UserInfoHisTribePost MR_createEntity];
            //            [f MR_importValuesForKeysWithObject:mDic];
            UserInfoHisTribePostModel *f = [UserInfoHisTribePostModel mj_objectWithKeyValues:mDic];
            [models addObject:f];
        }
        [HNBUtils sandBoxSaveInfo:postNum forKey:userinfo_histribe_total_post];
        
    } else {
        [models addObject:@"error"];
        NSLog(@" 改版(2.1) - 他人的个人中心 - TA的圈子 : %@",[responseObject returnValueWithKey:@"data"]);
    }
    
    if (completion) {
        completion(models);
    }
    
}

/*2.6新版他的回帖*/
+(void)doGetHisReplyDataWithPersonIdHandleData:(id)responseObject complete:(DataHandlerComplete)completion{
    NSDictionary *responseDic = (NSDictionary *)responseObject;
    int errorCode = [[responseDic returnValueWithKey:@"state"] intValue];
    
    NSMutableArray *models = [[NSMutableArray alloc] init];
    if (errorCode == 0) {
        
        NSDictionary *dataDic = [responseObject returnValueWithKey:@"data"];
        NSArray *listArr = [dataDic returnValueWithKey:@"infoList"];
        NSString *total = [dataDic returnValueWithKey:@"total"];

        [HNBUtils sandBoxSaveInfo:total forKey:userinfo_hisReply_total];
        
        for (NSInteger cou = 0; cou < listArr.count; cou ++) {
            
            NSDictionary *tmpDic = listArr[cou];
            NSDictionary *mDic = [self setTimestampDic:tmpDic];

            UserInfoTribeReplyModel *f = [UserInfoTribeReplyModel mj_objectWithKeyValues:mDic];
            [models addObject:f];
        }
    } else {
        [models addObject:@"error"];
        NSLog(@" 改版(2.1) - 他人的个人中心 - TA的回帖 : %@",[responseObject returnValueWithKey:@"data"]);
    }
    
    if (completion) {
        completion(models);
    }
}

+(void)doGetHisPostDataWithPersonIdHandleData:(id)responseObject complete:(DataHandlerComplete)completion
{
    NSDictionary *responseDic = (NSDictionary *)responseObject;
    int errorCode = [[responseDic returnValueWithKey:@"state"] intValue];
    
    NSMutableArray *models = [[NSMutableArray alloc] init];
    if (errorCode == 0) {
        
        NSDictionary *dataDic = [responseObject returnValueWithKey:@"data"];
        NSArray *listArr = [dataDic returnValueWithKey:@"infoList"];
        NSString *total = [dataDic returnValueWithKey:@"total"];
        
        [HNBUtils sandBoxSaveInfo:total forKey:userinfo_hisPost_total];
        
        for (NSInteger cou = 0; cou < listArr.count; cou ++) {
            
            NSDictionary *tmpDic = listArr[cou];
            NSDictionary *mDic = [self setTimestampDic:tmpDic];
            
            UserInfoTribePostModel *f = [UserInfoTribePostModel mj_objectWithKeyValues:mDic];
            [models addObject:f];
        }
    } else {
        [models addObject:@"error"];
        NSLog(@" 改版(2.1) - 他人的个人中心 - TA的发帖 : %@",[responseObject returnValueWithKey:@"data"]);
    }
    
    if (completion) {
        completion(models);
    }
}

#pragma mark ------ HisQA
+ (void)doGetHisQADataWithPersonIdHandleData:(id)responseObject complete:(DataHandlerComplete)completion{

    NSDictionary *dataDic = [responseObject returnValueWithKey:@"data"];
    NSArray *listArr = [dataDic returnValueWithKey:@"list"];
    NSString *total = [dataDic returnValueWithKey:@"totle"];
    [HNBUtils sandBoxSaveInfo:total forKey:userinfo_hisqa_total_post];
    NSMutableArray *models = [[NSMutableArray alloc] init];
    for (NSInteger cou = 0; cou < listArr.count; cou ++) {
        
        NSDictionary *infoDic = listArr[cou];
        NSDictionary *values = [self setTimestampDic:infoDic];
        
//        UserInfoHisQAPost *f = [UserInfoHisQAPost MR_createEntity];
//        [f MR_importValuesForKeysWithObject:[self convertDic:values arryToStrWithKey:@"label"]];
        UserInfoHisQAPostModel *f = [UserInfoHisQAPostModel mj_objectWithKeyValues:[self convertDic:values arryToStrWithKey:@"label"]];
        [models addObject:f];
        
    }
        
    
    if (completion) {
        completion(models);
    }

}

#pragma mark --- 问答首页

+ (void)doGetQAIndexQuestionList:(id)responseObject complete:(DataHandlerComplete)completion
{
    id qustionList = [responseObject returnValueWithKey:@"data"];
    NSMutableArray * QuestionIndexItemArray = [qustionList returnValueWithKey:@"questionList"];
    NSInteger countQuestionIndexItem = [QuestionIndexItemArray count];
    for(int i =0; i<countQuestionIndexItem; i++)
    {
        id tmpJson = QuestionIndexItemArray[i];
        NSArray *tmpArr = [QuestionIndexItem MR_findByAttribute:@"questionid" withValue:[tmpJson returnValueWithKey:@"questionid"]];
        if (tmpArr == nil || tmpArr.count == 0) {
            NSDictionary *jsontmp = [self setTimestampDic:tmpJson];
            QuestionIndexItem * f;
            f = [QuestionIndexItem MR_createEntity];
            [f MR_importValuesForKeysWithObject:jsontmp];
            //特殊字段处理
            f.qadescription = [tmpJson returnValueWithKey:@"description"];
            id answerInfo = [tmpJson returnValueWithKey:@"answerInfo"];
            if ([answerInfo isKindOfClass:[NSDictionary class]]) {
                f.answername = [answerInfo returnValueWithKey:@"name"];
                f.answerid = [answerInfo returnValueWithKey:@"uid"];
            }
            else
            {
                f.answername = @"";
                f.answerid = @"";
            }
            
            
            id userInfo = [tmpJson returnValueWithKey:@"userInfo"];
            
            NSDictionary *level_info = [userInfo returnValueWithKey:@"levelInfo"];
            
            f.userid        = [userInfo returnValueWithKey:@"uid"];
            f.username      = [userInfo returnValueWithKey:@"name"];
            f.level         = [level_info returnValueWithKey:@"level"];
            f.userhead_url  = [userInfo returnValueWithKey:@"head_url"];
            f.certified     = [userInfo returnValueWithKey:@"certified"];
            f.certified_type= [userInfo returnValueWithKey:@"certified_type"];
        }

    }
}

+ (void)doGetQAQuestionListByLabels:(id)responseObject complete:(DataHandlerComplete)completion
{
    id qustionList = [responseObject returnValueWithKey:@"data"];
    NSMutableArray * QuestionIndexItemArray = [qustionList returnValueWithKey:@"questionList"];
    NSInteger countQuestionIndexItem = [QuestionIndexItemArray count];
    for(int i =0; i<countQuestionIndexItem; i++)
    {
        id tmpJson = QuestionIndexItemArray[i];
        NSDictionary *jsontmp = [self setTimestampDic:tmpJson];
        QuestionFilterItem * f;
        f = [QuestionFilterItem MR_createEntity];
        [f MR_importValuesForKeysWithObject:jsontmp];
        //特殊字段处理
        f.qadescription = [tmpJson returnValueWithKey:@"description"];
        id answerInfo   = [tmpJson returnValueWithKey:@"answerInfo"];
        if ([answerInfo isKindOfClass:[NSDictionary class]])
        {
            f.answername = [answerInfo returnValueWithKey:@"name"];
            f.answerid = [answerInfo returnValueWithKey:@"uid"];
        }
        else
        {
            f.answername = @"";
            f.answerid = @"";
        }
        id userInfo = [tmpJson returnValueWithKey:@"userInfo"];
        NSDictionary *level_info = [userInfo returnValueWithKey:@"levelInfo"];
        
        f.userid        = [userInfo returnValueWithKey:@"uid"];
        f.username      = [userInfo returnValueWithKey:@"name"];
        f.level         = [level_info returnValueWithKey:@"level"];
        f.userhead_url  = [userInfo returnValueWithKey:@"head_url"];
        f.certified     = [userInfo returnValueWithKey:@"certified"];
        f.certified_type= [userInfo returnValueWithKey:@"certified_type"];
    }
}

+ (void)doGetSpecialistsList:(id)responseObject complete:(DataHandlerComplete)completion
{
    [QASpecialList MR_truncateAll];
    id qustionList = [responseObject returnValueWithKey:@"data"];
    NSMutableArray * QuestionSpecialListItemArray = [qustionList returnValueWithKey:@"specialistsList"];
    NSInteger countSpecialListItem = [QuestionSpecialListItemArray count];
    for(int i =0; i<countSpecialListItem; i++)
    {
        id tmpJson = QuestionSpecialListItemArray[i];
        NSDictionary *jsontmp = [self setTimestampDic:tmpJson];
        QASpecialList * f;
        f = [QASpecialList MR_createEntity];
        [f MR_importValuesForKeysWithObject:jsontmp];
    }
}

#pragma mark ------------------------------------------- private method
#pragma mark 时间戳方法
+ (NSDictionary *)setTimestampDic:(id)info{
    NSDictionary *dic = (NSDictionary *)info;
    NSMutableDictionary *jsontmp = [[NSMutableDictionary alloc] init];
    [jsontmp setDictionary:dic];
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval = [dat timeIntervalSince1970];
    NSString *dateTime = [NSString stringWithFormat:@"%f",timeInterval];
    [jsontmp setValue:dateTime forKey:@"timestamp"];
    return jsontmp;
}

+ (NSString *)formDateStringWithConfigDateTime:(NSString *)dateTime{
    /*
     2017-10-28 15:30:00 转为 2017-10-28
     */
    NSArray *strs = [dateTime componentsSeparatedByString:@" "];
    NSString *rltstring = [strs firstObject];
    return rltstring;
}

#pragma mark - NSArry 转 NSString 

+ (NSDictionary *)convertDic:(id)info arryToStrWithKey:(NSString *)key{

    NSDictionary *dic = (NSDictionary *)info;
    NSMutableDictionary *jsontmp = [[NSMutableDictionary alloc] init];
    [jsontmp setDictionary:dic];
    //NSLog(@" 移除前 ------ > %@",jsontmp);
    [jsontmp removeObjectForKey:key];
    //NSLog(@" 移除后 ------ > %@",jsontmp);
    NSMutableString *tmpString = [[NSMutableString alloc] init];
    NSArray *arr = [dic returnValueWithKey:key];
    for (NSString *str in arr) {
        [tmpString appendFormat:@"%@&",str];
        //NSLog(@"拼接字符串 ：%@",tmpString);
    }
    [jsontmp setValue:tmpString forKey:key];
    //NSLog(@" 最终所得字典 ------ > %@",jsontmp);
    return jsontmp;
}


#pragma mark ------ （帖子详情 ，楼层回复及评论）解析 HTML

+ (NSArray *)parseHTMLContents:(NSString *)content flag:(NSString *)flag{

    /**< 解析 >*/
    NSMutableArray *texts = [[NSMutableArray alloc] init];
    NSMutableArray *imgs = [[NSMutableArray alloc] init];
    NSMutableArray *hypers = [[NSMutableArray alloc] init];
    NSMutableArray *brs = [[NSMutableArray alloc] init];
    
    NSMutableArray *htmlContents = [[NSMutableArray alloc] init];
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *htmlParser = [[TFHpple alloc] initWithHTMLData:data];
    // img
    NSArray *IMGElementsArr = [htmlParser searchWithXPathQuery:@"//img"];
    for (TFHppleElement *tempAElement in IMGElementsArr) {
        NSString *imgStr = [tempAElement objectForKey:@"src"];
        
        if (![imgStr isKindOfClass:[NSNull class]] && imgStr != nil && imgStr.length > 0) {
            
            HTMLContentModel *f = [[HTMLContentModel alloc] init];
            [imgs addObject:f];
            f.tagType = HTMLContentModelTagImg;
            f.imgURLString = imgStr;
            
            if ([flag isEqualToString:@"Floor"]) {
                
                CGFloat w = [[tempAElement objectForKey:@"rawwidth"] floatValue];
                CGFloat h = [[tempAElement objectForKey:@"rawheight"] floatValue];
                f.imgWidth = w > 0 ? w : SETTING_IMAGE_SIZE_WIDTH;
                f.imgHeight = h > 0 ? h : SETTING_IMAGE_SIZE_WIDTH;
                
            } else {
                f.imgWidth = REPLY_FLOOR_IMAGE_SIZE_WIDTH;
                f.imgHeight = REPLY_FLOOR_IMAGE_SIZE_WIDTH;
            }
            
        }

        
    }
    
    // href
    NSArray *HYPERElementsArr = [htmlParser searchWithXPathQuery:@"//a"];
    for (TFHppleElement *tempAElement in HYPERElementsArr) {
        NSString *hyperStr = [tempAElement objectForKey:@"href"];
        NSString *text = tempAElement.text;
        
        if (![text isKindOfClass:[NSNull class]] && text != nil && text.length > 0) {
            
            HTMLContentModel *f = [[HTMLContentModel alloc] init];
            [hypers addObject:f];
            f.tagType = HTMLContentModelTagHref;
            f.hyperTitle = text;
            f.hyperLink = hyperStr;
        }
        
    }
    
    // text
    NSArray *TEXTElementsArr = [htmlParser searchWithXPathQuery:@"//text()"];
    for (TFHppleElement *tempAElement in TEXTElementsArr) {

        NSString *tmpTextString = tempAElement.content;
        if (![tmpTextString isKindOfClass:[NSNull class]] && tmpTextString != nil && tmpTextString.length > 0) {
         
            HTMLContentModel *f = [[HTMLContentModel alloc] init];
            [texts addObject:f];
            f.tagType = HTMLContentModelTagPText;
            f.textString = tempAElement.content;
            
        }
        
    }
    
    // br
    NSArray *brElements = [htmlParser searchWithXPathQuery:@"//br"];
    for (NSInteger cou = 0;cou < brElements.count;cou ++) {
        
        HTMLContentModel *f = [[HTMLContentModel alloc] init];
        [brs addObject:f];
        f.tagType = HTMLContentModelTagBr;
    
    }
    
    /**< P标签下的文本与超链接中提取出的文本会重复故需要剔除重复文本 >*/
    if (hypers.count > 0 && texts.count > 0) {
     
        [self deleteHypers:hypers fromTexts:texts];
        
    }
    
    /**< 查找各自的 location >*/
    NSRange searchImgRange = NSMakeRange(0, 0);
    NSRange imgRange = NSMakeRange(0, 0);
    NSString *searchString = @"<img";
    for (NSInteger cou = 0; cou < imgs.count; cou ++) {
        
        if (cou ==0) {
            imgRange = [content rangeOfString:searchString];
        }else{
            if ((searchImgRange.location < content.length) && ((searchImgRange.location + searchImgRange.length) <= content.length)) {
                imgRange = [content rangeOfString:searchString options:NSCaseInsensitiveSearch range:searchImgRange];
            }
        }
        
        [locations addObject:[NSValue valueWithRange:imgRange]];
        [htmlContents addObject:imgs[cou]];
        searchImgRange.location = imgRange.location + imgRange.length - 1;
        searchImgRange.length = content.length - searchImgRange.location;
        
    }
    
    NSRange searchHrefRange = NSMakeRange(0, 0);
    NSRange hrefRange = NSMakeRange(0, 0);
    NSString *searchHrefString = @"<a href";
    for (NSInteger cou = 0; cou < hypers.count; cou ++) {
        
        if (cou ==0) {
            hrefRange = [content rangeOfString:searchHrefString];
        }else{
            if ((searchHrefRange.location < content.length) && ((searchHrefRange.location + searchHrefRange.length) <= content.length)) {
                hrefRange = [content rangeOfString:searchHrefString options:NSCaseInsensitiveSearch range:searchHrefRange];
            }
        }
        
        [locations addObject:[NSValue valueWithRange:hrefRange]];
        [htmlContents addObject:hypers[cou]];
        searchHrefRange.location = hrefRange.location + hrefRange.length - 1;
        searchHrefRange.length = content.length - searchHrefRange.location;
        
    }
    
    // text
    NSRange searchTextRange = NSMakeRange(0, 0);
    NSRange textRange = NSMakeRange(0, 0);
    for (NSInteger cou = 0; cou < texts.count; cou ++) {
        
        HTMLContentModel *f = texts[cou];
        
        NSString *searchString = f.textString;
        
        if (cou == 0) {
            
            textRange = [content rangeOfString:searchString];
            
        }else{
            if ((searchTextRange.location < content.length) && ((searchTextRange.location + searchTextRange.length) <= content.length)) {
                textRange = [content rangeOfString:searchString options:NSCaseInsensitiveSearch range:searchTextRange];
            }
        }
        [locations addObject:[NSValue valueWithRange:textRange]];
        [htmlContents addObject:f];
        searchTextRange.location = textRange.location + textRange.length - 1;
        searchTextRange.length = content.length - searchTextRange.location;
        
    }
    
    // br
    NSRange searchBrRange = NSMakeRange(0, 0);
    NSRange brRange = NSMakeRange(0, 0);
    NSString *searchBrString = @"<br/>";
    for (NSInteger cou = 0; cou < brs.count; cou ++) {
        
        HTMLContentModel *f = brs[cou];
        
        if (cou == 0) {
            
            brRange = [content rangeOfString:searchBrString];
            
        }else{
            
            if ((searchBrRange.location < content.length) && ((searchBrRange.location + searchBrRange.length) <= content.length)) {
                brRange = [content rangeOfString:searchBrString options:NSCaseInsensitiveSearch range:searchBrRange];
            }
            
        }
        [locations addObject:[NSValue valueWithRange:brRange]];
        [htmlContents addObject:f];
        searchBrRange.location = brRange.location + brRange.length - 1;
        searchBrRange.length = content.length - searchBrRange.location;
        
    }
    
    /**< 排序 >*/
    [self reorderArr:locations contentArr:htmlContents];

    /**< 插入换行 --- 返回数据>*/
    return [self insertTagBrModelIntoData:htmlContents];
    
}


#pragma mark 剔除

+ (void)deleteHypers:(NSMutableArray *)hypers fromTexts:(NSMutableArray *)texts{
    
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:texts];
    
    for (HTMLContentModel *hyperF in hypers) {
        
        NSString *hyperText = hyperF.hyperTitle;
        
        for (HTMLContentModel *textF in tmpArr) {
            
            NSString *text = textF.textString;
            
            if ([hyperText isEqualToString:text]) {
                
                [texts removeObject:textF];
                
            }
            
        }
        
    }
    
}


#pragma mark 排序
+ (void)reorderArr:(NSMutableArray *)locationArr contentArr:(NSMutableArray *)contentArr{
    
    NSInteger num = locationArr.count;
    for(NSInteger i = 0;i < num;i ++)
    {
        
        for (NSInteger j = 0; j < num - 1 - i; j ++) {
            
            NSValue *preValue = locationArr[j];
            NSValue *backValue = locationArr[j+1];
            NSRange preRange = [preValue rangeValue];
            NSRange backRange = [backValue rangeValue];
            NSInteger preLocation = preRange.location;
            NSInteger backLocation = backRange.location;
            
            if (preLocation > backLocation) {
                
                NSNumber *tmp = locationArr[j];
                [locationArr replaceObjectAtIndex:j withObject:locationArr[j + 1]];
                [locationArr replaceObjectAtIndex:j+1 withObject:tmp];
                
                NSString *tmpString = contentArr[j];
                [contentArr replaceObjectAtIndex:j withObject:contentArr[j + 1]];
                [contentArr replaceObjectAtIndex:j+1 withObject:tmpString];
                
            }
            
        }
        
    }
    
}

#pragma mark 插入

+ (NSMutableArray *)insertTagBrModelIntoData:(NSMutableArray *)contents{

    //[self testNSLog:@"处理前" arr:contents];
    
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:contents];
    [contents removeAllObjects];
    
    HTMLContentModel *lastModel = nil;
    for (NSInteger cou = 0;cou < tmp.count;cou ++) {
        
        HTMLContentModel *f = tmp[cou];

        if (f.tagType == HTMLContentModelTagPText && lastModel.tagType == HTMLContentModelTagPText && lastModel != nil) {
            
            HTMLContentModel *tmpModel = [[HTMLContentModel alloc] init];
            tmpModel.tagType = HTMLContentModelTagBr;
            [contents addObject:tmpModel];
            [contents addObject:f];
            
        }else{
        
            [contents addObject:f];
//            lastModel = f;

        }
        
        if (f.tagType == HTMLContentModelTagBr) {
            
            HTMLContentModel *tmpModel = [[HTMLContentModel alloc] init];
            tmpModel.tagType = HTMLContentModelTagBr;
            [contents addObject:tmpModel];
            
        }
    
        lastModel = f;
        
    }
    
     //[self testNSLog:@"处理后" arr:contents];
    
    return contents;
}

#pragma mark 总页数

+ (NSInteger)caculateTotalPageNumWithResponse:(NSDictionary *)dataDic{

    NSString *perPageNumString = [NSString stringWithFormat:@"%@",[dataDic returnValueWithKey:@"perPageNum"]];
    NSString *totalString = [NSString stringWithFormat:@"%@",[dataDic returnValueWithKey:@"total"]];
    
    NSInteger perPageNum = [perPageNumString integerValue];
    NSInteger total = [totalString integerValue];
    
    if (perPageNum == 0) {
        return 0;
    }
    
    NSInteger tmp = total % perPageNum;
    NSInteger totalPages = (total - tmp) / perPageNum;
    
    if (tmp>0) {
        totalPages += 1;
    }
    
    return totalPages;
}


+ (void)testNSLog:(NSString *)flag arr:(NSArray *)arr{

    NSLog(@" ==================开始 %@ ================== ",flag);
    
    for (HTMLContentModel *tModel in arr) {
        
        
        switch (tModel.tagType) {
                
            case HTMLContentModelTagPText:
            {
                NSLog(@" HTMLContentModelTagPText ");
            }
                break;
            case HTMLContentModelTagImg:
            {
                NSLog(@" HTMLContentModelTagImg ");
            }
                break;
            case HTMLContentModelTagHref:
            {
                NSLog(@" HTMLContentModelTagHref ");
            }
                break;
            case HTMLContentModelTagBr:
            {
                NSLog(@" HTMLContentModelTagBr ");
            }
                break;
                
            default:
                break;
        }

    }
    
    NSLog(@" ==================结束 %@ ================== ",flag);
}

+ (void)doGetActivityIndexHandleData:(id)responseObject complete:(DataHandlerComplete)completion
{

    NSMutableArray * models = [[NSMutableArray alloc]init];
    NSMutableArray * CODActivityInfoArray = [[responseObject returnValueWithKey:@"data"] returnValueWithKey:@"infoList"];
    NSInteger countCODActivity = [CODActivityInfoArray count];
    for(int i =0; i<countCODActivity; i++)
    {
        id tmpJson = CODActivityInfoArray[i];
        NSDictionary *jsontmp = [self setTimestampDic:tmpJson];
        
        CODActivityIndex * f = [CODActivityIndex mj_objectWithKeyValues:jsontmp];
        [models addObject:f];
        //NSLog(@"CODActivityInfo ====== >%@",f.title);
    }
    if (completion) {
        completion(models);
    }
}

+ (void)doGetActivityTotalHandleDataByType:(NSString *)type responseObject:(id)responseObject complete:(DataHandlerComplete)completion
{
    NSMutableArray *totalArray = [responseObject returnValueWithKey:@"data"];
    NSMutableArray * models = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < totalArray.count; i++) {
        NSDictionary *tmpDic = totalArray[i];
        NSString *dataType = [tmpDic returnValueWithKey:@"type"];
        /*获取当前type的数据总数*/
        if ([dataType isEqualToString:@"seminar"]) {
            NSString *total = [tmpDic returnValueWithKey:@"total"];
            [HNBUtils sandBoxSaveInfo:total forKey:activity_seminar_total];
        }else if ([dataType isEqualToString:@"class"]){
            NSString *total = [tmpDic returnValueWithKey:@"total"];
            [HNBUtils sandBoxSaveInfo:total forKey:activity_class_total];
        }else if ([dataType isEqualToString:@"interview"]){
            NSString *total = [tmpDic returnValueWithKey:@"total"];
            [HNBUtils sandBoxSaveInfo:total forKey:activity_interview_total];
        }else if ([dataType isEqualToString:@"activity"]){
            NSString *total = [tmpDic returnValueWithKey:@"total"];
            [HNBUtils sandBoxSaveInfo:total forKey:activity_IMActivity_total];
        }
        /*获取当前type的数据*/
        if ([dataType isEqualToString:type]) {
            NSMutableArray * CODActivityInfoArray = [tmpDic returnValueWithKey:@"infoList"];
            NSInteger countCODActivity = [CODActivityInfoArray count];
            for(int i =0; i<countCODActivity; i++)
            {
                id tmpJson = CODActivityInfoArray[i];
                NSDictionary *jsontmp = [self setTimestampDic:tmpJson];
                
                CODActivityIndex * f = [CODActivityIndex mj_objectWithKeyValues:jsontmp];
                [models addObject:f];
            }
        }
    }
    if (completion) {
        completion(models);
    }
}

#pragma mark - 新页(2.8.4) - 获取项目的大洲与国家
+ (void)doGetContryAndProjectHandleData:(id)responseObject complete:(DataHandlerComplete)completion
{
    NSMutableArray *tmpData = [[NSMutableArray alloc] init];
    NSMutableArray *nationDataArr = nil;
    NSMutableArray *projectDataArr = nil;
    NSMutableArray *contientDataArr = [responseObject returnValueWithKey:@"data"];
    
    for (int index = 0; index < contientDataArr.count; index++) {
        
//        [ProjectContientModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//            return @{
//                     @"nation_id" : @"id"
//                     };
//        }];
        ProjectContientModel *fContientModel = [ProjectContientModel mj_objectWithKeyValues:contientDataArr[index]];
        
        nationDataArr = [contientDataArr[index] returnValueWithKey:@"nations"];
        
        for (int cout = 0; cout < nationDataArr.count; cout ++) {
            
            [ProjectNationsModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"nation_id" : @"id"
//                         @"project_info"
                         };
            }];
            ProjectNationsModel *fNationsModel = [ProjectNationsModel mj_objectWithKeyValues:nationDataArr[cout]];
            
            projectDataArr = [nationDataArr[cout] returnValueWithKey:@"project"];
            for (int tmp = 0; tmp < projectDataArr.count; tmp ++) {
                
                [ProjectItemModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                             @"project_id" : @"id",
                             @"url" : @"murl"
                             };
                }];
                ProjectItemModel *fProjectModel = [ProjectItemModel mj_objectWithKeyValues:projectDataArr[tmp]];
                
                [fNationsModel.project_Arr addObject:fProjectModel];
            }
            
            [fContientModel.nations_Arr addObject:fNationsModel];
        }
        [tmpData addObject:fContientModel];
        
    }
    if (completion) {
        completion(tmpData);
    }
}

+ (void)doGetTabInIMProjectHome:(id)responseObject complete:(DataHandlerComplete)completion {
    
    NSArray *dataArr = [responseObject returnValueWithKey:@"data"];
    NSMutableArray *tmpData = [[NSMutableArray alloc] init];
    
    if (dataArr) {
        for (int tmp = 0; tmp < dataArr.count; tmp ++) {
            IMHomeNationTabModel *fNationModel = [IMHomeNationTabModel mj_objectWithKeyValues:dataArr[tmp]];
            [tmpData addObject:fNationModel];
        }
    }
    
    if (completion) {
        completion(tmpData);
    }
    
}

+ (void)getInfoByTabInIMProjectHome:(id)responseObject complete:(DataHandlerComplete)completion {
    NSDictionary *dataDic = [responseObject returnValueWithKey:@"data"];
    NSMutableArray *bannerArr = [[NSMutableArray alloc] init];
    NSMutableArray *projArr = [[NSMutableArray alloc] init];
    NSMutableArray *visaArr = [[NSMutableArray alloc] init];
    
    //Banner
    NSArray *tmpArr = [dataDic returnValueWithKey:@"banner"];
    for (int tmp = 0; tmp < tmpArr.count; tmp++) {
        [IMHomeBannerModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"img_url"  : @"img"
                     };
        }];
        IMHomeBannerModel *model = [IMHomeBannerModel mj_objectWithKeyValues:tmpArr[tmp]];
        if (model) {
            [bannerArr addObject:model];
        }
    }
    
    //Project
    tmpArr = [dataDic returnValueWithKey:@"project"];
    for (int tmp = 0; tmp < tmpArr.count; tmp++) {
        [IMHomeProjModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"url"         : @"murl",
                     @"proj_id"      : @"id",
                     @"country_id"  : @"country",
                     @"img_url"     : @"f_app_img"
                     };
        }];
        IMHomeProjModel *model = [IMHomeProjModel mj_objectWithKeyValues:tmpArr[tmp]];
        model.time = [model.f_cycle returnValueWithKey:@"time"];
        model.time_unit = [model.f_cycle returnValueWithKey:@"unit"];
        
        model.sum = [model.min_amount_investment returnValueWithKey:@"sum"];
        model.sum_unit = [model.min_amount_investment returnValueWithKey:@"unit"];
        
        model.service_charge = [model.service_fee returnValueWithKey:@"current"];
        model.service_original = [model.service_fee returnValueWithKey:@"original"];
        model.service_unit = [model.service_fee returnValueWithKey:@"unit"];
        if (model.service_original > 0) {
            model.isShowOriginal = YES;
        }else{
            model.isShowOriginal = NO;
        }
        if (model) {
            [projArr addObject:model];
        }
    }
    
    //Visa
    tmpArr = [dataDic returnValueWithKey:@"visa"];
    for (int tmp = 0; tmp < tmpArr.count; tmp++) {
        [IMHomeVisaModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"url"             : @"murl",
                     @"name"            : @"f_mingzi",
                     @"visa_id"         : @"id",
                     @"country_id"      : @"f_guojia_id",
                     @"img_url"         : @"f_app_img",
                     @"service_charge"  : @"f_fuwufei",
                     @"service_original": @"f_original_price",
                     @"interview"       : @"f_mianshi",
                     @"official_charge" : @"f_lingguanshoufei",
                     @"all_charge"      : @"total_fee"
                     };
        }];
        IMHomeVisaModel *model = [IMHomeVisaModel mj_objectWithKeyValues:tmpArr[tmp]];
        model.time = [model.f_cycle returnValueWithKey:@"cycle_time"];
        model.time_unit = [model.f_cycle returnValueWithKey:@"cycle_unit"];
        
//        int all_charge = [model.service_charge floatValue] + [model.official_charge floatValue];
//        model.all_charge = [NSString stringWithFormat:@"%d",all_charge];
        if (model) {
            [visaArr addObject:model];
        }
        
    }
    
    NSDictionary *tmpDic = @{
                             IMHOME_BANNER  :bannerArr,
                             IMHOME_PROJECT :projArr,
                             IMHOME_VISA    :visaArr
                             };
    completion(tmpDic);
    
}

+ (void)doGetHotImmigrantProjectsHandleData:(id)responseObject complete:(DataHandlerComplete)completion{
    
    NSArray *activity = [responseObject returnValueWithKey:@"data"];
    NSMutableArray *activityRlt = [[NSMutableArray alloc] init];
    
    if (activity != nil && activity.count > 0) {
        for (NSInteger cou = 0; cou < activity.count; cou ++) {
            NSDictionary *dict = activity[cou];
            HotIMProjectModel *f = [HotIMProjectModel mj_objectWithKeyValues:dict];
            f.dateStShow = [self formDateStringWithConfigDateTime:f.dateSt];
            f.dateEdShow = [self formDateStringWithConfigDateTime:f.dateEd];
            // 是否上架
            if ([f.status isEqualToString:@"1"]) {
                [activityRlt addObject:f];
            }
            
        }
    }
    
    if(completion){
        completion(activityRlt);
    }
}


+ (void)doLoginWithThirdPartHandleData:(id)responseObject complete:(DataHandlerComplete)completion {
    [PersonalInfo MR_truncateAll];
    id json1 = [responseObject returnValueWithKey:@"data"];
    if (![[json1 objectForKey:@"im_nation"] isEqualToString:@""]) {
        [HNBUtils sandBoxSaveInfo:[json1 objectForKey:@"im_nation"] forKey:IM_NATION_LOCAL];
    }
    if (![[json1 objectForKey:@"im_state"] isEqualToString:@""]) {
        [HNBUtils sandBoxSaveInfo:[json1 objectForKey:@"im_state"] forKey:IM_INTENTION_LOCAL];
    }
    [HNBUtils resetPersonalityNotice];
    PersonalInfo *f = [PersonalInfo MR_createEntity];
    [f MR_importValuesForKeysWithObject:json1];
    [HNBUtils sandBoxSaveInfo:@"1" forKey:personal_is_login];
    [HNBUtils sandBoxSaveInfo:f.is_assess forKey:USER_ASSESSED_IMMIGRANT];
//    [HNBUtils loginNetEaseIMWithLoginAcount:f.netease_im_id loginToken:f.netease_im_token completion:^(id error) {
//        if (!error) {
//            completion(NETEASE_LOGIN_SUCCESS);
//        }else {
//            completion(NETEASE_LOGIN_FAIL);
//        }
//    }];
    [HNBUtils sandBoxSaveInfo:@"1" forKey:IMGuide_hasBeen_Logined];
    if(completion){
        completion(responseObject);
    }
}

#pragma mark ------------------------------------------ app 3.0 版本接口

+(void)doSetIndexFunctionHandleData:(id)responseObject complete:(DataHandlerComplete)completion{
    
    NSMutableArray *funcData = [[NSMutableArray alloc] init];
    NSArray *  jsonValueArray = [responseObject valueForKey:@"data"];
    if (jsonValueArray != nil && jsonValueArray.count > 0) {
        for (NSInteger index = 0; index < jsonValueArray.count; index++) {
            id jsonOneValue = jsonValueArray[index];
            IndexFunctionStatus *f = [[IndexFunctionStatus alloc] init];
            f.name = [jsonOneValue valueForKey:@"name"];
            f.no = [jsonOneValue valueForKey:@"no"];
            f.pic = [jsonOneValue valueForKey:@"pic"];
            f.url = [jsonOneValue valueForKey:@"url"];
            f.title = [jsonOneValue valueForKey:@"title"];
            f.isLocal = [jsonOneValue valueForKey:@"isLocal"];
            f.isHide = [jsonOneValue valueForKey:@"isHide"];
            
            f.isShowTip = [jsonOneValue valueForKey:@"isShowTip"];
            f.tipText = [jsonOneValue valueForKey:@"tipText"];
            f.tipBgColor = [jsonOneValue valueForKey:@"tipBgColor"];
            
            [funcData addObject:f];
            if ([f.name isEqualToString:@"imassess"]) {
                [HNBUtils encodeCustomDataModel:f toFile:homePage_func_imassess_fileName];
            }
        }
    }
    if(completion){
        completion(funcData);
    }
    
}

+ (void)doGetHomePage30PreferredPlanHandleData:(id)responseObject complete:(DataHandlerComplete)completion{
    
/**<判断是否有网络数据
 1. 有 ：先更新本地缓存数据再解析本地数据
 2. 无 ：只需解析本地数据>*/
    NSArray *jsonArray = [responseObject returnValueWithKey:@"data"];
    if (jsonArray != nil && jsonArray.count > 0) {
        [HNBFileManager writeDicAPPNetInterfaceData:responseObject cacheKey:PREFERRED_PLANS_DIC_DATAS];
    }else{
        NSDictionary *localData = [HNBFileManager readDicAPPNetInterfaceDataWithCacheKey:PREFERRED_PLANS_DIC_DATAS];
        jsonArray = [localData returnValueWithKey:@"data"];
    }
    
    NSMutableArray *rltData = [[NSMutableArray alloc] init];
    if (jsonArray != nil && jsonArray.count > 0) {
        for (NSInteger cou = 0; cou < jsonArray.count; cou ++) {
            id dict = jsonArray[cou];
            PreferredPlanModel *f = [PreferredPlanModel mj_objectWithKeyValues:dict];
            f.proId = [dict returnValueWithKey:@"id"];
            [rltData addObject:f];
            
        }
    }
    if (completion) {
        completion(rltData);
    }
}

// 首页 Banner 功能区 快讯
+ (void)doGetHomePage30BannerFuntionsLatestNewsHandleData:(id)responseObject complete:(DataHandlerComplete)completion{
    NSDictionary *dataJson =[responseObject returnValueWithKey:@"data"];
    NSArray *banner_list = [dataJson returnValueWithKey:@"banner_list"];
    NSArray *navi_list = [dataJson returnValueWithKey:@"navi_list"];
    NSArray *flash_list = [dataJson returnValueWithKey:@"flash_list"];
    
    NSMutableArray *bannerRlt = [[NSMutableArray alloc] init];
    NSMutableArray *naviRlt = [[NSMutableArray alloc] init];
    NSMutableArray *flashRlt = [[NSMutableArray alloc] init];
    if (banner_list != nil && banner_list.count > 0) {
        for (NSInteger cou = 0; cou < banner_list.count; cou ++) {
            NSDictionary *dict = banner_list[cou];
            HomeBannerModel *f = [HomeBannerModel mj_objectWithKeyValues:dict];
            [bannerRlt addObject:f];
        }
    }
    
    if (navi_list != nil && navi_list.count > 0) {
        for (NSInteger cou = 0; cou < navi_list.count; cou ++) {
            NSDictionary *dict = navi_list[cou];
            FunctionModel *f = [FunctionModel mj_objectWithKeyValues:dict];
            [naviRlt addObject:f];
        }
    }
    
    if (flash_list != nil && flash_list.count > 0) {
        for (NSInteger cou = 0; cou < flash_list.count; cou ++) {
            NSDictionary *dict = flash_list[cou];
            LatestNewsModel *f = [LatestNewsModel mj_objectWithKeyValues:dict];
            [flashRlt addObject:f];
        }
    }
    
    if (completion) {
        NSDictionary *rlt = @{
                              @"banner_list":bannerRlt,
                              @"navi_list":naviRlt,
                              @"flash_list":flashRlt,
                              };
        completion(rlt);
    }
    
}

// 首页 推荐专家 推荐活动 热门话题
+ (void)doGetHomePage30RcmdSpecialRcmdActivityHotTopicHandleData:(id)responseObject complete:(DataHandlerComplete)completion{
    NSDictionary *dataJson =[responseObject returnValueWithKey:@"data"];
    NSArray *specialist = [dataJson returnValueWithKey:@"specialist"];
    NSArray *activity = [dataJson returnValueWithKey:@"activity"];
    NSArray *topic = [dataJson returnValueWithKey:@"topic"];
    NSArray *class = [dataJson returnValueWithKey:@"class"];
    
    NSMutableArray *specialistRlt = [[NSMutableArray alloc] init];
    NSMutableArray *activityRlt = [[NSMutableArray alloc] init];
    NSMutableArray *topicRlt = [[NSMutableArray alloc] init];
    NSMutableArray *classRlt = [[NSMutableArray alloc] init];
    
    if (specialist != nil && specialist.count > 0) {
        for (NSInteger cou = 0; cou < specialist.count; cou ++) {
            NSDictionary *dict = specialist[cou];
            RcmdSpecialModel *f = [RcmdSpecialModel mj_objectWithKeyValues:dict];
            
            if (f.specializednations != nil && f.specializednations.count > 0) {
                NSMutableString *tmp = [[NSMutableString alloc] init];
                for (NSInteger ts = 0; ts < f.specializednations.count; ts ++) {
                    [tmp appendString:f.specializednations[ts]];
                    if (ts < f.specializednations.count - 1) {
                        [tmp appendString:@","];
                    }
                }
                f.nationstring = tmp;
            }
            
            // 是否上架
            if ([f.status isEqualToString:@"1"]) {
                [specialistRlt addObject:f];
            }
            
        }
    }
    
    if (activity != nil && activity.count > 0) {
        for (NSInteger cou = 0; cou < activity.count; cou ++) {
            NSDictionary *dict = activity[cou];
            RcmdActivityModel *f = [RcmdActivityModel mj_objectWithKeyValues:dict];
            
            // 0 - 1 - 2
            if ([f.actStatus isEqualToString:@"0"]) {
                f.actStatusShow = @"未开始";
            }else if ([f.actStatus isEqualToString:@"2"]) {
                f.actStatusShow = @"已结束";
            }else{
                f.actStatusShow = @"进行中";
            }
            
            f.dateStShow = [self formDateStringWithConfigDateTime:f.dateSt];
            f.dateEdShow = [self formDateStringWithConfigDateTime:f.dateEd];
            // 是否上架
            if ([f.status isEqualToString:@"1"]) {
                [activityRlt addObject:f];
            }
            
        }
    }
    
    if (topic != nil && topic.count > 0) {
        for (NSInteger cou = 0; cou < topic.count; cou ++) {
            NSDictionary *dict = topic[cou];
            HotTopicModel *f = [HotTopicModel mj_objectWithKeyValues:dict];
            f.topicId = [dict returnValueWithKey:@"id"];
            [topicRlt addObject:f];
        }
        
    }
    
    if (dataJson != nil && class.count > 0) {
        for (NSInteger cou = 0; cou < class.count; cou ++) {
            NSDictionary *dict = class[cou];
            OverSeaClassModel *f = [OverSeaClassModel mj_objectWithKeyValues:dict];
            [classRlt addObject:f];
        }
    }
    
    if (completion) {
        NSDictionary *rlt = @{
                              @"specialist":specialistRlt,
                              @"activity":activityRlt,
                              @"topic":topicRlt,
                              @"class":classRlt,
                              };
        completion(rlt);
    }
}

// 首页 大咖说 小边说
+ (void)doGetHomePage30GreatTalkHnbEditorTalkHandleData:(id)responseObject complete:(DataHandlerComplete)completion{
    NSDictionary *dataJson =[responseObject returnValueWithKey:@"data"];
    NSArray *big = [dataJson returnValueWithKey:@"big"];
    NSArray *little = [dataJson returnValueWithKey:@"little"];
    
    NSMutableArray *bigRlt = [[NSMutableArray alloc] init];
    NSMutableArray *littleRlt = [[NSMutableArray alloc] init];
    
    if (big != nil && big.count > 0) {
        for (NSInteger cou = 0; cou < big.count; cou ++) {
            NSDictionary *dict = big[cou];
            GreatTalkModel *f = [GreatTalkModel mj_objectWithKeyValues:dict];
            [bigRlt addObject:f];
        }
    }
    
    if (little != nil && little.count > 0) {
        for (NSInteger cou = 0; cou < little.count; cou ++) {
            NSDictionary *dict = little[cou];
            HnbEditorTalkModel *f = [HnbEditorTalkModel mj_objectWithKeyValues:dict];
            f.dateEndShow = [self formDateStringWithConfigDateTime:f.dateEnd];
            [littleRlt addObject:f];
        }
    }
    
    
    if (completion) {
        NSDictionary *rlt = @{
                              @"big":bigRlt,
                              @"little":littleRlt,
                              };
        completion(rlt);
    }
}


// 最新资讯列表
+ (void)doGetListLatestNewsHandleData:(id)responseObject start:(NSInteger)start complete:(DataHandlerComplete)completion{
    NSDictionary *dataDic = [responseObject returnValueWithKey:@"data"];
    NSMutableArray *rlt = [[NSMutableArray alloc] init];
    NSArray *theme_infoArr = [dataDic returnValueWithKey:@"theme_info"];
    NSString *total = [dataDic returnValueWithKey:@"total"];
    BOOL isSame = FALSE;
    
    NSMutableString *curIDString = [[NSMutableString alloc] init];
    
    if (theme_infoArr != nil || theme_infoArr.count > 0) {
        for (NSInteger cou = 0; cou < theme_infoArr.count; cou ++) {
            NSDictionary *dict = theme_infoArr[cou];
            LatestNewsModel *f = [LatestNewsModel mj_objectWithKeyValues:dict];
            f.themid = [dict returnValueWithKey:@"id"];
            //NSLog(@" index: %ld , id :%@ ,title :%@",cou,f.themid,f.title);
            [curIDString appendString:f.themid];
            [rlt addObject:f];
        }
    }
    // 计算前后两次数据是否一样
    if (start <= 0) { // 下拉刷新
        NSString *curIDMD5 = [HNBUtils md5HexDigest:curIDString];
        NSString *lastIDMD5 = [HNBUtils sandBoxGetInfo:[NSString class] forKey:LIST_LATEST_NEWS_LAST_IDMD5];
        if ([curIDMD5 isEqualToString:lastIDMD5]) {
            isSame = TRUE;
        }else{
            [HNBUtils sandBoxSaveInfo:curIDMD5 forKey:LIST_LATEST_NEWS_LAST_IDMD5];
        }
    }
    // 查重

    if (completion) {
        NSDictionary *rltDic = @{
                              @"total":total,
                              @"isSame":[NSString stringWithFormat:@"%d",isSame],
                              @"listData":rlt
                              };
        completion(rltDic);
    }
}

// 专家列表
+ (void)doGetListSpecialHandleData:(id)responseObject complete:(DataHandlerComplete)completion{
    NSArray *dataArr = [responseObject returnValueWithKey:@"data"];
    NSMutableArray *rlt = [[NSMutableArray alloc] init];
    if (dataArr != nil && dataArr.count > 0) {
        for (NSInteger cou = 0; cou < dataArr.count; cou ++) {
            NSDictionary *dict = dataArr[cou];
            RcmdSpecialModel *f = [RcmdSpecialModel mj_objectWithKeyValues:dict];
            if (f.specializednations != nil && f.specializednations.count > 0) {
                NSMutableString *tmp = [[NSMutableString alloc] init];
                for (NSInteger ts = 0; ts < f.specializednations.count; ts ++) {
                    [tmp appendString:f.specializednations[ts]];
                    if (ts < f.specializednations.count - 1) {
                        [tmp appendString:@","];
                    }
                }
                f.nationstring = tmp;
            }
            
            // 是否上架
            if ([f.status isEqualToString:@"1"]) {
                [rlt addObject:f];
            }
        }
    }
    if (completion) {
        completion(rlt);
    }
    
}

// 大咖说列表
+ (void)doGetListGreatTalkHandleData:(id)responseObject complete:(DataHandlerComplete)completion{
    NSArray *dataArr = [responseObject returnValueWithKey:@"data"];
    NSMutableArray *rlt = [[NSMutableArray alloc] init];
    if (dataArr != nil && dataArr.count > 0) {
        for (NSInteger cou = 0; cou < dataArr.count; cou ++) {
            NSDictionary *dict = dataArr[cou];
            GreatTalkModel *f = [GreatTalkModel mj_objectWithKeyValues:dict];
            f.dateShow = [self formDateStringWithConfigDateTime:f.talkTime];
            [rlt addObject:f];
        }
    }
    if (completion) {
        completion(rlt);
    }
    
}

// 小边说列表
+ (void)doGetListHnbEditorTalkHandleData:(id)responseObject complete:(DataHandlerComplete)completion{
    NSArray *dataArr = [responseObject returnValueWithKey:@"data"];
    NSMutableArray *rlt = [[NSMutableArray alloc] init];
    if (dataArr != nil && dataArr.count > 0) {
        for (NSInteger cou = 0; cou < dataArr.count; cou ++) {
            NSDictionary *dict = dataArr[cou];
            HnbEditorTalkModel *f = [HnbEditorTalkModel mj_objectWithKeyValues:dict];
            f.dateEndShow = [self formDateStringWithConfigDateTime:f.dateEnd];
            [rlt addObject:f];
        }
    }
    if (completion) {
        completion(rlt);
    }
    
}
+ (void)doGetIMAssessItemsHandleData:(id)responseObject complete:(DataHandlerComplete)completion {
    NSDictionary *dataJson = [responseObject returnValueWithKey:@"data"];
    // 字典写入文件
    // 创建一个存储字典的文件路径
    // 获取Documents目录
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileDicPath = [docPath stringByAppendingPathComponent:IMAssess_Question_TXT];
    // 字典写入时执行的方法
    [dataJson writeToFile:fileDicPath atomically:YES];

//    NSLog(@"fileDicPath is %@", fileDicPath);
    // 从文件中读取数据字典的方法
//    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:fileDicPath];
//    NSLog(@"%@", dic[@"national_city"]);
    
    
    NSArray *nationalArr = [dataJson returnValueWithKey:@"national_city"];
    NSArray *assessmentArr = [dataJson returnValueWithKey:@"assessment"];
    
    NSMutableArray *nationalResult   = [[NSMutableArray alloc] init];
    NSMutableArray *assessmentResult = [[NSMutableArray alloc] init];
    
    if (nationalArr && nationalArr.count > 0) {
        for (NSDictionary *nation in nationalArr) {
            [IMNationCityModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"icon"        : @"f_icon",
                         @"shortName"   : @"f_name_short_cn",
                         @"fID"         : @"f_id",
                         @"wholeName"   : @"f_name_cn",
                         };
            }];
            IMNationCityModel *f = [IMNationCityModel mj_objectWithKeyValues:nation];
            if (f) {
                [nationalResult addObject:f];
            }
        }
    }
    
    if (assessmentArr && assessmentArr.count > 0) {
        for (NSDictionary *item in assessmentArr) {
            IMAssessItemsModel *f = [IMAssessItemsModel mj_objectWithKeyValues:item];
            if (f) {
                [assessmentResult addObject:f];
            }
        }
    }
    
    if (completion) {
        NSDictionary *resultDic = @{
                                    GuideHome_Nation            :nationalResult,
                                    GuideHome_QuestionOptions   :assessmentResult,
                                    };
        completion(resultDic);
    }
    
}

+ (void)doGetListOverSeaClassHandleData:(id)responseObject complete:(DataHandlerComplete)completion{
    NSDictionary *dicData = [responseObject returnValueWithKey:@"data"];
    NSArray *dataArr = [dicData returnValueWithKey:@"data"];
    NSString *total = [dicData returnValueWithKey:@"total"];
    NSMutableArray *rlt = [[NSMutableArray alloc] init];
    NSMutableDictionary *rltDic = [[NSMutableDictionary alloc] init];
    if (dataArr != nil && dataArr.count > 0) {
        for (NSInteger cou = 0; cou < dataArr.count; cou ++) {
            NSDictionary *dict = dataArr[cou];
            OverSeaClassModel *f = [OverSeaClassModel mj_objectWithKeyValues:dict];
            [rlt addObject:f];
        }
    }
    [rltDic setObject:rlt forKey:overseaclass_data];
    [rltDic setObject:total forKey:overseaclass_total];
    if (completion) {
        completion(rltDic);
    }
}

+ (void)doGetIMNotificationWithHandlerData:(id)responseObject complete:(DataHandlerComplete)completion
{
    NSDictionary *dataDic = [responseObject returnValueWithKey:@"data"];
    NSArray *list           = [dataDic returnValueWithKey:@"list"];
    NSString *lastestCount  = [dataDic returnValueWithKey:@"f_unread_num"];
    NSString *total         = [dataDic returnValueWithKey:@"total"];
    NSMutableDictionary *rltDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *rlt = [[NSMutableArray alloc] init];
    if (list != nil && list.count > 0) {
        for (NSInteger cou = 0; cou < list.count; cou ++) {
            NSDictionary *dict = list[cou];
            IMNotificationModel *f = [IMNotificationModel mj_objectWithKeyValues:dict];
            f.f_create_time = [HNBUtils timeWithTimeIntervalString:f.f_create_time];
            [rlt addObject:f];
        }
    }
    [rltDic setObject:rlt forKey:IMNotification_Datas];
    [rltDic setObject:lastestCount forKey:IMNotification_Lastest_Count];
    [rltDic setObject:total forKey:IMNotification_Total];
    if (completion) {
        completion(rltDic);
    }
}

+ (void)doGetAllShowServiceListWithHandlerData:(id)responseObject complete:(DataHandlerComplete)completion
{
    NSDictionary *dataDic = [responseObject returnValueWithKey:@"data"];
    NSDictionary *hnbServiceDic = [dataDic returnValueWithKey:@"hnb_service"];
    NSDictionary *thirdPartServicesDic = [dataDic returnValueWithKey:@"third_party_service"];
    NSDictionary *iconHomeDic = [dataDic returnValueWithKey:@"icon_home"];
    
    NSArray *hnbServiceArr = [hnbServiceDic returnValueWithKey:@"list"];
    NSString *hnbGroupName = [hnbServiceDic returnValueWithKey:@"group_name"];
    
    NSArray *thirdPartServiceArr = [thirdPartServicesDic returnValueWithKey:@"list"];
    NSString *thirdPartGroupName = [thirdPartServicesDic returnValueWithKey:@"group_name"];
    
    NSArray *iconHomeArr = [iconHomeDic returnValueWithKey:@"list"];
    
    NSMutableDictionary *rltDic     = [[NSMutableDictionary alloc] init];
    NSMutableArray *hnbTempArr      = [[NSMutableArray alloc] init];
    NSMutableArray *thirdPartArr    = [[NSMutableArray alloc] init];
    NSMutableArray *iconHomeTempArr = [[NSMutableArray alloc] init];
    
    for (int index = 0 ; index < hnbServiceArr.count; index++) {
        NSDictionary *tempDic = hnbServiceArr[index];
        ShowAllServicesModel *f = [ShowAllServicesModel mj_objectWithKeyValues:tempDic];
        [hnbTempArr addObject:f];
    }
    for (int index = 0 ; index < thirdPartServiceArr.count; index++) {
        NSDictionary *tempDic = thirdPartServiceArr[index];
        ShowAllServicesModel *f = [ShowAllServicesModel mj_objectWithKeyValues:tempDic];
        [thirdPartArr addObject:f];
    }
    for (int index = 0 ; index < iconHomeArr.count; index++) {
        NSDictionary *tempDic = iconHomeArr[index];
        ShowAllServicesModel *f = [ShowAllServicesModel mj_objectWithKeyValues:tempDic];
        [iconHomeTempArr addObject:f];
    }
    
    [rltDic setObject:[hnbTempArr copy] forKey:showallservices_hnbservice];
    [rltDic setObject:[thirdPartArr copy] forKey:showallservices_thirdpartyservice];
    [rltDic setObject:[iconHomeTempArr copy] forKey:showallicon_home];
    [rltDic setObject:hnbGroupName forKey:showallservices_hnbgroupname];
    [rltDic setObject:thirdPartGroupName forKey:showallservices_thirdgroupname];
    
    if (completion) {
        completion(rltDic);
    }
}

+(void)doGetOverSeaServiceListWithHandlerData:(id)responseObject complete:(DataHandlerComplete)completion{
    
    NSArray *dataArr = [responseObject returnValueWithKey:@"data"];
    NSMutableArray *rlt = [[NSMutableArray alloc] init];
    rlt = dataArr != nil ? [CardTableDataModel mj_objectArrayWithKeyValuesArray:dataArr] : nil;
    if (completion) {
        completion(rlt);
    }
    
}

@end




