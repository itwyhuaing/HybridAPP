//
//  QAIndexManager.m
//  hinabian
//
//  Created by 余坚 on 16/7/25.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "QAIndexManager.h"
#import "QASearchViewController.h"
#import "IMQuestionViewController.h"
#import "QAMainView.h"
#import "DataFetcher.h"
#import "QuestionIndexItem.h"
#import "QASpecialList.h"
#import "PersonalInfo.h"
#import "QuestionFilterItem.h"
#import "SWKQuestionShowViewController.h"
#import "SpecialListsViewController.h"
#import "IMAssessViewController.h"
#import "UserInfoController2.h"
#import "SWKQuestionTopicViewController.h"
#import "HNBNetRemindView.h"
#import "LoginViewController.h"
#import "IMAssessVC.h"

@interface QAIndexManager () <HNBNetRemindViewDelegate>

@property (strong, nonatomic) QAMainView * mainView;
@property (nonatomic) NSInteger num;
@property (nonatomic) NSInteger allPost;
@property (nonatomic) NSInteger start;
@property (nonatomic) NSInteger filternum;
@property (nonatomic) NSInteger filterallPost;
@property (nonatomic) NSInteger filterstart;
@property (strong, nonatomic) NSString * filterString;
@property (strong, nonatomic) NSArray * questionIndexItemArray;
@property (strong, nonatomic) NSArray * questionFilterItemArray;

@end
@implementation QAIndexManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        _questionIndexItemArray = [[NSArray alloc]  init];
        _questionFilterItemArray = [[NSArray alloc]  init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoAskQuestion) name:QA_INDEX_GOTO_ASK_QUESTION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoSearch) name:QA_INDEX_GOTO_SEARCH object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getQaIndexDataWithStart) name:QA_INDEX_REFRESH_BOTTOM object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getQaIndexDataThenReload) name:QA_INDEX_REFRESH_TOP object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getQaFilterDataWithStart) name:QA_INDEX_REFRESH_FILTER_BOTTOM object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterok:) name:QA_FILTER_OK_PREESED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filtercancel:) name:QA_FILTER_CANCEL_PREESED object:nil];      
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(specliaSelect:) name:QA_INDEX_SPECIAL_SELECT_ITEM object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(indexTableSelect:) name:QA_INDEX_SELECT_TABLE_ITEM object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterTableSelect:) name:QA_FILTER_SELECT_TABLE_ITEM object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(answerButtonPressed:) name:QA_SELECT_ANSWER_ID object:nil];
        
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QA_INDEX_GOTO_ASK_QUESTION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QA_INDEX_GOTO_SEARCH object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QA_INDEX_REFRESH_BOTTOM object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QA_INDEX_REFRESH_TOP object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QA_INDEX_REFRESH_FILTER_BOTTOM object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QA_FILTER_OK_PREESED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QA_FILTER_CANCEL_PREESED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QA_INDEX_SPECIAL_SELECT_ITEM object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QA_INDEX_SELECT_TABLE_ITEM object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QA_FILTER_SELECT_TABLE_ITEM object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QA_SELECT_ANSWER_ID object:nil];
}

- (void) initMainView
{
    _mainView = [[QAMainView alloc] initWithFrame:self.superController.view.frame];
    [self.superController.view addSubview:_mainView];
    
    [QuestionFilterItem MR_truncateAll];
    if ([HNBUtils isConnectionAvailable]) {
        
        [[HNBLoadingMask shareManager] loadingMaskWithSuperView:_mainView loadingMaskType:LoadingMaskTypeExtendTabBar yoffset:0.0];
        [self getQaIndexDataThenReload];
        
    }else{
        
        HNBNetRemindView *showPoorNetView = [[HNBNetRemindView alloc] init];
        [showPoorNetView loadWithFrame:CGRectMake(0, 0, _mainView.frame.size.width, _mainView.frame.size.height)
                             superView:_mainView
                              showType:HNBNetRemindViewShowPoorNet
                              delegate:self];
    
    }
    
    
}

