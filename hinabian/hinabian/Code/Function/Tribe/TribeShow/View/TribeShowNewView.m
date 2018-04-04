//
//  TribeShowNewView.m
//  hinabian
//
//  Created by hnbwyh on 16/6/6.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "TribeShowNewView.h"
#import "RecommanRribeCell.h"
#import "TribeShowMainManager.h"
#import "DetailTribeHotestitem.h"
#import "DetailTribeLatestitem.h"
#import "TribeShowBriefInfo.h"
#import "hnbSegmentedView.h"
#import "TribeShowHeaderView.h"
#import "HotestView.h"
#import "LatestView.h"
#import "TribeShowQAView.h"
#import "TribeShowProjectView.h"
#import "HNBNetRemindView.h"
#import "HNBToast.h"


#import "YYText.h"

@interface TribeShowNewView () <UIScrollViewDelegate,RefreshControlDelegate,TribeShowMainManagerDelegate,HotestViewDelegate,LatestViewDelegate,TribeShowQAViewDelegate,TribeShowProjectViewDelegate,HNBNetRemindViewDelegate>

@property (nonatomic,strong) UIViewController *superVC;
@property (nonatomic,copy) NSString *theTribeID;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) HotestView *hotestView;
@property (nonatomic,strong) LatestView *latestView;
@property (nonatomic,strong) TribeShowQAView *qaView;
@property (nonatomic,strong) TribeShowProjectView *proView;
@property (strong, nonatomic) hnbSegmentedView *segmentedview;
@property (strong, nonatomic) hnbSegmentedView *cellSeg;
@property (strong, nonatomic) TribeShowHeaderView *headView;
@property (nonatomic) CGFloat headerHeight;
@property (nonatomic) CGFloat hotAndLatestBtnHeight;
@property (nonatomic) NSInteger countPerReq;
@property (nonatomic) CGRect tmpFrame;
@property (nonatomic,strong) NSMutableArray *tabItemTitles;

@end

@implementation TribeShowNewView

#pragma mark ------ init
-(instancetype)initWithFrame:(CGRect)frame tribeID:(NSString *)tribeID superVC:(UIViewController *)superVC{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _tmpFrame = frame;
        _theTribeID = tribeID;
        _superVC = superVC;
        _headerHeight = 133.0; // 140.0;   //108.0;
        _hotAndLatestBtnHeight = 36.0;
        _countPerReq = 20;      //每次网络请求帖子数 20 (注：2.0版本该参数为10 , 2.1版本该参数应要求修改为20)
        
        _tabItemTitles = [[NSMutableArray alloc] init];
        _manager = [[TribeShowMainManager alloc] init];
        _manager.delegate = self;
        [_manager setSuperControl:superVC entryTribe:tribeID];
        
        if (![HNBUtils isConnectionAvailable]){
            
            HNBNetRemindView *showPoorNetView = [[HNBNetRemindView alloc] init];
            [showPoorNetView loadWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)
                                 superView:self
                                  showType:HNBNetRemindViewShowPoorNet
                                  delegate:self];
        }else{
            
            [self loadViewWithFame:_tmpFrame];
            // 网络请求
            [_manager requestDataWithGetCount:_countPerReq tribeId:_theTribeID];
            
        }

    }
    return self;
    
}

