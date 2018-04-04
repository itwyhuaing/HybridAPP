//
//  UserAccountController.m
//  hinabian
//
//  Created by hnbwyh on 16/9/5.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "UserAccountController.h"
#import "RetrievePasswordViewController.h"
#import "RDVTabBarController.h"
#import "DataFetcher.h"
#import "PersonMainViewController.h"
#import "LoginViewController.h"
#import "RDVTabBarItem.h"
#import "GuideHomeViewController.h"

#define PWD_LENGTH_MIN 5

@interface UserAccountController ()

@end

@implementation UserAccountController


#pragma mark ------ life stytle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号登录";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self setUpNav];
    [[self rdv_tabBarController] setTabBarHidden:TRUE animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}


#pragma mark ------ private method

- (void)setUpNav{
    
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

- (void)setUpUI{
    
    [self.userAccountLabel setTextColor:[UIColor DDR50_G50_B50ColorWithalph:1.0]];
    [self.PWDLabel setTextColor:[UIColor DDR50_G50_B50ColorWithalph:1.0]];
    
//    [self.userAccountInput setTextColor:[UIColor DDR204_G204_B204ColorWithalph:1.0]];
//    [self.PWDLabelInput setTextColor:[UIColor DDR204_G204_B204ColorWithalph:1.0]];
    
    self.userAccountInput.keyboardType = UIKeyboardTypeASCIICapable;
    self.userAccountInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.PWDLabelInput.keyboardType = UIKeyboardTypeASCIICapable;
    self.PWDLabelInput.secureTextEntry = YES;
    self.PWDLabelInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.confirmButton.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0;
    [_confirmButton setEnabled:NO];
    _confirmButton.backgroundColor = [UIColor DDRegisterButtonEnable];
    self.confirmButton.tag = 100;
    [self.confirmButton addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.PWDButton setTitleColor:[UIColor DDR50_G50_B50ColorWithalph:1.0] forState:UIControlStateNormal];
    self.PWDButton.tag = 101;
    [self.PWDButton addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    // Observer 输入状态
    [_userAccountInput addTarget:self action:@selector(valuesChange:) forControlEvents:UIControlEventEditingChanged];
    [_PWDLabelInput addTarget:self action:@selector(valuesChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)back_main{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)clickEvent:(UIButton *)btn{

    //NSLog(@" %s ------ %ld",__FUNCTION__,btn.tag);
    
    if (btn.tag == 100) { // 账号登录
        [HNBClick event:@"146011" Content:nil];
        if (![self.userAccountInput.text isEqual: @""] && ![self.PWDLabelInput.text isEqual: @""]) {
            
            NSString *loacal_im_state = [HNBUtils sandBoxGetInfo:[NSString class] forKey:IM_INTENTION_LOCAL];
            [DataFetcher doLogin:self.userAccountInput.text password:self.PWDLabelInput.text im_state:loacal_im_state withSucceedHandler:^(id JSON) {
                int errCode = [[JSON valueForKey:@"state"] intValue];
                NSLog(@"errCode = %d",errCode);
                
                if (errCode == 0) {
                    [HNBUtils sandBoxSaveInfo:@"1" forKey:login_change_to_assess];
                    [self afterLoginSuccess];
                }
                
                
            } withFailHandler:^(NSError* error) {
                NSLog(@"errCode = %ld",(long)error.code);
            }];
            
        }
        
        
    } else {
        
        [HNBClick event:@"146012" Content:nil];
        [self.navigationController pushViewController:[[RetrievePasswordViewController alloc] init]  animated:YES];
        
    }
    
}

- (void)afterLoginSuccess {
    NSArray *tmpVCS = [self.navigationController viewControllers];
    NSMutableArray *vcs = [[NSMutableArray alloc] initWithArray:tmpVCS];
    //NSLog(@" 当前数组个数： ------ > %@",vcs);
    if (tmpVCS.count >= 2) {
        id vcLogin = vcs[tmpVCS.count - 2]; // 倒数第二个
        if ([HNBUtils isLogin] && [vcLogin isKindOfClass:[LoginViewController class]]) {
            [vcs removeObject:vcLogin];
        }
        if (tmpVCS.count >= 3) {
            /*如果有引导页的话，要将引导页移除*/
            id vcOther = vcs[tmpVCS.count - 3]; // 倒数第三个
            if ([HNBUtils isLogin] && [vcOther isKindOfClass:[GuideHomeViewController class]]) {
                [vcs removeObject:vcOther];
            }
        }
        self.navigationController.viewControllers = vcs;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
//    if ([HNBUtils sandBoxGetInfo:[NSString class] forKey:IMED_Local_Nation] != nil && [HNBUtils sandBoxGetInfo:[NSString class] forKey:IMED_Local_City] != nil && ![[HNBUtils sandBoxGetInfo:[NSString class] forKey:IMED_Local_Nation] isEqualToString:@"0"]) {
//        [DataFetcher updateIMEDNationCityWithSucceedHandler:^(id JSON) {
//
//        } withFailHandler:^(id error) {
//
//        }];
//    }
    // 上传评估数据
    [HNBUtils uploadAssessRlt];
}

#pragma mark ------ Observer

- (void)valuesChange:(UITextField *)textField{
    
    if (_userAccountInput.text.length >= PWD_LENGTH_MIN  && _PWDLabelInput.text.length > 0) {
        
        [_confirmButton setEnabled:YES];
        _confirmButton.backgroundColor = [UIColor DDR63_G162_B255ColorWithalph:1.0];
        
    }else{
        
        [_confirmButton setEnabled:NO];
        _confirmButton.backgroundColor = [UIColor DDRegisterButtonEnable];
        
    }
    
}


#pragma mark ------

@end
