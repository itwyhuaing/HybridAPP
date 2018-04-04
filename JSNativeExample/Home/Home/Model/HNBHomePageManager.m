//
//  HNBHomePageManager.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/18.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "HNBHomePageManager.h"
#import "DataFetcher.h"
//#import "NSDictionary+ValueForKey.h"
#import "PersonalInfo.h"
#import <NIMSDK/NIMSDK.h>

extern CFAbsoluteTime appOpenStartTime;
@interface HNBHomePageManager ()
{   // 网络状态标识
    BOOL bflNetStatus;
    BOOL sahNetStatus;
    BOOL pNetStatus;
    BOOL gtNetStatus;
    BOOL stNetStatus;
    // 移民评估弹框的相关请求只在第一次进入时发起
    BOOL isFirstReq;
    // 是否离开队列组
    BOOL isLeaveBFL;
    BOOL isLeaveSAT;
    BOOL isLeavePPlan;
    BOOL isLeaveAllServece;
}

@property (nonatomic,copy) NSString *imassessedCountString; // 后台获取的已经做过评估数据

@end

@implementation HNBHomePageManager

-(instancetype)init {
    if (self = [super init]) {
        isFirstReq = YES;
    }
    return self;
}

-(void)homePageReqDataForLatestDataUpScreen{
    
    __block NSDictionary *dic1;
    __block NSDictionary *dic2;
    __block NSArray *plans;
    __block NSArray *funcArr;
    __block NSArray *hnbServiceArr;
    __block NSArray *thirdPartArr;
    
    isLeaveBFL = FALSE;
    isLeaveSAT = FALSE;
    isLeavePPlan = FALSE;
    isLeaveAllServece = FALSE;
    
    dispatch_group_t loadGroup = dispatch_group_create();
    dispatch_queue_t loadQueue = dispatch_queue_create("homePageReqDataForLatestDataUpScreenLoadQueue", DISPATCH_QUEUE_CONCURRENT);
    
//    dispatch_group_enter(loadGroup);
//    [DataFetcher doGetHomePage30BannerFuntionsLatestNewsWithSucceedHandler:^(id JSON) {
//        dic1 = (NSDictionary *)JSON;
//        bflNetStatus = TRUE;
//        dispatch_group_leave(loadGroup);
//    } withFailHandler:^(id error) {
//        bflNetStatus = FALSE;
//        dispatch_group_leave(loadGroup);
//    }];
    
//    dispatch_group_enter(loadGroup);
//    [DataFetcher doGetHomePage30RcmdSpecialRcmdActivityHotTopicWithSucceedHandler:^(id JSON) {
//        dic2 = (NSDictionary *)JSON;
//        sahNetStatus = TRUE;
//        dispatch_group_leave(loadGroup);
//    } withFailHandler:^(id error) {
//        sahNetStatus = FALSE;
//        dispatch_group_leave(loadGroup);
//    }];
    

    
//    dispatch_group_enter(loadGroup);
//    [DataFetcher doGetHomePage30PreferredPlan:nil withSucceedHandler:^(id JSON) {
//        if ([JSON isKindOfClass:[NSArray class]]) {
//            plans = (NSArray *)JSON;
//        }
//        pNetStatus = TRUE;
//        dispatch_group_leave(loadGroup);
//    } withFailHandler:^(id error) {
//        pNetStatus = FALSE;
//        dispatch_group_leave(loadGroup);
//    }];
    
//    dispatch_group_enter(loadGroup);
//    [DataFetcher doGetAllShowServiceListWithSucceedHandler:^(id JSON) {
//        if (JSON) {
//            hnbServiceArr = [JSON valueForKey:showallservices_hnbservice];
//            thirdPartArr = [JSON valueForKey:showallservices_thirdpartyservice];
//            funcArr = [[JSON valueForKey:showallicon_home] copy];
//
//            NSString *hnbString = [JSON valueForKey:showallservices_hnbgroupname];
//            NSString *thirdPartString = [JSON valueForKey:showallservices_thirdgroupname];
//            dispatch_group_leave(loadGroup);
//        }
//    } withFailHandler:^(id error) {
//        dispatch_group_leave(loadGroup);
//    }];

    dispatch_group_enter(loadGroup);
    [DataFetcher doGetHomePage30BannerFuntionsLatestNewsWithLocalCachedHandler:^(id JSON) {
        dic1 = (NSDictionary *)JSON;
        isLeaveBFL = [self queryIsLeaveGrop:isLeaveBFL queueGroup:loadGroup];
    } succeedHandler:^(id JSON) {
        dic1 = (NSDictionary *)JSON;
        bflNetStatus = TRUE;
        isLeaveBFL = [self queryIsLeaveGrop:isLeaveBFL queueGroup:loadGroup];
    } withFailHandler:^(id error) {
        bflNetStatus = FALSE;
        isLeaveBFL = [self queryIsLeaveGrop:isLeaveBFL queueGroup:loadGroup];
    }];
    
    dispatch_group_enter(loadGroup);
    [DataFetcher doGetHomePage30RcmdSpecialRcmdActivityHotTopicWithLocalCachedHandler:^(id JSON) {
        dic2 = (NSDictionary *)JSON;
        isLeaveSAT = [self queryIsLeaveGrop:isLeaveSAT queueGroup:loadGroup];
    } succeedHandler:^(id JSON) {
        dic2 = (NSDictionary *)JSON;
        sahNetStatus = TRUE;
        isLeaveSAT = [self queryIsLeaveGrop:isLeaveSAT queueGroup:loadGroup];
    } withFailHandler:^(id error) {
        sahNetStatus = FALSE;
        isLeaveSAT = [self queryIsLeaveGrop:isLeaveSAT queueGroup:loadGroup];
    }];
    
    dispatch_group_enter(loadGroup);
    [DataFetcher doGetHomePage30PreferredPlanWithLocalCachedHandler:^(id JSON) {
        if ([JSON isKindOfClass:[NSArray class]]) {
            plans = (NSArray *)JSON;
        }
        isLeavePPlan = [self queryIsLeaveGrop:isLeavePPlan queueGroup:loadGroup];
    } para:nil withSucceedHandler:^(id JSON) {
        if ([JSON isKindOfClass:[NSArray class]]) {
            plans = (NSArray *)JSON;
        }
        pNetStatus = TRUE;
        isLeavePPlan = [self queryIsLeaveGrop:isLeavePPlan queueGroup:loadGroup];
    } withFailHandler:^(id error) {
        pNetStatus = FALSE;
        isLeavePPlan = [self queryIsLeaveGrop:isLeavePPlan queueGroup:loadGroup];
    }];
    
    dispatch_group_enter(loadGroup);
    [DataFetcher doGetAllShowServiceListWithLocalCachedHandler:^(id JSON) {
        
        if (JSON) {
            hnbServiceArr = [JSON valueForKey:showallservices_hnbservice];
            thirdPartArr = [JSON valueForKey:showallservices_thirdpartyservice];
            funcArr = [[JSON valueForKey:showallicon_home] copy];
        }
        isLeaveAllServece = [self queryIsLeaveGrop:isLeaveAllServece queueGroup:loadGroup];
    } succeedHandler:^(id JSON) {
        
        if (JSON) {
            hnbServiceArr = [JSON valueForKey:showallservices_hnbservice];
            thirdPartArr = [JSON valueForKey:showallservices_thirdpartyservice];
            funcArr = [[JSON valueForKey:showallicon_home] copy];
        }
        stNetStatus = TRUE;
        isLeaveAllServece = [self queryIsLeaveGrop:isLeaveAllServece queueGroup:loadGroup];
    } withFailHandler:^(id error) {
        stNetStatus = FALSE;
        isLeaveAllServece = [self queryIsLeaveGrop:isLeaveAllServece queueGroup:loadGroup];
    }];
    
    
    
    dispatch_group_notify(loadGroup, loadQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{

            [self upLoadOpenAPPTimeFirst];
            
/* banner_list navi_list flash_list \  activity specialist topic \ big little */
            NSArray *bannerArr = [dic1 returnValueWithKey:@"banner_list"];
//            NSArray *funcArr = [dic1 returnValueWithKey:@"navi_list"];
            NSArray *newsArr = [dic1 returnValueWithKey:@"flash_list"];
            NSArray *rcmspecialsArr = [dic2 returnValueWithKey:@"specialist"];

//            id rcmact = [dic2 returnValueWithKey:@"rcmActModel"];
//            id htpic = [dic2 returnValueWithKey:@"topicModel"];

            NSArray *rcmacts = [dic2 returnValueWithKey:@"activity"];
            NSArray *htpics = [dic2 returnValueWithKey:@"topic"];
            NSArray *classes = [dic2 returnValueWithKey:@"class"];
            
            id rcmact = [rcmacts firstObject];
            id htpic = [htpics firstObject];
            
            
            BOOL andBool = bflNetStatus && sahNetStatus && pNetStatus && stNetStatus;
            BOOL orBool = bflNetStatus || sahNetStatus || pNetStatus || stNetStatus;
            HomePage30NetReqStatus netStatus = HomePage30NetReqStatusAllSuccession;
            if (!andBool && orBool) {
                netStatus = HomePage30NetReqStatusPartFailure;
            }else if (!orBool){
                netStatus = HomePage30NetReqStatusAllFailure;
            }
            
            if(_delegate && [_delegate respondsToSelector:@selector(homePageReqDataSucWithBannerData:preferredplans:funcData:hnbServiceData:thirdPartData:lastedNews:rcmspecials:rcmActData:hotTopic:netReqStatus:classes:)]){
                [_delegate homePageReqDataSucWithBannerData:bannerArr
                                             preferredplans:plans
                                                   funcData:funcArr
                                             hnbServiceData:hnbServiceArr
                                              thirdPartData:thirdPartArr
                                                 lastedNews:newsArr
                                                rcmspecials:rcmspecialsArr
                                                 rcmActData:rcmact
                                                   hotTopic:htpic
                                               netReqStatus:netStatus
                                                    classes:classes];
            }
            
            // 下半屏数据
            [self homePageReqDataForLatestDataDownScreen];
            
            // 移民弹框
            if (isFirstReq) {
                [self inquiryAssesseView];
            }
            
            // 移民项目进度弹框
            [self upDateProjectState];
            
        });
    });
    
}

