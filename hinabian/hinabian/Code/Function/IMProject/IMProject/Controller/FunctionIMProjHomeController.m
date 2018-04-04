//
//  FunctionIMProjHomeController.m
//  hinabian
//
//  Created by 何松泽 on 2017/11/22.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "FunctionIMProjHomeController.h"
#import "HotIMProjectViewController.h" // V 2.9.5
#import "HotIMProjectVC.h" // V3.0
#import "DataFetcher.h"
#import "IMHomeNationTabModel.h"
#import "FunctionNationProjController.h"
#import "RDVTabBarController.h"
#import "ConditionTestManager.h"
#import "ProjectNationsModel.h"
#import "IMAllCountryView.h"
#import "RefreshControl.h"
#import "HNBClick.h"
#import "HNBNetRemindView.h"

#import "RDVTabBarItem.h"

#define TabBarOrignY ([UIScreen mainScreen].bounds.size.height == 812.0 ? 24+10 : 24)

@interface FunctionIMProjHomeController ()<TYTabPagerBarDelegate,TYTabPagerControllerDataSource,TYTabPagerControllerDelegate,RefreshControlDelegate,HNBNetRemindViewDelegate>
{
    BOOL isLeaveTab;
    BOOL isLeavePro;
}
@property (nonatomic,strong) RefreshControl *refreshControl;

@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) NSMutableArray<ProjectNationsModel *> *nationsArr;

@property (nonatomic, strong) IMAllCountryView *countryView;

@end

@implementation FunctionIMProjHomeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"国家项目";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"国家项目";
    self.tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    [self.tabBar setHotIcon:NO];
    self.tabBarOrignY = TabBarOrignY;
    [self setHotIcon:NO];
    [self setMenuShow:YES image:@"project_all_menu"];
    self.dataSource = self;
    self.delegate = self;
    
    //    _countryView = [[IMAllCountryView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 2, 0, 2, 2)];
    _countryView = [[IMAllCountryView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _countryView.hidden = YES;
    _countryView.collectionView.alpha = 0.f;
    [[UIApplication sharedApplication].keyWindow addSubview:_countryView];
    [[HNBLoadingMask shareManager] loadingMaskWithSuperView:self.view loadingMaskType:LoadingMaskTypeNormal yoffset:SCREEN_STATUSHEIGHT + SCREEN_NAVHEIGHT];
    
    if (![HNBUtils isConnectionAvailable]) {
        
        HNBNetRemindView *showPoorNetView = [[HNBNetRemindView alloc] init];
        [showPoorNetView loadWithFrame:CGRectMake(0, 66, SCREEN_WIDTH,SCREEN_HEIGHT) superView:self.view showType:HNBNetRemindViewShowPoorNet delegate:self];
        
    }else {
        [self loadData];
    }
    
    __weak typeof(self) weakSelf = self;
    [self setClickMenuButtonBlock:^(){
        [weakSelf clickMenu];
    }];
    
    [_countryView setClickCloseBlock:^{
        [weakSelf clickClose];
    }];
    
    [self setClickBackButtonBlock:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [_countryView setDidSelectCellWithIndex:^(NSIndexPath *indexPath){
        [weakSelf scrollToControllerAtIndex:indexPath.row animate:YES];
        [weakSelf clickClose];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //隐藏自带的返回按钮
//    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
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

- (void)clickMenu {
    //点击全部国家
    [HNBClick event:@"170001" Content:nil];
    
    [_countryView.collectionView reloadData];
    _countryView.collectionView.hidden = NO;
    _countryView.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        _countryView.BGImageView.transform = CGAffineTransformMakeScale(-SCREEN_WIDTH,SCREEN_HEIGHT);
        _countryView.collectionView.alpha = 1.0f;
        _countryView.alpha = 1.0f;
    }completion:^(BOOL finished) {
        
    }];
}

- (void)clickClose {
    [UIView animateWithDuration:0.3 animations:^{
        _countryView.collectionView.alpha = 0.0f;
        _countryView.alpha = 0.f;
        _countryView.BGImageView.transform = CGAffineTransformMakeScale(-1/SCREEN_WIDTH,1/SCREEN_HEIGHT);
    }completion:^(BOOL finished) {
        _countryView.collectionView.hidden = YES;
        _countryView.hidden = YES;
        
    }];
}

- (void)loadData {
    
    dispatch_group_t indexLoad  = dispatch_group_create();
    dispatch_queue_t indexQueue = dispatch_queue_create("IMCountryLists", DISPATCH_QUEUE_SERIAL);
    
    //先请求国家列表数据
//    dispatch_group_enter(indexLoad);
//    [DataFetcher gettabInIMProjectHomewithSucceedHandler:^(id JSON) {
//        [self backHandleFuncTabData:JSON];
//        dispatch_group_leave(indexLoad);
//    } withFailHandler:^(id error) {
//        [self showHudWithMessage];
//        [self showMessageWhenReqNetError];
//        dispatch_group_leave(indexLoad);
//    }];
//
//    dispatch_group_enter(indexLoad);
//    [DataFetcher doGetContryAndProject:^(id JSON) {
//
//        [self backHandleFuncContryAndProjectData:JSON];
//        dispatch_group_leave(indexLoad);
//
//    } withFailHandler:^(id error) {
//        dispatch_group_leave(indexLoad);
//    }];
    
    isLeaveTab = FALSE;
    isLeavePro = FALSE;
    dispatch_group_enter(indexLoad);
    [DataFetcher gettabInIMProjectHomeWithLocalCachedHandler:^(id JSON) {
        [self backHandleFuncTabData:JSON];
        isLeaveTab = [self queryFuncIsLeaveGrop:isLeaveTab queueGroup:indexLoad];
    } succeedHandler:^(id JSON) {
        [self backHandleFuncTabData:JSON];
        isLeaveTab = [self queryFuncIsLeaveGrop:isLeaveTab queueGroup:indexLoad];
    } withFailHandler:^(id error) {
        [self showHudWithMessage];
        //[self showMessageWhenReqNetError];
        isLeaveTab = [self queryFuncIsLeaveGrop:isLeaveTab queueGroup:indexLoad];
    }];
    dispatch_group_enter(indexLoad);
    [DataFetcher doGetContryAndProjectWithLocalCachedHandler:^(id JSON) {
        [self backHandleFuncContryAndProjectData:JSON];
        isLeavePro = [self queryFuncIsLeaveGrop:isLeavePro queueGroup:indexLoad];
    } succeedHandler:^(id JSON) {
        [self backHandleFuncContryAndProjectData:JSON];
        isLeavePro = [self queryFuncIsLeaveGrop:isLeavePro queueGroup:indexLoad];
    } withFailHandler:^(id error) {
        isLeavePro = [self queryFuncIsLeaveGrop:isLeavePro queueGroup:indexLoad];
    }];
    
    
    //再进行刷新
    dispatch_group_notify(indexLoad, indexQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[HNBLoadingMask shareManager] dismiss];
            [self reloadData];
        });
    });
    
}

