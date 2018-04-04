//
//  HomeSerachViewController.m
//  hinabian
//
//  Created by 余坚 on 16/5/31.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "HomeSerachViewController.h"
#import "RDVTabBarController.h"
//#import "HomeSearchMainView.h"
#import "SWKHomeSearchMainView.h"

@interface HomeSerachViewController ()<UISearchBarDelegate>
@property (strong, nonatomic) SWKHomeSearchMainView *mainview;
@end

@implementation HomeSerachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _mainview = [[HomeSearchMainView alloc] initWithFrame:self.view.frame];
    _mainview = [[SWKHomeSearchMainView alloc] initWithFrame:self.view.frame];
    _mainview.searchManager.superController = self;
    _mainview.superController = self;
    self.view = _mainview;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置导航栏颜色
//    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:[UIColor DDNavBarBlue]] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:NAV_TITLE_FONT_SIZE],
//       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //隐藏原生的NavigationBar
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_STATUSHEIGHT)];
    statusBarView.backgroundColor=[UIColor DDNavBarBlue];
    [self.view addSubview:statusBarView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    searchButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [searchButton setTitle:@"取消" forState:UIControlStateNormal];
    //[searchButton setBackgroundColor:[UIColor redColor]];
    [searchButton setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = barButton;
  
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