- (BOOL)queryIsLeaveGrop:(BOOL)isLeaveGrop queueGroup:(dispatch_group_t)group{
    if (!isLeaveGrop) {
        dispatch_group_leave(group);
    }
    return TRUE; // 只做标记
}

#pragma mark ------ 添加 fidfa 参数之后的移民评估弹框
- (void)inquiryAssesseView{
    
    if ([HNBUtils isConnectionAvailable]) {
        
        _imassessedCountString = @"254056";
        NSString *uid = @"";
        PersonalInfo *f = [PersonalInfo MR_findFirst];
        if (f != nil) {
            uid = f.id;
        }
        [DataFetcher doGetInfoAboutImassessionAlertWithUserId:uid success:^(id JSON) {
            int intState = [[JSON valueForKey:@"state"] intValue];
            if (intState == 0) {
                NSDictionary *dataDic = [JSON valueForKey:@"data"];
                _imassessedCountString = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"num"]];
                NSString *isPop = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"isPop"]];
                if (![isPop isEqualToString:@"0"]) {
                    [self completeReqNetThenRefresh];
                }
            }
            
        } withFailHandler:^(id error) {
            
        }];
    }
    
}

- (void)completeReqNetThenRefresh{
    // 添加 fidfa 参数之后的回调
    if (_delegate && [_delegate respondsToSelector:@selector(completeDataThenRefreshImAssessRemindViewWithCount:isAssessed:)]) {
        
        isFirstReq = NO;
        [_delegate completeDataThenRefreshImAssessRemindViewWithCount:_imassessedCountString isAssessed:0];
        
    }
}

