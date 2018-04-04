//
//  SettingPWDController.m
//  hinabian
//
//  Created by hnbwyh on 16/9/5.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "SettingPWDController.h"
#import "RDVTabBarController.h"
#import "DataFetcher.h"
#import "PersonalInfo.h"
#import "PersonMainViewController.h"
#import "LoginViewController.h"

#define PWD_LENGTH_MIN 5

@interface SettingPWDController ()

@end

@implementation SettingPWDController

#pragma mark ------ life stytle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置登录密码";
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
    
    [self.setPWDLabel setTextColor:[UIColor DDR50_G50_B50ColorWithalph:1.0]];
    [self.confirmPWDLabel setTextColor:[UIColor DDR50_G50_B50ColorWithalph:1.0]];
//    [self.PWDInput setTextColor:[UIColor DDR204_G204_B204ColorWithalph:1.0]];
//    [self.confirmPWDInput setTextColor:[UIColor DDR204_G204_B204ColorWithalph:1.0]];
    
    self.PWDInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.confirmPWDInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.PWDInput.keyboardType = UIKeyboardTypeASCIICapable;
    self.confirmPWDInput.keyboardType = UIKeyboardTypeASCIICapable;
    self.PWDInput.secureTextEntry = YES;
    self.confirmPWDInput.secureTextEntry = YES;
    
    self.confirmButton.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0;
    [self.confirmButton setEnabled:NO];
    self.confirmButton.backgroundColor = [UIColor DDRegisterButtonEnable];
    [self.confirmButton addTarget:self action:@selector(confirmClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    // Observer 输入状态
    [_PWDInput addTarget:self action:@selector(valuesChange:) forControlEvents:UIControlEventEditingChanged];
    [_confirmPWDInput addTarget:self action:@selector(valuesChange:) forControlEvents:UIControlEventEditingChanged];
}


- (void)back_main{
    
        if (SYSTEM_VERSION < 8.0) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"设置密码方便下次登录?"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"以后再说",@"继续设置", nil];
            [alertView show];
            
        } else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置密码方便下次登录?"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            [alert addAction:[UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //NSLog(@" 以后再说 ");
                [self popViewControllers];
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"继续设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //NSLog(@" 继续设置 ");
            }]];
            
        }
    
}

- (void)popViewControllers{

    NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    id vc = tmpArr[tmpArr.count - 2]; // 倒数第二个 LoginViewController 是否移除
    if ([vc isKindOfClass:[LoginViewController class]]) {
        [tmpArr removeObject:vc];
        self.navigationController.viewControllers = tmpArr;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)confirmClickEvent:(UIButton *)btn{

    //NSLog(@" %s ",__FUNCTION__);
    [HNBClick event:@"145011" Content:nil];
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
     if (tmpPersonalInfoArry.count != 0) {
        UserInfo = tmpPersonalInfoArry[0];
        [DataFetcher doChangePWD:UserInfo.id oldPWD:nil newPWD:self.PWDInput.text confirmPWD:self.confirmPWDInput.text withSucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            NSLog(@"errCode = %d",errCode);
            if (errCode == 0) {
                [self popViewControllers];
            }
        } withFailHandler:^(id error) {
            
        }];
    }
    
}


#pragma mark ------ Observer

- (void)valuesChange:(UITextField *)textField{

    if (_PWDInput.text.length >= PWD_LENGTH_MIN  && _confirmPWDInput.text.length > 0) {
        
        [_confirmButton setEnabled:YES];
        _confirmButton.backgroundColor = [UIColor DDR63_G162_B255ColorWithalph:1.0];
        
    }else{
    
        [_confirmButton setEnabled:NO];
        _confirmButton.backgroundColor = [UIColor DDRegisterButtonEnable];
        
    }
    
}

#pragma mark ------ UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    switch (buttonIndex) {
        case 0:
        { // 以后再说
            [self popViewControllers];
        }
            break;
        case 1:
        {
            // 继续设置
        }
            break;
            
        default:
            break;
    }
    
}


@end
