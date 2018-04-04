//
//  UserQAView.m
//  hinabian
//
//  Created by hnbwyh on 16/7/25.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "UserQAView.h"
#import "UserinfoQAAnswerCell.h"
#import "UserinfoBottomCell.h"
#import "RefreshControl.h"
#import "UserInfoHisQAPost.h"
#import "HNBToast.h"

@interface UserQAView () <UITableViewDelegate,UITableViewDataSource,UserinfoQAManagerDelegate,RefreshControlDelegate>

@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic) NSInteger allPost;
@property (nonatomic) NSInteger currentPost;
@property (nonatomic) NSInteger bottomCellCount;

@end

@implementation UserQAView

-(instancetype)initWithFrame:(CGRect)frame personid:(NSString *)personid superVC:(UIViewController *)superVC
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _dataSource = [[NSMutableArray alloc] init];
        _bottomCellCount = 0;
        
        _qaManager = [[UserinfoQAManager alloc] init];
        [_qaManager setUserinfoQASuperControl:superVC personid:personid];
        _qaManager.delegate = self;
        
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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor DDR245_G245_B245ColorWithalph:1.0];//[UIColor beigeColor];
    [_tableView registerNib:[UINib nibWithNibName:cellNib_UserinfoQAAnswerCell bundle:nil] forCellReuseIdentifier:cellNib_UserinfoQAAnswerCell];
    [_tableView registerNib:[UINib nibWithNibName:cellNib_UserinfoBottomCell bundle:nil] forCellReuseIdentifier:cellNib_UserinfoBottomCell];
    [self addSubview:_tableView];
    
    _refreshControl = [[RefreshControl alloc] initWithScrollView:_tableView delegate:self];
    _refreshControl.bottomEnabled = YES;

}

#pragma mark ---- UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count + _bottomCellCount;    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _dataSource.count && _dataSource.count > 0)    return 44.0;
    if (indexPath.row == _dataSource.count && _dataSource.count <= 0)   return SCREEN_HEIGHT / 4.0;
    
    return 109.0; // UserinfoQAAnswerCell
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *returnCell = nil;
    if (indexPath.row == _dataSource.count  && _dataSource.count >0) {
        
        UserinfoBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNib_UserinfoBottomCell];
        [cell.tipLabel setText:@"没有更多内容"];
        returnCell = cell;
        
    }else if (indexPath.row == _dataSource.count && _dataSource.count <= 0){
        
        UserinfoBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNib_UserinfoBottomCell];
        [cell.tipLabel setText:@"他学富五车,还没有什么疑问"];
        returnCell = cell;
        
    }else{
    
        UserinfoQAAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNib_UserinfoQAAnswerCell];
        UserInfoHisQAPost *f = _dataSource[indexPath.row];
        [cell setUserinfoQAAnswerCellWithModel:f];
        returnCell = cell;
    }
    
    returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    returnCell.layer.borderWidth = 0.5;
    returnCell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
    returnCell.layer.shouldRasterize = YES;
    returnCell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    return returnCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row >= _dataSource.count) {
        return;
    }
    
    UserInfoHisQAPost *f = _dataSource[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:USERINFO_HISQA_TABLECELL object:f];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_delegate && [_delegate respondsToSelector:@selector(scrollUserQAView:resetFrameWithYOffset:)]) {
        [_delegate scrollUserQAView:self resetFrameWithYOffset:scrollView.contentOffset.y];
    }
    
}

#pragma mark ------ RefreshControlDelegate

-(void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{

    if (direction == RefreshDirectionBottom && _currentPost < _allPost){ // 底部上拉加载 且 有数据
        
        // 刷新数据前管理提问按钮隐藏问题
        if (_delegate && [_delegate respondsToSelector:@selector(hiddenTheAskButtonWhenScrollUserQAView:)]) {
            [_delegate hiddenTheAskButtonWhenScrollUserQAView:self];
        }

        // 请求更多数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [_qaManager requestUserinfoQADataWithStart:_currentPost getCount:_countPerReq];
            
        });
        
    }else{
        
        [refreshControl finishRefreshingDirection:direction isEmpty:YES];
        
    }
    
    
}


#pragma mark ------ UserinfoQAManagerDelegate

- (void)completeThenRefreshUserinfoQAWithDataSource:(NSArray *)data{

    if (data.count <= _countPerReq) { // 第一次进入读取总数
        _allPost = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:userinfo_hisqa_total_post] integerValue];
    }
    NSInteger offset = _allPost - _currentPost;
    if (_allPost -_currentPost > _countPerReq) {
        offset = _countPerReq;
    }
    _currentPost += offset;
    if (_allPost <= _currentPost) {
        _bottomCellCount = 1;
        [_refreshControl finishRefreshingDirection:RefreshDirectionBottom isEmpty:YES];
        _refreshControl.bottomEnabled = NO;
    } else {
        _bottomCellCount = 0;
        [_refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        _refreshControl.bottomEnabled = YES;
    }
    
    [_dataSource addObjectsFromArray:data];
    [_tableView reloadData];
    // 刷新数据后管理提问按钮显示问题
    if (_delegate && [_delegate respondsToSelector:@selector(showTheAskButtonWhenEndRefreshScrollUserQAView:)]) {
        [_delegate showTheAskButtonWhenEndRefreshScrollUserQAView:self];
    }
}

- (void)failureThenFinishRefreshUserinfoQA{
    
    [self showHudWithMessage];
    [_refreshControl finishRefreshingDirection:RefreshDirectionBottom];
    
}


#pragma mark ------ 网络异常提醒

- (void)showHudWithMessage{
    
    // hub网络失败
     [[HNBToast shareManager] toastWithOnView:nil msg:@"网络请求有误" afterDelay:1.0 style:HNBToastHudFailure];
    
}

@end