- (void)homePageReqConfig {
    
    dispatch_group_t loadGroup = dispatch_group_create();
    dispatch_queue_t loadQueue = dispatch_queue_create("homePageDisplayVCBeforeHomepageVC", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_enter(loadGroup);
    if ([HNBUtils isConnectionAvailable]) {
        [DataFetcher doGetConfigInfoHomeIndex:^(id JSON) {
            NSString *showConsultation = (NSString *)JSON;
            if ([showConsultation isEqualToString:@"0"]) {
                /* 首页显示咨询按钮 */
                if (_delegate && [_delegate respondsToSelector:@selector(showConsultingButton)]) {
                    [_delegate showConsultingButton];
                }
            }
            dispatch_group_leave(loadGroup);
        } withFailHandler:^(id error) {
            dispatch_group_leave(loadGroup);
        }];
    } else {
        dispatch_group_leave(loadGroup);
    }
    
    dispatch_group_notify(loadGroup, loadQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_delegate && [_delegate respondsToSelector:@selector(isShowIMGuideView)]) {
                [_delegate isShowIMGuideView];
            }
        });
    });
}

- (void)homePageReqDataForPreferredPlans{
    
    [DataFetcher doGetHomePage30PreferredPlan:nil withSucceedHandler:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSArray class]]) {
            NSArray *tmp = (NSArray *)JSON;
            NSMutableArray *plans = [[NSMutableArray alloc] initWithArray:tmp];
            if (_delegate && [_delegate respondsToSelector:@selector(homePageReqDataSucWithPreferredplans:)]) {
                [_delegate homePageReqDataSucWithPreferredplans:plans];
            }
            
        }
        
    } withFailHandler:^(id error) {

    }];
    
}