- (void)getQaIndexDataThenReload
{
    [QuestionIndexItem MR_truncateAll];
    dispatch_group_t QAindexLoads = dispatch_group_create();
    dispatch_queue_t QAindexQueue = dispatch_queue_create("QAIndexQueue", DISPATCH_QUEUE_CONCURRENT);

    dispatch_group_enter(QAindexLoads);
    _start = 0;
    _num = 20;
    [DataFetcher doGetQAIndexQuestionList:_start GetNum:_num withSucceedHandler:^(id JSON) {
        dispatch_group_leave(QAindexLoads);
        _start += _num;
        id datajson = [JSON valueForKey:@"data"];
        NSString * tmptotalNum = [datajson valueForKey:@"totleNum"];
        _allPost = [tmptotalNum integerValue];
        if (_start >= _allPost) {
            /* 取消下拉刷新 */
            [_mainView setIndexViewBottomFresh:FALSE];
        }
        [_mainView setSearchPlaceHold:[NSString stringWithFormat:@"已有%ld个人在这里找到答案",(long)(_allPost*2.5)]];
        [_mainView stopIndexViewTopFresh];
        
    } withFailHandler:^(id error) {
        [self showMessageWhenReqNetError];
        [_mainView stopIndexViewTopFresh];
        dispatch_group_leave(QAindexLoads);
    }];
    
    /* 所有请求都完成后处理 */
    dispatch_group_notify(QAindexLoads, QAindexQueue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _questionIndexItemArray = [QuestionIndexItem MR_findAllSortedBy:@"timestamp" ascending:YES];
            [_mainView reloadQAIndexData];
            [[HNBLoadingMask shareManager] dismiss];
            
        });
        
    });
}

-(void)getQaIndexDataWithStart
{
    [DataFetcher doGetQAIndexQuestionList:_start GetNum:_num withSucceedHandler:^(id JSON) {
        [_mainView stopIndexViewBottomFresh];
        _start += _num;
        _questionIndexItemArray = [QuestionIndexItem MR_findAllSortedBy:@"timestamp" ascending:YES];
        [_mainView reloadQAIndexData];
        id datajson = [JSON valueForKey:@"data"];
        NSString * tmptotalNum = [datajson valueForKey:@"totleNum"];
        _allPost = [tmptotalNum integerValue];
        if (_start >= _allPost) {
            /* 取消下拉刷新 */
            [_mainView setIndexViewBottomFresh:FALSE];
        }
    } withFailHandler:^(id error) {
         [_mainView stopIndexViewBottomFresh];
    }];
}

-(void)getQaFilterDataWithStart
{
    [_mainView setFilterViewBottomFresh:TRUE];
    [DataFetcher doGetQAQuestionListByLabels:_filterString shoudInDatabase:TRUE Start:_filterstart GetNum:_filternum withSucceedHandler:^(id JSON) {
        _filterstart += _filternum;
        _questionFilterItemArray = [QuestionFilterItem MR_findAllSortedBy:@"timestamp" ascending:YES];
        [_mainView reloadQAIndexFilterData];
        id datajson = [JSON valueForKey:@"data"];
        NSString * tmptotalNum = [datajson valueForKey:@"totleNum"];
        _filterallPost = [tmptotalNum integerValue];
        if (_filterstart >= _filterallPost) {
            /* 取消下拉刷新 */
            [_mainView setFilterViewBottomFresh:FALSE];
        }
        else
        {
            [_mainView setFilterViewBottomFresh:TRUE];
        }
    } withFailHandler:^(id error) {
    }];
}

- (void)gotoAskQuestion
{
    [HNBClick event:@"108012" Content:nil];
    /* 是否登录  */
    if (![HNBUtils isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.superController.navigationController pushViewController:vc animated:YES];
        return;
    }
    IMQuestionViewController *vc = [[IMQuestionViewController alloc] init];
    [self.superController.navigationController pushViewController:vc animated:YES];
}

- (void)gotoSearch
{
    [HNBClick event:@"108011" Content:nil];
    QASearchViewController *vc = [[QASearchViewController alloc] init];
    [self.superController.navigationController pushViewController:vc animated:YES];
}

- (void)filterok:(NSNotification *)notification{
    [[HNBLoadingMask shareManager] loadingMaskWithSuperView:_mainView.secondView loadingMaskType:LoadingMaskTypeExtendTabBar yoffset:-44.0f];
    NSString*  labesString = [notification object];
    _filterString = labesString;
    _filterstart = 0;
    _filternum = 20;
    [QuestionFilterItem MR_truncateAll];
    [DataFetcher doGetQAQuestionListByLabels:labesString shoudInDatabase:TRUE Start:_filterstart GetNum:_filternum withSucceedHandler:^(id JSON) {
        _questionFilterItemArray = [QuestionFilterItem MR_findAllSortedBy:@"timestamp" ascending:YES];
        [_mainView reloadQAIndexFilterData];
        _filterstart += _filternum;
        id datajson = [JSON valueForKey:@"data"];
        NSString * tmptotalNum = [datajson valueForKey:@"totleNum"];
        _filterallPost = [tmptotalNum integerValue];
        NSLog(@"_filterallPost = %ld",_filterallPost);
        if (_filterstart >= _filterallPost) {
            /* 取消下拉刷新 */
            [_mainView setFilterViewBottomFresh:FALSE];
        }
        else
        {
            [_mainView setFilterViewBottomFresh:TRUE];
        }
        [[HNBLoadingMask shareManager] dismiss];
    } withFailHandler:^(id error) {
        [[HNBLoadingMask shareManager] dismiss];
    }];
}

