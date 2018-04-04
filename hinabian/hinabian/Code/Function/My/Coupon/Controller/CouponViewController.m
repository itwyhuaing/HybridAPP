//
//  CouponViewController.m
//  hinabian
//
//  Created by hnb on 16/4/13.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "CouponViewController.h"
#import "RDVTabBarController.h"
#import "CouponMainView.h"
#import "CouponMainManager.h"
#import "HNBNetRemindView.h"



@interface CouponViewController ()<CouponMainManagerDelegate,HNBNetRemindViewDelegate>
@property (strong, nonatomic) CouponMainManager * couponManager;
@property (strong, nonatomic) CouponMainView * mainView;
@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠券";
    [self.view setBackgroundColor:[UIColor DDNormalBackGround]];
    // Do any additional setup after loading the view.
    
    _couponManager = [[CouponMainManager alloc] init];
    _couponManager.superController = (id)self;
    _couponManager.delegate = (id)self;
    
    CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - SUIT_IPHONE_X_HEIGHT);
    _mainView = [[CouponMainView alloc] initWithFrame:rect];
    [self.view addSubview:_mainView];
    
    [[HNBLoadingMask shareManager] loadingMaskWithSuperView:_mainView loadingMaskType:LoadingMaskTypeExtendTabBar yoffset:0.0];
}

-(void) back_main
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back_main);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    button.titleLabel.font = [UIFont systemFontOfSize:FONT_UI28PX];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button setTitle:@"使用规则" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(explain)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/* 点击使用规则 */
-(void) explain
{
    [[NSNotificationCenter defaultCenter] postNotificationName:COUPON_EXPLAIN_SELECT_NOTIFICATION object:nil];
}

#pragma CouponMainManagerDelegate
-(void) getAllDateComplete
{
    [_mainView setCouponMainData:_couponManager.couponInUseArry UnUsed:_couponManager.couponUsedArry OutOfDate:_couponManager.couponOutOfDateArry];

    [[HNBLoadingMask shareManager] dismiss];
}

- (void)reqNetFail{

    CGRect rect = [HNBLoadingMask shareManager].frame;
    rect.origin.y = 0;
    HNBNetRemindView *showFailNetReqView = [[HNBNetRemindView alloc] init];
    [showFailNetReqView loadWithFrame:rect
                            superView:_mainView
                             showType:HNBNetRemindViewShowFailNetReq
                             delegate:self];
    [[HNBLoadingMask shareManager] dismiss];
    
}

#pragma mark ------ ReqNetErrorTipViewDelegate

-(void)clickOnNetRemindView:(HNBNetRemindView *)remindView{
    
    if (remindView.tag == HNBNetRemindViewShowFailNetReq) {
        
        [_couponManager getDataSource];
        [remindView removeFromSuperview];
        [[HNBLoadingMask shareManager] loadingMaskWithSuperView:_mainView loadingMaskType:LoadingMaskTypeExtendTabBar yoffset:0.0];
        
    }
    
}

@end