- (void)homePageReqDataForLatestDataDownScreen{

//    [DataFetcher doGetConfigInfoHomeIndex:^(id JSON) {
//
//        NSString *showConsultation = (NSString *)JSON;
//        if ([showConsultation isEqualToString:@"0"]) {
//            /* 首页显示咨询按钮 */
//            if (_delegate && [_delegate respondsToSelector:@selector(showConsultingButton)]) {
//                [_delegate showConsultingButton];
//            }
//        }
//
//    } withFailHandler:^(id error) {
//
//    }];

    
/** big little */

//    [DataFetcher doGetHomePage30GreatTalkHnbEditorTalkWithSucceedHandler:^(id JSON) {
//        NSDictionary *dic = (NSDictionary *)JSON;
//        NSArray *greatTalks = [dic returnValueWithKey:@"big"];
//        NSArray *editorTalks = [dic returnValueWithKey:@"little"];
//        if (_delegate && [_delegate respondsToSelector:@selector(homePageReqDataSucWithGreatTalks:editorTalks:)]) {
//            [_delegate homePageReqDataSucWithGreatTalks:greatTalks editorTalks:editorTalks];
//        }
//
//        // 其他需要准备的数据
//        [self reqNetDataForNextViewAtFetchCount];
//
//    } withFailHandler:^(id error) {
//
//    }];
    
    [DataFetcher doGetHomePage30GreatTalkHnbEditorTalkWithLocalCachedHandler:^(id JSON) {
        NSDictionary *dic = (NSDictionary *)JSON;
        NSArray *greatTalks = [dic returnValueWithKey:@"big"];
        NSArray *editorTalks = [dic returnValueWithKey:@"little"];
        if (_delegate && [_delegate respondsToSelector:@selector(homePageReqDataSucWithGreatTalks:editorTalks:)]) {
            [_delegate homePageReqDataSucWithGreatTalks:greatTalks editorTalks:editorTalks];
        }
    } succeedHandler:^(id JSON) {
        NSDictionary *dic = (NSDictionary *)JSON;
        NSArray *greatTalks = [dic returnValueWithKey:@"big"];
        NSArray *editorTalks = [dic returnValueWithKey:@"little"];
        if (_delegate && [_delegate respondsToSelector:@selector(homePageReqDataSucWithGreatTalks:editorTalks:)]) {
            [_delegate homePageReqDataSucWithGreatTalks:greatTalks editorTalks:editorTalks];
        }
        
        // 其他需要准备的数据
        [self reqNetDataForNextViewAtFetchCount];
    } withFailHandler:^(id error) {
        
    }];
    
    
}


