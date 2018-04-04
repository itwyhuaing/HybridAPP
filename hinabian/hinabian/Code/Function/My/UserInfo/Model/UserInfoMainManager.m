
//
//  UserInfoMainManager.m
//  hinabian
//
//  Created by hnbwyh on 16/7/25.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "UserInfoMainManager.h"
#import "DataFetcher.h"
#import "PersonInfoModel.h"
#import "UserInfoHisTribePost.h"
#import "UserInfoHisQAPost.h"

#import "LoginViewController.h"
#import "IMQuestionViewController.h" // 提问
#import "SWKQuestionShowViewController.h" // 问答
#import "SWKTribeShowViewController.h"// 帖子
#import "TribeDetailInfoViewController.h"

#import "NETEaseViewController.h"
#import <NIMSDK/NIMSDK.h>

@interface UserInfoMainManager ()

@property (nonatomic) BOOL reqStatus_showPersonnalInfo; // 个人信息网络请求状态
@property (nonatomic) BOOL reqStatus_doGetHisPostData;  // 他的发帖网络请求状态
@property (nonatomic) BOOL reqStatus_doGetHisReplyData; // 他的回帖网络请求状态

@end

@implementation UserInfoMainManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _reqStatus_showPersonnalInfo = YES;
        _reqStatus_doGetHisPostData  = YES;
        _reqStatus_doGetHisReplyData = YES;

    }
    return self;
}

- (void)reqPersonalOrSpecialInfoAndHisTribeDataWithID:(NSString *)personID count:(NSInteger)countNum{

    __block PersonInfoModel *f = nil;
    __block NSArray *hisPosts = nil;
    
    dispatch_group_t UserInfoMainManagerGroup = dispatch_group_create();
    dispatch_queue_t UserInfoMainManagerQueue = dispatch_queue_create("UserInfoMainManagerQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_enter(UserInfoMainManagerGroup);
    [DataFetcher showPersonnalInfoWithPersonId:personID withSucceedHandler:^(id JSON) {

        
        f = (PersonInfoModel *)JSON;
        if (f.errrormsg == nil) {
            _reqStatus_showPersonnalInfo = YES;
        } else {
            _reqStatus_showPersonnalInfo = NO;
        }
        
        dispatch_group_leave(UserInfoMainManagerGroup);
    } withFailHandler:^(id error) {
        
        f = nil;
        _reqStatus_showPersonnalInfo = NO;
        dispatch_group_leave(UserInfoMainManagerGroup);
    }];
    
    /*获取他的发帖*/
    dispatch_group_enter(UserInfoMainManagerGroup);
    
    [DataFetcher doGetHisPostDataWithPersonId:personID start:0 GetNum:countNum withSucceedHandler:^(id JSON) {
        
        NSArray *arr = (NSArray *)JSON;
        if ([[arr firstObject] isKindOfClass:[NSString class]]) {
            
            hisPosts = nil;
            //NSLog(@" hisPosts.count ------ > %ld",hisPosts.count);
            _reqStatus_doGetHisPostData = NO;
            
        } else {
            
            hisPosts = arr;
            _reqStatus_doGetHisPostData = YES;
            
        }
        dispatch_group_leave(UserInfoMainManagerGroup);
    } withFailHandler:^(id error) {
        
        _reqStatus_doGetHisPostData = NO;
        dispatch_group_leave(UserInfoMainManagerGroup);
    }];
    
    dispatch_group_notify(UserInfoMainManagerGroup, UserInfoMainManagerQueue, ^{
        
       dispatch_async(dispatch_get_main_queue(), ^{
          
           
           if (_delegate && [_delegate respondsToSelector:@selector(completeDataThenRefreshViewWithPersonInfo:hisTribePosts:personInfoReqStatus:hisTribeReqStatus:)]) {
               [_delegate completeDataThenRefreshViewWithPersonInfo:f hisTribePosts:hisPosts personInfoReqStatus:_reqStatus_showPersonnalInfo hisTribeReqStatus:(_reqStatus_doGetHisPostData && _reqStatus_doGetHisReplyData)];
           }
       });
       
        
    });
    
    
}


-(void)reqPersonalOrSpecialInfoWithID:(NSString *)personID{

    [DataFetcher showPersonnalInfoWithPersonId:personID withSucceedHandler:^(id JSON) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(completePersonInfoDataThenRefreshTheViewWithData:)]) {
            [_delegate completePersonInfoDataThenRefreshTheViewWithData:JSON];
        }
        
    } withFailHandler:^(id error) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(failToReqPersonInfoData)]) {
            [_delegate failToReqPersonInfoData];
        }
        
    }];
    
}

