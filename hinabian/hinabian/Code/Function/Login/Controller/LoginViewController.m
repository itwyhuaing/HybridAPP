//
//  LoginViewController.m
//  hinabian
//
//  Created by 余坚 on 15/6/15.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "LoginViewController.h"
#import "RDVTabBarController.h"
#import "LoginMainView.h"
#import "SettingPWDController.h"
#import "UserAccountController.h"

#import "DataFetcher.h"
#import "RegisterViewController.h"
#import "RetrievePasswordViewController.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "ThirdPartCompleteUserInfoViewController.h"
#import "HNBToast.h"
//#import "PostingViewController.h"
#import "HNBRichTextPostingVC.h" // 新版富文本发帖
#import "IMQuestionViewController.h"
#import "SWKTransactViewController.h" //项目签约办理
#import "SWKVisaShowViewController.h" //签证立即办理
#import "IdeaBackNewViewController.h" //意见反馈
#import "GuideHomeViewController.h" //引导评估页
#import "HNBAFNetTool.h"
#import "RDVTabBarItem.h"
#import "GuideImassessViewController.h"
#import <TencentOpenAPI/QQApiInterface.h>

@interface LoginViewController ()<TencentSessionDelegate,WXApiDelegate>

@property (nonatomic,strong) LoginMainView *mainView;
@property (nonatomic,strong) NSTimer *codeTimer;
@property (nonatomic) NSUInteger timeCount;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, strong) NSArray *qqPermissions;

@end


@implementation LoginViewController

#pragma mark ------ life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect rect = CGRectZero;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT;
    rect.size.height -= SCREEN_NAVHEIGHT;
    _mainView = [[LoginMainView alloc] initWithFrame:rect];
    [self.view addSubview:_mainView];
    _timeCount = 0;
    
    __weak typeof(self)weakSelf = self;
    _mainView.vcblock = ^(id event){
        if ([event isKindOfClass:[UIButton class]]) {
            [weakSelf handleClickEventButton:(UIButton *)event];
        }
    };
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQKEY andDelegate:self];
//    self.tencentOAuth.redirectURI = @"http://www.hinabian.com";
    self.qqPermissions = [NSArray arrayWithObjects:@"get_user_info", @"add_share", nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //添加微信登录监听事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatLogin) name:WX_LOGIN_NOTIFICATION object:nil];
    //判断有无安装微信并且支持wxapi
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        _mainView.wechatLoginBtn.hidden = NO;
    }
    else {
        _mainView.wechatLoginBtn.hidden = YES;
    }
    //判断有无安装qq并且支持qqapi
    if ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]) {
        _mainView.qqLoginBtn.hidden = NO;
    }
    else {
        _mainView.qqLoginBtn.hidden = YES;
    }
    
    [self setUpNav];
    [[self rdv_tabBarController] setTabBarHidden:TRUE animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [MobClick beginLogPageView:@"Login"];
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    if (self.navigationItem.leftBarButtonItem == nil || self.navigationItem.rightBarButtonItem == nil) {
        [self setUpNav];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [MobClick endLogPageView:@"Login"];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //移除微信登录监听事件
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WX_LOGIN_NOTIFICATION object:nil];
}


#pragma mark ------ private method

- (void)setUpNav{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:NAV_TITLE_FONT_SIZE],
       NSForegroundColorAttributeName:[UIColor DDR51_G51_B51ColorWithalph:1.0]}];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 9, 16)];
    [backImage setImage:[UIImage imageNamed:@"login_nav_back"]];
    UIButton *backBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    [backBtn addTarget:self action:@selector(back_main) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backImage];
    [backView addSubview:backBtn];
    UIBarButtonItem *tmpItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:tmpItem, nil]];
    
    UIButton *registerBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 66)];
    registerBtn.backgroundColor = [UIColor clearColor];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:FONT_UI30PX]];
    [registerBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [registerBtn setTitleColor:[UIColor DDR63_G162_B255ColorWithalph:1.0] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(touchRegister) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:registerBtn];
    self.navigationItem.rightBarButtonItem = barButton;
    
    
}