- (void)filtercancel:(NSNotification *)notification{
    if ([_mainView isLabelSelectEmpty]) {
        /* 如果没选择跳回精选界面 */
        [_mainView choseSegmentView:0];
    }
    else
    {
        /* 有选择则隐藏 */
        [_mainView hideFilterView];
    }
    
}

- (void)indexTableSelect:(NSNotification *)notification
{
    NSInteger index = [[notification object] integerValue];
    if (EN_QA_INDEX_ASSESS == index) {
        [HNBClick event:@"108013" Content:nil];
        if([[HNBUtils sandBoxGetInfo:[NSString class] forKey:im_assess_type] isEqualToString:@"1"])    //原生
        {
            if (IOS_VERSION < 8.0) { // 版本低于 8.0 时调用 web页
                IMAssessViewController * vc = [[IMAssessViewController alloc] init]; // skiplow － web页
                vc.URL = [NSURL URLWithString:@"https://m.hinabian.com/assess.html"];
                [self.superController.navigationController pushViewController:vc animated:YES];
            } else {
                IMAssessVC *vc = [[IMAssessVC alloc] init];           // 原生化
                [self.superController.navigationController pushViewController:vc animated:YES];
            }
            
        }
        else
        {
            IMAssessViewController * vc = [[IMAssessViewController alloc] init]; // skiplow － web页
            vc.URL = [NSURL URLWithString:@"https://m.hinabian.com/assess.html"];
            [self.superController.navigationController pushViewController:vc animated:YES];
        }

    }
    else if (EN_QA_INDEX_RECOMMEND_ONE == index)
    {
        if (_questionIndexItemArray.count > 0) {
            QuestionIndexItem * f = _questionIndexItemArray[0];
            if ([f.type isEqualToString:@"question"]) {
                SWKQuestionShowViewController *vc = [[SWKQuestionShowViewController alloc] init];
                NSString *tmpurl = [NSString stringWithFormat:@"https://m.hinabian.com/qa_question/detail/%@",f.questionid];
                NSDictionary *dict = @{@"url" : tmpurl};
                [HNBClick event:@"108014" Content:dict];
                vc.URL = [[NSURL alloc] withOutNilString:tmpurl];
                [self.superController.navigationController pushViewController:vc animated:YES];
            }
            else if ([f.type isEqualToString:@"topics"])
            {
                NSString *tmpurl = [NSString stringWithFormat:@"https://m.hinabian.com/qa_question/specialSubject?subject_id=%@",f.questionid];
                NSDictionary *dict = @{@"url" : tmpurl};
                [HNBClick event:@"108014" Content:dict];
                SWKQuestionTopicViewController *vc = [[SWKQuestionTopicViewController alloc] init];
                vc.URL = [[NSURL alloc] withOutNilString:tmpurl];
                [self.superController.navigationController pushViewController:vc animated:YES];
            }
        }

    }
    else if (EN_QA_INDEX_RECOMMEND_TWO == index)
    {
        if (_questionIndexItemArray.count > 1) {
            QuestionIndexItem * f = _questionIndexItemArray[1];
            if ([f.type isEqualToString:@"question"]) {
                SWKQuestionShowViewController *vc = [[SWKQuestionShowViewController alloc] init];
                NSString *tmpurl = [NSString stringWithFormat:@"https://m.hinabian.com/qa_question/detail/%@",f.questionid];
                NSDictionary *dict = @{@"url" : tmpurl};
                [HNBClick event:@"108014" Content:dict];
                vc.URL = [[NSURL alloc] withOutNilString:tmpurl];
                [self.superController.navigationController pushViewController:vc animated:YES];
            }
            else if ([f.type isEqualToString:@"topics"])
            {
                NSString *tmpurl = [NSString stringWithFormat:@"https://m.hinabian.com/qa_question/specialSubject?subject_id=%@",f.questionid];
                NSDictionary *dict = @{@"url" : tmpurl};
                [HNBClick event:@"108014" Content:dict];
                SWKQuestionTopicViewController *vc = [[SWKQuestionTopicViewController alloc] init];
                vc.URL = [[NSURL alloc] withOutNilString:tmpurl];
                [self.superController.navigationController pushViewController:vc animated:YES];
            }
        }
    }
    else if (EN_QA_INDEX_MORE_SPECIAL == index)
    {
        [HNBClick event:@"108018" Content:nil];
        SpecialListsViewController * vc = [[SpecialListsViewController alloc] init];
        [self.superController.navigationController pushViewController:vc animated:YES];
    }
    else if (EN_QA_INDEX_SPECIAL_LIST == index)
    {
        
    }
    else if (EN_QA_INDEX_NULL == index)
    {
       
    }
    else
    {
        if (_questionIndexItemArray.count > (index - EN_QA_INDEX_NULL + 1)) {
            QuestionIndexItem * f = _questionIndexItemArray[index - EN_QA_INDEX_NULL + 1];
            if ([f.type isEqualToString:@"question"]) {
                SWKQuestionShowViewController *vc = [[SWKQuestionShowViewController alloc] init];
                NSString *tmpurl = [NSString stringWithFormat:@"https://m.hinabian.com/qa_question/detail/%@",f.questionid];
                NSDictionary *dict = @{@"url" : tmpurl};
                [HNBClick event:@"108016" Content:dict];
                vc.URL = [[NSURL alloc] withOutNilString:tmpurl];
                [self.superController.navigationController pushViewController:vc animated:YES];
            }
            else if ([f.type isEqualToString:@"topics"])
            {
                NSString *tmpurl = [NSString stringWithFormat:@"https://m.hinabian.com/qa_question/specialSubject?subject_id=%@",f.questionid];
                NSDictionary *dict = @{@"url" : tmpurl};
                [HNBClick event:@"108016" Content:dict];
                SWKQuestionTopicViewController *vc = [[SWKQuestionTopicViewController alloc] init];
                vc.URL = [[NSURL alloc] withOutNilString:tmpurl];
                [self.superController.navigationController pushViewController:vc animated:YES];
            }

        }
    }
}

