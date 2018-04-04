//
//  BindingPhoneViewController.m
//  hinabian
//
//  Created by 何松泽 on 16/9/6.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "ThirdPartCompleteUserInfoViewController.h"
#import "BindingMainView.h"
#import "BindingSuccessView.h"
#import "RDVTabBarController.h"
#import "DataFetcher.h"
#import "HNBToast.h"
#import "HNBClick.h"
#import "PersonMainViewController.h"
#import "PersonalInfo.h"
#import "LoginViewController.h"

@interface ThirdPartCompleteUserInfoViewController ()<UIAlertViewDelegate>
{
    NSString *phoneNum;
    UIButton *skipButton;
}

@property (nonatomic,strong) BindingMainView *mainView;
@property (nonatomic,strong) BindingSuccessView *successView;
@property (nonatomic,strong) NSTimer *codeTimer;
@property (nonatomic,assign) BOOL mIsRegister;
@property (nonatomic) NSUInteger timeCount;
@property (nonatomic) NSUInteger codeCount;

@end

@implementation ThirdPartCompleteUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect rect = CGRectZero;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT;
    rect.size.height -= SCREEN_NAVHEIGHT;
    
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
    if (tmpPersonalInfoArry.count != 0) {
        UserInfo = tmpPersonalInfoArry[0];
        phoneNum = UserInfo.mobile_num;
        
    }
    
    if (![phoneNum isEqualToString:@""] && phoneNum != nil) {
        _successView = [[BindingSuccessView alloc]initWithFrame:rect withPhoneNum:phoneNum];
        [self.view addSubview:_successView];
    }else{
        _mainView = [[BindingMainView alloc] initWithFrame:rect andFindPWD:_isFindPWD];
        [self.view addSubview:_mainView];
    }
    
    _timeCount = 0;
    _codeCount = 0;
    
    __weak typeof(self)weakSelf = self;
    _mainView.vcblock = ^(id event){
        if ([event isKindOfClass:[UIButton class]]) {
            [weakSelf handleClickEventButton:(UIButton *)event];
        }
    };
    
}

-(void) isRegister:(BOOL) isregister
{
    _mIsRegister = isregister;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"绑定手机";
    
    [self setUpNav];
    [[self rdv_tabBarController] setTabBarHidden:TRUE animated:YES];
    
    if (_mIsRegister) {
        //屏蔽右滑返回功能
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

-(void)setUpNav
{
    if (_mIsRegister) {
        [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont boldSystemFontOfSize:NAV_TITLE_FONT_SIZE],
           NSForegroundColorAttributeName:[UIColor blackColor]}];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 9, 16)];
        [backImage setImage:[UIImage imageNamed:@"login_nav_back"]];
        UIButton *backBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
        [backBtn addTarget:self action:@selector(back_main) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:backImage];
        [backView addSubview:backBtn];
        UIBarButtonItem *tmpItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:tmpItem, nil]];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:[UIColor DDNavBarBlue]] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont boldSystemFontOfSize:NAV_TITLE_FONT_SIZE],
           NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
        temporaryBarButtonItem.target = self;
        temporaryBarButtonItem.action = @selector(back_main);
        self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    }
//    if (_mIsRegister) {
//        skipButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
//        skipButton.backgroundColor = [UIColor clearColor];
//        [skipButton setTitle:@"跳过" forState:UIControlStateNormal];
//        [skipButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//        [skipButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [skipButton addTarget:self action:@selector(touchPass) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:skipButton];
//        self.navigationItem.rightBarButtonItem = barButton;
//    }
    [self.navigationController.navigationBar setShadowImage:nil];
    
}

- (void)handleClickEventButton:(UIButton *)btn{
    switch (btn.tag) {
        case BindingConfirmBtnTag:
            [self touchVcodeButton];
            [HNBClick event:@"148011" Content:nil];
            break;
        case BindingCompleteBtnTag:
            [self complete];
            [HNBClick event:@"148012" Content:nil];
            break;
        default:
            break;
    }
}