- (void)loadViewWithFame:(CGRect)frame{
    
    
    /* 5672014429747675137 - 议事广场  5568280569369854710 - 赴美生子  没有后面两个  Tab */
//    if ([_theTribeID isEqualToString:@"5672014429747675137"] || [_theTribeID isEqualToString:@"5568280569369854710"]) {
//        [_tabItemTitles addObjectsFromArray:@[@"最热",@"最新"]];
//    } else {
//        [_tabItemTitles addObjectsFromArray:@[@"最热",@"最新",@"问答",@"项目"]];
//    }
    // v2.9.1 需求移除问答与项目
    [_tabItemTitles addObjectsFromArray:@[@"最热",@"最新"]];
    CGRect rect = frame;
    rect.size.height = _headerHeight;
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"TribeShowHeaderView" owner:self options:nil];
    _headView = [nibs objectAtIndex:0];
    [_headView setFrame:rect];
    
    rect.origin.y = CGRectGetMaxY(_headView.frame);
    rect.size.height = _hotAndLatestBtnHeight;
    _segmentedview = [[hnbSegmentedView alloc] initWithFrame:rect titles:_tabItemTitles clickBlick:^(NSInteger index) {
        [self clickToChooseLocation:index];
    }];
    _segmentedview.x_0ffset = (SCREEN_WIDTH/_tabItemTitles.count - SCREEN_WIDTH * 0.25) * 0.5;
    _segmentedview.titleNomalColor=[UIColor colorWithRed:78.0/255.0f green:78.0/255.0f blue:78.0/255.0f alpha:1.0f];
    _segmentedview.titleSelectColor=[UIColor DDNavBarBlue];
    _segmentedview.normalLineHeight = 0.3;
    
    // alloc - frame : 如使用约束则将scroll部分frame设置为 CGRectZero
    rect.origin.y = CGRectGetMaxY(_segmentedview.frame);
    rect.size.height = frame.size.height - CGRectGetMaxY(_segmentedview.frame);
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
//    _scrollView.contentSize = CGSizeMake(rect.size.width * _tabItemTitles.count * 1.0, rect.size.height);
    rect.origin.x = 0;
    rect.origin.y = 0;
    _hotestView = [[HotestView alloc] initWithFrame:CGRectZero tribeID:_theTribeID superVC:_superVC];
    rect.origin.x = rect.size.width;
    _latestView = [[LatestView alloc] initWithFrame:CGRectZero tribeID:_theTribeID superVC:_superVC];
    rect.origin.x = rect.size.width * 2.0;
    _qaView = [[TribeShowQAView alloc] initWithFrame:CGRectZero tribeID:_theTribeID superVC:_superVC];
    rect.origin.x = rect.size.width * 3.0;
    _proView = [[TribeShowProjectView alloc] initWithFrame:CGRectZero tribeID:_theTribeID superVC:_superVC];
    
    rect.size.width = 50;
    rect.size.height = rect.size.width;
    rect.origin.x = frame.size.width - rect.size.width - 18;
    rect.origin.y = frame.size.height - rect.size.height - 53;
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.tag = 6;
    [editBtn setBackgroundImage:[UIImage imageNamed:@"tribe_writing_normal"] forState:UIControlStateNormal];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"tribe_writing_selected"] forState:UIControlStateSelected];
    [editBtn addTarget:self action:@selector(clickEventToWriteTribe:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setFrame:rect];
    
    
    // add
    [_scrollView addSubview:_hotestView];
    [_scrollView addSubview:_latestView];
    [_scrollView addSubview:_qaView];
    [_scrollView addSubview:_proView];
    [self addSubview:_headView];
    [self addSubview:_segmentedview];
    [self addSubview:_scrollView];
    [self addSubview:editBtn];
    
    // 属性
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _hotestView.delegate = self;
    _hotestView.countPerReq =_countPerReq;
    _hotestView.currentPost = 0;
    _latestView.delegate = self;
    _latestView.countPerReq =_countPerReq;
    _latestView.currentPost = 0;
    _qaView.delegate = self;
    _qaView.countPerReq =_countPerReq;
    _qaView.currentPost = 0;
    _proView.delegate = self;
    _proView.countPerReq =_countPerReq;
    _proView.currentPost = 0;
    
    // 约束相关 - scroll 去除上面的frame设置,改为约束的方式，以便后面的交互均无须再去频繁修改 frame
    _scrollView.sd_layout
    .topSpaceToView(_segmentedview,0)
    .bottomSpaceToView(self,0)
    .leftSpaceToView(self,0)
    .widthIs(SCREEN_WIDTH);
    _hotestView.sd_layout
    .leftSpaceToView(_scrollView,0)
    .topSpaceToView(_scrollView,0)
    .bottomSpaceToView(_scrollView,0)
    .widthIs(SCREEN_WIDTH);
    _latestView.sd_layout
    .leftSpaceToView(_hotestView,0)
    .topSpaceToView(_scrollView,0)
    .bottomSpaceToView(_scrollView,0)
    .widthIs(SCREEN_WIDTH);
    _qaView.sd_layout
    .leftSpaceToView(_latestView,0)
    .topSpaceToView(_scrollView,0)
    .bottomSpaceToView(_scrollView,0)
    .widthIs(SCREEN_WIDTH);
    _proView.sd_layout
    .leftSpaceToView(_qaView,0)
    .topSpaceToView(_scrollView,0)
    .bottomSpaceToView(_scrollView,0)
    .widthIs(SCREEN_WIDTH);
    if (_tabItemTitles.count == 2) {
        [_scrollView setupAutoContentSizeWithRightView:_latestView rightMargin:0];
    } else {
        [_scrollView setupAutoContentSizeWithRightView:_proView rightMargin:0];
    }
    
    // 界面搭建完毕
    [[HNBLoadingMask shareManager] loadingMaskWithSuperView:self loadingMaskType:LoadingMaskTypeExtendTabBar yoffset:0.0];
    
}


