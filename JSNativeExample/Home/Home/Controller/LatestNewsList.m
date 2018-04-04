//
//  LatestNewsList.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/18.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "LatestNewsList.h"
#import "TopTipView.h"
#import "ListLatestNewsCell.h"
#import "LatestNewsListManager.h"
#import "RefreshGifTextHeader.h"
#import "RefreshBackFooter.h"
#import "LatestNewsModel.h"

@interface LatestNewsList () <UITableViewDelegate,UITableViewDataSource,LatestNewsListManagerDelegate>
{
    CGFloat lastOffsetY;
}
@property (nonatomic,strong) TopTipView *topTip;
@property (nonatomic,strong) UITableView *newsTable;
@property (nonatomic,strong) RefreshGifTextHeader *refreshHeader;
@property (nonatomic,strong) RefreshBackFooter *refreshFooter;
@property (nonatomic,strong) NSMutableArray *newsData;
@property (nonatomic,strong) LatestNewsListManager *manager;

@end

@implementation LatestNewsList

#pragma mark ------ life

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"快讯";

    [self.view addSubview:self.newsTable];
    [self addRefreshFuntion];
    [self.view addSubview:self.topTip];
    
    
    [self.manager reqLatestNewsListDataStart:0 count:CountDataPerReq];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpNav];
    
}

- (void)setUpNav{
    [self addTabBarButton];
}

- (void)addTabBarButton
{
    // 返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_fanhui"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(back_preVC)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------

- (void)back_preVC{
    [self.navigationController popViewControllerAnimated:TRUE];
}

#pragma mark ------

#pragma mark ------ UITableViewDelegate,UITableViewDataSource>

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HListLatestNewsCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListLatestNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_ListLatestNewsCell];
    if (cell == nil) {
        cell = [[ListLatestNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_ListLatestNewsCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setModel:self.newsData[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LatestNewsModel *f = self.newsData[indexPath.row];
    NSString *tmpString = [NSString stringWithFormat:@"%@/%@%@",H5URL,LatestNewsDetail,f.themid];

    SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];

    vc.URL = [vc.webManger configDefaultNativeNavWithURLString:tmpString];
    [self.navigationController pushViewController:vc animated:TRUE];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //NSLog(@" %s ",__FUNCTION__);
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGFloat curOffsetY = scrollView.contentOffset.y;
    BOOL isPullDown = curOffsetY - lastOffsetY > 0 ?  FALSE: TRUE;
    if (!isPullDown) {
        //NSLog(@" 向上翻动 ");
        [_manager reqLatestNewsListDataStart:self.newsData.count count:CountDataPerReq];
    }
    //NSLog(@" \n \n curOffsetY :%f - lastOffsetY :%f \n \n",curOffsetY,lastOffsetY);
    
    lastOffsetY = curOffsetY;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@" %s ",__FUNCTION__);
}

#pragma mark ------ 网络数据加载
- (void)loadNewData{
    
    NSLog(@" loadNewData ");
//    [_refreshHeader modifyLableMsg:@"正在努力加载中" hidden:FALSE];
//    [_refreshHeader modifyGifHidden:FALSE];
    
    [_manager reqLatestNewsListDataStart:0 count:CountDataPerReq];

}

- (void)loadMoreData{
    NSLog(@" loadMoreData ");
    
//    [_refreshFooter modifyLableMsg:@"正在努力加载中" hidden:FALSE];
//    [_refreshFooter modifyGifHidden:FALSE];
//    [_manager reqLatestNewsListDataStart:self.newsData.count count:CountDataPerReq];
    
    
}

#pragma mark ------ LatestNewsListManagerDelegate

-(void)latestNewsListReqNetSucWithDataSource:(id)dataSource total:(NSInteger)total isSame:(BOOL)isSame isBottomRefresh:(BOOL)br{
        NSArray *tmpData = (NSArray *)dataSource;
        if (!br) {
/**< 顶部下拉刷新>*/
            // 1. 提示条
            if (isSame) {
                // 暂无新内容更新
                [self.topTip displayWithMsg:@"暂无新内容更新"];
            }
            // 2. 停止刷新
            [self.newsTable.mj_header endRefreshing];
            // 3 .数据源修改
            [self.newsData removeAllObjects];
            [self.newsData addObjectsFromArray:tmpData];
            
        }else{
 /**< 底部上拉加载更多>*/
            NSLog(@" 向上翻动 - 停止刷新 ");
            // 2. 停止刷新
            [self.newsTable.mj_footer endRefreshing];
            // 3. 数据源修改
            [self.newsData addObjectsFromArray:tmpData];
        }
    
        // 3. 刷新
        [self deleteSameIdThem];
        [self.newsTable reloadData];

    
}

- (void)latestNewsListReqNetFailWithError:(NSError *)error reqStatus:(BOOL)rs{
    [self.newsTable.mj_header endRefreshing];
    [self.newsTable.mj_footer endRefreshing];
}

#pragma mark ------ 懒加载

-(TopTipView *)topTip{
    if (!_topTip) {
        CGRect rect = CGRectZero;
        rect.size.width = SCREEN_WIDTH;
        rect.size.height = (76.0 / 2.0);
        rect.origin.y = - rect.size.height;
        _topTip = [[TopTipView alloc] initWithFrame:rect];
    }
    return _topTip;
}

-(UITableView *)newsTable{
    if(!_newsTable){
        CGRect rect = self.view.bounds;
        rect.size.height = SCREEN_HEIGHT - SCREEN_NAVHEIGHT - SCREEN_STATUSHEIGHT;
        _newsTable = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _newsTable.delegate = self;
        _newsTable.dataSource = self;
        _newsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _newsData = [[NSMutableArray alloc] init];
    }
    return _newsTable;
}

-(LatestNewsListManager *)manager{
    if(!_manager){
        _manager = [[LatestNewsListManager alloc] init];
        _manager.delegate = self;
    }
    return _manager;
}

#pragma mark ------ prvate method

- (void)addRefreshFuntion{
    _refreshHeader = [RefreshGifTextHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.newsTable.mj_header = _refreshHeader;
//    [_refreshHeader modifyLableMsg:nil hidden:FALSE];
//    [_refreshHeader modifyGifHidden:FALSE];
    
    _refreshFooter = [RefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.newsTable.mj_footer = _refreshFooter;
    [_refreshFooter modifyLableMsg:nil hidden:TRUE];
    [_refreshFooter modifyGifHidden:FALSE];
}

#pragma mark 数据源查重
- (void)deleteSameIdThem{
    if (self.newsData.count > 0) {
        
        NSMutableArray *tmpData = [[NSMutableArray alloc] init];
        [tmpData addObjectsFromArray:self.newsData];
        
        for (NSInteger cou = 0; cou < self.newsData.count; cou ++) {
            LatestNewsModel *f = self.newsData[cou];
            for (NSInteger num = cou + 1; num < self.newsData.count; num ++) {
                LatestNewsModel *t = self.newsData[num];
                if ([f.themid isEqualToString:t.themid]) {
                    // 如果id 相同 则移除后者
                    [tmpData removeObject:t];
                }
            }
        }
        
        [self.newsData removeAllObjects];
        [self.newsData addObjectsFromArray:tmpData];
        
    }
}

@end
