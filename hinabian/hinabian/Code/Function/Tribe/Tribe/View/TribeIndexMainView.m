//
//  TribeIndexMainView.m
//  hinabian
//
//  Created by 余坚 on 16/6/6.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "TribeIndexMainView.h"
#import "RefreshControl.h"
#import "RDVTabBarController.h"
#import "HotTribeInIndexTableViewCell.h"
#import "TribeIndexNoticeTableViewCell.h"
#import "RecommanRribeCell.h"
#import "TribeIndexHotTribe.h"
#import "TribeIndexItem.h"
#import "HNBNetRemindView.h"
#import "HNBToast.h"
//#import "HNBTipMask.h"

#define WRITE_POST_BUTTON_SIZE  53
#define STATUE_BAR_HEIGTH       (IS_IPHONE_X ? 108+24 : 108)

//@interface TribeIndexMainView()<UITableViewDelegate,RefreshControlDelegate,TribeIndexMainManagerDelegate,HNBTipMaskDelegate,HNBNetRemindViewDelegate>
@interface TribeIndexMainView()<UITableViewDelegate,RefreshControlDelegate,TribeIndexMainManagerDelegate,FunctionTipViewDelegate,HNBNetRemindViewDelegate>

@property (nonatomic,strong) NSArray *hotTribes;
@property (nonatomic,strong) NSArray *hotPosts;
@property (nonatomic,strong) UIButton * writePostButton;
@property (nonatomic,strong) RefreshControl *refreshControl;
@end

@implementation TribeIndexMainView
- (instancetype)init
{
    self = [super init];
    if (self) {
        _hotTribes = [[NSArray alloc] init];
        _hotPosts = [[NSArray alloc] init];
        [self setBackgroundColor:[UIColor beigeColor]];
        _tribeManager = [[TribeIndexMainManager alloc] init];
        _tribeManager.delegate = (id)self;
        
        if (![HNBUtils isConnectionAvailable])
        {
            HNBNetRemindView *showPoorNetView = [[HNBNetRemindView alloc] init];
            [showPoorNetView loadWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)
                                 superView:self
                                  showType:HNBNetRemindViewShowPoorNet
                                  delegate:self];

        }
        else
        {
            [_tribeManager getAllInfoInTribeIndex:nil];
            [self initAfterGetData];
        }
        
    }
    return self;
}
-(void)initAfterGetData
{
    [TribeIndexItem MR_truncateAll];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - SCREEN_NAVHEIGHT - SCREEN_STATUSHEIGHT - SCREEN_TABHEIGHT)];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.tableView setDelegate:(id)self];
    [self.tableView setDataSource:(id)self];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self registerCellPrototype];
    [self addSubview:self.tableView];
    
    _refreshControl=[[RefreshControl alloc] initWithScrollView:self.tableView delegate:self];
    _refreshControl.topEnabled=YES;
    _refreshControl.bottomEnabled=YES;
    
    //增加发帖按钮
    float distance = 15.f;
    _writePostButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - WRITE_POST_BUTTON_SIZE - distance, SCREEN_HEIGHT - SCREEN_NAVHEIGHT - SCREEN_STATUSHEIGHT - SCREEN_TABHEIGHT - WRITE_POST_BUTTON_SIZE - distance, WRITE_POST_BUTTON_SIZE, WRITE_POST_BUTTON_SIZE)];
    [_writePostButton setImage:[UIImage imageNamed:@"tribe_writing_normal"] forState:UIControlStateNormal];
    [_writePostButton setImage:[UIImage imageNamed:@"tribe_writing_selected"] forState:UIControlStateSelected];
    [_writePostButton addTarget:self action:@selector(GotoPosting) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_writePostButton];
    
//    // 新功能提醒
//    _postMask = [[HNBTipMask alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    _postMask.delegate = self;
    
    // 界面搭建完毕
    [[HNBLoadingMask shareManager] loadingMaskWithSuperView:self loadingMaskType:LoadingMaskTypeNormal yoffset:0.0];
}

