//
//  AppDelegate.m
//  hinabian
//
//  Created by 余坚 on 15/6/1.
//  Copyright (c) 2015年 余坚. All rights reserved.
//

#import "AppDelegate.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "PersonMainViewController.h"
#import "IMAssessViewController.h"
#import "LoginViewController.h"
#import "MyQuestionViewController.h"
#import "SWKTribeShowViewController.h"
#import "TribeDetailInfoViewController.h"
#import "SWKSingleReplyViewController.h"
#import "SWKQuestionShowViewController.h"
#import "MyTribeViewController.h"
#import <UMAnalytics/MobClick.h>
#import "MyOnedayViewController.h"
#import "PublicViewController.h"
#import "IMProjectHomeViewController.h"
#import "NETEaseListViewController.h"
#import "NETEaseViewController.h"

#import <AlipaySDK/AlipaySDK.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import <UMSocialCore/UMSocialCore.h>
#import "DataFetcher.h"
#import "UMessage.h"
#import "WXApi.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "IQKeyboardManager.h"
#import "TalkingDataAppCpa.h"
#import <AdSupport/AdSupport.h>
#import "HNBHomePageV3.h"
#import "TribeIndexNewViewController.h"
#import <LinkedME_iOS/LinkedME.h>
#import <UMCommon/UMCommon.h>
#import <MeiQiaSDK/MeiQiaSDK.h>


@interface AppDelegate ()
@property (nonatomic,strong) UINavigationController * navigation;
@property (nonatomic,strong) RDVTabBarController *tabBarController;

@property (nonatomic,strong) UIImageView *splashImageView;
@property (nonatomic,strong) UIImageView *bottomImageV;
//@property (nonatomic,strong) UIButton *skipButton;
@property (nonatomic,strong) NSMutableArray *btnsOnWindow;
@property (nonatomic,strong) NSTimer *skipSplashTimer;

@property (nonatomic,strong) NSDictionary *remoteUserInfo;

@end

@implementation AppDelegate
@synthesize viewController = _viewController;

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    // MagicalRecord 设置
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"hinabian"];
    
    /*self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MainViewController *rootView = [[MainViewController alloc] init];
    rootView.title = @"海那边";
    
    self.navigation = [[UINavigationController alloc] init];
    [self.navigation pushViewController:rootView animated:YES];
    [self.window addSubview:self.navigation.view];
    [self.window makeKeyAndVisible];
    
    
    [self setupViewControllers];*/
    //UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    /* NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"old agent :%@", oldAgent);*/
    
/** 方案一
  保存到公共区域的
 // 0. 公共区域保存的唯一标识
 NSString *appVersion = [HNBUtils sandBoxGetInfo:[NSString class] forKey:APP_VERSION];
 if (appVersion == nil || appVersion.length <= 0) { // 第一次安装或重新安装
 //[HNBUtils saveUUIDToKeyChain];
 }
 
 //add my info to the new agent
 NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
 // 1. 为应对 idfa 取不到的情况，现将 自己生成一个标识 fidfa 及 对应的 md5fidfa 参数
 NSString *FIDFA = [HNBUtils sandBoxGetInfo:[NSString class] forKey:PRIVATE_FIDFA];
 NSString *MD5FIDFA = [HNBUtils sandBoxGetInfo:[NSString class] forKey:PRIVATE_MD5_FIDFA];
 if (FIDFA == nil && MD5FIDFA == nil) {
 FIDFA = [HNBUtils readUUIDFromKeyChain];
 MD5FIDFA = [HNBUtils readMD5UUIDFromKeyChain];
 [HNBUtils sandBoxSaveInfo:FIDFA forKey:PRIVATE_FIDFA];
 [HNBUtils sandBoxSaveInfo:MD5FIDFA forKey:PRIVATE_MD5_FIDFA];
 }
 
 **/
    /** 方案二  自定义标识 */
    //add my info to the new agent
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 1. 为应对 idfa 取不到的情况，现将 自己生成一个标识 fidfa 及 对应的 md5fidfa 参数
    NSString *FIDFA = [HNBUtils sandBoxGetInfo:[NSString class] forKey:PRIVATE_FIDFA];
    NSString *MD5FIDFA = [HNBUtils sandBoxGetInfo:[NSString class] forKey:PRIVATE_MD5_FIDFA];
    if (FIDFA == nil || FIDFA.length <= 0) { // 第一次安装或重新安装
        FIDFA = [HNBUtils createCustomUUID:infoDictionary];
        MD5FIDFA = [HNBUtils md5HexDigest:FIDFA];
        [HNBUtils sandBoxSaveInfo:FIDFA forKey:PRIVATE_FIDFA];
        [HNBUtils sandBoxSaveInfo:MD5FIDFA forKey:PRIVATE_MD5_FIDFA];
    }
    
    
    // 2. 在原来 UA 的基础上拼接生成的 fidfa
    UIWebView* tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* OldUserAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    // 尝试获取 真实 idfa
    NSString *ridfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *sandBoxIDFA = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_idfa];
    if(![sandBoxIDFA isEqualToString:ridfa])
    {
        [HNBUtils sandBoxSaveInfo:ridfa forKey:personal_idfa];
    }
    
    NSString *idfa = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_idfa];
    NSString *md5_idfa = [HNBUtils md5HexDigest:idfa];
    [HNBUtils sandBoxSaveInfo:md5_idfa forKey:personal_md5_idfa];
    NSString *newAgent = [NSString stringWithFormat:@"%@%@%@/idfa=%@/fidfa=%@",OldUserAgent,@"App_IOS_Hinabian/",[infoDictionary objectForKey:@"CFBundleShortVersionString"],md5_idfa,MD5FIDFA];
    [HNBUtils sandBoxSaveInfo:newAgent forKey:HNB_CUSTOM_USERAGENT];
    
    //3. 将修改之后 UA 注册 - regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
    //4. 设置状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //5. 设置导航默认标题的颜色及字体大小
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setupViewControllers];
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    
    
    /* 登录态校验 */
    if([HNBUtils isLogin])
    {
        [DataFetcher doVerifyUserInfo:^(id JSON) {
            int state = [[JSON valueForKey:@"state"]intValue];
            if (state != 0) {
                //显示HUD
                [[HNBToast shareManager] toastWithOnView:nil msg:@"登录失效请重新登录" afterDelay:DELAY_TIME style:HNBToastHudFailure];
            }
            else
            {
                id data = [JSON valueForKey:@"data"];
                if (![[data objectForKey:@"im_nation"] isEqualToString:@""]) {
                    [HNBUtils sandBoxSaveInfo:[data objectForKey:@"im_nation"] forKey:IM_NATION_LOCAL];
                }
                if (![[data objectForKey:@"im_state"] isEqualToString:@""]) {
                    [HNBUtils sandBoxSaveInfo:[data objectForKey:@"im_state"] forKey:IM_INTENTION_LOCAL];
                    [HNBUtils sandBoxSaveInfo:[data objectForKey:@"is_assess"] forKey:USER_ASSESSED_IMMIGRANT];
                }
                //如果IM未登录过并且登陆后返回登录成功进行tab未读数计算
                if ([[JSON valueForKey:NETEASE_LOGIN_RESULT] isEqualToString:NETEASE_LOGIN_SUCCESS]) {
                    RDVTabBarItem *tabBarItem = [[[self.tabBarController tabBar] items] objectAtIndex:TAB_MESSAGE_INDEX];
                    NSInteger messageCount = [tabBarItem.badgeValue integerValue] + [NIMSDK sharedSDK].conversationManager.allUnreadCount;
                    [tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",messageCount]];
                }
            }
            
        } withFailHandler:^(id error) {
            
        }];
    }
    [UMessage setLogEnabled:YES];
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    //判断是否是通过LinkedME的Universal Links唤起App
    if ([[userActivity.webpageURL description] rangeOfString:@"lkme.cc"].location != NSNotFound) {
        return  [[LinkedME getInstance] continueUserActivity:userActivity];
    }
    
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        
        NSURL *webPageURL = userActivity.webpageURL;
        NSString *host = webPageURL.host;
//        NSString *description = webPageURL.description;
//        NSLog(@"===!!!!!!!%@",description);
        //        NSString *urlString = userActivity.webpageURL.description;
        
        NSString *urlString = webPageURL.absoluteString;
        if ([host isEqualToString:@"stat.hinabian.com"]) {
            /*判断是否 hd 域名的链接，是的允许打开APP*/
            RDVTabBarController *tempTabBarController = (RDVTabBarController *)self.window.rootViewController;
            UINavigationController *tempNav = (UINavigationController *)tempTabBarController.selectedViewController;
            /*对URL进行解析*/
            //UrlHandler * tmpHandler = [[UrlHandler alloc] initWithSuperNavContorller:tempNav];
            //[tmpHandler handleUrlStringForUser:urlString jumpIntoAPP:YES];
            [[HNBWebManager defaultInstance] jumpHandleWithURL:urlString nav:tempNav jumpIntoAPP:TRUE];
            
        }
        
    }
    return YES;
}