#pragma mark clcik event

- (void)handleClickEventButton:(UIButton *)btn{
    
    switch (btn.tag) {
        case LoginConfirmBtnTag:
        {
            if (_mainView.phoneNumInput.text.length <= 0) {
                [[HNBToast shareManager] toastWithOnView:nil msg:@"请输入手机号" afterDelay:DELAY_TIME style:HNBToastHudFailure];
                return;
            }
            [HNBClick event:@"113012" Content:nil];
            // 获取验证码
            [DataFetcher doVcodeWithCountrycodeMobile:_mainView.phoneNumInput.text
                                           vcode_type:@"anyway"
                                  vcode_mobile_nation:_mainView.nationCode
                                   withSucceedHandler:^(id JSON) {
                                       
                                       //NSLog(@" JSON %@ ",JSON);
                                       
                                       int errCode= [[JSON valueForKey:@"state"] intValue];
                                       if(errCode == 0){
                                           
                                           //NSLog(@" 手机验证码登录 获取 errCode == 0 ");
                                           _timeCount = 60;
                                           [_mainView.confirmBtn setTitle:[NSString stringWithFormat:@"%lus后重试",(unsigned long)_timeCount] forState:UIControlStateDisabled];
                                           [_mainView.confirmBtn setEnabled:NO];
                                           _mainView.confirmBtn.layer.borderColor = [UIColor DDPlaceHoldGray].CGColor;
                                           [_mainView.confirmBtn setTitleColor:[UIColor DDPlaceHoldGray] forState:UIControlStateNormal];
                                           [[HNBToast shareManager] toastWithOnView:nil msg:@"验证码已发送,请查收" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
                                           
                                           _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                                         target:self
                                                                                       selector:@selector(timeCountDown:)
                                                                                       userInfo:nil
                                                                                        repeats:YES];
                                           
                                           
                                       }
                                       
                                   } withFailHandler:^(id error) {
                                       
                                   }];
            
            
            
        }
            break;
        case LoginBtnTag:
        {
            [HNBClick event:@"113021" Content:nil];
            if (![_mainView.phoneNumInput.text isEqual: @""] && ![_mainView.confirmCode.text isEqual: @""]) {
                
                NSString *loacal_im_state = [HNBUtils sandBoxGetInfo:[NSString class] forKey:IM_INTENTION_LOCAL];
                [DataFetcher doLoginWithVcode:_mainView.confirmCode.text
                                   mobile_num:_mainView.phoneNumInput.text
                                mobile_nation:_mainView.nationCode
                                     im_state:loacal_im_state
                           withSucceedHandler:^(id JSON) {
                               
                               int errCode = [[JSON valueForKey:@"state"] intValue];
                               if (errCode == 0) {
                                   [self afterLoginSuccess];
                                   [HNBUtils sandBoxSaveInfo:@"1" forKey:login_change_to_assess];
                                   NSDictionary *j = [JSON valueForKey:@"data"];
                                   int isNew= [[j valueForKey:@"isNew"] intValue];
                                   if (isNew) { // 新用户
                                       [self.navigationController pushViewController:[[SettingPWDController alloc] init] animated:YES];
                                   } else { // 老用户
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }
                                   
                                   //NSLog(@" 手机验证码登录  errCode == 0 新老用户问题 : %d",isNew);
                                   
                               }else if (errCode == 110001){ // 可以直接重新获取验证码按钮
                                   
                                   [self invalidateCodeTimer];
                                   
                               }
                               
                           } withFailHandler:^(id error) {
                               
                               
                               
                           }];
                
            }
            
            
        }
            break;
        case LoginUserBtnTag:
        {
            [HNBClick event:@"113022" Content:nil];
            [self.navigationController pushViewController:[[UserAccountController alloc] init] animated:YES];
        }
            break;
        case LoginQQbTtnTag:
        {
            [HNBClick event:@"113031" Content:nil];
            [self touchQQButton];
        }
            break;
        case LoginWeChatBtnTag:
        {
            [HNBClick event:@"113032" Content:nil];
            [self touchWeChatButton];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark -- QQ登录
- (void)touchQQButton
{
    [_tencentOAuth authorize:_qqPermissions inSafari:NO];
}

- (void)tencentDidLogin
{
    NSLog(@"登录完成");
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        [[NSUserDefaults standardUserDefaults] setObject:_tencentOAuth.accessToken  forKey:QQ_ACCESS_TOKEN];
        [[NSUserDefaults standardUserDefaults] setObject:_tencentOAuth.openId forKey:QQ_OPEN_ID];
        
        [self thirdLoginWithType:QQ_LOGIN_TYPE access_token:_tencentOAuth.accessToken Open_ID:_tencentOAuth.openId];
        
    }
    else
    {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"登录失败" afterDelay:1.0 style:HNBToastHudFailure];
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"取消登录" afterDelay:1.0 style:HNBToastHudFailure];
    }else{
        [[HNBToast shareManager] toastWithOnView:nil msg:@"登录失败" afterDelay:1.0 style:HNBToastHudFailure];
    }
}

