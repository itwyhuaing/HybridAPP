//
//  RegisterViewController.m
//  hinabian
//
//  Created by 何松泽 on 16/9/7.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterMainView.h"
#import "RDVTabBarController.h"
#import "CompleteUserInfoNewController.h"
#import "DataFetcher.h"
#import "HNBToast.h"

@interface RegisterViewController ()

@property (nonatomic ,strong) RegisterMainView *mainView;
@property (nonatomic,strong) NSTimer *codeTimer;
@property (nonatomic) NSUInteger timeCount;
@property (nonatomic) NSUInteger codeCount;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"手机注册"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect rect = CGRectZero;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT;
    rect.size.height -= SCREEN_NAVHEIGHT;
    _mainView = [[RegisterMainView alloc] initWithFrame:rect];
    [self.view addSubview:_mainView];
    
    _timeCount = 0;
    _codeCount = 0;
    
    __weak typeof(self)weakSelf = self;
    _mainView.vcblock = ^(id event){
        if ([event isKindOfClass:[UIButton class]]) {
            [weakSelf handleClickEventButton:(UIButton *)event];
        }
    };
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUpNav];
    [[self rdv_tabBarController] setTabBarHidden:TRUE animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [MobClick beginLogPageView:@"Register"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //显示tabbar
    [[self rdv_tabBarController] setTabBarHidden:FALSE animated:YES];
    
    [MobClick endLogPageView:@"Register"];
}

-(void)setUpNav
{
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:NAV_TITLE_FONT_SIZE],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    UIButton *backBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 9, 16)];
    [backBtn addTarget:self action:@selector(back_main) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"login_nav_back"] forState:UIControlStateNormal];
    UIBarButtonItem *tmpLeftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = tmpLeftItem;
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 66)];
    [loginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:FONT_UI30PX]];
    [loginBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [loginBtn setTitleColor:[UIColor DDR63_G162_B255ColorWithalph:1.0] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(back_main) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *tmpRightItem = [[UIBarButtonItem alloc] initWithCustomView:loginBtn];
    self.navigationItem.rightBarButtonItem = tmpRightItem;
}

- (void)handleClickEventButton:(UIButton *)btn{
    switch (btn.tag) {
        case RegisterConfirmBtnTag:
            [self getVcode];
            break;
        case RegisterBtnTag:
            [self completeRegister];
            break;
        case RegisterAgreeBtnTag:
            [self toAgreement];
            break;
        default:
            break;
    }
}

//顶层与次层的交换
- (void)exChangeTopAndSecondViewController{
    NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
    [viewControllers exchangeObjectAtIndex:viewControllers.count-1 withObjectAtIndex:viewControllers.count-2];
    [self.navigationController setViewControllers:viewControllers.copy animated:YES];
}

-(void)getVcode
{
    if(![_mainView.phoneNumInput.text isEqualToString:@""])
    {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:DELAY_TIME style:HNBToastHudWaiting];
        
        [HNBClick event:@"114011" Content:nil];
        
        /* 加入国家码 校验手机号 */
        /*  */
        [DataFetcher doVcodeWithCountrycodeMobile:_mainView.phoneNumInput.text
                                       vcode_type:@"need_new"
                              vcode_mobile_nation:_mainView.countryCode.text
                               withSucceedHandler:^(id JSON) {
                                   
                                   int errCode = [[JSON valueForKey:@"state"] intValue];
                                   if (errCode == 0) {//如果是未注册的手机号
                                       _timeCount = 60;
                                       [_mainView.confirmBtn setTitle:[NSString stringWithFormat:@"%lus后重试",(unsigned long)_timeCount] forState:UIControlStateDisabled];
                                       [_mainView.confirmBtn setEnabled:NO];
                                       _mainView.confirmBtn.layer.borderColor = [UIColor DDPlaceHoldGray].CGColor; // 204 204 204
                                       [_mainView.confirmBtn setTitleColor:[UIColor DDPlaceHoldGray] forState:UIControlStateNormal];
                                       [[HNBToast shareManager] toastWithOnView:nil msg:@"验证码已发送,请查收" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
                                       _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                                     target:self
                                                                                   selector:@selector(timeCountDown:)
                                                                                   userInfo:nil
                                                                                    repeats:YES];
                                   }else if (errCode == 100000){//如果是已注册的手机号
                                       
                                   }else if (errCode == 110001){ // 可以直接重新获取验证码按钮
                                       
                                       [self invalidateCodeTimer];
                                       
                                   }
                                   NSLog(@"errCode = %d",errCode);
                                   
                               } withFailHandler:^(id error) {
                                   NSLog(@"errCode = %@",error);
                               }];
    }else{
        // 显示HUD
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请输入手机号" afterDelay:1.0 style:HNBToastHudFailure];
    }
}

- (void)completeRegister
{
    /*  */
    if (![_mainView.phoneNumInput.text isEqual: @""] && ![_mainView.confirmCode.text isEqual: @""] && ![_mainView.pwdInput.text isEqual: @""]) {
        
        [HNBClick event:@"114012" Content:nil];
        
        // 手机注册接口,添加国家码
        [DataFetcher doRegisterWithMobile:_mainView.phoneNumInput.text
                      vcode_mobile_nation:_mainView.countryCode.text
                               verifyCode:_mainView.confirmCode.text
                                 password:_mainView.pwdInput.text
                       withSucceedHandler:^(id JSON) {
                           int errCode = [[JSON valueForKey:@"state"] intValue];
                           NSLog(@"errCode = %d",errCode);
                           if (errCode == 0) {
                               CompleteUserInfoNewController *vc = [[CompleteUserInfoNewController alloc] init];
                               [self.navigationController pushViewController:vc animated:YES];
                           }
                       } withFailHandler:^(id error) {
                           
                           NSLog(@"errCode = %@",error);
                           
                       }];
        
    }
}

-(void)toAgreement
{
    SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
    vc.URL = [vc.webManger configNativeNavWithURLString:[NSString  stringWithFormat:@"https://m.hinabian.com/about/mianze.html"]
                                                   ctle:@"1"
                                             csharedBtn:@"0"
                                                   ctel:@"0"
                                              cfconsult:@"0"];
    [self.navigationController pushViewController:vc animated:YES];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back_main
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