#pragma mark ------ clickEvent 

- (void)clickCareBtn:(NSNotification *)nofy{

    NSDictionary *info = (NSDictionary *)[nofy object];
    PersonInfoModel *f = (PersonInfoModel *)[info valueForKey:@"model"];
    UIButton *btn = (UIButton *)[info valueForKey:@"btn"];
    if (![HNBUtils isLogin]) {
        [self gotoLogin];
        return;
    }
    
    //NSLog(@" 执行前 btn.tag: %ld f.isFollow ------ > %@",btn.tag,f.isFollow);
    if ([f.isFollow isEqualToString:@"1"]) { // 点击执行取消关注
        
        if ([f.personID isEqualToString:hainabian_xiaozuli_id]) {
            //海那边小助理不允许取关
            return;
        }
        // 统计代码
        NSDictionary *dict = @{@"state" : @"0"};
        if ([f.type isEqualToString:@"normal"]) { // 普通用户
            [HNBClick event:@"105011" Content:dict];
        } else { // 专家
            [HNBClick event:@"126001" Content:dict];
        }

        [DataFetcher removeFollowWithParameter:_personid withSucceedHandler:^(id JSON) {
            [btn setTitle:@"关注" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"userinfo_follow_btn_default"] forState:UIControlStateNormal];
            f.isFollow = @"0";
            //NSLog(@" 取消成功 f.isFollow ------ > %@",f.isFollow);
        } withFailHandler:^(id error) {
            [btn setTitle:@"已关注" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"userinfo_follow_btn_pressed"] forState:UIControlStateNormal];
            //NSLog(@" 取消失败 f.isFollow ------ > %@",f.isFollow);
        }];
        
    }else{ // 点击执行增加关注
    
        // 统计代码
        NSDictionary *dict = @{@"state" : @"1"};
        if ([f.type isEqualToString:@"normal"]) { // 普通用户
            [HNBClick event:@"105011" Content:dict];
        } else { // 专家
            [HNBClick event:@"126001" Content:dict];
        }
        
        [DataFetcher addFollowWithParameter:_personid withSucceedHandler:^(id JSON) {
            [btn setTitle:@"已关注" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"userinfo_follow_btn_pressed"] forState:UIControlStateNormal];
            f.isFollow = @"1";
            //NSLog(@" 增加成功 f.isFollow ------ > %@",f.isFollow);
        } withFailHandler:^(id error) {
            [btn setTitle:@"关注" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"userinfo_follow_btn_default"] forState:UIControlStateNormal];
            //NSLog(@" 增加失败 f.isFollow ------ > %@",f.isFollow);
        }];
        
    }
    
}

