//
//  HotIMProjectVC.m
//  hinabian
//
//  Created by hnbwyh on 2017/11/6.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "HotIMProjectVC.h"
#import "HotImmigrantCell.h"
#import "HotIMProjectManager.h"
#import "HotIMProjectModel.h"
#import "RefreshControl.h"
 

// 热门活动模型
#import "HotIMProjectModel.h"

@interface HotIMProjectVC () <UITableViewDelegate,UITableViewDataSource,HotIMProjectManagerDelegate,RefreshControlDelegate>

@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) HotIMProjectManager *manager;

@end

@implementation HotIMProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_STATUSHEIGHT - SCREEN_TABHEIGHT - SCREEN_PROJ_NAVHEIGHT);
    _tableView = [[UITableView alloc] initWithFrame:rect];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    _manager = [[HotIMProjectManager alloc] init];
    _manager.delegate= self;
    [_manager reqHotIMProjectData];
    
    // 刷新控件
    _refreshControl=[[RefreshControl alloc] initWithScrollView:self.tableView topOffset:0.0 delegate:self];
    _refreshControl.topEnabled=YES;
    _refreshControl.bottomEnabled=NO;
    
}

#pragma mark ------ UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HHotImmigrantCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HotImmigrantCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_HotImmigrantCell];
    if (!cell) {
        cell = [[HotImmigrantCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_HotImmigrantCell];
    }
    [cell setUpItemCellWithModel:self.dataSource[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak typeof(self)weakSelf = self;
    cell.clickCellBtnBlock = ^(UIButton *btn) {
        [weakSelf jumpVCAtIndexPath:indexPath];
    };
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self jumpVCAtIndexPath:indexPath];
}

- (void)jumpVCAtIndexPath:(NSIndexPath *)indexPath{
    HotIMProjectModel *f = self.dataSource[indexPath.row];
    if (f.actLink == nil || f.actLink.length <= 0) {
        return;
    }
    NSString *link = f.actLink;

    SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
    if ([[HNBWebManager defaultInstance] isHinabianSiteWithURLString:link]) {
        vc.manualRefreshWhenBack = TRUE;
    }else{
        vc.manualRefreshWhenBack = FALSE;
    }
    vc.URL = [vc.webManger configDefaultNativeNavWithURLString:link];
    [self.navigationController pushViewController:vc animated:YES];
    
    NSDictionary *dict = @{@"url":link,
                           @"index":[NSString stringWithFormat:@"%ld",indexPath.row],
                           };
    [HNBClick event:@"172011" Content:dict];
}

#pragma mark ------ RefreshControlDelegate

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{
    
    if (direction == RefreshDirectionTop) { // 顶部下拉刷新
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [_manager reqHotIMProjectData];
            [_refreshControl finishRefreshingDirection:RefreshDirectionTop isEmpty:YES];
        });
        return;
        
    } else { // 底部上拉加载
        [refreshControl finishRefreshingDirection:direction isEmpty:YES];
    }
    
}

#pragma mark ------ HotIMProjectManagerDelegate

- (void)hotIMProjectManagerReqNetSucWithDataSource:(id)dataSource reqStatus:(BOOL)rs{
    NSArray *tmpData = (NSArray *)dataSource;
    _dataSource = [[NSMutableArray alloc] initWithArray:tmpData];
    [self.tableView reloadData];
}


-(void)hotIMProjectManagerReqNetFailWithError:(NSError *)error reqStatus:(BOOL)rs{
    
}

@end
