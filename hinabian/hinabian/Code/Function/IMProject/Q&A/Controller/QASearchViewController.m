//
//  QASearchViewController.m
//  hinabian
//  问答搜索页面
//  Created by 余坚 on 16/7/22.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "QASearchViewController.h"
#import "RDVTabBarController.h"
#import "QASearchManager.h"
#import "SWKQASearchView.h"

@interface QASearchViewController ()<UISearchBarDelegate>
@property (strong, nonatomic) SWKQASearchView *mainview;
@end

@implementation QASearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainview = [[SWKQASearchView alloc] initWithFrame:self.view.frame];
    _mainview.searchManager.superController = self;
    _mainview.superController = self;
    self.view = _mainview;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //隐藏原生的NavigationBar
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    statusBarView.backgroundColor=[UIColor DDNavBarBlue];
    [self.view addSubview:statusBarView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    searchButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [searchButton setTitle:@"取消" forState:UIControlStateNormal];
    [searchButton setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = barButton;
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
