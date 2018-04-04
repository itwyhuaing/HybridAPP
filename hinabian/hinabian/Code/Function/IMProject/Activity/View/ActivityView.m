//
//  SeminarView.m
//  hinabian
//
//  Created by 何松泽 on 17/1/10.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "ActivityView.h"
#import "ActivityItemTableViewCell.h"
#import "CODActivityIndex.h"
#import "RefreshControl.h"
#import "HNBToast.h"
#import "DataFetcher.h"
#import "HNBUtils.h"
#import "HNBNetRemindView.h"

#define CELL_HEIGHT     165 * SCREEN_SCALE

@interface ActivityView () <UITableViewDelegate,UITableViewDataSource,RefreshControlDelegate,ActivityManagerDelegate,HNBNetRemindViewDelegate>

@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic) NSInteger allPost;
@property (nonatomic) NSInteger currentSeminar;
@property (nonatomic) NSInteger bottomCellCount;
@property (nonatomic,strong) UIViewController *superVC;

@end

@implementation ActivityView

-(instancetype)initWithFrame:(CGRect)frame
                        type:(NSString *)type
                     superVC:(UIViewController *)superVC
{
    if (self = [super initWithFrame:frame]) {
        
        _seminarSource = [[NSMutableArray alloc]init];
        _bottomCellCount = 0;
        _countPerReq = 10;
        _type = type;
        
        _activityManager = [[ActivityManager alloc]init];
        [_activityManager setSuperControl:superVC type:_type];
        _superVC = superVC;
        _activityManager.delegate = (id)self;
        
        [self loadViewWithFame:frame];
        
        if (![HNBUtils isConnectionAvailable]) {
            
            HNBNetRemindView *showPoorNetView = [[HNBNetRemindView alloc] init];
            [showPoorNetView loadWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-SCREEN_STATUSHEIGHT - SCREEN_NAVHEIGHT - 44) superView:self showType:HNBNetRemindViewShowPoorNet delegate:self];
            
        } else {
            
            [[HNBLoadingMask shareManager] loadingMaskWithSuperView:self loadingMaskType:LoadingMaskTypeExtendTabBar yoffset:0.0];
            
//            [_activityManager requestDataInFirstTimeByType:type];
            [_activityManager reqiestSeminarFirstDataFrom:0 getCount:_countPerReq];
            
            
        }
        
    }
    return self;
}

-(void)loadViewWithFame:(CGRect)frame
{
    CGRect rect = frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor DDR245_G245_B245ColorWithalph:1.0];//[UIColor beigeColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_ActivityItemTableViewCell bundle:nil] forCellReuseIdentifier:cellNibName_ActivityItemTableViewCell];
    [self addSubview:_tableView];
    
    // 导航栏是否透明设置刷新控件的顶部偏移 透明 - 64.0 、不透明 - 0.0
    _refreshControl=[[RefreshControl alloc] initWithScrollView:_tableView delegate:self];
    _refreshControl.bottomEnabled=YES;
}

- (void)getDataSource:(NSArray *)dataSource{
    
    _currentSeminar = _countPerReq;
    if (_currentSeminar >= _allPost) {
        _bottomCellCount = 1;
        _refreshControl.bottomEnabled = NO;
    } else {
        _bottomCellCount = 0;
        _refreshControl.bottomEnabled = YES;
    }
    
    [self reloadTableViewWIthData:dataSource];
}

-(void)reloadTableViewWIthData:(NSArray *)data
{
    [_seminarSource addObjectsFromArray:data];
    [_tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _seminarSource.count + _bottomCellCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = [[UITableViewCell alloc]init];
    
    if (_seminarSource.count > 0) {
        CODActivityIndex * tmpDic = _seminarSource[indexPath.row];
        ActivityItemTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_ActivityItemTableViewCell];
        [cell setActivityItem:tmpDic.img Title:tmpDic.title isNew:[tmpDic.is_new boolValue] See:tmpDic.view_num Url:tmpDic.url];
        cell.superController = _superVC;
        returnCell = cell;
    }
    returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    returnCell.layer.borderWidth = 0.5;
    returnCell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
    
    
    return returnCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _seminarSource.count && _seminarSource.count > 0) {
        
        return 44.0;
        
    }
    CGFloat tmpHeight = CELL_HEIGHT;
    
    return tmpHeight;
}

#pragma mark ------ RefreshControlDelegate

-(void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{
    if (direction == RefreshDirectionBottom && _currentSeminar <= _allPost){ // 底部上拉加载 且 有数据
        
        // 请求更多数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_activityManager requestSeminarDataFrom:_currentSeminar getCount:_countPerReq];
        });
        
    }else{
        [refreshControl finishRefreshingDirection:direction isEmpty:YES];
    }
}

#pragma mark ------- ActivityManagerDelegate

-(void)completeThenRefreshSeminarWithData:(NSArray *)data
{
    NSInteger offset = 0;
    if ([_type isEqualToString:@"seminar"]) {
        _allPost = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:activity_seminar_total] integerValue];
    }else if ([_type isEqualToString:@"class"]){
        _allPost = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:activity_class_total] integerValue];
    }else if ([_type isEqualToString:@"interview"]){
        _allPost = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:activity_interview_total] integerValue];
    }else if ([_type isEqualToString:@"activity"]){
        _allPost = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:activity_IMActivity_total] integerValue];
    }else{
        _allPost = 0;
    }
    
    
    if (_allPost - _currentSeminar >= _countPerReq) {
        offset = _countPerReq;
    }else{
        offset = _allPost - _currentSeminar;
    }
    
    _currentSeminar += offset;
    //NSLog(@" 当前 _currentPost ---- > %ld  _allPost---- >  %ld",_currentPost,_allPost);
    
    
    if (_allPost <= _currentSeminar) {
        [_refreshControl finishRefreshingDirection:RefreshDirectionBottom isEmpty:YES];
        _refreshControl.bottomEnabled = NO;
    } else {
        [_refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        _refreshControl.bottomEnabled = YES;
    }
    [self reloadTableViewWIthData:data];
    
    [[HNBLoadingMask shareManager] dismiss];
}

- (void)failedThenFinishRefreshSeminarView{
    
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