/* 首页显示 上报app打开时间 */
- (void)upLoadOpenAPPTimeFirst{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[dat timeIntervalSince1970];
    NSDictionary *sendDic = nil;
    sendDic = @{@"id" : @"appOpen", @"time" : [NSString stringWithFormat:@"%f",(CFAbsoluteTimeGetCurrent()-appOpenStartTime)]};
    NSMutableArray *sendArray = [[NSMutableArray alloc] init];
    [sendArray addObject:sendDic];
    
    [DataFetcher doSendAppOpenTimeInfo:sendArray Count:[NSString stringWithFormat:@"%d",1] Time:[NSString stringWithFormat:@"%0.f",time] withSucceedHandler:^(id JSON) {
        
    } withFailHandler:^(id error) {
        
    }];
    
}

// 首页主要数据请求结束之后
- (void)reqNetDataForNextViewAtFetchCount{
    
    // 问答首页专家列表
    [DataFetcher doGetSpecialistsList:^(id JSON) {
        
    } withFailHandler:^(id error) {
        
    }];
    
    // 问答首页筛选列表
    [DataFetcher doGetAllLabels:^(id JSON) {
        
    } withFailHandler:^(id error) {
        
    }];
    
    // 圈子 - 获取所有圈子
    [DataFetcher doGetAllTribes:^(id JSON) {
        
    } withFailHandler:^(id error) {
        
    }];
    
    // 请求国家码 移民评估、完善用户信息 发表我的一天
    [DataFetcher doGetAllNationAndMobieNationAllCODNationInfo:^(id JSON) {
        
    } withFailHandler:^(id error) {
        
    }];
    
}

- (void)homePageVertifyLoginStatusAndUpdateUserInfo{
    
    dispatch_group_t lGroupWhenWill = dispatch_group_create();
    dispatch_queue_t lQueueWhenWill = dispatch_queue_create("homePageReqDataWhenViewWillAppear", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_enter(lGroupWhenWill);
    [DataFetcher doVerifyUserInfo:^(id JSON) {
        
        int state = [[JSON valueForKey:@"state"]intValue];
        if (state == 0){
            
            id data = [JSON valueForKey:@"data"];
            if (![[data objectForKey:@"im_nation"] isEqualToString:@""]) {
                [HNBUtils sandBoxSaveInfo:[data objectForKey:@"im_nation"] forKey:IM_NATION_LOCAL];
            }
            if (![[data objectForKey:@"im_state"] isEqualToString:@""]) {
                [HNBUtils sandBoxSaveInfo:[data objectForKey:@"im_state"] forKey:IM_INTENTION_LOCAL];
            }
            if (![[data objectForKey:@"is_assess"] isEqualToString:@""]) {
                [HNBUtils sandBoxSaveInfo:[data objectForKey:@"is_assess"] forKey:USER_ASSESSED_IMMIGRANT];
            }
            
        }
        //如果IM未登录过并且登陆后返回登录成功进行tab未读数计算
//        if ([[JSON valueForKey:NETEASE_LOGIN_RESULT] isEqualToString:NETEASE_LOGIN_SUCCESS]) {
//            if (_delegate && [_delegate respondsToSelector:@selector(homePageSetUnReadMessageCount)]) {
//                [_delegate homePageSetUnReadMessageCount];
//            }
//        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(homePageUpdateUserInfoThenModifyHomePageStyle)]) {
            [_delegate homePageUpdateUserInfoThenModifyHomePageStyle];
        }
        
        dispatch_group_leave(lGroupWhenWill);
    } withFailHandler:^(id error) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(homePageUpdateUserInfoThenModifyHomePageStyle)]) {
            [_delegate homePageUpdateUserInfoThenModifyHomePageStyle];
        }
        dispatch_group_leave(lGroupWhenWill);
    }];
    
    // 结束之后 发起更新 im 登陆态请求
    dispatch_group_notify(lGroupWhenWill, lQueueWhenWill, ^{
        NSLog(@" %s : %@ ",__FUNCTION__,[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [DataFetcher loginNetEaseIMWithCompletion:^(id error) {
                if (!error && _delegate && [_delegate respondsToSelector:@selector(homePageSetUnReadMessageCount)]) {
                    [_delegate homePageSetUnReadMessageCount];
                }
            }];
            
        });
    });
    
    
}


