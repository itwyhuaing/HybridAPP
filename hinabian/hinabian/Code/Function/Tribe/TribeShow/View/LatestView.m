//
//  LatestView.m
//  hinabian
//
//  Created by hnbwyh on 16/6/22.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "LatestView.h"
#import "RecommanRribeCell.h"
#import "DetailTribeLatestitem.h"
#import "HNBToast.h"

@interface LatestView () <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,RefreshControlDelegate,LatestManagerDelegate>

@end

@implementation LatestView

-(instancetype)initWithFrame:(CGRect)frame tribeID:(NSString *)tribeID superVC:(UIViewController *)superVC{
    self = [super initWithFrame:frame];
    if (self) {
        
        _manager = [[LatestManager alloc] init];
        _manager.delegate = self;
        [_manager setSuperControl:superVC tribe:tribeID];
        
        [self loadViewWithFame:frame];
    }
    return self;
    
}




- (void)loadViewWithFame:(CGRect)frame{
    
    CGRect rect = frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self addSubview:_tableView];
    _tableView.sd_layout
    .leftSpaceToView(self,0)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0)
    .rightSpaceToView(self,0);
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor DDR245_G245_B245ColorWithalph:1.0];
    [_tableView registerNib:[UINib nibWithNibName:cellNibName_RecommanRribeCell bundle:nil] forCellReuseIdentifier:cellNibName_RecommanRribeCell];
    
    
    // 导航栏是否透明设置刷新控件的顶部偏移 透明 - 64.0 、不透明 - 0.0    
    _refreshControl=[[RefreshControl alloc] initWithScrollView:_tableView delegate:self];
    //_refreshControl.topEnabled=YES;
    _refreshControl.bottomEnabled=YES;
    
}

- (void)getData:(NSArray *)data{

    _dataSource = data;
    [_tableView reloadData];
    
    _currentPost = _countPerReq > data.count ? _countPerReq : data.count;
    _allPost = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:tribeshow_total_latestitems_count] integerValue];
    
}

#pragma mark ------ UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 148.0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    RecommanRribeCell *returncell = [_tableView dequeueReusableCellWithIdentifier:cellNibName_RecommanRribeCell];
    
    returncell.selectionStyle = UITableViewCellSelectionStyleNone;
    returncell.layer.borderWidth = 0.5;
    returncell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
    [returncell setCellItemWithDetailTribeLatestModel:_dataSource[indexPath.row] indexPath:indexPath];
    //returncell.subTitle.text = [NSString stringWithFormat:@"latest %ld",indexPath.row];
    
    return returncell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@" latest ---- > %@",indexPath);
    
    DetailTribeLatestitem *model = _dataSource[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:TRIBESHOW_LATEST_TABLEVIEW_NOTIFICATION object:model.link];
    
    return nil;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_delegate && [_delegate respondsToSelector:@selector(scrollLatestViewView:resetFrameWithYOffset:)]) {
        [_delegate scrollLatestViewView:self resetFrameWithYOffset:scrollView.contentOffset.y];
    }
}

#pragma mark ------ RefreshControlDelegate

-(void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{
    
    if (direction == RefreshDirectionBottom && _currentPost < _allPost){ // 底部上拉加载 且 有数据
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
             [_manager requestLatestViewDataWithStart:_currentPost getCount:_countPerReq];
            
        });
        
    }else{
        
        [refreshControl finishRefreshingDirection:direction isEmpty:YES];
        
    }

    
}

#pragma mark ------ HotestManagerDelegate

- (void)completeThenRefreshViewWithDataSource:(NSArray *)data{
    
    if (_allPost <= 0 ) {
        _allPost = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:tribeshow_total_latestitems_count] integerValue];
    }
    _currentPost = data.count;
    if (_dataSource.count == data.count) { // 说明此次并没有请求到新的数据
        _currentPost = _allPost;
    }
    
    if (_allPost <= _currentPost) {
        [_refreshControl finishRefreshingDirection:RefreshDirectionBottom isEmpty:YES];
    } else {
        [_refreshControl finishRefreshingDirection:RefreshDirectionBottom];
    }
    
    _dataSource = data;
    [_tableView reloadData];

}

- (void)failureThenFinishRefresh{
    
    [self showHudWithMessage];
    [_refreshControl finishRefreshingDirection:RefreshDirectionBottom];
    
}


- (void)showHudWithMessage{
    
    // hub网络失败
      [[HNBToast shareManager] toastWithOnView:nil msg:@"网络请求有误" afterDelay:1.0 style:HNBToastHudFailure];
    
}

@end