#pragma mark ------ clickEventToChooseLocation

- (void)clickToChooseLocation:(NSInteger)location{
    
    //NSLog(@"点击触发位置更新 %ld ", location);
    [self handleViewAtLocation:location];
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * (location - 1), 0) animated:YES];
}

- (void)clickEventToWriteTribe:(UIButton *)btn{
    
    if (_theTribeID == nil || _superVC.title == nil) {
        return;
    }
    NSDictionary *tribeInfo = @{
                                @"tribeID":_theTribeID,
                                @"tribeName":_superVC.title
                                };
    [[NSNotificationCenter defaultCenter] postNotificationName:TRIBESHOW_WRITING_NOTIFICATION object:tribeInfo];
    
}


#pragma mark ------ UIScrollViewDelegate

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    int page = (int)round(scrollView.contentOffset.x / scrollView.frame.size.width);
//    [_segmentedview setIndex:page];
//    NSLog(@"  scrollViewDidScroll ------ > page : %d",page);
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    int page = (int)round(scrollView.contentOffset.x / scrollView.frame.size.width);
    [_segmentedview setIndex:page];
    [self handleViewAtLocation:(long)(page + 1)];
    
//    NSLog(@" scrollViewDidEndDecelerating ------ > page : %d",page);

}

#pragma mark ------ HotestViewDelegate,LatestViewDelegate , TribeShowQAViewDelegate,TribeShowProjectViewDelegate

-(void)scrollHotestView:(HotestView *)hotestView resetFrameWithYOffset:(CGFloat)yOffset{
    
     //NSLog(@" scrollHotestView ===== yOffset ------ > %f",yOffset);
    
    if (yOffset > 0 && _headView.frame.origin.y == 0) { // 上推得条件
        
        [self animationMoveResetFrameWithOffset:-_headerHeight];
        
        
    } else if (yOffset < 0 && _headView.frame.origin.y == -_headerHeight){ // 下拉条件
        
        [self animationMoveResetFrameWithOffset:_headerHeight];
        
    }else{
    
        _hotestView.tableView.scrollEnabled = YES;
        
    }

}

-(void)scrollLatestViewView:(LatestView *)latestView resetFrameWithYOffset:(CGFloat)yOffset{
    
     //NSLog(@" scrollLatestViewView ===== yOffset ------ > %f",yOffset);
    
    if (yOffset > 0 && _headView.frame.origin.y == 0) {
    
        [self animationMoveResetFrameWithOffset:-_headerHeight];

    } else if (yOffset < 0 && _headView.frame.origin.y == -_headerHeight){
        
        [self animationMoveResetFrameWithOffset:_headerHeight];
        
    }else{
    
        _latestView.tableView.scrollEnabled = YES;
        
    }
    
}


- (void)scrollTribeShowQAView:(TribeShowQAView *)qaView resetFrameWithYOffset:(CGFloat)yOffset{

    //NSLog(@" scrollLatestViewView ===== yOffset ------ > %f",yOffset);
    
    if (yOffset > 0 && _headView.frame.origin.y == 0) {
        
        [self animationMoveResetFrameWithOffset:-_headerHeight];
        
    } else if (yOffset < 0 && _headView.frame.origin.y == -_headerHeight){
        
        [self animationMoveResetFrameWithOffset:_headerHeight];
        
    }else{
        
        _qaView.tableView.scrollEnabled = YES;
        
    }
}

- (void)scrollTribeShowProjectView:(TribeShowProjectView *)proView resetFrameWithYOffset:(CGFloat)yOffset{

    //NSLog(@" scrollLatestViewView ===== yOffset ------ > %f",yOffset);
    
    if (yOffset > 0 && _headView.frame.origin.y == 0) {
        
        [self animationMoveResetFrameWithOffset:-_headerHeight];
        
    } else if (yOffset < 0 && _headView.frame.origin.y == -_headerHeight){
        
        [self animationMoveResetFrameWithOffset:_headerHeight];
        
    }else{
        
        _proView.tableView.scrollEnabled = YES;
        
    }

}

#pragma mark ------ TribeShowMainManagerDelegate 数据回调处理