-(void)homePageUploadNewUserWithType:(NSString *)type{
    
    [DataFetcher doSendUserUniqueFlagWithType:type withSucceedHandler:^(id JSON) {
        
        if ([type isEqualToString:@"0"]) {
            [HNBUtils sandBoxSaveInfo:@"suc" forKey:RecordResultUploadingUserFlag];
        }
        
    } withFailHandler:^(id error) {
        if ([type isEqualToString:@"0"]) {
            [HNBUtils sandBoxSaveInfo:@"fail" forKey:RecordResultUploadingUserFlag];
        }
    }];
    
}

-(void)downLoadAndSaveImage{
    
    [DataFetcher doGetSplashScreen:^(id JSON) {
        int errCode = [[JSON valueForKey:@"state"] intValue];
        if (errCode == 0) {
            id urlJson = [JSON valueForKey:@"data"];
            NSString * urlString = [urlJson valueForKey:@"img_url"];
            NSString * targetUrlString = [urlJson valueForKey:@"target_url"];
            SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
            [manager downloadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                NSString *path_sandox = NSHomeDirectory();
                //设置一个图片的存储路径
                NSString *imagePath = [path_sandox stringByAppendingString:@"/Library/pic_splash.png"];
                //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
                [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
                
                [HNBUtils sandBoxSaveInfo:imagePath forKey:SPLASHIMAGE];
                [HNBUtils sandBoxSaveInfo:targetUrlString forKey:SPLASHURL];
            }];
            
        }
        /* 清除文件 不推闪屏 */
        else
        {
            NSFileManager* fileManager=[NSFileManager defaultManager];
            NSString *path_sandox = NSHomeDirectory();
            //设置一个图片的存储路径
            NSString *imagePath = [path_sandox stringByAppendingString:@"/Library/pic_splash.png"];
            BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:imagePath];
            if (!blHave) {
                NSLog(@"no  have");
                return ;
            }else {
                NSLog(@" have");
                BOOL blDele= [fileManager removeItemAtPath:imagePath error:nil];
                if (blDele) {
                    NSLog(@"dele success");
                }else {
                    NSLog(@"dele fail");
                }
                
            }
        }
        
        
    } withFailHandler:^(id error) {
        
    }];
}

// 项目进度通知
- (void)upDateProjectState{
    if ([HNBUtils isLogin]) {
        // 项目进度通知
        [DataFetcher doGetStateForProjectShowONHome:^(id JSON) {
            
            if (_delegate && [_delegate respondsToSelector:@selector(updateProjectStateNoticeThenReloadViewWithData:)]) {
                [_delegate updateProjectStateNoticeThenReloadViewWithData:JSON];
            }
            
        } withFailHandler:^(id error) {
            
        }];
        
    }
}

@end