- (void)filterTableSelect:(NSNotification *)notification
{
    NSInteger index = [[notification object] integerValue];
    if (index < _questionFilterItemArray.count) {
        QuestionFilterItem * f = _questionFilterItemArray[index];
        SWKQuestionShowViewController *vc = [[SWKQuestionShowViewController alloc] init];
        NSString *tmpurl = [NSString stringWithFormat:@"https://m.hinabian.com/qa_question/detail/%@",f.questionid];
        vc.URL = [[NSURL alloc] withOutNilString:tmpurl];
        [self.superController.navigationController pushViewController:vc animated:YES];
    }

}

- (void)specliaSelect:(NSNotification *)notification
{
    NSString * id = [notification object];
    NSDictionary *dict = @{@"url" : id};
    [HNBClick event:@"108015" Content:dict];
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
    if (tmpPersonalInfoArry.count != 0) {
        UserInfo = tmpPersonalInfoArry[0];
    }
    
    if (![UserInfo.id isEqualToString:id] || UserInfo == NULL)
    {
        UserInfoController2 * vc = [[UserInfoController2 alloc] init];
        vc.personid = id;
        [self.superController.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        
    }

}

- (void)answerButtonPressed:(NSNotification *)notification
{
    NSString * id = [notification object];
    UserInfoController2 * vc = [[UserInfoController2 alloc] init];
    vc.personid = id;
    [self.superController.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------ 网络状况 

- (void)showMessageWhenReqNetError{
    
    // 网络请求全部失败且无帖子数据 蒙版网络失败
    HNBNetRemindView *showFailNetReqView = [[HNBNetRemindView alloc] init];
    [showFailNetReqView loadWithFrame:CGRectMake(0, 0, _mainView.frame.size.width, _mainView.frame.size.height)
                            superView:_mainView
                             showType:HNBNetRemindViewShowFailNetReq
                             delegate:self];
    
    
}


- (void)clickOnNetRemindView:(HNBNetRemindView *)remindView{

    switch (remindView.tag) {
        case HNBNetRemindViewShowPoorNet:
        {
            if ([HNBUtils isConnectionAvailable]) {
            
                [remindView removeFromSuperview];
                [self getQaIndexDataThenReload];
                [[HNBLoadingMask shareManager] loadingMaskWithSuperView:_mainView loadingMaskType:LoadingMaskTypeExtendTabBar yoffset:0.0];
                
            }
        }
            break;
        case HNBNetRemindViewShowFailNetReq:
        {
            
            [remindView removeFromSuperview];
            [self getQaIndexDataThenReload];
            [[HNBLoadingMask shareManager] loadingMaskWithSuperView:_mainView loadingMaskType:LoadingMaskTypeExtendTabBar yoffset:0.0];
            
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