#pragma mark - Methods

- (void)setupViewControllers {


    UIViewController *firstViewController = [HNBHomePageV3 shareHNBHomePageVC];
    UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    UIViewController *secondViewController = [[IMProjectHomeViewController alloc] init];
    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    
    UIViewController *thirdViewController = [[TribeIndexNewViewController alloc] init];
    UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    
    UIViewController *fourthViewController = [[NETEaseListViewController alloc] init];
    UIViewController *fourthNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:fourthViewController];
    
    UIViewController *fifthViewController = [[PersonMainViewController alloc] init];
    UIViewController *fifthNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:fifthViewController];
    
    
    self.tabBarController = [[RDVTabBarController alloc] init];
    [self.tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,
                                           thirdNavigationController,fourthNavigationController,fifthNavigationController]];
    self.viewController = self.tabBarController;
    
    [self customizeTabBarForController:self.tabBarController];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    
    NSArray *tabBarItemImages;
    
    if ([HNBUtils isLogin]) {
        tabBarItemImages = @[@"index_icon_home",@"index_icon_banli",@"index_icon_quanzi",@"index_icon_message",@"index_icon_login"];
    }else{
        tabBarItemImages = @[@"index_icon_home",@"index_icon_banli",@"index_icon_quanzi",@"index_icon_message",@"index_icon_login"];
    }
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        //[item setBackgroundSelectedImage:unfinishedImage withUnselectedImage:unfinishedImage];
        
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_pressed",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        
//        
//        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",
//                                                      [tabBarItemImages objectAtIndex:index]]];
//        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",
//                                                        [tabBarItemImages objectAtIndex:index]]];
        
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
    
    [DataFetcher doGetAllNotices:^(id JSON) {
        int errCode = [[JSON valueForKey:@"state"] intValue];
        if (errCode == 0) {
            id jsonmain = [JSON valueForKey:@"data"];
            NSNumber * qaNotice = [jsonmain valueForKey:@"qa"];
            NSInteger count = [qaNotice integerValue];
            NSNumber * tribeNotice =  [jsonmain valueForKey:@"tribe"];
            NSNumber *follow = [jsonmain valueForKey:@"follow"];
            NSNumber *f_unread_num = [jsonmain valueForKey:@"f_unread_num"];
            
            //设置个人中心Tab消息数
            NSInteger tempUnreadNum = [f_unread_num integerValue];
            NSInteger tmpCount = [tribeNotice integerValue];
            NSInteger followInt = [follow integerValue];
            NSInteger tmpCoupon = [[jsonmain valueForKey:@"coupon"] integerValue];
            count += tmpCount; // 我的问答  、 我的圈子 、
            count += followInt; // 我的关注
            count += tmpCoupon; // 我的优惠券
            //NSInteger tmpPersonMsg = [[jsonmain valueForKey:@"msg"] integerValue];
            //count += tmpPersonMsg;
            NSArray * tmpItem = [[tabBarController tabBar] items];
            RDVTabBarItem *item = [tmpItem lastObject];
            [item setBadgeValue:[NSString stringWithFormat:@"%ld",count]];

            //设置消息Tab的通知列表数
            RDVTabBarItem *messageItem = [tmpItem objectAtIndex:TAB_MESSAGE_INDEX];
            NSInteger messageCount = [messageItem.badgeValue integerValue] + tempUnreadNum;
            [messageItem setBadgeValue:[NSString stringWithFormat:@"%ld",messageCount]];
        }
    } withFailHandler:^(id error) {
        
    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //初始化及实例
    LinkedME* linkedme = [LinkedME getInstance];
    
    [self registerAPNs];
    //打印日志
//    [linkedme setDebug];
    
    
#pragma mark -- LinkME 必须实现
    //获取跳转参数
    [linkedme initSessionWithLaunchOptions:launchOptions automaticallyDisplayDeepLinkController:NO deepLinkHandler:^(NSDictionary* params, NSError* error) {
        if (!error) {
            //防止传递参数出错取不到数据,导致App崩溃这里一定要用try catch
            @try {
//                NSLog(@"LinkedME finished init with params = %@",[params description]);
                //获取详情页类型(如新闻客户端,有图片类型,视频类型,文字类型等)
                //            NSString *title = [params objectForKey:@"$og_title"];
                NSString *tagURL = params[@"$control"][@"url"];
                NSString *tagType = params[@"$control"][@"type"];
//                NSString *tagID = params[@"$control"][@"id"];
                
                if (tagURL.length >0) {
                    /*判断是否 hd 域名的链接，是的允许打开APP*/
                    RDVTabBarController *tempTabBarController = (RDVTabBarController *)self.window.rootViewController;
                    UINavigationController *tempNav = (UINavigationController *)tempTabBarController.selectedViewController;
                    
                    /*对URL进行解析*/
                    if ([tagType isEqualToString:@"theme"]) {   //帖子为特殊替换url
                        if ([tagURL containsString:@"theme/share"]) {
                            tagURL = [tagURL stringByReplacingOccurrencesOfString:@"theme/share" withString:@"theme/detail"];
                        }
//                        if (tagID.length > 0) {
//                            tagURL = [NSString stringWithFormat:@"%@/theme/detail/%@.html",H5URL,tagID];
//                        }
                    }else if ([tagType isEqualToString:@"userInfo"]) {  //跳转个人中心
                        
                    }
                    //UrlHandler * tmpHandler = [[UrlHandler alloc] initWithSuperNavContorller:tempNav];
                    //[tmpHandler handleUrlStringForUser:tagURL jumpIntoAPP:YES];
                    [[HNBWebManager defaultInstance] jumpHandleWithURL:tagURL nav:tempNav jumpIntoAPP:TRUE];
                    
                }
                
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            
        } else {
            NSLog(@"LinkedME failed init: %@", error);
        }
    }];
    
    // APP 打开记录
    NSInteger openCount = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:OpenAPPCountFlag] integerValue];
    //NSLog(@" APP 打开记录前：%ld",openCount);
    NSString *newOpenCount = [NSString stringWithFormat:@"%ld",openCount + 1];
    //NSLog(@" APP 打开记录后：%@",newOpenCount);
    [HNBUtils sandBoxSaveInfo:newOpenCount forKey:OpenAPPCountFlag];
    
    // 每次打开 App ,判断此次打开日期距离上次弹框日期差值
    NSString *preDateString = [HNBUtils sandBoxGetInfo:[NSString class] forKey:homepage_assessremindview_showdate];
    NSString *dateCountFlag = [HNBUtils compareDateWithGivedDateString:preDateString];
    [HNBUtils sandBoxSaveInfo:dateCountFlag forKey:homepage_assessremindview_overexpire];
    
    
    // MagicalRecord 设置 － 因为兼容 iOS7 的缘故， 初始化操作需要放在 willFinishLaunch 中进行
    //[MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"hinabian"];
    
    [HNBUtils sandBoxSaveInfo:@"1" forKey:TRIBEDETAILTHEME_NATIVEUI_WEB];
    
    //IQKeyboardManager
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
//    [WXApi registerApp:@"wx12f1387805bf2897" withDescription:@"HINABIAN"];
    [WXApi registerApp:WXKEY];

    [UMConfigure initWithAppkey:UMKEY channel:nil];
//    [MobClick startWithAppkey:UMKEY reportPolicy:BATCH   channelId:nil];
    /** 手动设置友盟统计的版本号，对齐App Store 版本号 */
//    NSString *shortVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [MobClick setAppVersion:shortVersion];
    
    // Rain
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMKEY];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                          appKey:WXKEY
                                       appSecret:WXSECRET
                                     redirectURL:@"http://www.hinabian.com"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ
                                          appKey:QQKEY
                                       appSecret:nil
                                     redirectURL:@"http://www.hinabian.com"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina
                                          appKey:@"3186632588"
                                       appSecret:@"d915476e5f4f24db378a7df4563022d8"
                                     redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    //初始化方法,也可以使用(void)startWithAppkey:(NSString *)appKey launchOptions:(NSDictionary * )launchOptions httpsenable:(BOOL)value;这个方法，方便设置https请求。
    [UMessage startWithAppkey:UMKEY launchOptions:launchOptions httpsenable:YES ];
    if (REGISTERFORREMOTENOTIFICATION_APPDELEGATE) {
        
        
        // 注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
        [UMessage registerForRemoteNotifications];
        
        //iOS10必须加下面这段代码。
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate=(id)self;
        UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                //这里可以添加一些自己的逻辑
            } else {
                //点击不允许
                //这里可以添加一些自己的逻辑
            }
        }];
        //打开日志，方便调试
        [UMessage setLogEnabled:YES];
        
    }
    
    /*  */
    [Fabric with:@[[Crashlytics class]]];
    
    // iOS10以下系统在后台情况下打开
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo != NULL && ![self judgeDeviceSystemOverTop10]) {
        [self handlePushMessageInfo:userInfo];
    }