- (void)completeDateThenRefreshViewWithHeadModel:(TribeShowBriefInfo *)model dataSource:(NSArray *)data tribeInfoReqStatus:(BOOL)tribeInfoReqStatus hotestPostInfoReqStatus:(BOOL)hotestPostInfoReqStatus{
    
    // 展示网络请求状态
    BOOL tmpReqAnd = tribeInfoReqStatus & hotestPostInfoReqStatus;
    BOOL tmpReqOr = tribeInfoReqStatus | hotestPostInfoReqStatus;
    if ((!tmpReqOr && data.count <= 0) || model == nil) {
        // 全部失败且数据库数据为空 / 头部信息为空
        [self showMessageWhenReqNetError];
    }else if (tmpReqAnd){
        // 全部成功
    }else{
        // 有请求失败
        [self showHudWithMessage];
    }
    
    [self reLayoutHeaderFrameAfterData:model];
    [_headView setViewWithInfo:model];
    [_hotestView getData:data];
    _superVC.title = model.tribe_name;
    [[HNBLoadingMask shareManager] dismiss];
    
}


/* v2.8 Tab个数问题的处理方案 ：先做网络请求而后依据数据判断Tab个数*/
-(void)completeDateThenRefreshViewWithHeadModel:(TribeShowBriefInfo *)model qaDataSource:(NSArray *)qaData proDataSource:(NSArray *)proData hotDataSource:(NSArray *)hotData qaReqStatus:(BOOL)qaReqStatus proReqStatus:(BOOL)proReqStatus tribeInfoReqStatus:(BOOL)tribeInfoReqStatus hotestPostInfoReqStatus:(BOOL)hotestPostInfoReqStatus{

    // 展示网络请求状态
    BOOL tmpReqAnd = tribeInfoReqStatus & hotestPostInfoReqStatus;
    BOOL tmpReqOr = tribeInfoReqStatus | hotestPostInfoReqStatus;
    if ((!tmpReqOr && hotData.count <= 0) || model == nil) {
        // 全部失败且数据库数据为空 / 头部信息为空
        [self showMessageWhenReqNetError];
    }else if (tmpReqAnd){
        // 全部成功
    }else{
        // 有请求失败
        [self showHudWithMessage];
    }
    
    [self reLayoutHeaderFrameAfterData:model];
    [_headView setViewWithInfo:model];
    [_hotestView getData:hotData];
    _superVC.title = model.tribe_name;
    
    // 项目 Tab 是否显示
    if (proData == nil || proData.count <= 0) {
        [_tabItemTitles removeObject:@"项目"];
        [_segmentedview relayoutTabAfterDeleteTitle:@"项目"];
        [self reLayoutTabScrollFrameAfterRemoveTabType:TRIBE_PROTHEM];
        _segmentedview.x_0ffset = (SCREEN_WIDTH/_tabItemTitles.count - SCREEN_WIDTH * 0.25) * 0.5;
    } else {
        [_proView getData:proData];
    }
    // 问答 Tab 是否显示
    if (qaData == nil || qaData.count <= 0) {
        [_tabItemTitles removeObject:@"问答"];
        [_segmentedview relayoutTabAfterDeleteTitle:@"问答"];
        [self reLayoutTabScrollFrameAfterRemoveTabType:TRIBE_QATHEM];
        _segmentedview.x_0ffset = (SCREEN_WIDTH/_tabItemTitles.count - SCREEN_WIDTH * 0.25) * 0.5;
    } else {
        [_qaView getData:qaData];
    }

    [[HNBLoadingMask shareManager] dismiss];

}


- (void)completeDateThenRefreshHeaderViewWithHeadModel:(TribeShowBriefInfo *)model tribeInfoReqStatus:(BOOL)tribeInfoReqStatus{

    [_headView setViewWithInfo:model];
    
}

- (void)failReqHeaderViewDataWithTribeInfoReqStatus:(BOOL)tribeInfoReqStatus{

    [self showMessageWhenReqNetError];

}

- (void)reqFirstPageDagta:(NSArray *)dataArr reqStatus:(BOOL)reqStatus tabIndex:(NSString *)tabIndex{

    if ([tabIndex isEqualToString:TRIBE_LATEST]){
        [_latestView getData:dataArr];
    }else if ([tabIndex isEqualToString:TRIBE_QATHEM]){
        [_qaView getData:dataArr];
    }else if ([tabIndex isEqualToString:TRIBE_PROTHEM]){
        [_proView getData:dataArr];
    }

}

