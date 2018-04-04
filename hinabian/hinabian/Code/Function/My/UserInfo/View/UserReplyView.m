//
//  UserReplyView.m
//  hinabian
//
//  Created by 何松泽 on 16/12/19.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "UserReplyView.h"
#import "UserinfoTribeAnswerCell.h"
#import "UserinfoBottomCell.h"
#import "UserInfoTribeReplyModel.h"
#import "RefreshControl.h"
#import "HNBToast.h"

@interface UserReplyView () <UITableViewDelegate,UITableViewDataSource,UserinfoHisReplyManagerDelegate,RefreshControlDelegate>

@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic) NSInteger allPost;
@property (nonatomic) NSInteger currentPost;
@property (nonatomic) NSInteger bottomCellCount;

@end


@implementation UserReplyView

-(instancetype)initWithFrame:(CGRect)frame personid:(NSString *)personid superVC:(UIViewController *)superVC{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _replySource = [[NSMutableArray alloc] init];
        _bottomCellCount = 0;
        
        _hisReplyManager = [[UserinfoHisReplyManager alloc] init];
        _hisReplyManager.delegate = self;
        [_hisReplyManager setUserinfoHisReplyViewSuperControl:superVC personid:personid];
        
        [self loadViewWithFame:frame];
    }
    return self;
}

- (void)loadViewWithFame:(CGRect)frame{
    
    CGRect rect = frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor DDR245_G245_B245ColorWithalph:1.0];//[UIColor beigeColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:cellNib_UserinfoTribeAnswerCell bundle:nil] forCellReuseIdentifier:cellNib_UserinfoTribeAnswerCell];
    [_tableView registerNib:[UINib nibWithNibName:cellNib_UserinfoBottomCell bundle:nil] forCellReuseIdentifier:cellNib_UserinfoBottomCell];
    [self addSubview:_tableView];
    
    // 导航栏是否透明设置刷新控件的顶部偏移 透明 - 64.0 、不透明 - 0.0
    _refreshControl=[[RefreshControl alloc] initWithScrollView:_tableView delegate:self];
    _refreshControl.bottomEnabled=YES;
    
}

- (void)getDataSource:(NSArray *)dataSource{
    
    _currentPost = _countPerReq;
    _allPost = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:userinfo_hisReply_total] integerValue];
    
    
    if (_currentPost >= _allPost) {
        _bottomCellCount = 1;
        _refreshControl.bottomEnabled = NO;
    } else {
        _bottomCellCount = 0;
        _refreshControl.bottomEnabled = YES;
    }
    
    [self reloadTableViewWithData:dataSource];
}

#pragma mark ------ UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _replySource.count + _bottomCellCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == _replySource.count && _replySource.count > 0)      return 44.0;
    if (indexPath.row == _replySource.count && _replySource.count <= 0)     return SCREEN_HEIGHT / 4.0;
    
    return 174.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *returnCell = nil;
    
    if (indexPath.row == _replySource.count  && _replySource.count > 0)
    {
        UserinfoBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNib_UserinfoBottomCell];
        [cell.tipLabel setText:@"没有更多内容"];
        returnCell = cell;
    }
    else if (indexPath.row == _replySource.count && _replySource.count <= 0)
    {
        UserinfoBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNib_UserinfoBottomCell];
        [cell.tipLabel setText:@"他正在加入圈子的路上"];
        returnCell = cell;
    }
    else
    {
        UserInfoTribeReplyModel *f = _replySource[indexPath.row];
        
        UserinfoTribeAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNib_UserinfoTribeAnswerCell];
        [cell setUserinfoTribeAnswerCellWithModel:f];
        returnCell = cell;
    }
    
    returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    returnCell.layer.borderWidth = 0.5;
    returnCell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
    
    return returnCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row >= _replySource.count)    return;
    
    UserInfoTribeReplyModel *f = _replySource[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:USERINFO_HISTRIBE_TABLECELL object:f];
    
}

#pragma mark ------ scrollViewDidScroll

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_delegate && [_delegate respondsToSelector:@selector(scrollUserReplyView:resetFrameWithYOffset:)]) {
        [_delegate scrollUserReplyView:self resetFrameWithYOffset:scrollView.contentOffset.y];
    }
    
}


#pragma mark ------ reloadData

- (void)reloadTableViewWithData:(NSArray *)data{
    
    [_replySource addObjectsFromArray:data];
    
    [_tableView reloadData];
    // 刷新结束之后管理提问按钮是否显示
    if (_delegate && [_delegate respondsToSelector:@selector(showTheAskButtonWhenEndRefreshScrollUserReplyView:)]) {
        [_delegate showTheAskButtonWhenEndRefreshScrollUserReplyView:self];
    }
    
}


#pragma mark ------ RefreshControlDelegate

-(void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{
    
    if (direction == RefreshDirectionBottom && _currentPost < _allPost){ // 底部上拉加载 且 有数据
        // 开始加载前管理提问按钮是否隐藏
        if (_delegate && [_delegate respondsToSelector:@selector(hiddenTheAskButtonWhenScrollUserReplyView:)]) {
            [_delegate hiddenTheAskButtonWhenScrollUserReplyView:self];
        }
        // 请求更多数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_hisReplyManager requestUserinfoHisReplyViewDataWithStart:_currentPost getCount:_countPerReq];
        });
        
    }else{
        [refreshControl finishRefreshingDirection:direction isEmpty:YES];
    }
    
}


#pragma mark ------ UserinfoHisTribeManagerDelegate

- (void)completeThenRefreshUserinfoHisReplyViewWithDataSource:(NSArray *)data{
    
    if (data.count <= _countPerReq) { // 第一次进入读取总数
        _allPost = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:userinfo_hisReply_total] integerValue];
    }
    NSInteger offset = _allPost - _currentPost;
    if (_allPost -_currentPost > _countPerReq) {
        offset = _countPerReq;
    }
    _currentPost += offset;
    //NSLog(@" 当前 _currentPost ---- > %ld  _allPost---- >  %ld",_currentPost,_allPost);
    
    
    if (_allPost <= _currentPost) {
        _bottomCellCount = 1;
        [_refreshControl finishRefreshingDirection:RefreshDirectionBottom isEmpty:YES];
        _refreshControl.bottomEnabled = NO;
    } else {
        _bottomCellCount = 0;
        [_refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        _refreshControl.bottomEnabled = YES;
    }
    [self reloadTableViewWithData:data];
}

- (void)failureThenFinishRefreshUserinfoHisReplyView{
    
    [self showHudWithMessage];
    [_refreshControl finishRefreshingDirection:RefreshDirectionBottom];
    //NSLog(@"失败停止刷新");
}


#pragma mark - 网络异常提醒

- (void)showHudWithMessage{
    
    // hub网络失败
    [[HNBToast shareManager] toastWithOnView:nil msg:@"网络请求有误" afterDelay:1.0 style:HNBToastHudFailure];
}
@end
