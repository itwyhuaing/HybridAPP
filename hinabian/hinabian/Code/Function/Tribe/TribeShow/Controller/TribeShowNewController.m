//
//  TribeShowNewController.m
//  hinabian
//
//  Created by hnbwyh on 16/6/6.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "TribeShowNewController.h"
#import "RDVTabBarController.h"
#import "TribeShowNewView.h"
#import "DataFetcher.h"
#import "TribeShowMainManager.h"
#import "WEBMASK.h"

#import "DetailTribeHotestitem.h"
#import "DetailTribeLatestitem.h"

@interface TribeShowNewController ()

@property (nonatomic,strong) TribeShowNewView *showView;
@property (nonatomic,strong) NSArray *hotData;
@property (nonatomic,strong) NSArray *latedData;
@property (nonatomic) BOOL isAlloc;

@end

@implementation TribeShowNewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 圈子 ID 的为空判断
    if (self.tribeId == nil) {
        return;
    }
    _isAlloc = YES;
    
    // 界面
    CGFloat statusHight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGRect rect = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - navBarHeight - statusHight);
    self.view.backgroundColor = [UIColor yellowColor];
    _showView = [[TribeShowNewView alloc] initWithFrame:rect tribeID:_tribeId superVC:self];
    [self.view addSubview:_showView];
//    [WEBMASK setMaskFrame:CGRectMake(0, navBarHeight + statusHight, SCREEN_WIDTH,SCREEN_HEIGHT - navBarHeight - statusHight)];
//    [WEBMASK show];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];//用于去除导航栏的底线，也就是周围的边线
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_fanhui"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(back_preVC)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    if (_isAlloc) {
        _isAlloc = NO;
    }else{
        // 每次更新圈子简介信息
        [_showView.manager requestHeaderDataWithTribeId:_tribeId];
        //NSLog(@"  更新圈子简介信息 ");
    }
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[WEBMASK dismiss];
    
    NSInteger  cou = 0;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        NSString *vcstring = [NSString stringWithFormat:@"%@",[vc class]];
        NSString *selfClassString = [NSString stringWithFormat:@"%@",[self class]];
        if ([vcstring isEqualToString:selfClassString] ) {
            cou ++;
        }
        
    }
    //NSLog(@" %s ------ %@",__FUNCTION__,self.navigationController.viewControllers);
    if (cou <= 0) {
        //NSLog(@" 无当前类控制器 数据库需要清空 ");
        
        [DetailTribeHotestitem MR_truncateAll];
        [DetailTribeLatestitem MR_truncateAll];
        
    }
    
}

- (void)back_preVC{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
 
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:_showView.manager name:TRIBESHOW_BRIEFINFO_CAREBUTTON_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:_showView.manager name:TRIBESHOW_BRIEFINFO_TRIBEHOST_USERINFO_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:_showView.manager name:TRIBESHOW_HOTEST_TABLEVIEW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:_showView.manager name:TRIBESHOW_LATEST_TABLEVIEW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:_showView.manager name:TRIBESHOW_QA_TABLEVIEW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:_showView.manager name:TRIBESHOW_PROJECT_TABLEVIEW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:_showView.manager name:TRIBESHOW_WRITING_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:_showView.manager name:TRIBESHOW_QA_SELECT_ANSWER_ID_NOTIFICATION object:nil];
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:_showView.manager selector:@selector(theTribeCare:) name:TRIBESHOW_BRIEFINFO_CAREBUTTON_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_showView.manager selector:@selector(theTribeHost:) name:TRIBESHOW_BRIEFINFO_TRIBEHOST_USERINFO_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_showView.manager selector:@selector(hotestTableViewSelected:) name:TRIBESHOW_HOTEST_TABLEVIEW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_showView.manager selector:@selector(latestTableViewSelected:) name:TRIBESHOW_LATEST_TABLEVIEW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_showView.manager selector:@selector(questionTableViewSelected:) name:TRIBESHOW_QA_TABLEVIEW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_showView.manager selector:@selector(projectTableViewSelected:) name:TRIBESHOW_PROJECT_TABLEVIEW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_showView.manager selector:@selector(writingInTribe:) name:TRIBESHOW_WRITING_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_showView.manager selector:@selector(answerNamePressed:) name:TRIBESHOW_QA_SELECT_ANSWER_ID_NOTIFICATION object:nil];
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