-(void)registerCellPrototype
{
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_HotTribeInIndexCell bundle:nil] forCellReuseIdentifier:cellNibName_HotTribeInIndexCell];
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_TribeIndexNoticeCell bundle:nil] forCellReuseIdentifier:cellNibName_TribeIndexNoticeCell];
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_RecommanRribeCell bundle:nil] forCellReuseIdentifier:cellNibName_RecommanRribeCell];
}

-(void) GotoPosting
{
     [[NSNotificationCenter defaultCenter] postNotificationName:TRIBE_INDEX_POST_NOTIFICATION object:nil];
}
#pragma mark 列表
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCellPtr;
    
    if(indexPath.row == EN_TRIBE_INDEX_TRIBE_TITLE)
    {
        TribeIndexNoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_TribeIndexNoticeCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTribeIndexNoticeInfo:@"热门圈子" HidenDesc:FALSE];
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
        returnCellPtr = cell;
    }
    else if(indexPath.row == EN_TRIBE_INDEX_HOT_TRIBE)
    {
        
        HotTribeInIndexTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_HotTribeInIndexCell];
        [cell setHotTirbeInfo:_hotTribes];
        //UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
        returnCellPtr = cell;
    }
    else if(indexPath.row == EN_TRIBE_INDEX_EMITY_ONE)
    {
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        returnCellPtr = cell;
    }
    else if(indexPath.row == EN_TRIBE_INDEX_POST_TITLE)
    {
        TribeIndexNoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_TribeIndexNoticeCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTribeIndexNoticeInfo:@"本周热贴" HidenDesc:TRUE];
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
        returnCellPtr = cell;
    }
    else if (indexPath.row >= EN_TRIBE_INDEX_POST)
    {
        TribeIndexItem * f = _hotPosts[indexPath.row - EN_TRIBE_INDEX_POST];
        RecommanRribeCell * cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_RecommanRribeCell];
        [cell setCellItemWithIndexTribeModel:f indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
        returnCellPtr = cell;
    }
    else
    {
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        returnCellPtr = cell;
    }
     
    return returnCellPtr;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return EN_TRIBE_INDEX_POST + _hotPosts.count ;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat tmpHeight = 168.0;
    if(indexPath.row == EN_TRIBE_INDEX_TRIBE_TITLE || indexPath.row == EN_TRIBE_INDEX_POST_TITLE)
    {
        tmpHeight = 32.0;
    }
    if(indexPath.row == EN_TRIBE_INDEX_EMITY_ONE)
    {
        tmpHeight = 10.0;
    }
    if (indexPath.row >= EN_TRIBE_INDEX_POST) {
        tmpHeight = 148.0;
    }
    return tmpHeight;
    
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TRIBE_INDEX_TABLE_CELL_SELECTED_NOTIFICATION object:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    return nil;
}

#pragma mark ------ TribeIndexMainManagerDelegate

- (void)completeDateThenReloadWithIndexPosts:(NSArray *)tribes totalPostCount:(NSInteger)totalPostCount hotTribesReqStatus:(BOOL)hotTribesReqStatus hotPostReqStatus:(BOOL)hotPostReqStatus{
    
    _hotTribes = [TribeIndexHotTribe MR_findAllSortedBy:@"timestamp" ascending:YES];
    _hotPosts = [TribeIndexItem MR_findAllSortedBy:@"timestamp" ascending:YES];
    [self.tableView reloadData];
    
    // 展示网络请求状态
    BOOL tmpReqAnd = hotTribesReqStatus & hotPostReqStatus;
    BOOL tmpReqOr = hotTribesReqStatus | hotPostReqStatus;
    if ((!tmpReqOr && _hotPosts.count <= 0) || !hotTribesReqStatus) {
        [self showMessageWhenReqNetError]; // 全部失败且数据库数据为空 / 热门圈子请求失败
    }else if (tmpReqAnd){
        [self showNewFunctionWriting]; // 全部成功
    }else{
        [self showHudWithMessage]; // 有请求失败
        [self showNewFunctionWriting];
    }
    [[HNBLoadingMask shareManager] dismiss];
    
}