- (void)backHandleFuncTabData:(id)JSON{
    if ([JSON isKindOfClass:[NSArray class]]) {
        NSMutableArray *datas = JSON;
        if (datas.count >= 1) {
            [datas removeObjectAtIndex:0];//热门为首个，将其移除掉
        }
        _datas = [datas copy];
        _countryView.dataArr = _datas;
        [_countryView.collectionView reloadData];
    }
}

- (void)backHandleFuncContryAndProjectData:(id)JSON{
    
    if ([JSON isKindOfClass:[NSArray class]]) {
        NSMutableArray *arr = JSON;
        NSMutableArray *nationsArr = [[NSMutableArray alloc] init];
        for (NSDictionary *contientDic in arr) {
            NSArray *tempArr = [contientDic valueForKey:@"nations_Arr"];
            [nationsArr addObjectsFromArray:tempArr];
        }
        if (arr.count >= 1) {
            [arr removeObjectAtIndex:0];//热门为首个，将其移除掉
        }
        _nationsArr = [nationsArr copy];
    }
    
}


- (BOOL)queryFuncIsLeaveGrop:(BOOL)isLeaveGrop queueGroup:(dispatch_group_t)group{
    if (!isLeaveGrop) {
        dispatch_group_leave(group);
        //NSLog(@" %s ",__FUNCTION__);
    }
    return TRUE; // 只做标记
}

#pragma mark - TYTabPagerControllerDataSource

- (NSInteger)numberOfControllersInTabPagerController {
    return _datas.count;
}

- (UIViewController *)tabPagerController:(TYTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    //国家项目页
    FunctionNationProjController *VC = [[FunctionNationProjController alloc]init];
    IMHomeNationTabModel *model = _datas[index];
    VC.f_id = model.f_id;
    VC.f_title = model.f_name_short_cn;
    for (ProjectNationsModel *nationModel in _nationsArr) {
        if ([nationModel.nation_id isEqualToString:model.f_id]) {
            VC.model = nationModel;
            break;
        }
    }
    return VC;
    
}

- (NSString *)tabPagerController:(TYTabPagerController *)tabPagerController
                   titleForIndex:(NSInteger)index {
    IMHomeNationTabModel *model = _datas[index];
    NSString *title = model.f_name_short_cn;
    return title;
}

- (void)showHudWithMessage{
    [[HNBLoadingMask shareManager] dismiss];
    // hub网络失败
    [[HNBToast shareManager] toastWithOnView:nil msg:@"网络请求有误" afterDelay:1.0 style:HNBToastHudFailure];
    
}

- (void)showMessageWhenReqNetError{
    [[HNBLoadingMask shareManager] dismiss];
    // 网络请求全部失败且无帖子数据 蒙版网络失败
    HNBNetRemindView *showFailNetReqView = [[HNBNetRemindView alloc] init];
    [showFailNetReqView loadWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_TABHEIGHT)
                            superView:self.view showType:HNBNetRemindViewShowFailNetReq
                             delegate:self];
    
}

-(void)clickOnNetRemindView:(HNBNetRemindView *)remindView{
    
    [[HNBLoadingMask shareManager] loadingMaskWithSuperView:self.view loadingMaskType:LoadingMaskTypeNormal yoffset:SCREEN_STATUSHEIGHT + SCREEN_NAVHEIGHT];
    
    switch (remindView.tag) {
        case HNBNetRemindViewShowPoorNet:
        {
            if ([HNBUtils isConnectionAvailable]) {
                
                [remindView removeFromSuperview];
                [self loadData];
                [[self rdv_tabBarController] setTabBarHidden:FALSE animated:YES];
                
            } else {
                
                [[HNBLoadingMask shareManager] dismiss];
                
            }
        }
            break;
        case HNBNetRemindViewShowFailNetReq:
        {
            [self loadData];
            [remindView removeFromSuperview];
        }
            break;
        case HNBNetRemindViewShowFailReleatedData:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