#pragma mark  集成第一步: 初始化,  参数:appkey  ,尽可能早的初始化appkey.
    [MQManager initWithAppkey:MeiQiaAPPKey completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            NSLog(@"美洽 SDK：初始化成功");
        } else {
            NSLog(@" 美洽 SDK error:%@",error);
        }
    }];
    
    
#pragma mark  添加闪屏页
    NSString * filePath = [HNBUtils sandBoxGetInfo:[NSString class] forKey:SPLASHIMAGE];
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    //NSLog(@" 999-filePath :%@",filePath);
    if (img) {
        
        // 闪屏图片
        _splashImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 140.0 * SCREEN_WIDTHRATE_6)];
        [_splashImageView setImage:img];
        [self.viewController.view addSubview:_splashImageView];
        _bottomImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_splashImageView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetHeight(_splashImageView.frame))];
        [_bottomImageV setImage:[UIImage imageNamed:@"splashBottom.png"]];
        _bottomImageV.userInteractionEnabled = YES;
        [self.viewController.view addSubview:_bottomImageV];
        
        // 跳过按钮
        UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [skipButton addTarget:self action:@selector(clickSkipSplashImageViewBtn:) forControlEvents:UIControlEventTouchUpInside];
        CGRect skipBtnRect = CGRectZero;
        skipBtnRect.size.width = 55.f *SCREEN_SCALE;
        skipBtnRect.size.height = 29.f * SCREEN_SCALE;
        skipBtnRect.origin.x = (SCREEN_WIDTH - skipBtnRect.size.width - 12.f * SCREEN_SCALE);
        skipBtnRect.origin.y = (20.f + 10.f) * SCREEN_SCALE;
        [skipButton setFrame:skipBtnRect];
        [skipButton.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI24PX]];
        [skipButton setTitleColor:[UIColor colorWithRed:230.f/255.f green:230.f/255.f blue:230.f/255.f alpha:1.f] forState:UIControlStateNormal];
        [skipButton setBackgroundColor:[UIColor colorWithRed:0.f/255.f green:0.f/255.f blue:0.f/255.f alpha:0.2f]];
        skipButton.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5].CGColor;
        skipButton.layer.borderWidth = 1.f;
        skipButton.layer.cornerRadius = CGRectGetHeight(skipButton.frame)/2.f;
        [skipButton setTitle:@"跳过3" forState:UIControlStateNormal];
        [self.viewController.view addSubview:skipButton];
        
        // 闪屏上按钮相应区域
        UIButton * splashButton1 = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                              CGRectGetMaxY(skipButton.frame),
                                                                              SCREEN_WIDTH,
                                                                              SCREEN_HEIGHT - CGRectGetMaxY(skipButton.frame) - CGRectGetHeight(_bottomImageV.frame))];
        [splashButton1 addTarget:self action:@selector(singleTapSplashImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.viewController.view addSubview:splashButton1];
        UIButton * splashButton2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMinX(skipButton.frame), CGRectGetMaxY(skipButton.frame))];
        [splashButton2 addTarget:self action:@selector(singleTapSplashImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.viewController.view addSubview:splashButton2];
        _btnsOnWindow = [NSMutableArray arrayWithObjects:skipButton,splashButton1,splashButton2, nil];
    
        // 定时器
        _skipSplashTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(upDateTimeCounts:) userInfo:skipButton repeats:YES];
        
        [UIView animateWithDuration:3.0 animations:^{
            
            _splashImageView.transform = CGAffineTransformMakeScale(1.02, 1.02);
            
        } completion:^(BOOL finished) {
            
            if ([_skipSplashTimer isValid]) {
                [_skipSplashTimer invalidate];
                _skipSplashTimer = nil;
            }
            
            [UIView animateWithDuration:0.1 animations:^{
                
                _splashImageView.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                
                //[[NSNotificationCenter defaultCenter] postNotificationName:HOME_JUDGE_TIME_NOTIFICATION object:nil];
                [self removeSubviewsFromWindow];
                
            }];
        }];
    }

    [TalkingDataAppCpa init:@"ff923cd36d234199bdca8e48147c6af0" withChannelId:@"AppStore"];

    return YES;
}