- (void)touchVcodeButton
{
    if ([_mainView.phoneNumInput.text isEqualToString:@""]) {
        // 显示HUD
        [[HNBToast shareManager] toastWithOnView:nil msg:@"手机号不能为空" afterDelay:1.0 style:HNBToastHudFailure];
    }
    else
    {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:DELAY_TIME style:HNBToastHudWaiting];
        /* 校验手机号 */
        if (_mIsRegister)
        {
            NSLog(@"is register");
            [DataFetcher doVcodeWithCountrycodeMobile:_mainView.phoneNumInput.text
                                           vcode_type:@"anyway"
                                  vcode_mobile_nation:_mainView.countryCode.text
                                   withSucceedHandler:^(id JSON) {
                                       
                                       int errCode = [[JSON valueForKey:@"state"] intValue];
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
                                       }
                                   } withFailHandler:^(id error) {
                                       NSLog(@"errCode = %@",error);
                                   }];
        }
        else{
            [DataFetcher doVcodeWithCountrycodeMobile:_mainView.phoneNumInput.text
                                           vcode_type:@"need_new"
                                  vcode_mobile_nation:_mainView.countryCode.text
                                   withSucceedHandler:^(id JSON) {
                                       int errCode = [[JSON valueForKey:@"state"] intValue];
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
    }
    
}

-(void)complete
{
    if (![_mainView.phoneNumInput.text isEqual: @""] && ![_mainView.countryCode.text isEqual: @""] )
    {
        if (_mIsRegister)
        {
//            NSString *access_token;
//            NSString *open_id;
//            if ([_login_type isEqualToString:WX_LOGIN_TYPE]) {
//                access_token = [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN];
//                open_id = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
//            }else if ([_login_type isEqualToString:QQ_LOGIN_TYPE]) {
//                access_token = [[NSUserDefaults standardUserDefaults] objectForKey:QQ_ACCESS_TOKEN];
//                open_id = [[NSUserDefaults standardUserDefaults] objectForKey:QQ_OPEN_ID];
//            }
            [DataFetcher requestPhoneNumIsBindWithType:_login_type TEL:_mainView.phoneNumInput.text mobile_nation:_mainView.countryCode.text withSucceedHandler:^(id JSON) {
                int state = [[JSON valueForKey:@"state"] intValue];
                int errorCode = [[JSON valueForKey:@"errorCode"] intValue];
                if (state == 0) {
                    if (errorCode == 0) {
                        [self bindPhoneNum];
                    }
                    /*已有绑定手机号*/
                    else if (errorCode == 1) {
                        UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:nil message:[JSON valueForKey:@"data"]  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定绑定", nil];
                        [alterview show];
                    }
                    
                }
            } withFailHandler:^(id error) {
                NSLog(@"errCode = %@",error);
            }];
            
            
//            [DataFetcher doCombineTElForRegister:_mainView.confirmCode.text
//                                             TEL:_mainView.phoneNumInput.text
//                             vcode_mobile_nation:_mainView.countryCode.text
//                              withSucceedHandler:^(id JSON) {
//                                  int errCode = [[JSON valueForKey:@"state"] intValue];
//                                  NSLog(@"errCode = %d",errCode);
//                                  if (errCode == 0) {
////                                      [_mainView nextOperation:_mainView.phoneNumInput.text];
////                                      [skipButton setTitle:@"完成" forState:UIControlStateNormal];
//                                      [self touchPass];
//                                  }
//                              } withFailHandler:^(id error) {
//                                  NSLog(@"errCode = %@",error);
//                              }];
            
        }
        else{
            
            [DataFetcher doCombineTEl:_mainView.confirmCode.text
                                  TEL:_mainView.phoneNumInput.text
                  vcode_mobile_nation:_mainView.countryCode.text
                   withSucceedHandler:^(id JSON) {
                       int errCode = [[JSON valueForKey:@"state"] intValue];
                       NSLog(@"errCode = %d",errCode);
                       if (errCode == 0) {
                           [_mainView nextOperation:_mainView.phoneNumInput.text];
                       }
                   } withFailHandler:^(id error) {
                       NSLog(@"errCode = %@",error);
                   }];
        }
        
    }

}

- (void)bindPhoneNum {
    
    NSString *loacal_im_state = [HNBUtils sandBoxGetInfo:[NSString class] forKey:IM_INTENTION_LOCAL];
    [DataFetcher doBindPhoneWithThirdPartType:_login_type vCode:_mainView.confirmCode.text TEL:_mainView.phoneNumInput.text vcode_mobile_nation:_mainView.countryCode.text im_state:loacal_im_state withSucceedHandler:^(id JSON) {
        int errCode = [[JSON valueForKey:@"state"] intValue];
        if (errCode == 0) {
            [self touchPass];
        }
    } withFailHandler:^(id error) {
        NSLog(@"errCode = %@",error);
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self bindPhoneNum];
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

- (void) touchPass
{
    //开启右滑返回功能
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    NSArray *vcArr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:vcArr];
    for (NSInteger i = vcArr.count - 2; i>0; i--) {
        /*除去栈内的注册、登录VC*/
        UIViewController *tempVC = vcArr[i];
        if ([tempVC isKindOfClass:[LoginViewController class]]) {
            [tmpArr removeObject:tempVC];
            self.navigationController.viewControllers = tmpArr;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)back_main
{
//    if (_mIsRegister) {
//        [self touchPass];
//    }else{
        [self.navigationController popViewControllerAnimated:YES];
//    }
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
