//
//  HNBHomePageV3.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/18.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "HNBHomePageV3.h"
#import "HNBHomePageManager.h"
#import "HNBHomePageV3MainView.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "LatestNewsList.h"
#import "TribeDetailInfoViewController.h"
#import "IMAssessViewController.h"
#import "QAIndexViewController.h"
#import "QAIndexViewController.h"
#import "WeSuperiorityViewController.h"
#import "SWKTribeShowViewController.h"
#import "SpecialActivityViewController.h"
#import "GuideHomeViewController.h"
#import "UserInfoController2.h"
#import "LoginViewController.h"
#import "RcmSpecialListVC.h"
#import "GreatTalksListVC.h"
#import "HnbEditorTalksListVC.h"
#import "HotTopicListVC.h"
#import "TribeDetailInfoViewController.h" // 帖子详情
#import "HomeSerachViewController.h"
#import "GuideHomeViewController.h"  // V3.0 版本引导页
#import "IMAssessVC.h"
#import "HNBLoadingMask.h"
#import "HNBNetRemindView.h"
#import "GuideImassessViewController.h"
#import "RefreshControl.h"
#import "PersonInfoModel.h"
#import "ProjectStateModel.h" // 项目进度通知
#import <NIMSDK/NIMSDK.h>
#import "NETEaseViewController.h"
#import "FunctionIMProjHomeController.h"//原生的移民项目
#import "OverSeaClassesVC.h"

// 首页旧版业务
#import "JudgeAppView.h"
#import "AppointmentButton.h"
#import "IdeaBackNewViewController.h"
#import "SWKConsultOnlineViewController.h"
#import <AdSupport/AdSupport.h>
#import "UMessage.h"
#import "IMAssessRemindView.h"
#import <NIMSDK/NIMSDK.h>
// 美洽
#import "MQChatViewManager.h"

#import "ShowAllServicesViewController.h"

#define FIRST_ALERT_NUM         5
#define CONTINUE_ALERT_NUM      15

@interface HNBHomePageV3 () <HNBHomePageV3MainViewDelegate,HNBHomePageManagerManagerDelegate,JudgeAppViewDelegate,AppointmentButtonDelegate,HNBNetRemindViewDelegate,RefreshControlDelegate,IMAssessRemindViewDelegate>

@property (nonatomic,strong) HNBHomePageManager *homePageManager;
@property (nonatomic,strong) HNBHomePageV3MainView *homePage;
@property (nonatomic,strong) HNBLoadingMask *loadingMask;
@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic,assign) BOOL preferredPlansDataStatus;         // 最佳方案数据状态 - 有数据为 真
@property (nonatomic,assign) BOOL isFirstInSetTabNum;               // 第一次进来才设置tabnum


/**<导航栏处理>*/
@property (nonatomic,strong) HNBNetRemindView *showPoorNetView;
@property (nonatomic,strong) HNBNetRemindView *showFailNetReqView;
@property (nonatomic,assign) CGFloat lastOffset;
@property (nonatomic,assign) BOOL flag;
@property (nonatomic,assign) BOOL willDissAppear;

/**<首页其他业务处理>*/
@property (nonatomic,strong) AppointmentButton *appointmentBtn; // 预约咨询按钮
@property (nonatomic,strong) NSTimer *userChaJudgeTimer;
@property (nonatomic,assign) BOOL isRegisterForRemoteNotifi;

/**<点击统计>*/
@property (nonatomic,copy) NSString *homeStyle;

@property (nonatomic,strong) IMAssessRemindView *imassessguide; // 移民评估引导弹框

/**<全部页里的所有数据>*/
@property (nonatomic, strong) NSArray *hnbServiceArr;
@property (nonatomic, strong) NSArray *thirdPartArr;

@end

@implementation HNBHomePageV3

+ (instancetype)shareHNBHomePageVC{
    
    static HNBHomePageV3 *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[HNBHomePageV3 alloc] init];
        
    });
    return instance;
}

#pragma mark ------ life

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"首页";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 优先处理引导业务
//    [self displayVCBeforeHomepageVC];
    
    // 初始值
    _isRegisterForRemoteNotifi = FALSE;
    _isFirstInSetTabNum        = TRUE;
    _homeStyle = @"C";
    _hnbServiceArr = [[NSArray alloc] init];
    _thirdPartArr = [[NSArray alloc] init];
    
    // 主页面及数据
    _homePageManager = [[HNBHomePageManager alloc] init];
    _homePageManager.delegate = self;
    // 优先处理引导业务
    [_homePageManager homePageReqConfig];
    _homePage = [[HNBHomePageV3MainView alloc] initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        SCREEN_WIDTH,
                                                                        SCREEN_HEIGHT)];
    _homePage.delegate = self;
    if (@available(iOS 11.0, *)) {
        UITableView *tmpTable = [_homePage getCurrentTableView];
        tmpTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        tmpTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tmpTable.scrollIndicatorInsets = tmpTable.contentInset;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self.view addSubview:_homePage];
    
    // 其他业务
    [self openAPPCountCaculate];
    [self getAndSaveIdfa];
    [self newUserUploadData];
    [_homePageManager downLoadAndSaveImage];
    
    // 处理网络状态
    [self handleNetStatus];
    
    // 刷新控件
    float topOffset = IS_IPHONE_X ? 24 : 0; /*适配IphoneX 下拉刷新*/
    _refreshControl=[[RefreshControl alloc] initWithScrollView:[_homePage getCurrentTableView] topOffset:topOffset delegate:self];
    _refreshControl.topEnabled=YES;
    _refreshControl.bottomEnabled=NO;
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _willDissAppear = FALSE;
    [self setUpNav];
    if (_imassessguide) { //如果存在再判断
        /*
         ** 主要判断是否做过引导页的内容，如果做过就不再出现评估弹框
         */
        if ([[HNBUtils sandBoxGetInfo:[NSString class] forKey:IMGuide_hasBeen_Finished] isEqualToString:@"1"] && [[HNBUtils sandBoxGetInfo:[NSString class] forKey:IMGuide_Finished_Show] isEqualToString:@"0"]) {
            //完成了题目；并且通过引导页进来的
            self.imassessguide.hidden = YES;
        }

        if (!_imassessguide.hidden) {
            [[self rdv_tabBarController] setTabBarHidden:TRUE animated:YES];
        }else{
            [[self rdv_tabBarController] setTabBarHidden:FALSE animated:YES];
        }
    }else {
        [[self rdv_tabBarController] setTabBarHidden:FALSE animated:YES];
    }
    
    [self userUpload];
    
    //
    if ([HNBUtils isLogin]) {
        [HNBUtils uploadAssessRlt];
    }
    
    // 验证登陆及最佳方案
    [_homePageManager homePageVertifyLoginStatusAndUpdateUserInfo];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (!REGISTERFORREMOTENOTIFICATION_APPDELEGATE && !_isRegisterForRemoteNotifi) {
        
        _isRegisterForRemoteNotifi = YES;
        
        // 注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
        [UMessage registerForRemoteNotifications];
        
        //iOS10必须加下面这段代码。
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate=(id)self;
        //center.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
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
    
    // 判断是否显示搜索按钮
    [self judgeSearchBtnItem];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 导航栏与底部标签栏的处理的处理
    _willDissAppear = TRUE;
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:[UIColor DDNavBarBlue]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = FALSE;
    UIImageView *navBackImageView = (UIImageView *)self.navigationController.navigationBar.subviews.firstObject;
    navBackImageView.alpha = 1.0;
    
}