- (void)tencentDidNotNetWork
{
    [[HNBToast shareManager] toastWithOnView:nil msg:@"无网络" afterDelay:1.0 style:HNBToastHudFailure];
}

#pragma mark -- 微信登录
- (void)touchWeChatButton
{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"App";
    [WXApi sendReq:req];
}

-(void)wechatLogin
{
    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN];
    NSString *open_id = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    if (access_token && access_token.length != 0 && open_id && open_id.length != 0) {
        
        [self thirdLoginWithType:WX_LOGIN_TYPE access_token:access_token Open_ID:open_id];

    }else{
        [[HNBToast shareManager] toastWithOnView:nil msg:@"登录失败" afterDelay:1.0 style:HNBToastHudFailure];
    }
}

- (void)thirdLoginWithType:(NSString *)type access_token:(NSString *)access_token Open_ID:(NSString *)open_id {
    
//    [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:0.f style:HNBToastHudWaiting];
    // 记录登录用户的OpenID、Token以及过期时间
    //NSLog(@"Token:%@\n,ID:%@\n",access_token,open_id);
    NSString *loacal_im_state = [HNBUtils sandBoxGetInfo:[NSString class] forKey:IM_INTENTION_LOCAL];
    [DataFetcher doLoginWithThirdPartWithType:type Access_Token:access_token Open_ID:open_id im_state:loacal_im_state withSucceedHandler:^(id JSON) {
        
        int state       = [[JSON valueForKey:@"state"] intValue];
        int errorCode   = [[JSON valueForKey:@"errorCode"] intValue];
        
        if (state == 0) {
            if (errorCode == 0) { //有账号、有手机号的正常登陆
                [HNBUtils sandBoxSaveInfo:@"1" forKey:login_change_to_assess];
                [self afterLoginSuccess];
                [self.navigationController popViewControllerAnimated:YES];
            }else if(errorCode == 1) {
                /*
                 1、有账号没手机号
                 2、没账号、没手机号的
                 */
                ThirdPartCompleteUserInfoViewController * vc = [[ThirdPartCompleteUserInfoViewController alloc] init];
                vc.login_type = type;
                [vc isRegister:TRUE];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }withFailHandler:^(id error) {
        NSLog(@"error");
    }];
}

- (void)touchRegister{
    
    //    NSLog(@" %s ",__FUNCTION__);4
    //
    [HNBClick event:@"113011" Content:nil];
    RegisterViewController * vc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)back_main{
    
    NSArray *tmpVCS = [self.navigationController viewControllers];
    NSMutableArray *vcs = [[NSMutableArray alloc] initWithArray:tmpVCS];
    //NSLog(@" 当前数组个数： ------ > %@",vcs);
    if (tmpVCS.count >= 2) {
        id vc = vcs[tmpVCS.count - 2]; // 倒数第二个
        if (![HNBUtils isLogin] && [vc isKindOfClass:[HNBRichTextPostingVC class]]) { // 依旧没有登录 - 发帖
            
            [vcs removeObject:vc];
            self.navigationController.viewControllers = vcs;
            
        }else if (![HNBUtils isLogin] && [vc isKindOfClass:[IMQuestionViewController class]]) { // 依旧没有登录 - 提问
            
            [vcs removeObject:vc];
            self.navigationController.viewControllers = vcs;
        }else if (![HNBUtils isLogin] && [vc isKindOfClass:[SWKTransactViewController class]]) { // 依旧没有登录 - 提问
            
            [vcs removeObject:vc];
            self.navigationController.viewControllers = vcs;
        }else if (![HNBUtils isLogin] && [vc isKindOfClass:[SWKVisaShowViewController class]]) { // 依旧没有登录 - 提问
            
            [vcs removeObject:vc];
            self.navigationController.viewControllers = vcs;
        }else if (![HNBUtils isLogin] && [vc isKindOfClass:[IdeaBackNewViewController class]]) { // 依旧没有登录 - 提问
            
            [vcs removeObject:vc];
            self.navigationController.viewControllers = vcs;
        }else if (![HNBUtils isLogin] && [vc isKindOfClass:[GuideImassessViewController class]]) { // 依旧没有登录 - 首页点击查看评估结果
            
            [vcs removeObject:vc];
            self.navigationController.viewControllers = vcs;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)afterLoginSuccess {
    NSArray *tmpVCS = [self.navigationController viewControllers];
    NSMutableArray *vcs = [[NSMutableArray alloc] initWithArray:tmpVCS];
    //NSLog(@" 当前数组个数： ------ > %@",vcs);
    if (tmpVCS.count >= 2) {
        id vc = vcs[tmpVCS.count - 2]; // 倒数第二个如果是引导页，将其移除
        if ([HNBUtils isLogin] && [vc isKindOfClass:[GuideHomeViewController class]]) {
            [vcs removeObject:vc];
            self.navigationController.viewControllers = vcs;
        }
        
    }
//    //本地有已移民国家城市数据上传服务器
//    if ([HNBUtils sandBoxGetInfo:[NSString class] forKey:IMED_Local_Nation] != nil && [HNBUtils sandBoxGetInfo:[NSString class] forKey:IMED_Local_City] != nil) {
//        [DataFetcher updateIMEDNationCityWithSucceedHandler:^(id JSON) {
//            
//        } withFailHandler:^(id error) {
//            
//        }];
//    }
    
    // 上传评估数据
    [HNBUtils uploadAssessRlt];

}

- (void)timeCountDown:(NSTimer *)timer{
    
    _timeCount --;
    
    if (_timeCount <= 0) {
        
        [self invalidateCodeTimer];
        
    } else {
        
        [_mainView.confirmBtn setTitle:[NSString stringWithFormat:@"%lus后重试",(unsigned long)_timeCount] forState:UIControlStateDisabled];
        [_mainView.confirmBtn setEnabled:NO];
        _mainView.confirmBtn.layer.borderColor = [UIColor DDPlaceHoldGray].CGColor; // 204 204 204
        [_mainView.confirmBtn setTitleColor:[UIColor DDPlaceHoldGray] forState:UIControlStateNormal];
    }
    
}

//停止倒计时
- (void)invalidateCodeTimer{
    
    [_codeTimer invalidate];
    _codeTimer = nil;
    [_mainView.confirmBtn setEnabled:YES];
    [_mainView.confirmBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
    _mainView.confirmBtn.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:1.0].CGColor;
    [_mainView.confirmBtn setTitleColor:[UIColor DDR63_G162_B255ColorWithalph:1.0] forState:UIControlStateNormal];
    
}

#pragma mark ------ life cycle



@end
