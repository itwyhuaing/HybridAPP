//
//  ConditionTestVC.m
//  hinabian
//
//  Created by hnbwyh on 17/6/9.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "ConditionTestVC.h"
#import "RDVTabBarController.h"
#import "ConditionTestManager.h"
#import "ConditionTestView.h"

@interface ConditionTestVC () <ConditionTestManagerDelegate,ConditionTestViewDelegate>

@property (nonatomic,strong) ConditionTestManager *manager;
@property (nonatomic,strong) ConditionTestView *mainV;

@end

@implementation ConditionTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [[ConditionTestManager alloc] init];
    _manager.delegate = self;
    [_manager reqConditionTestDataSource];
    
    CGRect rect = CGRectZero;
    CGSize navSize = self.navigationController.navigationBar.frame.size;
    CGSize statusSize = [[UIApplication sharedApplication] statusBarFrame].size;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT - navSize.height - statusSize.height;
    if (self.model) {
        _mainV = [[ConditionTestView alloc] initWithFrame:rect dataModel:self.model];
    } else {
        _mainV = [[ConditionTestView alloc] initWithFrame:rect];
    }
    _mainV.testDelegate = (id)self;
    [self.view addSubview:_mainV];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpNav];
}

- (void)setUpNav{

    self.title = @"条件测试";
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
}

-(void) back
{
    if (_mainV.isBackToNation) {
        //如果在项目页，返回此前的国家页
        [_mainV backToNation];
        _mainV.isBackToNation = FALSE;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ------ ConditionTestViewDelegate
-(void)jumpToProjectTest:(NSString *)url
{
    SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
    vc.URL = [NSURL URLWithString:url];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------ ConditionTestManagerDelegate

-(void)fetchNetState:(BOOL)state data:(id)data{
    [_mainV refreshMainViewWithDataSource:data fetchState:state];
}

-(void)fetchNetState:(BOOL)state error:(NSError *)er{
    [_mainV refreshMainViewWithDataSource:nil fetchState:state];
}

@end
