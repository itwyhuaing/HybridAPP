//
//  UserInfoMainView.m
//  hinabian
//
//  Created by hnbwyh on 16/7/22.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "UserInfoMainView.h"
#import "UserQAView.h"
#import "hnbSegmentedView.h"
#import "UserPostView.h"
#import "UserReplyView.h"
#import "UserHeaderView2.h"
#import "UserBriefInfoView.h"
#import "UserInfoMainManager.h"
#import "PersonInfoModel.h"
#import "HNBNetRemindView.h"
#import "HNBToast.h"

#define moreBasicInfoHeight 35.f



@interface UserInfoMainView () <UIScrollViewDelegate,UserReplyViewDelegate,UserPostViewDelegate,UserQAViewDelegate,UserInfoMainManagerDelegate,HNBNetRemindViewDelegate>

@property (nonatomic) CGRect tmpFrame;
@property (nonatomic) CGFloat headerHeight;
@property (nonatomic) CGFloat userBriefInfoHeight;
@property (nonatomic) CGFloat verticalGap;
@property (nonatomic) CGFloat tribeAndqaBtnHeight;
@property (nonatomic) NSInteger countPerReq;
@property (nonatomic,strong) UIViewController *superVC;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *moreBasicInfoView;
@property (nonatomic,strong) UIView *askButtonBackView;
@property (nonatomic,strong) UserPostView *userPostView;
@property (nonatomic,strong) UserReplyView *userReplyView;
@property (nonatomic,strong) UserQAView *userQAView;
@property (nonatomic,strong) hnbSegmentedView *segmentedview;
@property (nonatomic,strong) UserHeaderView2 *headView;
@property (nonatomic,strong) UserBriefInfoView *briefInfoView;
@property (nonatomic,strong) PersonInfoModel *personModel;

@property (nonatomic,copy) NSString *personid;
@property (nonatomic,copy) NSString *personType; // 区分专家或个人
@property (nonatomic,copy) NSString *personName; // 名字
@property (nonatomic,copy) NSString *personCertified; // 是否为认证用户

@end

@implementation UserInfoMainView

-(instancetype)initWithFrame:(CGRect)frame personid:(NSString *)personid superVC:(UIViewController *)superVC{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor DDR245_G245_B245ColorWithalph:1.0];//[UIColor beigeColor];
        _superVC = superVC;
        _personid = personid;
        _tmpFrame = frame;
        
//        _headerHeight = 195.0;
        _headerHeight = 163.0;
        _userBriefInfoHeight = 60.0;
        _verticalGap = 10.0;
        _tribeAndqaBtnHeight = 36.0;
        _countPerReq = 10;
        
        _mainMnager = [[UserInfoMainManager alloc] init];
        _mainMnager.delegate = self;
        _mainMnager.superVC = superVC;
        _mainMnager.personid = personid;
        
        _briefInfoView = [[UserBriefInfoView alloc] init];
    
        if (![HNBUtils isConnectionAvailable]) {
            
            HNBNetRemindView *showPoorNetView = [[HNBNetRemindView alloc] init];
            [showPoorNetView loadWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-SCREEN_STATUSHEIGHT - SCREEN_NAVHEIGHT) superView:self showType:HNBNetRemindViewShowPoorNet delegate:self];
            
        } else {
            
            [_mainMnager reqPersonalOrSpecialInfoAndHisTribeDataWithID:personid count:_countPerReq];
            
            [[HNBLoadingMask shareManager] loadingMaskWithSuperView:self loadingMaskType:LoadingMaskTypeExtendTabBar yoffset:0.0];
            
        }
        
    }
    return self;
    
}

- (void)loadViewWithFame:(CGRect)frame{
    
    CGRect rect = frame;
    rect.size.height = _headerHeight;
    
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"UserHeaderView2" owner:self options:nil];
    
    _headView = [nibs objectAtIndex:0];
    _headView.backgroundColor = [UIColor DDNavBarBlue];
    [_headView setFrame:rect];
    
    rect.origin.y = CGRectGetMaxY(_headView.frame) + _verticalGap;
    rect.size.height = _userBriefInfoHeight;
    _briefInfoView = [[UserBriefInfoView alloc]initWithFrame:rect];