- (void)registerAPNs
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)])
    {
        UIUserNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |      UIRemoteNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound |        UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
}

#pragma mark --- splash
- (void)removeSubviewsFromWindow{

    [_splashImageView removeFromSuperview];
    [_bottomImageV removeFromSuperview];
    for (UIButton *btn in _btnsOnWindow) {
        [btn removeFromSuperview];
    }
    
}

- (void)upDateTimeCounts:(NSTimer *)timer{
    
    UIButton *btn = (UIButton *)[timer userInfo];
    NSString *currentText = btn.titleLabel.text;
    NSArray *strs = [currentText componentsSeparatedByString:@"跳过"];
    NSInteger currentF = [[strs lastObject] integerValue];
    NSInteger nextF = currentF - 1;
    NSString *text = [NSString stringWithFormat:@"跳过%ld",(long)nextF];
    [btn setTitle:text forState:UIControlStateNormal];
    
}



//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    return UIInterfaceOrientationMaskPortrait;
//}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    //return UIInterfaceOrientationMaskPortrait;
    return self.window.rootViewController.supportedInterfaceOrientations;
}

#pragma mark --- remote notification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
     // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    [UMessage registerDeviceToken:deviceToken];
    
    /*NSLog(@"deviceToken = %@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);*/
    NSString *newToken =[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                          stringByReplacingOccurrencesOfString: @">" withString: @""]
                         stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    //判断是否已经有devicetoken
     NSString * token = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_device_token];
    if(![token isEqualToString:newToken])
    {
         [HNBUtils sandBoxSaveInfo:newToken forKey:personal_device_token];
    }

    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
    