#pragma mark ------ toolMethod

- (void)handleViewAtLocation:(NSInteger)location{
    
    NSString *selectedTitle = _tabItemTitles[location-1];
    //NSLog(@"当前被选中的Tab - Title :%@",selectedTitle);
    if ([selectedTitle isEqualToString:@"最热"]) {
        
        [HNBClick event:@"103021" Content:nil];
        
        if (_hotestView.dataSource.count <= 0) {
            [_hotestView.manager requestHotViewDataWithStart:0 getCount:_countPerReq];
        } else {
            [_hotestView.tableView reloadData];
        }
        
    } else if ([selectedTitle isEqualToString:@"最新"]){
        
        [HNBClick event:@"103022" Content:nil];
        
        if (_latestView.dataSource.count <= 0) {
            [_latestView.manager requestLatestViewDataWithStart:0 getCount:_countPerReq];
        } else {
            [_latestView.tableView reloadData];
        }
        
    }else if ([selectedTitle isEqualToString:@"问答"]){
        
        [HNBClick event:@"103052" Content:nil];
        
        if (_qaView.dataSource.count <= 0) {
            [_qaView.manager requestTribeShowQAViewDataWithStart:0 getCount:_countPerReq];
        } else {
            [_qaView.tableView reloadData];
        }
        
    }else if ([selectedTitle isEqualToString:@"项目"]){
        
        [HNBClick event:@"103053" Content:nil];
        
        if (_proView.dataSource.count <= 0) {
            [_proView.manager requestTribeShowProjectViewDataWithStart:0 getCount:_countPerReq];
        } else {
            [_proView.tableView reloadData];
        }
        
    }
    
}

- (void)animationMoveResetFrameWithOffset:(CGFloat)offset{

    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect = _headView.frame;
        rect.origin.y += offset;
        [_headView setFrame:rect];
        
        rect = _segmentedview.frame;
        rect.origin.y += offset;
        [_segmentedview setFrame:rect];
        
        /* 约束相关 - 做完约束情况下无需频繁修改 frame
        rect = _scrollView.frame;
        rect.size.height -= offset;
        rect.origin.y += offset;
        [_scrollView setFrame:rect];
        
        rect = _hotestView.frame;
        rect.origin.y = 0;
        rect.origin.x = 0;
        rect.size.height -= offset;
        [_hotestView setFrame:rect];
        
        rect = _hotestView.tableView.frame;
        rect.origin.y = 0;
        rect.origin.x = 0;
        rect.size.height -= offset;
        [_hotestView.tableView setFrame:rect];
        
        rect = _latestView.frame;
        rect.origin.y = 0;
        rect.size.height -= offset;
        [_latestView setFrame:rect];
        
        rect = _latestView.tableView.frame;
        rect.origin.y = 0;
        rect.origin.x = 0;
        rect.size.height -= offset;
        [_latestView.tableView setFrame:rect];
        
        rect = _qaView.frame;
        rect.origin.y = 0;
        rect.size.height -= offset;
        [_qaView setFrame:rect];
        
        rect = _qaView.tableView.frame;
        rect.origin.y = 0;
        rect.origin.x = 0;
        rect.size.height -= offset;
        [_qaView.tableView setFrame:rect];
        
        
        rect = _proView.frame;
        rect.origin.y = 0;
        rect.size.height -= offset;
        [_proView setFrame:rect];
        
        rect = _proView.tableView.frame;
        rect.origin.y = 0;
        rect.origin.x = 0;
        rect.size.height -= offset;
        [_proView.tableView setFrame:rect];*/
        
        [self layoutSubviews];
        [_scrollView layoutSubviews];
        [_hotestView layoutSubviews];
        [_latestView layoutSubviews];
        [_qaView layoutSubviews];
        [_proView layoutSubviews];
        
        
    } completion:^(BOOL finished) {
        
        _hotestView.tableView.scrollEnabled = YES;
        _latestView.tableView.scrollEnabled = YES;
        _qaView.tableView.scrollEnabled = YES;
        _proView.tableView.scrollEnabled = YES;
        
    }];

    
}