//    NSArray *nibs_brief = [[NSBundle mainBundle] loadNibNamed:@"UserBriefInfoView" owner:self options:nil];
//    _briefInfoView = [nibs_brief objectAtIndex:0];
//    [_briefInfoView setFrame:rect];
    
    rect.origin.y = CGRectGetMaxY(_briefInfoView.frame) + 1;//+1显示背景颜色的分割线
    rect.size.height = moreBasicInfoHeight;
    [self.moreBasicInfoView setFrame:rect];
    
    rect.origin.y = CGRectGetMaxY(_moreBasicInfoView.frame) + _verticalGap;
    rect.size.height = _tribeAndqaBtnHeight;
    
    /** APP 3.0 移除问答
     _segmentedview = [[hnbSegmentedView alloc] initWithFrame:rect titles:@[@"发帖",@"回帖",@"TA的问答"] clickBlick:^(NSInteger index) {
     [self clickToChooseLocation:index];
     }];

     */
    _segmentedview = [[hnbSegmentedView alloc] initWithFrame:rect titles:@[@"发帖",@"回帖"] clickBlick:^(NSInteger index) {
        [self clickToChooseLocation:index];
    }];
    
    _segmentedview.x_0ffset = 40 * SCREEN_WIDTHRATE_6;
    _segmentedview.titleNomalColor=[UIColor colorWithRed:78.0/255.0f green:78.0/255.0f blue:78.0/255.0f alpha:1.0f];
    _segmentedview.titleSelectColor=[UIColor DDNavBarBlue];
    _segmentedview.normalLineHeight = 0.3;
    [_segmentedview setIsRoundCorner:YES];
    rect.origin.y = CGRectGetMaxY(_segmentedview.frame);
    rect.size.height = frame.size.height - CGRectGetMaxY(_segmentedview.frame);
    _scrollView = [[UIScrollView alloc] initWithFrame:rect];
//    _scrollView.contentSize = CGSizeMake(rect.size.width * 3.0, rect.size.height);
    _scrollView.contentSize = CGSizeMake(rect.size.width * 2.0, rect.size.height);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    
    /*发帖*/
    rect.origin.y = 0.f;
    rect.origin.x = 0.f;
    rect.size.width = SCREEN_WIDTH;
    _userPostView = [[UserPostView alloc] initWithFrame:rect personid:_personid superVC:_superVC];
    _userPostView.delegate = self;
    _userPostView.countPerReq = _countPerReq;
    
    /*回帖*/
    rect.origin.x = frame.size.width;
    rect.origin.y = 0.f;
    _userReplyView = [[UserReplyView alloc] initWithFrame:rect personid:_personid superVC:_superVC];
    _userReplyView.delegate = self;
    _userReplyView.countPerReq = _countPerReq;
    
    /*问答*/
    rect.origin.x = frame.size.width * 2;
    rect.origin.y = 0.f;
    _userQAView = [[UserQAView alloc] initWithFrame:rect personid:_personid superVC:_superVC];
    _userQAView.delegate = self;
    _userQAView.countPerReq = _countPerReq;
    
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = 64.0 * SCREEN_WIDTHRATE_6;
    rect.origin.x = 0.f;
    rect.origin.y = frame.size.height - rect.size.height;
    _askButtonBackView = [[UIView alloc] initWithFrame:rect];
    _askButtonBackView.backgroundColor = [UIColor whiteColor];
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1.0)];
    lineLabel.backgroundColor = [UIColor DDR238_G238_B238ColorWithalph:1.0];
    rect.origin.x = 10.0 * SCREEN_WIDTHRATE_6;
    rect.origin.y = 10.0 * SCREEN_WIDTHRATE_6;
    rect.size.width = CGRectGetWidth(_askButtonBackView.frame) - 2 * rect.origin.x;
    rect.size.height = CGRectGetHeight(_askButtonBackView.frame) - 2 * rect.origin.y;
    UIButton *askButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    askButton.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0;
    [askButton setFrame:rect];
    [askButton setBackgroundColor:[UIColor DDNavBarBlue]];
    [askButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [askButton setTitle:@"向TA提问" forState:UIControlStateNormal];
    [askButton addTarget:self action:@selector(askQuestion:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:_userPostView];
    [_scrollView addSubview:_userReplyView];
    [_scrollView addSubview:_userQAView];
    [_askButtonBackView addSubview:lineLabel];
    [_askButtonBackView addSubview:askButton];
    
    [self addSubview:_headView];
    [self addSubview:_briefInfoView];
    [self addSubview:_moreBasicInfoView];
    [self addSubview:_segmentedview];
    [self addSubview:_scrollView];
    [self addSubview:_askButtonBackView];
    // 界面搭建完毕
}

#pragma mark ------ clickEvent

- (void)clickToChooseLocation:(NSInteger)location{

    // 统计代码
    if ([_personType isEqualToString:@"normal"] && location == 1) {
        [HNBClick event:@"105030" Content:nil];
    } else if ([_personType isEqualToString:@"normal"] && location == 2){
        [HNBClick event:@"105031" Content:nil];
    }else if ([_personType isEqualToString:@"normal"] && location == 3){
        [HNBClick event:@"105024" Content:nil];
    }if (![_personType isEqualToString:@"normal"] && location == 1) {
        [HNBClick event:@"126021" Content:nil];
    } else if (![_personType isEqualToString:@"normal"] && location == 2){
        [HNBClick event:@"126022" Content:nil];
    }else if (![_personType isEqualToString:@"normal"] && location == 3){
        [HNBClick event:@"126005" Content:nil];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * (location - 1), 0) animated:YES];
    [self handleViewAtLocation:location];
}