- (void)completeDataThenReloadWithIndexTribes:(NSArray *)tribes tribePosts:(NSArray *)posts hotTribesReqStatus:(BOOL)hotTribesReqStatus hotPostReqStatus:(BOOL)hotPostReqStatus{
    
    _hotTribes = tribes;
    _hotPosts = posts;
    [self.tableView reloadData];
    
    // 展示网络请求状态
    BOOL tmpReqAnd = hotTribesReqStatus & hotPostReqStatus;
    BOOL tmpReqOr = hotTribesReqStatus | hotPostReqStatus;
    if ((!tmpReqOr && _hotPosts.count <= 0) || !hotTribesReqStatus) {
        [self showMessageWhenReqNetError]; // 全部失败且数据库数据为空 / 热门圈子请求失败
    }else if (tmpReqAnd){
        [self showNewFunctionWriting]; // 全部成功
    }else{
        [self showHudWithMessage]; // 有请求失败
        [self showNewFunctionWriting];
    }
    
    [[HNBLoadingMask shareManager] dismiss];
    
}


-(void)updateHotTribesWithHotTribesReqStatus:(BOOL)reqStatus{

    _hotTribes = [TribeIndexHotTribe MR_findAllSortedBy:@"timestamp" ascending:YES];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:EN_TRIBE_INDEX_HOT_TRIBE inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

}

- (void) completePostDateThenReloadWithBottomPostsWithReqStatus:(BOOL)reqStatus
{
    _hotPosts = [TribeIndexItem MR_findAllSortedBy:@"timestamp" ascending:YES];
    [self.tableView reloadData];
}

-(void)failReqDataTribeThenEndRefreshWithReqStatus:(BOOL)reqStatus{

    [self showHudWithMessage];
}

#pragma mark ------ RefreshControlDelegate

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{
    
    if (_hotPosts == 0) { // 后台没数据直接结束操作
        
        //NSLog(@" (_postAllCount == 0) ");
        
        return;
    }
    
    if (direction == RefreshDirectionTop) { // 顶部下拉刷新
        
        //NSLog(@" (direction == RefreshDirectionTop) ");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [TribeIndexItem MR_truncateAll];
            [_tribeManager getAllInfoInTribeIndex:refreshControl];
            [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
            [self.superController.navigationController setNavigationBarHidden:FALSE animated:TRUE];
            
        });
        
        return;
        
    } else if (direction == RefreshDirectionBottom){ // 底部上拉加载
        
        //NSLog(@" (direction == RefreshDirectionBottom) ");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tribeManager getDataThenReload:_refreshControl];
        });
        
    }
    
}

- (void)refreshScrollViewMoveFromTop:(CGFloat)topOffset
{
//    if (topOffset < -20) {
//        //隐藏导航栏和状态栏
//        //隐藏Status bar（状态栏）
//        [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
//        //隐藏NavigationBar（导航栏）
//        [self.superController.navigationController setNavigationBarHidden:TRUE animated:TRUE];
//    }
//    else
//    {
//        //显示导航栏和状态栏
//        [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
//        [self.superController.navigationController setNavigationBarHidden:FALSE animated:TRUE];
//    }
}

#pragma mark ------ 新功能提醒

