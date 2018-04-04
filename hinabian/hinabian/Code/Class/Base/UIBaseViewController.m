//
//  UIBaseViewController.m
//  hinabian
//
//  Created by 何松泽 on 2017/6/29.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "UIBaseViewController.h"
#import "RDVTabBarController.h"

@interface UIBaseViewController ()

@end

@implementation UIBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:[UIColor DDNavBarBlue]] forBarMetrics:UIBarMetricsDefault];
    
    //设置tint颜色值
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //设置导航栏字体大小
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:NAV_TITLE_FONT_SIZE],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //显示原生的NavigationBar
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //关闭透明度
    self.navigationController.navigationBar.translucent = NO;
    
    //隐藏底部TAB
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    //隐藏自带的返回按钮
    [self.navigationItem hidesBackButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

@end



