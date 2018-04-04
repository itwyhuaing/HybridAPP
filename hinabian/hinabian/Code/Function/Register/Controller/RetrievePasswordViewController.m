//
//  RetrievePWDController.m
//  hinabian
//
//  Created by 何松泽 on 16/9/5.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "RetrievePasswordViewController.h"
#import "RetrievePWDMainView.h"

#import "RDVTabBarController.h"
#import "LoginMainView.h"
#import "PersonalInfo.h"
#import "DataFetcher.h"
#import "HNBToast.h"

@interface RetrievePasswordViewController ()

@property (nonatomic ,strong) RetrievePWDMainView *mainView;
@property (nonatomic,strong) NSTimer *codeTimer;
@property (nonatomic) NSUInteger timeCount;
@property (nonatomic) NSUInteger codeCount;
@property (nonatomic,strong) NSString *userInfTel;

@end

@implementation RetrievePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"手机找回密码"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*判断用户是否绑定手机，若是获取手机号*/
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
    if (tmpPersonalInfoArry.count != 0) {
        UserInfo = tmpPersonalInfoArry[0];
        _userInfTel = UserInfo.mobile_num;
    }
    
    CGRect rect = CGRectZero;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT;
    rect.size.height -= SCREEN_NAVHEIGHT;
    _mainView = [[RetrievePWDMainView alloc] initWithFrame:rect withPhoneNum:_userInfTel];
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
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
    UIBarButtonItem *tmpItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = tmpItem;
    
}

- (void)handleClickEventButton:(UIButton *)btn{
    switch (btn.tag) {
        case RetrieveNextBtnTag:
            [self next];
            [HNBClick event:@"147012" Content:nil];
            break;
        case RetrieveConfirmBtnTag:
            [self getVcode];
            [HNBClick event:@"147011" Content:nil];
            break;
        case RetrieveCompleteBtnTag:
            [self completeChange];
            [HNBClick event:@"147013" Content:nil];
            break;
        default:
            break;
    }
}

-(void)getVcode
{
    if(![_mainView.phoneNumInput.text isEqualToString:@""])
    {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:DELAY_TIME style:HNBToastHudWaiting];
        /* 添加国家码 */
        [DataFetcher doForgetPWDSetpOne:_mainView.phoneNumInput.text
                    vcode_mobile_nation:_mainView.countryCode.text
                     withSucceedHandler:^(id JSON) {
                         
                         int errCode = [[JSON valueForKey:@"state"] intValue];
                         NSLog(@"errCode = %d",errCode);
                         if (errCode == 0) {
                             NSLog(@" 手机验证码登录 获取 errCode == 0 ");
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
                             NSLog(@"success");
                         }else if (errCode == 110001){ // 可以直接重新获取验证码按钮
                             
                             [self invalidateCodeTimer];
                             
                         }
                         
                     } withFailHandler:^(id error) {
                         
                         NSLog(@"errCode = %@",error);
                         
                     }];
        
    }
    else
    {
        // 显示HUD
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请输入手机号" afterDelay:1.0 style:HNBToastHudFailure];
    }
}

-(void)next
{
    if(![_mainView.confirmCode.text isEqualToString:@""] && ![_mainView.phoneNumInput.text isEqualToString:@""])
    {
        [DataFetcher doForgetPWDSetpTwo:_mainView.confirmCode.text TEL:_mainView.phoneNumInput.text withSucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            NSLog(@"errCode = %d",errCode);
            if (errCode == 0) {
                [_mainView nextOperation];
            }
            
        } withFailHandler:^(NSError* error) {
            NSLog(@"errCode = %ld",(long)error.code);
        }];
    }
    else if ([_mainView.phoneNumInput.text isEqualToString:@""])
    {
        // 显示HUD
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请输入手机号" afterDelay:1.0 style:HNBToastHudFailure];
    }
    else if([_mainView.confirmCode.text isEqualToString:@""])
    {
        // 显示HUD
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请输入验证码" afterDelay:1.0 style:HNBToastHudFailure];
        
    }
}

- (void)completeChange
{
    if(![_mainView.pwdInput.text isEqualToString:@""] && ![_mainView.surePWDInput.text isEqualToString:@""])
    {
        if ([_mainView.pwdInput.text isEqualToString:_mainView.surePWDInput.text]) {
            [DataFetcher doForgetPWDSetpThree:_mainView.pwdInput.text Vcode:_mainView.confirmCode.text TEL:_mainView.phoneNumInput.text withSucceedHandler:^(id JSON) {
                int errCode = [[JSON valueForKey:@"state"] intValue];
                NSLog(@"errCode = %d",errCode);
                if (errCode == 0) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
                
            } withFailHandler:^(NSError* error) {
                NSLog(@"errCode = %ld",(long)error.code);
            }];
            
        }
        else
        {
            //显示HUD
            [[HNBToast shareManager] toastWithOnView:nil msg:@"两次密码输入不一致" afterDelay:1.0 style:HNBToastHudFailure];
        }
        
    }
    else
    {
        //显示HUD
        [[HNBToast shareManager] toastWithOnView:nil msg:@"密码为空" afterDelay:1.0 style:HNBToastHudFailure];
    }
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
