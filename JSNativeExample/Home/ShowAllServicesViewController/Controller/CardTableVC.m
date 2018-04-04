//
//  CardTableVC.m
//  hinabian
//
//  Created by hnbwyh on 2018/3/28.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "CardTableVC.h"
#import "CardTableManager.h"
#import "CardTableView.h"
#import "RDVTabBarController.h"

@interface CardTableVC ()<CardTableViewDelegate,CardTableManagerDelegate>

@property (nonatomic,strong) CardTableManager *manager;
@property (nonatomic,strong) CardTableView *ctView;
@property (nonatomic,copy) NSString *themTitle;

@end

@implementation CardTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.ctView];
    if (@available(iOS 11.0, *)) {
        UITableView *tmpTable = [self.ctView getCurrentTableView];
        tmpTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        tmpTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tmpTable.scrollIndicatorInsets = tmpTable.contentInset;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hiddenNav];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:FALSE animated:NO];
    self.navigationController.navigationBar.translucent = FALSE;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)hiddenNav{
    [self.navigationController setNavigationBarHidden:TRUE animated:NO];
}

- (void)showNav{
    
    //设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    //设置tint颜色值
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    //设置导航栏字体大小
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:NAV_TITLE_FONT_SIZE],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    //显示原生的NavigationBar
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //关闭透明度
    self.navigationController.navigationBar.translucent = TRUE;
    //隐藏底部TAB
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    //隐藏自带的返回按钮
    [self.navigationItem hidesBackButton];
    
    [self addTabBarButton];
    
    self.title = _themTitle;
    
}

- (void)addTabBarButton{
    
    // 返回
    [self.navigationItem hidesBackButton];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40.0, 40.0)];
    [backBtn setImage:[UIImage imageNamed:@"btn_fanhui_black"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back_preVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_fanhui"]
//                                                                 style:UIBarButtonItemStylePlain
//                                                                target:self
//                                                                action:@selector(back_preVC)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)back_preVC{
    [self.navigationController popViewControllerAnimated:TRUE];
}

#pragma mark - CardTableViewDelegate

- (void)didClickCardTableHeaderBackBtn:(UIButton *)btn{
    [self back_preVC];
}

-(void)cardTableView:(CardTableView *)v didSelectedIndexPath:(NSIndexPath *)index{
    NSLog(@" %s ",__FUNCTION__);
}

-(void)scrollCardTableViewWithOffsetY:(CGFloat)offsetY{
    if (offsetY > kTABLEHEADERHEIGHT) {
        NSLog(@" %s - %f ",__FUNCTION__,offsetY);
        [self showNav];
    }else{
        [self hiddenNav];
    }
}

#pragma mark - CardTableManagerDelegate

-(void)cardTableData:(id)data{
    [self.ctView refreshTableWithDataSource:data];
}

#pragma mark - set重写

-(void)setLinkString:(NSString *)linkString{
    
    _themTitle = @"海外公司注册";
    [self.ctView modifyTableHeaderWithType:CardTableContentTypeOverseaCompany];
    [self.manager reqOverSeaServiceListWithType:@"1" start:0 num:5];
    
}

#pragma mark - 懒加载

-(CardTableView *)ctView{
    if (!_ctView) {
        CGRect rect = CGRectZero;
        rect.size.width = SCREEN_WIDTH;
        rect.size.height = SCREEN_HEIGHT;
        _ctView = [[CardTableView alloc] initWithFrame:rect];
        _ctView.delegate = self;
    }
    return _ctView;
}

-(CardTableManager *)manager{
    if (!_manager) {
        _manager = [[CardTableManager alloc] init];
        _manager.delegate = self;
    }
    return _manager;
}

@end