- (void)clickMsgBtn:(NSNotification *)nofy{
    
    if ([HNBUtils isLogin]) {
//        NSString *urlStr = [NSString stringWithFormat:@"%@/personal_chat/conversation/%@",H5APIURL,_personid];
//        [self jumpToShowWeb:urlStr];
//
        // 统计代码
        NSDictionary *dict = @{@"url" : _personid};
        PersonInfoModel *f = (PersonInfoModel *)[nofy object];
        if ([f.type isEqualToString:@"normal"]) {
            [HNBClick event:@"105012" Content:dict];
        } else {
            [HNBClick event:@"126003" Content:dict];
        }
        if (f.netEase_ID && ![f.netEase_ID isEqualToString:@""]) {
            //构造会话
            NIMSession *session = [NIMSession session:f.netEase_ID type:NIMSessionTypeP2P];
            
            NSArray *tmpVCS = [self.superVC.navigationController viewControllers];
            NSMutableArray *vcs = [[NSMutableArray alloc] initWithArray:tmpVCS];
            if (tmpVCS.count >= 2) {
                id vc = vcs[tmpVCS.count - 2]; // 倒数第二个
                if ([vc isKindOfClass:[NETEaseViewController class]]) { // 依旧没有登录 - 发帖
                    [self.superVC.navigationController popViewControllerAnimated:YES];
                    return;
                }
            }
            
            BOOL isAllow_Chat = YES;    //是否允许与该用户聊天
            NSArray *limitedDataArr = [HNBUtils sandBoxGetInfo:[NSMutableArray class] forKey:NETEASE_LIMITED_ARRAY];
            if (limitedDataArr.count == 0 || !limitedDataArr) {
                //如果没有存过数据，则将这条数据以及用户ID存下
                [HNBUtils setIMLocalLimited];
            }else {
                for (int index = 0; index <limitedDataArr.count; index++) {
                    NSMutableDictionary *tempDic = limitedDataArr[index];
                    NSString *tempID = tempDic[NETEASE_LIMITED_ID];
                    if ([tempID isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
                        //如果是当前账号，获取今日已经新增的对话框数
                        NSInteger todayChatNum = [tempDic[NETEASE_TODAY_CHATNUM] integerValue];
                        if ([f.is_Need_Follow isEqualToString:@"1"] && todayChatNum >= 10) {
                            isAllow_Chat = NO;
                        }
                        break;
                    }
                    if (![tempID isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount] && index == limitedDataArr.count - 1){
                        //如果没有存过该账号的数据，将该ID存下
                        [HNBUtils setIMLocalLimited];
                    }
                }
            }
            NSLog(@"=====>点击私信 :%@",[HNBUtils sandBoxGetInfo:[NSMutableArray class] forKey:NETEASE_LIMITED_ARRAY]);
            //发送消息
            NETEaseViewController *chatVC = [[NETEaseViewController alloc] initWithSession:session];
            chatVC.isAllow_Chat = isAllow_Chat;
            [self.superVC.navigationController pushViewController:chatVC animated:YES];
        }
        
    } else {
        [self gotoLogin];
    }
    
}

- (void)clickVBtn:(NSNotification *)nofy{
    // 统计代码
    PersonInfoModel *f = (PersonInfoModel *)[nofy object];
    if ([f.type isEqualToString:@"normal"]) {
        [HNBClick event:@"105021" Content:nil];
    } else {
        [HNBClick event:@"126030" Content:nil];
    }
    //官方认证页
 
    NSString *tmpString = [NSString stringWithFormat:@"%@/native/official_cert",H5URL];
    SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
    vc.URL = [vc.webManger configNativeNavWithURLString:tmpString
                                                   ctle:@"1"
                                             csharedBtn:@"0"
                                                   ctel:@"0"
                                              cfconsult:@"0"];
    vc.manualRefreshWhenBack = FALSE;
    [self.superVC.navigationController pushViewController:vc animated:YES];
}

- (void)clickLevelBtn:(NSNotification *)nofy{
    // 统计代码
    PersonInfoModel *f = (PersonInfoModel *)[nofy object];
    if ([f.type isEqualToString:@"normal"]) {
        [HNBClick event:@"105020" Content:nil];
    } else {
        [HNBClick event:@"126020" Content:nil];
    }
    //等级介绍页
 
    NSString *tmpString = [NSString stringWithFormat:@"%@/native/mylevel/levelintroduce",H5APIURL];
    SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
    vc.URL = [vc.webManger configNativeNavWithURLString:tmpString
                                                   ctle:@"1"
                                             csharedBtn:@"0"
                                                   ctel:@"0"
                                              cfconsult:@"0"];
    vc.manualRefreshWhenBack = FALSE;
    [self.superVC.navigationController pushViewController:vc animated:YES];
}

- (void)clickHeadBtn:(NSNotification *)nofy{
    
    PersonInfoModel *f = (PersonInfoModel *)[nofy object];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/personal_userinfo/brief/%@.html",H5APIURL,_personid];
    [self jumpToShowWeb:urlStr];
    
    // 统计代码
    NSDictionary *dict = @{@"url":urlStr};
    if ([f.type isEqualToString:@"special"]) {
        [HNBClick event:@"126011" Content:dict];
    } else {
        [HNBClick event:@"105027" Content:dict];
    }
    
}

- (void)clickBriefInfoBtn:(NSNotification *)nofy{
    
    PersonInfoModel *f = (PersonInfoModel *)[nofy object];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/personal_userinfo/brief/%@.html",H5APIURL,_personid];
    [self jumpToShowWeb:urlStr];
    
    // 统计代码
    NSDictionary *dict = @{@"url":urlStr};
    if ([f.type isEqualToString:@"special"]) {
        [HNBClick event:@"126012" Content:dict];
    } else {
        [HNBClick event:@"105028" Content:dict];
    }
    
}

- (void)clickAskQuestion:(NSNotification *)nofy{
    // 统计代码
    [HNBClick event:@"126006" Content:nil];
    //NSLog(@"  ------ %s ------ ",__FUNCTION__);
    NSString *personName = (NSString *)[nofy object];
    IMQuestionViewController *vc = [[IMQuestionViewController alloc] init];
    vc.answererUid = _personid;
    vc.answererName = personName;
    if ([HNBUtils isLogin]) {
        
        [_superVC.navigationController pushViewController:vc animated:YES];
        
    } else {
        
        [self gotoLogin];
        NSArray *vcs = _superVC.navigationController.viewControllers;
        _superVC.navigationController.viewControllers = [HNBUtils operateNavigationVCS:vcs index:vcs.count-1 vc:vc];
    }
    
}

- (void)hisTribeTableViewSelected:(NSNotification *)nofy{

    //NSLog(@"  ------ %s ------ ",__FUNCTION__); http://m.hinabian.com/theme/detail/6324019947043765845.html
    UserInfoHisTribePost *f = (UserInfoHisTribePost *)[nofy object];
    NSString *urlString = [NSString stringWithFormat:@"%@/theme/detail/%@",H5URL,f.theme_id];
    
    NSString *isNativeString = [HNBUtils sandBoxGetInfo:[NSString class] forKey:TRIBEDETAILTHEME_NATIVEUI_WEB];
    if ([isNativeString isEqualToString:@"1"]) {
        
        TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
        vc.URL = [NSURL URLWithString:urlString];
        [_superVC.navigationController pushViewController:vc animated:YES];
        
    } else {
        
        SWKTribeShowViewController *vc = [[SWKTribeShowViewController alloc] init];
        vc.URL = [NSURL URLWithString:urlString];
        [_superVC.navigationController pushViewController:vc animated:YES];
        
    }
    
    // 统计代码
    NSDictionary *dict = @{@"url":urlString};
    if ([_personType isEqualToString:@"normal"]) {
        [HNBClick event:@"105025" Content:dict];
    } else {
        [HNBClick event:@"126008" Content:dict];
    }
    
}

- (void)hisQATableViewSelected:(NSNotification *)nofy{

    //NSLog(@"  ------ %s ------ ",__FUNCTION__);
    UserInfoHisQAPost *f = (UserInfoHisQAPost *)[nofy object];
    SWKQuestionShowViewController *vc = [[SWKQuestionShowViewController alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"%@/qa_question/detail/%@",H5URL,f.question_id];
    vc.URL = [NSURL URLWithString:urlString];
    [_superVC.navigationController pushViewController:vc animated:YES];
    
    // 统计代码
    NSDictionary *dict = @{@"url":urlString};
    if ([_personType isEqualToString:@"normal"]) {
        [HNBClick event:@"105026" Content:dict];
    } else {
        [HNBClick event:@"126009" Content:dict];
    }
    
}

#pragma mark ------ toolMethod 

- (void)jumpToShowWeb:(NSString *)urlStr{

    SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
    vc.URL = [vc.webManger configDefaultNativeNavWithURLString:urlStr];
    
    [_superVC.navigationController pushViewController:vc animated:YES];
}

- (void)gotoLogin{
    
    LoginViewController *vc = [[LoginViewController alloc] init];
    [_superVC.navigationController pushViewController:vc animated:YES];
    
}

@end