- (void)askQuestion:(UIButton *)btn{

    if (_personName.length <= 0) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:USERINFO_SPECIALIST_ASKBUTTON object:_personName];
}


- (void)handleViewAtLocation:(NSInteger)location{
    
        if (location == 1) {
    
            self.userQAView.hidden = YES;
            self.userReplyView.hidden  = YES;
            self.userPostView.hidden  = NO;
        }
        else if (location == 2){
            self.userQAView.hidden = YES;
            self.userReplyView.hidden  = NO;
            self.userPostView.hidden  = YES;
        }
        else if (location == 3){
    
            self.userQAView.hidden = NO;
            self.userReplyView.hidden  = YES;
            self.userPostView.hidden  = YES;
        }
        else{

        }

//    if (location == 1 && _userPostView.postSource.count <= 0) {
//        
//        [_userPostView.hisPostManager requestUserinfoHisPostViewDataWithStart:0 getCount:_countPerReq];
//    }
//    else if (location == 2 && _userReplyView.replySource.count <= 0){
//        [_userReplyView.hisReplyManager requestUserinfoHisReplyViewDataWithStart:0 getCount:_countPerReq];
//    }
//    else if (location == 3 && _userQAView.dataSource.count <= 0){
//        
//        [_userQAView.qaManager requestUserinfoQADataWithStart:0 getCount:_countPerReq];
//    }
//    else if (location == 1 && _userPostView.postSource.count <= 0){
//    
//        [_userPostView.tableView reloadData];
//    }
//    else{
//        [_userReplyView.tableView reloadData];
//        [_userQAView.tableView reloadData];
//    }
    
    
}

-(void)moreBasicInfoEvent{
    [[NSNotificationCenter defaultCenter] postNotificationName:USERINFO_BRIEFINFOBUTTON object:_personModel];
}

#pragma mark ------ UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    int page = (int)round(scrollView.contentOffset.x / scrollView.frame.size.width);
    [_segmentedview setIndex:page];
    [self handleViewAtLocation:(long)(page+1)];
}


#pragma mark ------ UserPostViewDelegate,UserReplyViewDelegate,UserQAViewDelegate

- (void)scrollUserPostView:(UserPostView *)userPostView resetFrameWithYOffset:(CGFloat)yOffset{
    
    if (yOffset > 0 && _headView.frame.origin.y == 0) { // 上推得条件
        
        [self animationMoveResetFrameWithOffset:-(_headerHeight + moreBasicInfoHeight + _userBriefInfoHeight + 2.0 * _verticalGap)];
        
        
    } else if (yOffset < 0 && _headView.frame.origin.y == -(_headerHeight + moreBasicInfoHeight + _userBriefInfoHeight + 2.0 * _verticalGap)){ // 下拉条件
        
        [self animationMoveResetFrameWithOffset:(_headerHeight + moreBasicInfoHeight + _userBriefInfoHeight + 2.0 * _verticalGap)];
        
        
    }else{
        
        _userPostView.tableView.scrollEnabled = YES;
        
    }
    
}