- (void)showNewFunctionWriting{

    NSString *first_writing = [HNBUtils sandBoxGetInfo:[NSString class] forKey:tribeView_newFunction_writingpost];
    if (![first_writing isEqualToString:@"1"]) {
        
        [HNBUtils sandBoxSaveInfo:@"1" forKey:tribeView_newFunction_writingpost];
        
//        if (_postMask != nil) {
//            
//            CGFloat gap = 5.0 * SCREEN_WIDTHRATE_6;
//            CGRect locationRect = [self convertRect:_writePostButton.frame toView:nil];
//            CGPoint point = [self convertPoint:_writePostButton.center toView:nil];
//            locationRect.size.width += gap;
//            locationRect.size.height = locationRect.size.width;
//            locationRect.origin.x -= gap / 2.0;
//            locationRect.origin.y -= gap / 2.0;
//            
//            CGRect imgRect = CGRectZero;
//            imgRect.size.width = (324.0/2.0) * SCREEN_WIDTHRATE_6;
//            imgRect.size.height = (233.0/2.0) * SCREEN_WIDTHRATE_6;
//            imgRect.origin.x = SCREEN_WIDTH - gap * 4.0 - imgRect.size.width;
//            imgRect.origin.y = point.y - gap - locationRect.size.height/2.0 - imgRect.size.height;
//            _writingImgV = [[UIImageView alloc] initWithFrame:imgRect];
//            [_writingImgV setImage:[UIImage imageNamed:@"tribe_post_writing"]];
//            
//            _postMask.maskType = HNBTipMaskRoundType;
//            _postMask.superViewRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//            _postMask.holeRect = locationRect;
//            _postMask.opaque = NO;
//            _postMask.backgroundColor = [UIColor clearColor];
//            
//            [[UIApplication sharedApplication].keyWindow addSubview:_postMask];
//            [[UIApplication sharedApplication].keyWindow addSubview:_writingImgV];
//            
//        }
        
        CGFloat gap = 5.0 * SCREEN_WIDTHRATE_6;
        CGRect locationRect = [self convertRect:_writePostButton.frame toView:nil];
        CGPoint point = [self convertPoint:_writePostButton.center toView:nil];
        locationRect.size.width += gap;
        locationRect.size.height = locationRect.size.width;
        locationRect.origin.x -= gap / 2.0;
        locationRect.origin.y -= gap / 2.0;
        
        CGRect imgRect = CGRectZero;
        imgRect.size.width = (324.0/2.0) * SCREEN_WIDTHRATE_6;
        imgRect.size.height = (233.0/2.0) * SCREEN_WIDTHRATE_6;
        imgRect.origin.x = SCREEN_WIDTH - gap * 4.0 - imgRect.size.width;
        imgRect.origin.y = point.y - gap - locationRect.size.height/2.0 - imgRect.size.height;
        
        _postMask = [[FunctionTipView alloc] initWithHollowRectA:locationRect tipRectB:imgRect];
        _postMask.delegate = self;
        _postMask.shapeType = CircleType;
        _postMask.lineType = SolidLineType;
        _postMask.tipImageName = @"tribe_post_writing";
        [[UIApplication sharedApplication].keyWindow addSubview:_postMask];
        
    }
    
}

//-(void)touchEventOnView:(HNBTipMask *)tipView{
//
//    tipView.hidden = YES;
//    _writingImgV.hidden = YES;
//    
//}

-(void)functionTipView:(FunctionTipView *)tipView didTouchEvent:(UITouch *)touch{

    [tipView removeFromSuperview];
    
}

#pragma mark ------ 网络状况判断

- (void)showMessageWhenReqNetError{
    
    // 网络请求全部失败且无帖子数据 蒙版网络失败
    HNBNetRemindView *showFailNetReqView = [[HNBNetRemindView alloc] init];
    [showFailNetReqView loadWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_TABHEIGHT)
                            superView:self
                             showType:HNBNetRemindViewShowFailNetReq
                             delegate:self];
    
    
}

- (void)showHudWithMessage{
    
    // hub网络失败
    [[HNBToast shareManager] toastWithOnView:nil msg:@"网络请求有误" afterDelay:1.0 style:HNBToastHudFailure];
    
}

- (void)clickOnNetRemindView:(HNBNetRemindView *)remindView{

    [[HNBLoadingMask shareManager] loadingMaskWithSuperView:self loadingMaskType:LoadingMaskTypeNormal yoffset:0.0];
    
    switch (remindView.tag) {
        case HNBNetRemindViewShowPoorNet:
        {
            if ([HNBUtils isConnectionAvailable]) {
                
                [_tribeManager getAllInfoInTribeIndex:nil];
                [self initAfterGetData];
                [remindView removeFromSuperview];
                
            } else {
                
                [[HNBLoadingMask shareManager] dismiss];
                
            }
        }
            break;
        case HNBNetRemindViewShowFailNetReq:
        {
            [_tribeManager getAllInfoInTribeIndex:nil];
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