#pragma mark  集成第四步: 上传设备deviceToken
    [MQManager registerDeviceToken:deviceToken];
    
    //NSLog(@" newToken : %@ : %s",newToken,__FUNCTION__);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"Error = %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//#pragma mark -- 设置未读消息数，保证服务器与本地一致
//    NSInteger count = [[[NIMSDK sharedSDK] conversationManager] allUnreadCount];
//
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
#pragma mark  集成第二步: 进入前台 打开meiqia服务
    [MQManager openMeiqiaService];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
    
#pragma mark  集成第三步: 进入后台 关闭美洽服务
    [MQManager closeMeiqiaService];
#pragma mark  MagicalRecord 设置
    [MagicalRecord cleanUp];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //LoginViewController *login =[[LoginViewController alloc] init];
    
    // 1 .
//    return [WXApi handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url];
    
    // 2 .
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
//        // 其他如支付等SDK的回调
//    }
//    return result;
    
    // 3 .
//    return [WXApi handleOpenURL:url delegate:self] || [[UMSocialManager defaultManager] handleOpenURL:url];
    
    NSString *URLString = url.absoluteString;
    if ([URLString hasPrefix:@"wx"] && [URLString rangeOfString:@"oauth"].location != NSNotFound) {
        /*
         wx12f1387805bf2897://oauth?code=013t50vQ1Mxw971bT6xQ1moZuQ1t50vp&state=App  微信授权登录
         wx12f1387805bf2897://platformId=wechat 微信分享
         */
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    if ([URLString hasPrefix:@"tencent"]) {
        /*
         tencent101187770://qzapp/mqzone/0?generalpastboard=1 qq登录
         QQ060800BA://response_from_qq?source=qq&source_scheme=mqqapi&error=0&version=1 qq分享
         QQ060800BA://response_from_qq?source=qq&source_scheme=mqqapi&error=0&version=1 qq空间分享
         */
        return [TencentOAuth HandleOpenURL:url];
    }
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
    
    
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    //判断是否是通过LinkedME的UrlScheme唤起App
    if ([[url description] rangeOfString:@"click_id"].location != NSNotFound) {
        return [[LinkedME getInstance] handleDeepLink:url];
    }
    
    // 支付宝支付
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@" sourceApplication - 处理支付结果 result = %@",resultDic);
        }];
        
        
         // 授权跳转支付宝钱包进行支付，处理支付结果
//         [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//         NSLog(@"result = %@",resultDic);
//         // 解析 auth code
//         NSString *result = resultDic[@"result"];
//         NSString *authCode = nil;
//         if (result.length>0) {
//         NSArray *resultArr = [result componentsSeparatedByString:@"&"];
//         for (NSString *subResult in resultArr) {
//         if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//         authCode = [subResult substringFromIndex:10];
//         break;
//         }
//         }
//         }
//         NSLog(@"授权结果 authCode = %@", authCode?:@"");
//         }];
     
        
        return YES;
    }
    
    //LoginViewController *login =[[LoginViewController alloc] init];
    // 1 .
    //    return [WXApi handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url];
    
    // 2 .
    //    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    //    if (!result) {
    //        // 其他如支付等SDK的回调
    //    }
    //    return result;
    
    // 3 .
    NSString *URLString = url.absoluteString;
    if ([URLString hasPrefix:@"wx"] && [URLString rangeOfString:@"oauth"].location != NSNotFound) {
        /*
         wx12f1387805bf2897://oauth?code=013t50vQ1Mxw971bT6xQ1moZuQ1t50vp&state=App  微信授权登录
         wx12f1387805bf2897://platformId=wechat 微信分享
         */
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    if ([URLString hasPrefix:@"tencent"]) {
        /*
         tencent101187770://qzapp/mqzone/0?generalpastboard=1 qq登录 
         QQ060800BA://response_from_qq?source=qq&source_scheme=mqqapi&error=0&version=1 qq分享
         QQ060800BA://response_from_qq?source=qq&source_scheme=mqqapi&error=0&version=1 qq空间分享
         */
        return [TencentOAuth HandleOpenURL:url];
    }
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
    
}


// NOTE:   支付宝支付 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    //判断是否是通过LinkedME的UrlScheme唤起App
    if ([[url description] rangeOfString:@"click_id"].location != NSNotFound) {
        return [[LinkedME getInstance] handleDeepLink:url];
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@" openURL - 处理支付结果 result = %@",resultDic);
        }];
        
       
         // 授权跳转支付宝钱包进行支付，处理支付结果
