//
//  OverSeaClassesVC.m
//  hinabian
//
//  Created by 何松泽 on 2018/1/11.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "OverSeaClassesVC.h"
#import "RDVTabBarController.h"
#import "HNBNetRemindView.h"
#import "RDVTabBarItem.h"

#import "AsianTalkVC.h"
#import "IMClassesVC.h"
#import "OverSeaHouseVC.h"


#define TabBarOrignY ([UIScreen mainScreen].bounds.size.height == 812.0 ? 24+10 : 24)

typedef enum:NSInteger
{
    OverSeaAsianTalk = 0,
    OverSeaIMClasses,
    OverSeaHouse,
    OverSeaTypeCount,   //计数
} OverSeaType;

@interface OverSeaClassesVC ()<TYTabPagerBarDelegate,TYTabPagerControllerDataSource,TYTabPagerControllerDelegate,HNBNetRemindViewDelegate>

@property (nonatomic, strong) NSArray *asianTalkArr;
@property (nonatomic, strong) NSArray *imClassesArr;
@property (nonatomic, strong) NSArray *overSeaHouseArr;

@end

@implementation OverSeaClassesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _asianTalkArr = [[NSArray alloc] init];
    _imClassesArr = [[NSArray alloc] init];
    _overSeaHouseArr = [[NSArray alloc] init];
    
    [self.tabBar setHotIcon:NO];
    self.tabBarOrignY = TabBarOrignY;
    [self setHotIcon:NO];
    self.tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    self.tabBar.layout.cellEdging = 25.f * SCREEN_WIDTHRATE_6;
    self.dataSource = self;
    self.delegate = self;
    
    __weak typeof(self) weakSelf = self;
    [self setClickBackButtonBlock:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    [self.navigationItem hidesBackButton];
    
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationItem hidesBackButton];
}

- (NSInteger)numberOfControllersInTabPagerController {
    return OverSeaTypeCount;
}

- (UIViewController *)tabPagerController:(TYTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    //国家项目页
    UIViewController *vc;
    switch (index) {
        case OverSeaAsianTalk:
            vc = [[AsianTalkVC alloc] init];
            break;
        case OverSeaIMClasses:
            vc = [[IMClassesVC alloc] init];
            break;
        case OverSeaHouse:
            vc = [[OverSeaHouseVC alloc] init];
            break;
        default:
            break;
    }
    return vc;
}

- (NSString *)tabPagerController:(TYTabPagerController *)tabPagerController
                   titleForIndex:(NSInteger)index {
    NSString *title = @"";
    switch (index) {
        case OverSeaAsianTalk:
            title = @"华人说";
            break;
        case OverSeaIMClasses:
            title = @"移民";
            break;
        case OverSeaHouse:
            title = @"海房";
            break;
        default:
            break;
    }
    return title;
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