- (void)scrollUserReplyView:(UserReplyView *)userReplyView resetFrameWithYOffset:(CGFloat)yOffset{
    
    if (yOffset > 0 && _headView.frame.origin.y == 0) { // 上推得条件
        
        [self animationMoveResetFrameWithOffset:-(_headerHeight + moreBasicInfoHeight + _userBriefInfoHeight + 2.0 * _verticalGap)];
        
        
    } else if (yOffset < 0 && _headView.frame.origin.y == -(_headerHeight + moreBasicInfoHeight + _userBriefInfoHeight + 2.0 * _verticalGap)){ // 下拉条件
        
        [self animationMoveResetFrameWithOffset:(_headerHeight + moreBasicInfoHeight + _userBriefInfoHeight + 2.0 * _verticalGap)];
        
    }else{
        
        _userReplyView.tableView.scrollEnabled = YES;
        
    }
    
}

- (void)scrollUserQAView:(UserQAView *)UserQAView resetFrameWithYOffset:(CGFloat)yOffset{

    ///NSLog(@" scrollUserQAView ------ > %f",yOffset);
    
    if (yOffset > 0 && _headView.frame.origin.y == 0) { // 上推得条件
        
        [self animationMoveResetFrameWithOffset:-(_headerHeight + moreBasicInfoHeight + _userBriefInfoHeight + 2.0 * _verticalGap)];
        
        
    } else if (yOffset < 0 && _headView.frame.origin.y == -(_headerHeight + moreBasicInfoHeight + _userBriefInfoHeight + 2.0 * _verticalGap)){ // 下拉条件
        
        [self animationMoveResetFrameWithOffset:(_headerHeight + moreBasicInfoHeight + _userBriefInfoHeight + 2.0 * _verticalGap)];
        
    }else{
        
        _userQAView.tableView.scrollEnabled = YES;
        
    }
    
}

- (void)animationMoveResetFrameWithOffset:(CGFloat)offset{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect = _headView.frame;
        rect.origin.y += offset;
        [_headView setFrame:rect];
        
        rect = _briefInfoView.frame;
        rect.origin.y += offset;
        [_briefInfoView setFrame:rect];
        
        rect = _moreBasicInfoView.frame;
        rect.origin.y += offset;
        [_moreBasicInfoView setFrame:rect];
        
        rect = _segmentedview.frame;
        rect.origin.y += offset;
        [_segmentedview setFrame:rect];
        
        rect = _scrollView.frame;
        rect.size.height -= offset;
        rect.origin.y += offset;
        [_scrollView setFrame:rect];
        
        rect = _userPostView.frame;
        rect.origin.y = 0;
        rect.origin.x = 0;
        rect.size.height -= offset;
        [_userPostView setFrame:rect];
        
        rect = _userPostView.tableView.frame;
        rect.origin.y = 0;
        rect.origin.x = 0;
        rect.size.height -= offset;
        [_userPostView.tableView setFrame:rect];
        
        rect = _userReplyView.frame;
        rect.origin.y = 0;
        rect.size.height -= offset;
        [_userReplyView setFrame:rect];
        
        rect = _userReplyView.tableView.frame;
        rect.origin.y = 0;
        rect.origin.x = 0;
        rect.size.height -= offset;
        [_userReplyView.tableView setFrame:rect];
        
        rect = _userQAView.frame;
        rect.origin.y = 0;
        rect.size.height -= offset;
        [_userQAView setFrame:rect];
        
        rect = _userQAView.tableView.frame;
        rect.origin.y = 0;
        rect.origin.x = 0;
        rect.size.height -= offset;
        [_userQAView.tableView setFrame:rect];
        
    } completion:^(BOOL finished) {

        _userPostView.tableView.scrollEnabled = YES;
        _userReplyView.tableView.scrollEnabled = YES;
        _userQAView.tableView.scrollEnabled = YES;
    }];
    
}

- (void)hiddenTheAskButtonWhenScrollUserPostView:(UserPostView *)userPostView{
    
    if (![_personType isEqualToString:@"normal"]) { // 专家
        _askButtonBackView.hidden = YES;
    }
    
}

- (void)hiddenTheAskButtonWhenScrollUserReplyView:(UserReplyView *)userReplyView{
    
    if (![_personType isEqualToString:@"normal"]) { // 专家
        _askButtonBackView.hidden = YES;
    }
    
}

-(void)showTheAskButtonWhenEndRefreshScrollUserPostView:(UserPostView *)userPostView{
    
    if (![_personType isEqualToString:@"normal"]) { // 专家
        _askButtonBackView.hidden = NO;
    }
    
}