//         [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//         NSLog(@"result = %@",resultDic);
//         // 解析 auth code
//         NSString *result = resultDic[@"result"];
//         NSString *authCode = nil;
//         if (result.length>0) {
//         NSArray *resultArr = [result componentsSeparatedByString:@"&"];
//         for (NSString *subResult in resultArr) {
//         if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//         authCode = [subResult substringFromIndex:10];
//         break;
//         }
//         }
//         }
//         NSLog(@"授权结果 authCode = %@", authCode?:@"");
//         }];
        
        return YES;
        
    }
    
    
    NSString *URLString = url.absoluteString;
    if ([URLString hasPrefix:@"wx"] && [URLString rangeOfString:@"oauth"].location != NSNotFound) {
        /*
         wx12f1387805bf2897://oauth?code=013t50vQ1Mxw971bT6xQ1moZuQ1t50vp&state=App  微信授权登录
         wx12f1387805bf2897://platformId=wechat 微信分享
         */
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    if ([URLString hasPrefix:@"tencent"]) {
        /*
         tencent101187770://qzapp/mqzone/0?generalpastboard=1 qq登录
         QQ060800BA://response_from_qq?source=qq&source_scheme=mqqapi&error=0&version=1 qq分享
         QQ060800BA://response_from_qq?source=qq&source_scheme=mqqapi&error=0&version=1 qq空间分享
         */
        return [TencentOAuth HandleOpenURL:url];
    }
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
    
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "hinabian.hinabian" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"hinabian" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    if (![NSThread isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            (void)[self persistentStoreCoordinator];
        });
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"hinabian.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isDeleteDB"]) {
            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];   //删除数据库
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isDeleteDB"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        //abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
        }
    }
}
// 授权后回调 WXApiDelegate
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        NSString * order_no = [HNBUtils sandBoxGetInfo:[NSString class] forKey:wx_pay_order];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [DataFetcher doVerifyVisaPayInfo:order_no PayState:[NSString stringWithFormat:@"%d",resp.errCode] withSucceedHandler:^(id JSON) {
                    
                } withFailHandler:^(id error) {
                    
                }];
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败!"];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                [DataFetcher doVerifyVisaPayInfo:order_no PayState:[NSString stringWithFormat:@"%d",resp.errCode] withSucceedHandler:^(id JSON) {
                    
                } withFailHandler:^(id error) {
                    
                }];
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    // 向微信请求授权后,得到响应结果
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        
        SendAuthResp *temp = (SendAuthResp *)resp;
        
        NSString *accessUrlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",  WXKEY, WXSECRET, temp.code];
        
        NSURL *zoneUrl = [NSURL URLWithString:accessUrlStr];
        
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        
        if (data) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *accessToken = [dic objectForKey:WX_ACCESS_TOKEN];
            NSString *openID = [dic objectForKey:WX_OPEN_ID];
            NSString *refreshToken = [dic objectForKey:WX_REFRESH_TOKEN];
            
            if (accessToken && ![accessToken isEqualToString:@""] && openID && ![openID isEqualToString:@""]) {
                [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:WX_ACCESS_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:openID forKey:WX_OPEN_ID];
                [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:WX_REFRESH_TOKEN];
                [[NSUserDefaults standardUserDefaults] synchronize]; // 命令直接同步到文件里，来避免数据的丢失
                [[NSNotificationCenter defaultCenter] postNotificationName:WX_LOGIN_NOTIFICATION object:nil];
            }
            [self wechatLoginByRequestForUserInfo];
        }
    }
}

- (void)wechatLoginByRequestForUserInfo {
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    NSString *userUrlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", accessToken, openID];
    // 请求用户数据
    NSURL *zoneUrl = [NSURL URLWithString:userUrlStr];
    
    NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
    
    NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSLog(@"请求用户信息的data = %@", data);
    }else{
        NSLog(@"获取用户信息时出错");
    }
}


#pragma mark ------ push 消息的接收

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@" Test-Function %s ",__FUNCTION__);
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    //[UMessage didReceiveRemoteNotification:userInfo];
    
    self.remoteUserInfo = userInfo;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [self displayCustomAlertView];
    }else{
        [self handlePushMessageInfo:userInfo];
    }
    
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSLog(@" Test-Function %s ",__FUNCTION__);
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    self.remoteUserInfo = userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        //[UMessage didReceiveRemoteNotification:userInfo];
//        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
//            [self displayCustomAlertView];
//        }else{
//            [self handlePushMessageInfo:userInfo];
//        }
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    
    //NSLog(@" userInfo : %@ : %s",userInfo,__FUNCTION__);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSLog(@" Test-Function %s ",__FUNCTION__);
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        //[UMessage didReceiveRemoteNotification:userInfo];
        [self handlePushMessageInfo:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
    //NSLog(@" userInfo : %@ : %s",userInfo,__FUNCTION__);
    
}



#pragma mark - 处于前台运行时自定义弹框及push / im 跳转
- (void)displayCustomAlertView{
    
    /*
     NSDictionary *apsDic = [self.remoteUserInfo objectForKey:@"aps"];
     NSString *alertstring = [NSString stringWithFormat:@"%@",[apsDic objectForKey:@"alert"]];
     // 定制自己的弹出框
     UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"新消息提醒"
     message:alertstring
     delegate:self
     cancelButtonTitle:@"确定"
     otherButtonTitles:@"取消", nil];
     [aler show];
     */
    NSDictionary *apsDic = [self.remoteUserInfo objectForKey:@"aps"];
    NSString *tmpTitle = @"新消息";
    id alertInfo = [apsDic objectForKey:@"alert"];
    if ([alertInfo isKindOfClass:[NSDictionary class]]) { // 推送消息的新模板返回的数据结构解析
        tmpTitle = [alertInfo objectForKey:@"title"];
        //NSLog(@"if: 111");
    }else{
        tmpTitle = [NSString stringWithFormat:@"%@",alertInfo];
        //NSLog(@"else: 222");
    }
    
    // 定制自己的弹出框
    UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"新消息提醒"
                                                   message:tmpTitle
                                                  delegate:self
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:@"取消", nil];
    [aler show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        [self handlePushMessageInfo:self.remoteUserInfo];
        
    }
    
}

// 版本3.0.1 应运营需求，修改推送打开方案即：前台情况下依据使用系统弹框不展示自定义的 alertView
- (BOOL)judgeDeviceSystemOverTop10{
    
    BOOL rlt = FALSE;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        rlt = TRUE;
    }
    return rlt;
    
}

// 远程推送消息的处理
- (void)handlePushMessageInfo:(NSDictionary *)info{
    
    if (info[@"nim"] != nil) {
        [self jumpIntoChatView:info];
    }else {
        [self receiveMsgJumIntoView:info];
    }
    
}

- (void)jumpIntoChatView:(NSDictionary *)chatDic {
    self.tabBarController.selectedIndex = 0;
    [self.tabBarController selectedViewController];
    
    id noteListViewNavVC = self.tabBarController.viewControllers[0];
    if ([HNBUtils isLogin]) {
        if (chatDic[@"senderID"] && ![chatDic[@"senderID"] isEqualToString:@""]) {
            if([noteListViewNavVC isKindOfClass:[UINavigationController class]]){
                NSString *senderID = chatDic[@"senderID"];
                NIMSession *session = [NIMSession session:senderID type:NIMSessionTypeP2P];
                NETEaseViewController *vc = [[NETEaseViewController alloc] initWithSession:session];
                vc.isAllow_Chat = YES;
                [noteListViewNavVC pushViewController:vc animated:YES];
            }
        }
    }else {
        if([noteListViewNavVC isKindOfClass:[UINavigationController class]]){
            LoginViewController *vc = [[LoginViewController alloc] init];
            [noteListViewNavVC pushViewController:vc animated:YES];
        }
    }
    
}