- (void)setUpNav{
    [self.navigationController setNavigationBarHidden:FALSE animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    //NSLog(@" 666 %s ",__FUNCTION__);
    [self reSetCurrentNavStyleWithTableOffsetY:[_homePage getCurrentTableOffsetY]];
    self.navigationController.navigationBar.translucent = TRUE;
    
}

#pragma mark ------ RefreshControlDelegate

-(void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{
    
    if (direction == RefreshDirectionTop) { // 顶部下拉刷新
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_homePageManager homePageReqDataForLatestDataUpScreen];
        });
        
    }
    
}

#pragma mark ------ HNBHomePageV3MainViewDelegate
#pragma mark 首页 banner 点击
-(void)homePageV3BannerAtIndex:(NSInteger)idx link:(NSString *)link{
    
    if ([[HNBWebManager defaultInstance] isHinabianThemeDetailWithURLString:link]) {
        
        TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:link];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [NSURL URLWithString:link];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    NSDictionary *dict = @{@"url":link,
                           @"state":_homeStyle
                           };
    NSString *indexString = [NSString stringWithFormat:@"20100%ld",idx];
    [HNBClick event:indexString Content:dict];
    
}

#pragma mark 首页 function 点击

-(void)homePageV3FunctionAtItem:(NSString *)itemName isLocal:(NSString *)isLocal link:(NSString *)link{

/** 新版 === v3.0
 visa
 大国签证
 
 house
 海外房产
 
 project
 移民项目
 
 baike
 国家百科
 */
    NSString *lowerItemName = [itemName lowercaseString];
    if ([lowerItemName isEqualToString:@"visa"]){
        

        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [NSURL URLWithString:link];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([lowerItemName isEqualToString:@"project"]){
        //原生
        FunctionIMProjHomeController *vc = [[FunctionIMProjHomeController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:link];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
    NSString *indexString = @"";
    if ([lowerItemName isEqualToString:@"baike"]) {
        indexString = @"201011";
    } else if([lowerItemName isEqualToString:@"project"]){
        indexString = @"201012";
    } else if([lowerItemName isEqualToString:@"house"]){
        indexString = @"201013";
    }else if([lowerItemName isEqualToString:@"visa"]){
        indexString = @"201014";
    }
    NSDictionary *dict = @{@"state":_homeStyle};
    [HNBClick event:indexString Content:dict];
    
}

- (void)homePageV3FunctionAtAll {
    ShowAllServicesViewController *vc = [[ShowAllServicesViewController alloc] init];
    vc.hnbServicesArr = [_hnbServiceArr copy];
    vc.thirdPartArr = [_thirdPartArr copy];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 首页 快讯、推荐专家-查看全部、大咖说-查看全部

-(void)homePageV3MainView:(HNBHomePageV3MainView *)homeView didSelectRowAtIndexPath:(NSIndexPath *)indexPath functionTag:(HomePageClickFunction)clickTag{
    
    switch (clickTag) {
        case HomePageClickFunctionLatestNewsList:
            {
                NSLog(@" HomePageClickFunctionLatestNewsList ");
                LatestNewsList *vc = [[LatestNewsList alloc] init];
                [HNBUtils sandBoxSaveInfo:@"" forKey:LIST_LATEST_NEWS_LAST_IDMD5];
                [self.navigationController pushViewController:vc animated:TRUE];
                
                NSString *indexString = @"201021";
                NSDictionary *dict = @{@"state":_homeStyle};
                [HNBClick event:indexString Content:dict];
            }
            break;
        case HomePageClickFunctionLookAssessResult:
            {
                NSLog(@" HomePageClickFunctionLookAssessResult ");
                if (![HNBUtils isLogin]) {
                    LoginViewController *vc = [[LoginViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:TRUE];
                    
                    GuideImassessViewController *nxtvc = [[GuideImassessViewController alloc] init];
                    nxtvc.willAppearReload = TRUE;
                    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,GuideImassessList];
                    nxtvc.URL = [nxtvc.webManger configNativeNavWithURLString:URLString ctle:@"0" csharedBtn:@"0" ctel:@"0" cfconsult:@"0"];
                    NSArray *tmpvcs = [self.navigationController viewControllers];
                    self.navigationController.viewControllers = [HNBUtils operateNavigationVCS:tmpvcs index:tmpvcs.count - 1 vc:nxtvc];
                    
                }else{                    
                    GuideImassessViewController *vc = [[GuideImassessViewController alloc] init];
                    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,GuideImassessList];
                    vc.URL = [vc.webManger configNativeNavWithURLString:URLString ctle:@"0" csharedBtn:@"0" ctel:@"0" cfconsult:@"0"];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                
                NSDictionary *dict = @{@"state":@"A"};
                [HNBClick event:@"201022" Content:dict];
                
            }
            break;
        case HomePageClickFunctionRcmSpecialsList:
            {
                NSLog(@" HomePageClickFunctionRcmSpecialsList ");
                RcmSpecialListVC *vc = [[RcmSpecialListVC alloc] init];
                [self.navigationController pushViewController:vc animated:TRUE];
                
                NSDictionary *dict = @{@"state":_homeStyle};
                [HNBClick event:@"201030" Content:dict];
            }
            break;
        case HomePageClickFunctionGreatTalkList:
            {
                NSLog(@" HomePageClickFunctionGreatTalkList ");
                GreatTalksListVC *vc = [[GreatTalksListVC alloc] init];
                [self.navigationController pushViewController:vc animated:TRUE];
                
                NSDictionary *dict = @{@"state":_homeStyle};
                [HNBClick event:@"201036" Content:dict];
                
            }
            break;
        case HomePageClickFunctionHnbEditorTalkList:
            {
                NSLog(@" HomePageClickFunctionHnbEditorTalkList ");
                HnbEditorTalksListVC *vc = [[HnbEditorTalksListVC alloc] init];
                [self.navigationController pushViewController:vc animated:TRUE];
                
                NSDictionary *dict = @{@"state":_homeStyle};
                [HNBClick event:@"201038" Content:dict];
                
            }
            break;
        case HomePageClickFunctionBigDataAssess:
            {
                IMAssessVC *vc = [[IMAssessVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
                NSDictionary *dict = @{@"state":@"B"};
                [HNBClick event:@"201026" Content:dict];
                
            }
            break;
        case HomePageClickFunctionOverSeaClass:
            {
                OverSeaClassesVC *vc = [[OverSeaClassesVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
                NSDictionary *dict = @{@"state":_homeStyle,};
                [HNBClick event:@"201050" Content:dict];
                //NSLog(@"Class -- Go OverSeaClasses");
            }
            break;
        default:
            break;
    }
    
}

#pragma mark B: 重新评估、查看全部评估结果

-(void)homePageBV3MainView:(HNBHomePageV3MainView *)homeView didSelectRowAtIndex:(NSString *)flag {
    
    if ([flag isEqualToString:cREASSESS]) {
        
        IMAssessVC *vc = [[IMAssessVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
        NSDictionary *dict = @{@"state":@"B"};
        [HNBClick event:@"201023" Content:dict];
        
    } else if([flag isEqualToString:cLOOKALLRLTS]){
        
        GuideImassessViewController *vc = [[GuideImassessViewController alloc] init];
        NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,GuideImassessList];
        vc.URL = [vc.webManger configNativeNavWithURLString:URLString ctle:@"0" csharedBtn:@"0" ctel:@"0" cfconsult:@"0"];
        [self.navigationController pushViewController:vc animated:YES];
        
        NSDictionary *dict = @{@"state":@"B"};
        [HNBClick event:@"201025" Content:dict];
        
    }
}

#pragma mark 最佳方案

- (void)homePageV3PreferredPlansWithURLString:(NSString *)URLString{
    
    SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
    vc.URL = [NSURL URLWithString:URLString];
    [self.navigationController pushViewController:vc animated:TRUE];
    
    NSDictionary *dict = @{@"state":@"B"};
    [HNBClick event:@"201024" Content:dict];

}

#pragma mark  点击 首页推荐专家咨询

- (void)homePageV3RcmSpecialConsultWithID:(NSString *)specialid imId:(NSString *)imid specialName:(NSString *)specialName{
    
    if ([HNBUtils isLogin]) {
        
        if (imid && ![imid isEqualToString:@""]) {
            NIMSession *session = [NIMSession session:imid type:NIMSessionTypeP2P];
            NETEaseViewController *chatVC = [[NETEaseViewController alloc] initWithSession:session];
            chatVC.isAllow_Chat = YES;
            [self.navigationController pushViewController:chatVC animated:YES];
        }
        
    } else {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    NSDictionary *dict = @{@"state":_homeStyle,
                           @"f_expert":specialName
                           };
    [HNBClick event:@"201031" Content:dict];
    
}

#pragma mark 首页 推荐活动
-(void)homePageV3RcmActLink:(NSString *)link{
    
 
    if ([[HNBWebManager defaultInstance] isHinabianThemeDetailWithURLString:link]) {
        
        NSString *isNativeString = [HNBUtils sandBoxGetInfo:[NSString class] forKey:TRIBEDETAILTHEME_NATIVEUI_WEB];
        if ([isNativeString isEqualToString:@"1"]) {
            
            TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
            vc.URL = [[NSURL alloc] withOutNilString:link];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
            
            SWKTribeShowViewController *vc = [[SWKTribeShowViewController alloc] init];
            vc.URL = [[NSURL alloc] withOutNilString:link];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    } else {
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [NSURL URLWithString:link];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    NSString *indexString = @"201033";
    NSDictionary *dict = @{@"state":_homeStyle};
    [HNBClick event:indexString Content:dict];
    
}


#pragma mark 首页 热门话题
-(void)homePageV3HotTopicLink:(NSString *)link{
    //NSLog(@" \n \n  %s \n \n link : %@  \n \n ",__FUNCTION__,link);
    HotTopicListVC *vc = [[HotTopicListVC alloc] init];
    vc.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@%@",H5URL,HomePage30HotTopicList,link]];
    [self.navigationController pushViewController:vc animated:TRUE];
    
    NSString *codeNum = @"201034";
    NSDictionary *dict = @{@"state":_homeStyle};
    [HNBClick event:codeNum Content:dict];
}

#pragma mark 首页 大咖说
-(void)homePageV3GreatTalkLink:(NSString *)link index:(NSInteger)index{
    //NSLog(@" \n \n  %s \n \n link : %@  \n \n ",__FUNCTION__,link);
    TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
    vc.URL = [NSURL URLWithString:link];
    [self.navigationController pushViewController:vc animated:TRUE];
    
    NSString *pos = [NSString stringWithFormat:@"%ld",index];
    NSDictionary *dict = @{@"state":_homeStyle,
                           @"pos":pos,
                           @"url":link
                           };
    [HNBClick event:@"201037" Content:dict];
}

#pragma mark 首页 小边说
-(void)homePageV3HnbEditorLink:(NSString *)link index:(NSInteger)index{
    //NSLog(@" \n \n  %s \n \n link : %@  \n \n ",__FUNCTION__,link);
    TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
    vc.URL = [NSURL URLWithString:link];
    [self.navigationController pushViewController:vc animated:TRUE];
    
    NSString *pos = [NSString stringWithFormat:@"%ld",index];
    NSDictionary *dict = @{@"state":_homeStyle,
                           @"pos":pos,
                           @"url":link
                           };
    [HNBClick event:@"201039" Content:dict];
}

#pragma mark 首页 滚动导航栏

- (void)reSetCurrentNavStyleWithTableOffsetY:(CGFloat)offsetY{
    
    CGFloat offset = offsetY;
    CGFloat minAlphaOffset = -(SCREEN_NAVHEIGHT + SCREEN_STATUSHEIGHT); // -64
    CGFloat maxAlphaOffset = HBannerHeight;                             // 174
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    //     确保 取之范围 0 - 1
    if(alpha <= 0){
        alpha = 0.0;
    }else if(alpha >= 1.0){
        alpha = 1.0;
    }
    
    // 区分滑动方向
    //BOOL upDir = offset > _lastOffset ? TRUE : FALSE;
    _lastOffset = offset;
    // 滑动 - 确保向上滑动过程中只执行一次
    //NSLog(@" 滚动方向：%d ==== 便移：%f 透明度：%f",upDir,offset,alpha);
    //if(alpha >= 0.01 && offsetY != 0){
    if(alpha >= 0.015 && offsetY > 0){
        [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:[UIColor DDNavBarBlue]] forBarMetrics:UIBarMetricsDefault];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 90.0f, 24.3f)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImage:[UIImage imageNamed:@"homeTitle.png"]];
        [self.navigationItem setTitleView:imageView];
        _flag = FALSE;
        //NSLog(@" 1111111111111111111111 - 显示 ");
    //}else if(alpha < 0.01 && !upDir && !_flag){
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 90.0f, 24.3f)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImage:[UIImage new]];
        [self.navigationItem setTitleView:imageView];
        //NSLog(@" 1111111111111111111111 - 隐藏");
        _flag = TRUE;
    }

    UIImageView *navBackImageView = (UIImageView *)self.navigationController.navigationBar.subviews.firstObject;
    navBackImageView.alpha = alpha;
    //NSLog(@"  \n \n == reSetCurrentNavStyleWithTableOffsetY == > %f \n alpha : %f\n",offsetY,alpha);
}

- (void)scrollViewDidScrollWithCurrentOffset:(CGFloat)offset{
    if (!_willDissAppear) {
        //NSLog(@" 666 %s ",__FUNCTION__);
        [self reSetCurrentNavStyleWithTableOffsetY:offset];
    }
}

#pragma mark 首页 推荐专家 点击
-(void)homePageV3RcmSpecialId:(NSString *)perid{
    UserInfoController2 *vc = [[UserInfoController2 alloc]init];
    vc.personid = perid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------ HNBHomePageManagerManagerDelegate

-(void)homePageReqDataSucWithBannerData:(NSArray *)bannerData preferredplans:(NSArray *)planData funcData:(NSArray *)funcData hnbServiceData:(NSArray *)hnbServiceData thirdPartData:(NSArray *)thirdPartData lastedNews:(NSArray *)lastedNews rcmspecials:(NSArray *)rcmspecials rcmActData:(id)rcmActModel hotTopic:(id)topicModel netReqStatus:(HomePage30NetReqStatus)netReqStatus classes:(NSArray *)classes {
    
    if (_refreshControl.refreshingDirection == RefreshingDirectionTop) {
        [_refreshControl finishRefreshingDirection:RefreshDirectionBottom isEmpty:YES];
        
    }
    
    [_homePage reFreshHomeViewWithBannerData:bannerData
                             preferredplans:planData
                                  funcData:funcData
                                      news:lastedNews
                                  specials:rcmspecials
                                rcmActData:rcmActModel
                                  hotTopic:topicModel];
    
    [_homePage reFreshHomeViewWithOverSeaClasses:classes];
    
    _hnbServiceArr = [hnbServiceData copy];
    _thirdPartArr = [thirdPartData copy];
    
    [self.loadingMask dismiss];
    [self displaySearchBtnItemWithStatus:TRUE];
    if (netReqStatus == HomePage30NetReqStatusPartFailure) {
        [self showHudWithMessage];
    }else if (netReqStatus == HomePage30NetReqStatusAllFailure){
        [self showMessageWhenReqNetError];
        [self displaySearchBtnItemWithStatus:FALSE];
    }else{
        
    }

}

- (void)homePageReqDataSucWithPreferredplans:(NSArray *)planData{
    [_homePage reFreshHomeViewWithPreferredplans:planData];
}

- (void)homePageReqDataSucWithGreatTalks:(NSArray *)greatTalks editorTalks:(NSArray *)editorTalks{
    [_homePage reFreshHomeViewWithGreatTalks:greatTalks editorTalks:editorTalks];

}

- (void)homePageUpdateUserInfoThenModifyHomePageStyle{
    [self chooseHomeUI];
    
    // 标记一次上报
    NSDictionary *dict = @{@"state":_homeStyle};
    [HNBClick event:@"201040" Content:dict];
    
}

- (void)homePageSetUnReadMessageCount{
    if (_isFirstInSetTabNum) {
        //第一次进入设置tab数值
        _isFirstInSetTabNum = FALSE;
        RDVTabBarItem *tabBarItem = [[[[self rdv_tabBarController] tabBar] items] objectAtIndex:TAB_MESSAGE_INDEX];
        NSInteger messageCount = [tabBarItem.badgeValue integerValue] + [NIMSDK sharedSDK].conversationManager.allUnreadCount;
        [tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",messageCount]];
    }
    
    // 每次打开 App ,判断此次打开日期距离上次第一次记录聊天日期差值
    NSMutableArray *limitedDataArr = [HNBUtils sandBoxGetInfo:[NSMutableArray class] forKey:NETEASE_LIMITED_ARRAY];
    NSMutableArray *tempDataArr = [limitedDataArr mutableCopy];
    for (int index = 0; index < limitedDataArr.count; index++) {
        NSMutableDictionary *tempDic = limitedDataArr[index];
        NSMutableDictionary *changeDic = [tempDic mutableCopy];
        NSString *tempID = tempDic[NETEASE_LIMITED_ID];
        if ([tempID isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
            NSString *preDateString = tempDic[NETEASE_FIRST_CHATTIME];
            if (tempDic[NETEASE_FIRST_CHATTIME] || ![tempDic[NETEASE_FIRST_CHATTIME] isEqualToString:@""]) {
                NSString *dateCountFlag = [HNBUtils compareDateWithGivedDateString:preDateString];
                if ([dateCountFlag isEqualToString:@"1"]) {
                    //如果大于24小时重新设置
                    NSArray *recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
                    NSInteger todayWholeNum = recentSessions.count;
                    
                    NSString *curentDateString = @"";
                    [changeDic setObject:curentDateString forKey:NETEASE_FIRST_CHATTIME];
                    [changeDic setObject:@"0" forKey:NETEASE_TODAY_CHATNUM];
                    [changeDic setObject:[NSString stringWithFormat:@"%ld",todayWholeNum] forKey:NETEASE_TODAY_WHOLE];
                    [tempDataArr replaceObjectAtIndex:index withObject:changeDic];
                    [HNBUtils sandBoxSaveInfo:tempDataArr forKey:NETEASE_LIMITED_ARRAY];
                    NSLog(@"=====>24小时到了，重置 :%@",[HNBUtils sandBoxGetInfo:[NSMutableArray class] forKey:NETEASE_LIMITED_ARRAY]);
                }
            }
            break;
        }
        if (![tempID isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount] && index == limitedDataArr.count - 1) {
            break;
        }
    }
}

- (void)showConsultingButton{
    // 预约按钮
    [self.homePage addSubview:self.appointmentBtn];
    self.appointmentBtn.hidden = NO;
}

- (void)completeDataThenRefreshImAssessRemindViewWithCount:(NSString *)countString isAssessed:(BOOL)isAssessed{
    
    NSString *isOverSevenDayString = [HNBUtils sandBoxGetInfo:[NSString class] forKey:homepage_assessremindview_overexpire]; // 本地加强防护，避免一天弹出多次
    if ([isOverSevenDayString isEqualToString:@"1"]) {
        // 添加 fidfa 参数之后的回调
        self.imassessguide.imassessCountString = countString;
        self.imassessguide.hidden = NO;
        [self.view addSubview:self.imassessguide];
        [[self rdv_tabBarController] setTabBarHidden:TRUE animated:YES];
        [self judgeSearchBtnItem];
        // 统计代码
        NSDateFormatter *formtter = [[NSDateFormatter alloc] init];
        [formtter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *currentDate = [NSDate date];
        NSString *curentDateString = [formtter stringFromDate:currentDate];
        [HNBUtils sandBoxSaveInfo:curentDateString forKey:homepage_assessremindview_showdate];
        [HNBClick event:@"100066" Content:nil];
    }

    [self.loadingMask dismiss];

}

-(void)updateProjectStateNoticeThenReloadViewWithData:(ProjectStateModel *)data{

    if (data && [[data valueForKey:@"isShow"] isEqualToString:@"1"]) {
        [_homePage displayProjectStateNoticeWithData:data];
        [[self rdv_tabBarController] setTabBarHidden:TRUE animated:TRUE];
    }

}

#pragma mark ------ 首页点击

#pragma mark ------
#pragma mark ------
- (void)rightBarSearch:(UIButton *)btn{
    
    [HNBClick event:@"100002" Content:nil];
    HomeSerachViewController *vc = [[HomeSerachViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    
}

#pragma mark ------ 首页 选择

- (void)chooseHomeUI{
    
    // 判断展示哪种首页
    BOOL isImmigranted = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:IM_INTENTION_LOCAL] isEqualToString:IMED_STATED];
    BOOL isAssessed = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:USER_ASSESSED_IMMIGRANT] isEqualToString:@"1"];
    
    if (isImmigranted) {
        // 已移民
        _homePage.pageStyle = HNBHomePageV3MainViewStyleD;
        _homeStyle = @"D";
    }else{
        // 要移民
        
        if (isAssessed) {
            // 有评估记录
            if (![HNBUtils isLogin]) {
                // 未登录
                _homePage.pageStyle = HNBHomePageV3MainViewStyleA;
                _homeStyle = @"A";
            } else {
                // 已登录
                _homePage.pageStyle = HNBHomePageV3MainViewStyleB;
                _homeStyle = @"B";
            }
            
        }else{
            // 无评估记录
            _homePage.pageStyle = HNBHomePageV3MainViewStyleC;
            _homeStyle = @"C";
        }
        
        
    }
    /* A - C - Default 首页样式一样 */
//    NSString *txt = [NSString stringWithFormat:@"%@-%d-%d",_homeStyle,isImmigranted,isAssessed];
//
//    NSLog(@" choose :%@",txt);
    
    [_homePage refreshHomePageAllView];
    if (_homePage.pageStyle == HNBHomePageV3MainViewStyleB) {
        [_homePageManager homePageReqDataForPreferredPlans];
    }
    
}

#pragma mark ------ 首页 查看海外课堂详情
- (void)homePageV3OverSeaClassLink:(NSString *)link eventSource:(id)es{
    TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
    vc.URL = [NSURL URLWithString:link];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    NSDictionary *dict = @{@"url":link,
                           @"state":_homeStyle
                           };
    if (es != nil) {
        [HNBClick event:@"201052" Content:dict];
    }else{
        [HNBClick event:@"201051" Content:dict];
    }
    
}


 #pragma mark ------ 点击首页 项目进度通知立即查看

-(void)homePageV3ProjectStateNotice:(NSDictionary *)infoDic{
    //NSLog(@" %s ",__FUNCTION__);
    if (infoDic) {
        NSString *look = [infoDic valueForKey:@"lookLink"];
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [NSURL URLWithString:look];
        [self.navigationController pushViewController:vc animated:TRUE];
    }
    [[self rdv_tabBarController] setTabBarHidden:FALSE animated:YES];
    
}

#pragma mark ------ 引导页即V3.0的评估页

- (void)isShowIMGuideView{
    
    BOOL isUpdated = TRUE;
    BOOL isNewUser = TRUE;
    BOOL isAssessed = FALSE;
    BOOL isFinished = TRUE;
    BOOL isLoginedBefore = FALSE;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * curentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //默认已经完成引导页
    [HNBUtils sandBoxSaveInfo:@"1" forKey:IMGuide_Finished_Show];
    
    if ([HNBUtils sandBoxGetInfo:[NSString class] forKey:APP_VERSION] != nil) {
        // 新用户
        isNewUser = FALSE;
    }
    if ([[HNBUtils sandBoxGetInfo:[NSString class] forKey:APP_VERSION] isEqualToString: curentVersion]) {
        // 新升级
        isUpdated = FALSE;
    }
    if ([[HNBUtils sandBoxGetInfo:[NSString class] forKey:USER_ASSESSED_IMMIGRANT] isEqualToString:@"1"]) {
        // 已评估
        isAssessed = TRUE;
    }
    if ([[HNBUtils sandBoxGetInfo:[NSString class] forKey:IMGuide_hasBeen_Finished] isEqualToString:@"0"]) {
        // 没有完成题目
        isFinished = FALSE;
    }
    if ([[HNBUtils sandBoxGetInfo:[NSString class] forKey:IMGuide_hasBeen_Logined] isEqualToString:@"1"]) {
        // 此前已经登陆过
        isLoginedBefore = TRUE;
    }
    
    BOOL isJumpeIMGuide = FALSE;
    if ([[HNBUtils sandBoxGetInfo:[NSString class] forKey:IMGuide_Show_Switch] isEqualToString:@"1"]) {
        //引导页总开关
        isJumpeIMGuide = TRUE;
    }
    
    /**<是否进入引导页>*/
    if (!isJumpeIMGuide) {  //服务端控制是否跳过引导页
        BOOL isEnterGuideVC = isNewUser || (isUpdated && ![HNBUtils isLogin] && !isAssessed);
        if (isEnterGuideVC) {
            //NSLog(@"新用户 或 新升级且未登录且没有评估 ：%d - %d",isUpdated,isNewUser);
            [HNBUtils sandBoxSaveInfo:curentVersion forKey:APP_VERSION];
            GuideHomeViewController *vc = [[GuideHomeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:NO];
            
            [HNBUtils sandBoxSaveInfo:@"0" forKey:IMGuide_Finished_Show];
        }
        
        
        if (!isFinished && !isLoginedBefore) {
            //没有做完题目的进入引导页
            GuideHomeViewController *vc = [[GuideHomeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:NO];
            
            [HNBUtils sandBoxSaveInfo:@"0" forKey:IMGuide_Finished_Show];
        }
    }
    
}

#pragma mark ------ 用户打开次数

- (void)openAPPCountCaculate{
        
        int alertNum = 0;
        if ([HNBUtils sandBoxGetInfo:[NSString class] forKey:JUDGE_APP_NEXT] == nil) {
            //还没弹过框
            alertNum = FIRST_ALERT_NUM;
            
        }else {
            //弹框后判断数增大
            alertNum = CONTINUE_ALERT_NUM;
        }
        
        if ([HNBUtils sandBoxGetInfo:[NSString class] forKey:JUDGE_APP] == nil) {
            [HNBUtils sandBoxSaveInfo:@"1" forKey:JUDGE_APP];
        }else if ([[HNBUtils sandBoxGetInfo:[NSString class] forKey:JUDGE_APP] intValue] < alertNum && [[HNBUtils sandBoxGetInfo:[NSString class] forKey:JUDGE_APP] intValue] != 0) {
            [HNBUtils sandBoxSaveInfo:[NSString stringWithFormat:@"%d",[[HNBUtils sandBoxGetInfo:[NSString class] forKey:JUDGE_APP] intValue]+1] forKey:JUDGE_APP];
        }else if([[HNBUtils sandBoxGetInfo:[NSString class] forKey:JUDGE_APP] intValue] == alertNum) {
            JudgeAppView *judgeView = [[JudgeAppView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            judgeView.delegate = (id)self;
            [self.view addSubview:judgeView];
            [self.view bringSubviewToFront:judgeView]; // 显示在最前面
        }
    
}

#pragma mark JudgeAppViewDelegate

-(void)JudgeAppView:(JudgeAppView *)judgeAppView didClickButton:(UIButton *)btn {
    
    if (btn.tag == JudgeAppViewGoStoreButton) {
        [HNBUtils sandBoxSaveInfo:@"0" forKey:JUDGE_APP];
        [HNBUtils gotoAppStorePageRaisal];
    }else if (btn.tag == JudgeAppViewGoIdeaBackButton) {
        [HNBUtils sandBoxSaveInfo:@"0" forKey:JUDGE_APP];
        
        if (![HNBUtils isLogin]) {
            
            LoginViewController *vc = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
            IdeaBackNewViewController *ibVC = [[IdeaBackNewViewController alloc]init];
            NSArray *tmpvcs = [self.navigationController viewControllers];
            self.navigationController.viewControllers = [HNBUtils operateNavigationVCS:tmpvcs index:tmpvcs.count - 1 vc:ibVC];
        } else {
            IdeaBackNewViewController *vc = [[IdeaBackNewViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (btn.tag == JudgeAppViewCloseButton) {
        [HNBUtils sandBoxSaveInfo:@"1" forKey:JUDGE_APP];
        [HNBUtils sandBoxSaveInfo:@"1" forKey:JUDGE_APP_NEXT];
    }
    [judgeAppView removeFromSuperview];
    
}



#pragma mark AppointmentButtonDelegate

- (void)consultOnlineEvent:(AppointmentButton *)appointmentButton
{
//    NSString *str = [NSString stringWithFormat:@"https://eco-api.meiqia.com/dist/standalone.html?eid=1875"];
//    SWKConsultOnlineViewController *vc = [[SWKConsultOnlineViewController alloc]init];
//    vc.URL = [[NSURL alloc] withOutNilString:str];
//    [self.navigationController pushViewController:vc animated:YES];
    
    //7ab95cefc1046cabbdb4628399c56f9a 海房 / 905f2ee7e38205f6d55e1edc83eaf26b 移民
    NSString *groupId = @"7ab95cefc1046cabbdb4628399c56f9a";
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager setScheduledGroupId:groupId];
    [chatViewManager setScheduleLogicWithRule:MQChatScheduleRulesRedirectNone];
    [chatViewManager enableEvaluationButton:NO];
    MQChatViewStyle *aStyle = [chatViewManager chatViewStyle];
    [aStyle setNavBackButtonImage:[UIImage imageNamed:@"btn_fanhui"]];
    [aStyle setNavBarColor:[UIColor DDNavBarBlue]];
    [aStyle setNavTitleColor:[UIColor whiteColor]];
    [aStyle setEnableOutgoingAvatar:NO]; //不显示用户头像
    //[aStyle setEnableIncomingAvatar:NO]; //不显示客服头像
    [chatViewManager pushMQChatViewControllerInViewController:self];
    
}

- (void)consultPhoneEvent:(AppointmentButton *)appointmentButton
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",DEFAULT_TELNUM];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void)touchConsultEvent:(AppointmentButton *)appointmentButton
{
    //问答详情页快速咨询上报事件
    //[HNBClick event:@"109013" Content:nil];
}


#pragma mark HNBNetRemindViewDelegate

- (void)clickOnNetRemindView:(HNBNetRemindView *)remindView{
    
    [self.loadingMask loadingMaskWithSuperView:self.view loadingMaskType:LoadingMaskTypeExtendNavBarAndTabBar yoffset:0.f];
    switch (remindView.tag) {
        case HNBNetRemindViewShowPoorNet:
        {
            if ([HNBUtils isConnectionAvailable]) {
                [remindView removeFromSuperview];
                [_homePageManager homePageReqDataForLatestDataUpScreen];
            }else{
                [self.loadingMask dismiss];
            }
        }
            break;
        case HNBNetRemindViewShowFailNetReq:
        {
            [_homePageManager homePageReqDataForLatestDataUpScreen];
            [remindView removeFromSuperview];
        }
            break;
        case HNBNetRemindViewShowFailReleatedData:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)imAssessRemindView:(IMAssessRemindView *)imassessremindview didClickButton:(UIButton *)btn{
    
    [[self rdv_tabBarController] setTabBarHidden:FALSE animated:YES];
    [self judgeSearchBtnItem];
    
    if (btn != nil && btn.tag == IMAssessRemindViewNextButton) {
        
        [HNBClick event:@"100064" Content:nil];
        
        //弹框进引导页只走web
        IMAssessViewController * vc = [[IMAssessViewController alloc] init]; // skiplow － web页
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if(btn.tag == IMAssessRemindViewCloseButton) {
        self.imassessguide = nil;
    }
    
}

#pragma mark ------ 懒加载
-(AppointmentButton *)appointmentBtn{
    
    if (_appointmentBtn == nil) {
        
        float scale = SCREEN_WIDTH/SCREEN_WIDTH_6;
        float btnWidth = 53.0f*scale;
        float btnHeight = 53.0f*scale;
        _appointmentBtn = [[AppointmentButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - btnWidth - 15*scale, SCREEN_HEIGHT - SCREEN_NAVHEIGHT - SCREEN_STATUSHEIGHT - btnHeight, btnWidth, btnHeight)];
        _appointmentBtn.delegate = (id)self;
        
    }
    return _appointmentBtn;
}

- (HNBLoadingMask *)loadingMask{
    if (!_loadingMask) {
        _loadingMask = [[HNBLoadingMask alloc] init];
        _loadingMask.backgroundColor = [UIColor greenColor];
    }
    return _loadingMask;
}

- (IMAssessRemindView *)imassessguide{
    
    if (_imassessguide == nil) {
        
        // 移民评估提醒
        _imassessguide = [[IMAssessRemindView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.imassessguide.hidden = YES;
        _imassessguide.delegate = self;
        
    }
    return _imassessguide;
}

#pragma mark ------ V3.0 版本之前迁移业务

#pragma mark 获取并存储idfa
- (void)getAndSaveIdfa
{
    //获取idfa
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *token = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_idfa];
    if(![token isEqualToString:adId])
    {
        [HNBUtils sandBoxSaveInfo:adId forKey:personal_idfa];
    }
}

- (void)newUserUploadData{
    
    
    
    //是否激活，激活为使用1分钟或者进来3次算一次激活，激活完成后需要上传用户信息
    if([HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_activate] == nil){
        _userChaJudgeTimer = [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(onMinTimerFunc) userInfo:nil repeats:NO];
    }
    
    if([[HNBUtils sandBoxGetInfo:[NSString class] forKey:JUDGE_APP] intValue] > 3 && [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_activate] == nil){
        
        [_userChaJudgeTimer invalidate];
        _userChaJudgeTimer = nil;
        
        [_homePageManager homePageUploadNewUserWithType:@"1"];
        [HNBUtils sandBoxSaveInfo:@"1" forKey:personal_activate];
    }
    
}

// 1分钟后则判断用户激活
- (void) onMinTimerFunc{

    [_homePageManager homePageUploadNewUserWithType:@"1"];
    [HNBUtils sandBoxSaveInfo:@"1" forKey:personal_activate];
}

- (void)userUpload{
    // 确保 用户第一次打开上报成功
    NSString *isSuc = [HNBUtils sandBoxGetInfo:[NSString class] forKey:RecordResultUploadingUserFlag];
    if (![isSuc isEqualToString:@"suc"]) {
        [_homePageManager homePageUploadNewUserWithType:@"0"];
        //NSLog(@" userUpload ");
    }
}


#pragma mark ------ private method

- (void)handleNetStatus{
    if (![HNBUtils isConnectionAvailable]) {
        [self poorNet];
    }else{

        [self.loadingMask loadingMaskWithSuperView:self.view loadingMaskType:LoadingMaskTypeExtendNavBarAndTabBar yoffset:0.f];
        [_homePageManager homePageReqDataForLatestDataUpScreen];
    }
    
    
}

- (void)poorNet{

    _showPoorNetView = [[HNBNetRemindView alloc] init];
    [_showPoorNetView loadWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)
                         superView:self.view
                          showType:HNBNetRemindViewShowPoorNet
                          delegate:self];
}

- (void)showMessageWhenReqNetError{
    
    // 网络请求全部失败且无帖子数据 蒙版网络失败
    _showFailNetReqView = [[HNBNetRemindView alloc] init];
    [_showFailNetReqView loadWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_TABHEIGHT)
                            superView:self.view
                             showType:HNBNetRemindViewShowFailNetReq
                             delegate:self];
    
}

- (void)showHudWithMessage{
    
    // hub网络失败
    [[HNBToast shareManager] toastWithOnView:nil msg:@"网络请求有误" afterDelay:1.0 style:HNBToastHudFailure];
    
}

#pragma mark ------ 搜索按钮

- (void)judgeSearchBtnItem{
    
    BOOL show = TRUE;
    if (_imassessguide) {
        if (!_imassessguide.hidden || self.loadingMask.isStatus || self.showPoorNetView.isStatus || self.showFailNetReqView.isStatus) {
            show = FALSE;
        }
    }else{
        if (self.loadingMask.isStatus || self.showPoorNetView.isStatus || self.showFailNetReqView.isStatus) {
            show = FALSE;
        }
    }
//    NSLog(@" self.imassessguide.hidden :%d",self.imassessguide.hidden);
//    NSLog(@" self.loadingMask.isStatus :%d",self.loadingMask.isStatus);
//    NSLog(@" self.showPoorNetView.isStatus :%d",self.showPoorNetView.isStatus);
//    NSLog(@" self.showFailNetReqView.isStatus :%d",self.showFailNetReqView.isStatus);
    [self displaySearchBtnItemWithStatus:show];
    
}


- (void)displaySearchBtnItemWithStatus:(BOOL)status{
    
    if (status) {
        
        //搜索按钮
        UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30.0 * SCREEN_WIDTHRATE_6, 30.0 * SCREEN_WIDTHRATE_6)];
        [searchButton setBackgroundImage:[UIImage imageNamed:@"index_search_button"]forState:UIControlStateNormal];
        [searchButton addTarget:self action:@selector(rightBarSearch:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightbarButton = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
        self.navigationItem.rightBarButtonItem = rightbarButton;
        //NSLog(@" 搜索显示 ");
        
    }else{
        
        self.navigationItem.rightBarButtonItem = nil;
        //NSLog(@" 搜索隐藏 ");
        
    }
    
}


#pragma mark ------ test

- (void)testHomeType{

    
    _homePage.pageStyle = HNBHomePageV3MainViewStyleA;
//    _homePage.pageStyle = HNBHomePageV3MainViewStyleB;
    
//    _homePage.pageStyle = HNBHomePageV3MainViewStyleC;
    
//    _homePage.pageStyle = HNBHomePageV3MainViewStyleDefault;
    
//    _homePage.pageStyle = HNBHomePageV3MainViewStyleD;
    
    NSString *msg = @"Default";
    if (_homePage.pageStyle == HNBHomePageV3MainViewStyleD) {
        msg = @"D";
    }else if (_homePage.pageStyle == HNBHomePageV3MainViewStyleB) {
        msg = @"B";
    }else if (_homePage.pageStyle == HNBHomePageV3MainViewStyleA){
        msg = @"A";
    }else if (_homePage.pageStyle == HNBHomePageV3MainViewStyleC){
        msg = @"C";
    }
    [[HNBToast shareManager] toastWithOnView:nil msg:[NSString stringWithFormat:@"HomePage- %@",msg] afterDelay:2.0 style:HNBToastHudOnlyText];
}

@end