-(void)showTheAskButtonWhenEndRefreshScrollUserReplyView:(UserReplyView *)userReplyView{
    
    if (![_personType isEqualToString:@"normal"]) { // 专家
        _askButtonBackView.hidden = NO;
    }
    
}

- (void)hiddenTheAskButtonWhenScrollUserQAView:(UserQAView *)userQAView{

    if (![_personType isEqualToString:@"normal"]) { // 专家
        _askButtonBackView.hidden = YES;
    }
    
}

-(void)showTheAskButtonWhenEndRefreshScrollUserQAView:(UserQAView *)userQAView{

    if (![_personType isEqualToString:@"normal"]) { // 专家
        _askButtonBackView.hidden = NO;
    }
    
}

#pragma mark ------ UserInfoMainManagerDelegate

-(void)completeDataThenRefreshViewWithPersonInfo:(PersonInfoModel *)pModel hisTribePosts:(NSArray *)posts personInfoReqStatus:(BOOL)personInfoReqStatus hisTribeReqStatus:(BOOL)hisTribeReqStatus
{
    // 网络请求结果判断
    BOOL andBool = personInfoReqStatus & hisTribeReqStatus;
    BOOL orBool = personInfoReqStatus | hisTribeReqStatus;
    // 用户不存在
    if (pModel.errrormsg != nil) {
        // 用户不存在
        HNBNetRemindView *showFailToShowTipView = [[HNBNetRemindView alloc] init];
        [showFailToShowTipView loadWithFrame:CGRectMake(0, 0, _tmpFrame.size.width,_tmpFrame.size.height) superView:self showType:HNBNetRemindViewShowFailToShowTip delegate:self];
        [showFailToShowTipView setTipWithMsg:[NSString stringWithFormat:@"%@,点击返回",pModel.errrormsg] subStringArray:@[@"点击"]];
        
    } else {
        
        if (andBool) {
            
        } else if (!orBool){
            [self showMessageWhenReqNetError];
        }else{
            [self showHudWithMessage];
        }
    }
    
    //是否有认证
    _personCertified = pModel.certified;
    
    [_briefInfoView setHeightWithInfo:pModel.introduce];
    
    if (_briefInfoView.needNextLine) {
        _userBriefInfoHeight = 60.f;
    }else{
        _userBriefInfoHeight = 44.f;
    }
    
    [self loadViewWithFame:_tmpFrame];
    
    //底部提问按钮是否隐藏
    _personType = pModel.type;
    _personName = pModel.name;
    _personModel = pModel;
    _mainMnager.personType = _personType;
    if ([_personType isEqualToString:@"normal"]) {
        _askButtonBackView.hidden = YES;
        if (self.modifyShareBtn) {
            self.modifyShareBtn(NO,pModel);
        }
    }else{
        _askButtonBackView.hidden = NO;
        if (self.modifyShareBtn) {
            self.modifyShareBtn(YES,pModel);
        }
    }
    
    [_headView setUserHeaderViewWithInfo:pModel];
    [_briefInfoView setUserBriefInfoViewWithInfo:pModel];
    
    [_userPostView getDataSource:posts];
    [[HNBLoadingMask shareManager] dismiss];
    
    //消失后再请求非首屏显示的数据
    [_userReplyView.hisReplyManager requestUserinfoHisReplyViewDataWithStart:0 getCount:_countPerReq];
    [_userReplyView.tableView reloadData];
    
    
    /** APP 3.0 移除问答
     [_userQAView.qaManager requestUserinfoQADataWithStart:0 getCount:_countPerReq];
     [_userQAView.tableView reloadData];

     */
    [self setSegmentedviewTitlesWithModel:pModel];
}

- (void)completePersonInfoDataThenRefreshTheViewWithData:(PersonInfoModel *)pModel{

    [_headView setUserHeaderViewWithInfo:pModel];
    
    
    if ([_personType isEqualToString:@"normal"]) {
        _askButtonBackView.hidden = YES;
        if (self.modifyShareBtn) {
            self.modifyShareBtn(NO,pModel);
        }
    }else{
        _askButtonBackView.hidden = NO;
        if (self.modifyShareBtn) {
            self.modifyShareBtn(YES,pModel);
        }
    }
    
}

- (void)failToReqPersonInfoData{

    [self showHudWithMessage];
    
}