// 获取数据后 - 重新布局头部视图
- (void)reLayoutHeaderFrameAfterData:(TribeShowBriefInfo *)f{
  
    /*
        19 - 单行计算高度  33 - 两行计算高度
        14 - Xib 中单行预设高度  15 - 间距值
     */
        CGFloat tmp_f = 0.f;
        if (f.tribeHostTextHeight <= 0) {
            tmp_f =  -(15+14);
        } else if (f.tribeHostTextHeight - 22 > 0){
            tmp_f = f.tribeHostTextHeight - 14;
        }
        _headerHeight += tmp_f;
        CGRect rect = _headView.frame;
        rect.size.height = _headerHeight;
        [_headView setFrame:rect];
        
        rect = _segmentedview.frame;
        rect.origin.y = CGRectGetMaxY(_headView.frame);
        [_segmentedview setFrame:rect];
        
        /* 约束相关 - 做完约束情况下无需频繁修改 frame
        rect = _scrollView.frame;
        rect.origin.y = CGRectGetMaxY(_segmentedview.frame);
        rect.size.height = _tmpFrame.size.height - rect.origin.y;
        [_scrollView setFrame:rect];

        rect = _latestView.frame;
        rect.size.height = _scrollView.size.height;
        [_latestView setFrame:rect];
        rect = _hotestView.frame;
        rect.size.height = _scrollView.size.height;
        [_hotestView setFrame:rect];
        rect = _qaView.frame;
        rect.size.height = _scrollView.size.height;
        [_qaView setFrame:rect];
        rect = _proView.frame;
        rect.size.height = _scrollView.size.height;
        [_proView setFrame:rect];
        
        
        rect = _latestView.tableView.frame;
        rect.size.height = _latestView.frame.size.height;
        [_latestView.tableView setFrame:rect];
        rect = _hotestView.tableView.frame;
        rect.size.height = _hotestView.frame.size.height;
        [_hotestView.tableView setFrame:rect];
        rect = _qaView.tableView.frame;
        rect.size.height = _qaView.frame.size.height;
        [_qaView.tableView setFrame:rect];
        rect = _proView.tableView.frame;
        rect.size.height = _proView.frame.size.height;
        [_proView.tableView setFrame:rect];*/
    
    [self layoutSubviews];
    [_scrollView layoutSubviews];
    [_hotestView layoutSubviews];
    [_latestView layoutSubviews];
    [_qaView layoutSubviews];
    [_proView layoutSubviews];
    
}

- (void)reLayoutTabScrollFrameAfterRemoveTabType:(NSString *)tabType{
    
    CGSize tmp_contentSize = _scrollView.contentSize;
    tmp_contentSize.width = SCREEN_WIDTH * _tabItemTitles.count;
    _scrollView.contentSize = tmp_contentSize;
    if ([tabType isEqualToString:TRIBE_PROTHEM]) {
        [_proView removeFromSuperview];
    } else if ([tabType isEqualToString:TRIBE_QATHEM]){
        [_qaView removeFromSuperview];
        CGRect tmp_rect = _proView.frame;
        tmp_rect.origin.x = _scrollView.contentSize.width - SCREEN_WIDTH;
        [_proView setFrame:tmp_rect];
    }
}

#pragma mark ------ 网络状况

- (void)showMessageWhenReqNetError{
    
    // 网络请求全部失败且无帖子数据 蒙版网络失败
    HNBNetRemindView *showFailNetReqView = [[HNBNetRemindView alloc] init];
    [showFailNetReqView loadWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                            superView:self
                             showType:HNBNetRemindViewShowFailNetReq
                             delegate:self];
    
    
}

- (void)showHudWithMessage{
    
    // hub网络失败
    [[HNBToast shareManager] toastWithOnView:nil msg:@"网络请求有误" afterDelay:1.0 style:HNBToastHudFailure];
    
}

-(void)clickOnNetRemindView:(HNBNetRemindView *)remindView{

    [[HNBLoadingMask shareManager] loadingMaskWithSuperView:self loadingMaskType:LoadingMaskTypeExtendTabBar yoffset:0.0];
    
    switch (remindView.tag) {
        case HNBNetRemindViewShowPoorNet:
        {
            if ([HNBUtils isConnectionAvailable]) {
                
                [self loadViewWithFame:_tmpFrame];
                [_manager requestDataWithGetCount:_countPerReq tribeId:_theTribeID];
                [remindView removeFromSuperview];
                
            } else {
                
                [[HNBLoadingMask shareManager] dismiss];
                
            }
        }
            break;
        case HNBNetRemindViewShowFailNetReq:
        {
            [_manager requestDataWithGetCount:_countPerReq tribeId:_theTribeID];
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

@end