- (void) receiveMsgJumIntoView:(NSDictionary *)userInfo
{
    NSLog(@" Test-Function %s ",__FUNCTION__);
    /**
     {
     aps =     {
     TribeUrl = "https://www.hinabian.com/theme/detail/7117334806568333605.html";
     alert =         {
     body = 4;
     subtitle = 3;
     title = 2;
     };
     badge = 3;
     "mutable-content" = 1;
     sound = default;
     };
     d = uu72717151546861717611;
     p = 0;
     }
     */
    [UMessage didReceiveRemoteNotification:userInfo];
    NSString * TribeUrl = [self queryValueWithKey:@"TribeUrl" info:userInfo];//[userInfo objectForKey:@"TribeUrl"];
    if (TribeUrl != nil && ![TribeUrl isEqualToString:@""]) {
        self.tabBarController.selectedIndex = 0;
        [self.tabBarController selectedViewController];
        
        id noteListViewNavVC = self.tabBarController.viewControllers[0];
        
        if([noteListViewNavVC isKindOfClass:[UINavigationController class]]){
            
            NSString *isNativeString = [HNBUtils sandBoxGetInfo:[NSString class] forKey:TRIBEDETAILTHEME_NATIVEUI_WEB];
            if ([isNativeString isEqualToString:@"1"]) {
                
                TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
                vc.URL = [[NSURL alloc] withOutNilString:TribeUrl];
                [noteListViewNavVC pushViewController:vc animated:YES];
                
            } else {
                
                SWKTribeShowViewController *vc = [[SWKTribeShowViewController alloc] init];
                vc.URL = [[NSURL alloc] withOutNilString:TribeUrl];
                [noteListViewNavVC pushViewController:vc animated:YES];
                
            }
            
        }
        return;
        
    }
    
    NSString * ProjectNotice = [self queryValueWithKey:@"ProjectNotice" info:userInfo];//[userInfo objectForKey:@"ProjectNotice"];
    if (ProjectNotice != nil && ![ProjectNotice isEqualToString:@""]) {
        self.tabBarController.selectedIndex = 3;
        [self.tabBarController selectedViewController];
        
        id noteListViewNavVC = self.tabBarController.viewControllers[3];
        
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [vc.webManger configNativeNavWithURLString:[NSString stringWithFormat:@"%@/%@",H5URL,TheURLForProjectOnHandling]
                                                       ctle:@"1"
                                                 csharedBtn:@"0"
                                                       ctel:@"1"
                                                  cfconsult:@"0"];
        
        if([noteListViewNavVC isKindOfClass:[UINavigationController class]]){
            
            [noteListViewNavVC pushViewController:vc animated:YES];
        }
        return;
        
    }
    
    NSString * ActivityPush = [self queryValueWithKey:@"ActivityPush" info:userInfo];//[userInfo objectForKey:@"ActivityPush"];
    if (ActivityPush != nil && ![ActivityPush isEqualToString:@""]) {
        self.tabBarController.selectedIndex = 0;
        [self.tabBarController selectedViewController];
        
        id noteListViewNavVC = self.tabBarController.viewControllers[0];
         
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [vc.webManger configNativeNavWithURLString:ActivityPush
                                                       ctle:@"1"
                                                 csharedBtn:@"1"
                                                       ctel:@"0"
                                                  cfconsult:@"0"];
        if([noteListViewNavVC isKindOfClass:[UINavigationController class]]){
            
            [noteListViewNavVC pushViewController:vc animated:YES];
        }
        return;
        
    }
    
    
    NSString * QAUrl = [self queryValueWithKey:@"Q&AUrl" info:userInfo];//[userInfo objectForKey:@"Q&AUrl"];
    if (QAUrl != nil && ![QAUrl isEqualToString:@""]) {
        self.tabBarController.selectedIndex = 0;
        [self.tabBarController selectedViewController];
        
        id noteListViewNavVC = self.tabBarController.viewControllers[0];
        SWKQuestionShowViewController *vc = [[SWKQuestionShowViewController alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:QAUrl];
        if([noteListViewNavVC isKindOfClass:[UINavigationController class]]){
            
            [noteListViewNavVC pushViewController:vc animated:YES];
        }
        return;
        
    }
    
    NSString * ReplyUrl = [self queryValueWithKey:@"ReplyUrl" info:userInfo];//[userInfo objectForKey:@"ReplyUrl"];
    if (ReplyUrl != nil && ![ReplyUrl isEqualToString:@""]) {
        self.tabBarController.selectedIndex = 0;
        [self.tabBarController selectedViewController];
        
        id noteListViewNavVC = self.tabBarController.viewControllers[0];
        SWKSingleReplyViewController *vc = [[SWKSingleReplyViewController alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:ReplyUrl];
        if([noteListViewNavVC isKindOfClass:[UINavigationController class]]){
            
            [noteListViewNavVC pushViewController:vc animated:YES];
        }
        return;
        
    }
    
    NSString * QANotice = [self queryValueWithKey:@"Q&ANotice" info:userInfo];//[userInfo objectForKey:@"Q&ANotice"];
    if (QANotice != nil && ![QANotice isEqualToString:@""]) {
        self.tabBarController.selectedIndex = 3;
        [self.tabBarController selectedViewController];
        
        id noteListViewNavVC = self.tabBarController.viewControllers[3];
        MyQuestionViewController *vc = [[MyQuestionViewController alloc] init];
        if([noteListViewNavVC isKindOfClass:[UINavigationController class]]){
            
            [noteListViewNavVC pushViewController:vc animated:YES];
        }
        return;
        
    }
    
    NSString * TribeNotice = [self queryValueWithKey:@"TribeNotice" info:userInfo];//[userInfo objectForKey:@"TribeNotice"];
    if (TribeNotice != nil && ![TribeNotice isEqualToString:@""]) {
        self.tabBarController.selectedIndex = 3;
        [self.tabBarController selectedViewController];
        
        id noteListViewNavVC = self.tabBarController.viewControllers[3];
        MyTribeViewController *vc = [[MyTribeViewController alloc] init];
        if([noteListViewNavVC isKindOfClass:[UINavigationController class]]){
            
            [noteListViewNavVC pushViewController:vc animated:YES];
        }
        return;
        
    }
    
}

- (NSString *)queryValueWithKey:(NSString *)key info:(NSDictionary *)info{
    NSString *value = @"";
    NSDictionary *aps = [info returnValueWithKey:@"aps"];
    if (aps) {
        value = [aps returnValueWithKey:key];
    }else{
        value = [info returnValueWithKey:key];
    }
    return value;
}


#pragma mark - 点击闪屏的处理

- (void)clickSkipSplashImageViewBtn:(UIButton *)btn{
    
    [HNBClick event:@"155011" Content:nil];
    
    if ([_skipSplashTimer isValid]) {
        
        [_skipSplashTimer invalidate];
        _skipSplashTimer = nil;
        
    }
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:HOME_JUDGE_TIME_NOTIFICATION object:nil];
    [self removeSubviewsFromWindow];
    
}

/**
 *  @author &#20313;&#22362;, 16-01-06 14:01:38
 *
 *  点击闪屏页处理
 *
 *  @param gestureRecognizer gestureRecognizer description
 */
- (void)singleTapSplashImage:(id)sender
{
    
    if ([_skipSplashTimer isValid]) {
        
        [_skipSplashTimer invalidate];
        _skipSplashTimer = nil;
        
    }

    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:sender];
    [self performSelector:@selector(todoSomething:) withObject:sender afterDelay:0.2f];
    
}