// 获取数据之后重置按钮标题
- (void)setSegmentedviewTitlesWithModel:(PersonInfoModel *)model{
    NSString *postNumTitle;
    NSString *replyNumTitle;
    //NSString *qaNumTitle;
    
    NSInteger postNum   = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:userinfo_hisPost_total] integerValue];
    NSInteger replyNum  = ([model.tribenum integerValue] - [[HNBUtils sandBoxGetInfo:[NSString class] forKey:userinfo_hisPost_total] integerValue]);
//    NSInteger replyNum =  [[HNBUtils sandBoxGetInfo:[NSString class] forKey:userinfo_hisReply_total] integerValue];
    //NSInteger qaNum     = [model.qanum integerValue];
    
    if (postNum >= 99) {
        postNumTitle = [NSString stringWithFormat:@"发帖 99+"];
    }else{
        postNumTitle = [NSString stringWithFormat:@"发帖 %ld",(long)postNum];
    }
    if (replyNum >= 99) {
        replyNumTitle = [NSString stringWithFormat:@"回帖 99+"];
    }else{
       replyNumTitle = [NSString stringWithFormat:@"回帖 %ld",(long)replyNum];
    }
    /** APP 3.0 移除 问答
    if (qaNum >= 99) {
        qaNumTitle = [NSString stringWithFormat:@"问答 99+"];
    }else{
        qaNumTitle = [NSString stringWithFormat:@"问答 %ld",(long)qaNum];
    }
    
     [_segmentedview setItemsWithTitles:@[postNumTitle,replyNumTitle,qaNumTitle]];
     */
    [_segmentedview setItemsWithTitles:@[postNumTitle,replyNumTitle]];
}

#pragma mark - 网络异常提醒

- (void)showMessageWhenReqNetError{
    
    // 网络请求全部失败 蒙版网络失败
    HNBNetRemindView *showFailNetReqView = [[HNBNetRemindView alloc] init];
    [showFailNetReqView loadWithFrame:CGRectMake(0, 0, _tmpFrame.size.width,_tmpFrame.size.height) superView:self showType:HNBNetRemindViewShowFailNetReq delegate:self];
}

- (void)showHudWithMessage{
    
    // hub网络失败
    [[HNBToast shareManager] toastWithOnView:nil msg:@"网络请求有误" afterDelay:1.0 style:HNBToastHudFailure];
    
}


-(void)clickOnNetRemindView:(HNBNetRemindView *)remindView{

    
    switch (remindView.tag) {
        case HNBNetRemindViewShowPoorNet:
        {
        
            if ([HNBUtils isConnectionAvailable]) {
                
                [remindView removeFromSuperview];
                [_mainMnager reqPersonalOrSpecialInfoAndHisTribeDataWithID:_personid count:_countPerReq];
                [self loadViewWithFame:_tmpFrame];

            }
            
        }
            break;
        case HNBNetRemindViewShowFailNetReq:
        {
    
            [remindView removeFromSuperview];
            [_mainMnager reqPersonalOrSpecialInfoAndHisTribeDataWithID:_personid count:_countPerReq];
            
        }
            break;
        case HNBNetRemindViewShowFailToShowTip:
        {
            [_superVC.navigationController popViewControllerAnimated:YES];
            //[remindView removeFromSuperview];
            
        }
            break;
        default:
            break;
    }
    

}

-(UIView *)moreBasicInfoView
{
    if (!_moreBasicInfoView) {
        _moreBasicInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, moreBasicInfoHeight)];
        _moreBasicInfoView.backgroundColor = [UIColor whiteColor];
        UILabel * centerLabel = [[UILabel alloc] initWithFrame:_moreBasicInfoView.frame];
        [centerLabel setTextAlignment:NSTextAlignmentCenter];
        [centerLabel setTextColor:[UIColor colorWithRed:140.f/255.f green:140.f/255.f blue:140.f/255.f alpha:1.f]];
        [centerLabel setText:@"更多基本资料"];
        [centerLabel setFont:[UIFont systemFontOfSize:12.f]];
        
        UIButton *eventButton = [[UIButton alloc] initWithFrame:_moreBasicInfoView.frame];
        [eventButton addTarget:self action:@selector(moreBasicInfoEvent) forControlEvents:UIControlEventTouchUpInside];
        
        [_moreBasicInfoView addSubview:centerLabel];
        [_moreBasicInfoView addSubview:eventButton];
    }
    return _moreBasicInfoView;
}

@end
