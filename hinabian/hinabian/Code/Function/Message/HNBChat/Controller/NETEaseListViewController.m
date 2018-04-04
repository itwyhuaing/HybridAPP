//
//  NETEaseListViewController.m
//  hinabian
//
//  Created by 何松泽 on 2017/10/17.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "NETEaseListViewController.h"
#import "NETEaseViewController.h"
#import <NIMSDK/NIMSDK.h>
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "PersonalInfo.h"
#import "DataFetcher.h"
#import "LoginViewController.h"

#import "BubbleButtonView.h"
#import "HNBChatNotificationView.h"
#import "TribeDetailInfoViewController.h"
#import "RefreshControl.h"
#import "IMNotificationModel.h"

enum BubbleButtonViewTah {
    ChatBubbleTag = 0,
    NotificationBubbleTag = 1,
};

@interface NETEaseListViewController ()<NIMSDKConfigDelegate,BubbleButtonDelegate,HNBChatNotificationDelegate,RefreshControlDelegate>

@property (nonatomic, strong) PersonalInfo * UserInfo;

@property (nonatomic, strong) UIView *fakeView;

@property (nonatomic, strong) BubbleButtonView *chatBubbleBtn;
@property (nonatomic, strong) BubbleButtonView *notificationBubbleBtn;
@property (nonatomic, strong) HNBChatNotificationView *notificationView;
@property (nonatomic, strong) RefreshControl *refreshControl;

@property (nonatomic, assign) NSInteger currentNotificationCount;
@property (nonatomic, assign) NSInteger totalNotificationCount;

@end

@implementation NETEaseListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"消息";
    }
    return self;
}

- (id)init {
    
    if (self = [super init]) {
        [self setupNIMSDK];
    }
    return self;
}

- (void)setupNIMSDK
{
    //在注册 NIMSDK appKey 之前先进行配置信息的注册，如是否使用新路径,是否要忽略某些通知，是否需要多端同步未读数等
    [[NIMSDKConfig sharedConfig] setDelegate:self];
    [[NIMSDKConfig sharedConfig] setShouldSyncUnreadCount:YES];
    [[NIMSDKConfig sharedConfig] setMaxAutoLoginRetryTimes:10];
    [[NIMSDKConfig sharedConfig] setMaximumLogDays:7];
    [[NIMSDKConfig sharedConfig] setShouldCountTeamNotification:YES];
    
    
    //appkey 是应用的标识，不同应用之间的数据（用户、消息、群组等）是完全隔离的。
    //如需打网易云信 Demo 包，请勿修改 appkey ，开发自己的应用时，请替换为自己的 appkey 。
    //并请对应更换 Demo 代码中的获取好友列表、个人信息等网易云信 SDK 未提供的接口。
    NSString *appKey        = @"50a3d1b02c15dd7ded198b843e8c094b";
    NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:appKey];
    option.apnsCername      = @"hnbDev";
    option.pkCername        = @"hnbDevPushKit";
//    option.apnsCername      = @"hnbProductTrue";
//    option.pkCername        = @"hnbProduct";
    [[NIMSDK sharedSDK] registerWithOption:option];
    
    //注册 NIMKit 自定义排版配置
    [[NIMKit sharedKit] registerLayoutConfig:[NIMCellLayoutConfig new]];
}