-(void) todoSomething:(id)sender
{

    [self removeSubviewsFromWindow];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:HOME_JUDGE_TIME_NOTIFICATION object:nil];
    NSString *splashUrl = [HNBUtils sandBoxGetInfo:[NSString class] forKey:SPLASHURL];
    if(splashUrl)
    {
        /* 判断url  tribe  q&a 华人一天 */
        NSRange range = [splashUrl rangeOfString:@"theme/detail"];//帖子
        if (range.location != NSNotFound)
        {
            self.tabBarController.selectedIndex = 0;
            [self.tabBarController selectedViewController];
            
            id noteListViewNavVC = self.tabBarController.viewControllers[0];
            if([noteListViewNavVC isKindOfClass:[UINavigationController class]]){
                
                NSString *isNativeString = [HNBUtils sandBoxGetInfo:[NSString class] forKey:TRIBEDETAILTHEME_NATIVEUI_WEB];
                if ([isNativeString isEqualToString:@"1"]) {
                    
                    TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
                    vc.URL = [[NSURL alloc] withOutNilString:splashUrl];
                    [noteListViewNavVC pushViewController:vc animated:YES];
                    
                } else {
                    
                    SWKTribeShowViewController *vc = [[SWKTribeShowViewController alloc] init];
                    vc.URL = [[NSURL alloc] withOutNilString:splashUrl];
                    [noteListViewNavVC pushViewController:vc animated:YES];
                    
                }
                
            }
            return;
            
        }
        
        range = [splashUrl rangeOfString:@"cnd/detail"];//华人一天
        if (range.location != NSNotFound)
        {
            self.tabBarController.selectedIndex = 0;
            [self.tabBarController selectedViewController];
            
            id noteListViewNavVC = self.tabBarController.viewControllers[0];
            MyOnedayViewController *vc = [[MyOnedayViewController alloc] init];
            vc.URL = [[NSURL alloc] withOutNilString:splashUrl];
            if([noteListViewNavVC isKindOfClass:[UINavigationController class]]){
                
                [noteListViewNavVC pushViewController:vc animated:YES];
            }
            return;
        }
        
        range = [splashUrl rangeOfString:@"qa_question/detail"];//问答
        if (range.location != NSNotFound)
        {
            self.tabBarController.selectedIndex = 0;
            [self.tabBarController selectedViewController];
            
            id noteListViewNavVC = self.tabBarController.viewControllers[0];
            SWKQuestionShowViewController *vc = [[SWKQuestionShowViewController alloc] init];
            vc.URL = [[NSURL alloc] withOutNilString:splashUrl];
            if([noteListViewNavVC isKindOfClass:[UINavigationController class]]){
                
                [noteListViewNavVC pushViewController:vc animated:YES];
            }
            return;
        }
        range = [splashUrl rangeOfString:@"m.hinabian.com/assess"];//移民评估
        if (range.location != NSNotFound)
        {
            self.tabBarController.selectedIndex = 0;
            [self.tabBarController selectedViewController];
            
            id noteListViewNavVC = self.tabBarController.viewControllers[0];
            IMAssessViewController * vc = [[IMAssessViewController alloc] init];
            vc.URL = [NSURL URLWithString:@"https://m.hinabian.com/assess.html"];
            if([noteListViewNavVC isKindOfClass:[UINavigationController class]]){
                
                [noteListViewNavVC pushViewController:vc animated:YES];
            }
            return;
        }

        
        self.tabBarController.selectedIndex = 0;
        [self.tabBarController selectedViewController];
        
        id noteListViewNavVC = self.tabBarController.viewControllers[0];
        PublicViewController *vc = [[PublicViewController alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:splashUrl];
        if([noteListViewNavVC isKindOfClass:[UINavigationController class]]){
            
            [noteListViewNavVC pushViewController:vc animated:YES];
        }
        
    }
    
    
}

@end