- (void)loginNetEase{
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    if (tmpPersonalInfoArry.count != 0) {
        self.UserInfo = tmpPersonalInfoArry[0];
        NSString *loginAccount = self.UserInfo.netease_im_id;
        NSString *loginToken = self.UserInfo.netease_im_token;
        
        //NIM SDK 只提供消息通道，并不依赖用户业务逻辑，开发者需要为每个APP用户指定一个NIM帐号，NIM只负责验证NIM的帐号即可(在服务器端集成)
        //用户APP的帐号体系和 NIM SDK 并没有直接关系
        //DEMO中使用 username 作为 NIM 的account ，md5(password) 作为 token
        //开发者需要根据自己的实际情况配置自身用户系统和 NIM 用户系统的关系
        [[[NIMSDK sharedSDK] loginManager] login:loginAccount
                                           token:loginToken
                                      completion:^(NSError *error) {
                                          if (error == nil)
                                          {
                                              self.recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
                                              [self refresh];
                                          }
                                      }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";
    self.currentNotificationCount   = 0;
    self.totalNotificationCount     = 0;
    
    self.chatBubbleBtn = [[BubbleButtonView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 50, 5, 40, 40)];
    self.chatBubbleBtn.delegate = (id)self;
    [self.navigationController.navigationBar addSubview:_chatBubbleBtn];
    [_chatBubbleBtn setBubbleFont:[UIFont systemFontOfSize:FONT_UI40PX]];
    [_chatBubbleBtn setBubbleButtonTitle:@"聊天" state:UIControlStateNormal];
    [_chatBubbleBtn setChoosen:YES];
    [_chatBubbleBtn setTag:ChatBubbleTag];
    [_chatBubbleBtn moveBadgeWithX:2 Y:6];
    [_chatBubbleBtn setBubbleBadgeWithNumber:0];
    
    self.notificationBubbleBtn = [[BubbleButtonView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 10, 5, 40, 40)];
    [self.navigationController.navigationBar addSubview:_notificationBubbleBtn];
    self.notificationBubbleBtn.delegate = (id)self;
    [_notificationBubbleBtn setBubbleFont:[UIFont systemFontOfSize:FONT_UI40PX]];
    [_notificationBubbleBtn setBubbleButtonTitle:@"通知" state:UIControlStateNormal];
    [_notificationBubbleBtn setChoosen:NO];
    [_notificationBubbleBtn setBubbleTag:NotificationBubbleTag];
    [_notificationBubbleBtn moveBadgeWithX:2 Y:6];
    [_notificationBubbleBtn setBubbleBadgeWithNumber:0];
    
    /*通知页*/
    self.notificationView = [[HNBChatNotificationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_STATUSHEIGHT - SCREEN_NAVHEIGHT - SCREEN_TABHEIGHT)];
    _notificationView.delegate = (id)self;
    _notificationView.hidden = YES;
    [self.view addSubview:_notificationView];
    
    // 导航栏是否透明设置刷新控件的顶部偏移
    _refreshControl=[[RefreshControl alloc] initWithScrollView:_notificationView.tableView delegate:self];
    _refreshControl.bottomEnabled=YES;
    _refreshControl.topEnabled=YES;

    [self getNotificationDataWithHasRead:NO];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.chatBubbleBtn.hidden = NO;
    self.notificationBubbleBtn.hidden = NO;
    
    //设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:[UIColor DDNavBarBlue]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:NAV_TITLE_FONT_SIZE],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    if (![HNBUtils isLogin]) {
        self.fakeView.hidden = NO;
    }else{
        self.fakeView.hidden = YES;
        if (![[NIMSDK sharedSDK].loginManager isLogined]) {
            NSString *userID = [NIMSDK sharedSDK].loginManager.currentAccount;
            if (!userID || [userID isEqualToString:@""]) {
                [self loginNetEase];
            }else{
                self.recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
                [self refresh];
            }
        }else {
            self.recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
            [self refresh];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.chatBubbleBtn.hidden = YES;
    self.notificationBubbleBtn.hidden = YES;
}

#pragma mark -- HNBChatNotificationDelegate 查看通知详情
- (void)lookTribe:(NSString *)url
{
    TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
    vc.URL = [NSURL URLWithString:url];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- BubbleButtonViewDelegate 点击导航栏上部分的按钮
- (void)clickBubbleButton:(id)sender
{
    UIButton *segmentBtn = sender;
    if (segmentBtn.tag == ChatBubbleTag) {
        //统计上报
        [HNBClick event:@"202011" Content:nil];
        [_chatBubbleBtn setChoosen:YES];
        [_notificationBubbleBtn setChoosen:NO];
        
        self.tableView.hidden = NO;
        self.notificationView.hidden = YES;
    }else if (segmentBtn.tag == NotificationBubbleTag) {
        //统计上报
        [HNBClick event:@"202012" Content:nil];
        
        [_chatBubbleBtn setChoosen:NO];
        [_notificationBubbleBtn setChoosen:YES];
        
        if ([self.notificationBubbleBtn.bubble_value integerValue] > 0) {
            //有新消息再获取消息，否则不获取
            self.notificationView.tableView.hidden = NO;
            [self getNotificationDataWithHasRead:YES];
        }
        
        //点击后全部设为0
        [[self rdv_tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%ld",(long)[NIMSDK sharedSDK].conversationManager.allUnreadCount]];
        [self.notificationBubbleBtn setBubbleBadgeWithNumber:0];
        
        self.tableView.hidden = YES;
        self.notificationView.hidden = NO;
    }
}

- (void)refresh{
    [super refresh];
    
    [DataFetcher doGetAllNotices:^(id JSON) {
        int errCode = [[JSON valueForKey:@"state"] intValue];
        if (errCode == 0) {
            id jsonmain = [JSON valueForKey:@"data"];
            NSNumber *f_unread_num = [jsonmain valueForKey:@"f_unread_num"];
            NSInteger newNotificationNum = [f_unread_num integerValue];
            NSInteger tempMessageCount = [NIMSDK sharedSDK].conversationManager.allUnreadCount;
            NSInteger tempCount = tempMessageCount + newNotificationNum;
            [[self rdv_tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%ld", tempCount]];
            [self.chatBubbleBtn setBubbleBadgeWithNumber:tempMessageCount];
            [self.notificationBubbleBtn setBubbleBadgeWithNumber:newNotificationNum];
        }else {
            [[self rdv_tabBarItem] setBadgeValue:[NSString stringWithFormat:@"0"]];
            [self.notificationBubbleBtn setBubbleBadgeWithNumber:0];
        }
    } withFailHandler:^(id error) {
        
    }];
}

- (void)getNotificationDataWithHasRead:(BOOL)hasRead {
    _currentNotificationCount = 0;
    __block NSInteger getDataNum = 10;          //一次获取消息数，默认10条
    __block NSInteger newNotificationNum = 0;   //新的消息数
    dispatch_group_t loadGroup = dispatch_group_create();
    dispatch_queue_t loadQueue = dispatch_queue_create("NETEaseListRefreshData", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_enter(loadGroup);
    [DataFetcher doGetAllNotices:^(id JSON) {
        int errCode = [[JSON valueForKey:@"state"] intValue];
        if (errCode == 0) {
            id jsonmain = [JSON valueForKey:@"data"];
            NSNumber *f_unread_num = [jsonmain valueForKey:@"f_unread_num"];
            newNotificationNum = [f_unread_num integerValue];
//            NSInteger tempMessageCount = [NIMSDK sharedSDK].conversationManager.allUnreadCount;
//            NSInteger tempCount = tempMessageCount + newNotificationNum;
//            [[self rdv_tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%ld", tempCount]];
//            [self.chatBubbleBtn setBubbleBadgeWithNumber:tempMessageCount];
//            [self.notificationBubbleBtn setBubbleBadgeWithNumber:newNotificationNum];
        }else {
            [[self rdv_tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%ld",[NIMSDK sharedSDK].conversationManager.allUnreadCount]];
            [self.notificationBubbleBtn setBubbleBadgeWithNumber:0];
        }
        dispatch_group_leave(loadGroup);
    } withFailHandler:^(id error) {
        dispatch_group_leave(loadGroup);
    }];
    
    dispatch_group_notify(loadGroup, loadQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (newNotificationNum > 10) {
                //有新的通知消息
                getDataNum = newNotificationNum;
            }
            [DataFetcher doGetIMNotificationWithStart:@"0" num:[NSString stringWithFormat:@"%ld",getDataNum] WithSucceedHandler:^(id JSON) {
                NSArray *tempArr        = [JSON valueForKey:IMNotification_Datas];
                /**
                 * 后台传的新消息数不可靠，只能靠自己计算
                 */
                newNotificationNum = 0;
                for (IMNotificationModel *model in tempArr) {
                    if ([model.f_is_read isEqualToString:@"2"]) {
                        newNotificationNum ++;
                    }
                }
                _totalNotificationCount = [[JSON valueForKey:IMNotification_Total] integerValue];
                _currentNotificationCount = tempArr.count;
                [_notificationView getData:tempArr andNewsNum:[NSString stringWithFormat:@"%ld",newNotificationNum]];
                if (_currentNotificationCount >= _totalNotificationCount) {
                    _refreshControl.bottomEnabled = NO;
                }else {
                    _refreshControl.bottomEnabled = YES;
                }
                if (hasRead) {
                    [self setNotificationHasRead];
                }
            } withFailHandler:^(id error) {
                
            }];
        });
    });
}

- (void)setNotificationHasRead {
    //取到最新通知再设置为已读
    [DataFetcher doSetIMNotificationHasReadWithSucceedHandler:^(id JSON) {
        NSLog(@"消息已读");
    } withFailHandler:^(id error) {
        
    }];
}

- (void)loadNotificationData {
    NSString *pageNum = @"10";
    [DataFetcher doGetIMNotificationWithStart:[NSString stringWithFormat:@"%ld",_currentNotificationCount] num:pageNum WithSucceedHandler:^(id JSON) {
        NSArray *tempArr        =   [JSON valueForKey:IMNotification_Datas];
//        _totalNotificationCount =   [[JSON valueForKey:IMNotification_Total] integerValue];
        [_notificationView loadData:tempArr];
        _currentNotificationCount += tempArr.count;
        if ([pageNum integerValue] > tempArr.count) {
            _refreshControl.bottomEnabled = NO;
        }
    } withFailHandler:^(id error) {
        
    }];
}

#pragma mark ------ RefreshControlDelegate

-(void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{
    if (direction == RefreshDirectionBottom && _currentNotificationCount < _totalNotificationCount) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadNotificationData];
            [refreshControl finishRefreshingDirection:direction isEmpty:YES];
        });
    }else if(direction == RefreshDirectionTop){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getNotificationDataWithHasRead:YES];
            [refreshControl finishRefreshingDirection:direction isEmpty:YES];
        });
    }
    
}

#pragma mark - 点击最近的会话框
- (void)onSelectedRecent:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
    NETEaseViewController *vc = [[NETEaseViewController alloc] initWithSession:recent.session];
    vc.isAllow_Chat = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 最近会话框的title
- (NSString *)nameForRecentSession:(NIMRecentSession *)recent{
    
    NIMUser *otherUser = [[NIMSDK sharedSDK].userManager userInfo:recent.session.sessionId];
    NSDictionary *otherEXTDic = [HNBUtils dictionaryWithJsonString:otherUser.userInfo.ext];
    NSString *subTitle = otherEXTDic[@"title"];
    if ([recent.session.sessionId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
        return @"我的电脑";
    }else if ([otherEXTDic[@"type"] integerValue] == SpecialistIDType && subTitle && ![subTitle isEqualToString:@""] ) {
        //专家显示头衔
        NSString *specialistTitle = [NSString stringWithFormat:@"(%@)",otherEXTDic[@"title"]];
        return [[super nameForRecentSession:recent] stringByAppendingString:specialistTitle];
    }
    return [super nameForRecentSession:recent];
}

- (void)jumpIntoLoginViewController {
    [HNBClick event:@"202003" Content:nil];
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onLogin:(NIMLoginStep)step{
    [super onLogin:step];
    switch (step) {
        case NIMLoginStepLinkFailed:
//            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(未连接)"];
            break;
        case NIMLoginStepLinking:
//            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(连接中)"];
            break;
        case NIMLoginStepLinkOK:
        case NIMLoginStepSyncOK:
//            self.titleLabel.text = SessionListTitle;
            break;
        case NIMLoginStepSyncing:
//            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(同步数据)"];
            break;
        default:
            break;
    }
    [self.view setNeedsLayout];
}

#pragma mark - Lazy Load

- (UIView *)fakeView {
    if (!_fakeView) {
        CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
        CGRect rectNav = self.navigationController.navigationBar.frame;
        
        CGRect rect = CGRectZero;
        rect.size.width = SCREEN_WIDTH;
        rect.size.height = SCREEN_HEIGHT;
        rect.size.height -= rectNav.size.height + SCREEN_TABHEIGHT + rectStatus.size.height;
        _fakeView = [[UIView alloc] initWithFrame:rect];
        [_fakeView setBackgroundColor:[UIColor orangeColor]];
        [self.view addSubview:_fakeView];
        
        
        UIImageView *fakeImageView = [[UIImageView alloc] initWithFrame:rect];
        if (IS_IPHONE_X) {
            fakeImageView.image = [UIImage imageNamed:@"IMEaseNoLoginBackGround-X"];
        }else {
            fakeImageView.image = [UIImage imageNamed:@"IMEaseNoLoginBackGround"];
        }
        [_fakeView addSubview:fakeImageView];
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setBackgroundColor:[UIColor clearColor]];
        [loginButton addTarget:self action:@selector(jumpIntoLoginViewController) forControlEvents:UIControlEventTouchUpInside];
        [loginButton setTitle:@"" forState:UIControlStateNormal];
        [_fakeView addSubview:loginButton];
        loginButton.sd_layout
        .centerXEqualToView(_fakeView)
        .bottomSpaceToView(_fakeView, 25)
        .widthIs(SCREEN_WIDTH - 40)
        .heightIs(60);
    }
    return _fakeView;
}

@end
