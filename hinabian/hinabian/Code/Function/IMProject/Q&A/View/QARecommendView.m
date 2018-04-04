//
//  QARecommendView.m
//  hinabian
//
//  Created by 余坚 on 16/7/25.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "QARecommendView.h"
#import "QAHomeQuestionCell.h"
#import "QuestionIndexItem.h"
#import "QASpeciaListView.h"
#import "QASpecialList.h"
#import "IMAssessNoticeTableViewCell.h"
#import "MoreSpecialsTableViewCell.h"
#import "QAHomeTopicCell.h"
#import "QuestionIndexItem.h"


@interface QARecommendView ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,RefreshControlDelegate>
@property (nonatomic,strong) NSArray *dataSource;

@end

@implementation QARecommendView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self loadViewWithFame:frame];
        
    }
    return self;
}

- (void)loadViewWithFame:(CGRect)frame{
    
    CGRect rect = frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = (id)self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor beigeColor];
    [_tableView registerNib:[UINib nibWithNibName:cellNilName_QAHomeQuestionCell bundle:nil] forCellReuseIdentifier:cellNilName_QAHomeQuestionCell];
    [_tableView registerNib:[UINib nibWithNibName:cellNilName_IMAssessNoticeTableViewCell bundle:nil] forCellReuseIdentifier:cellNilName_IMAssessNoticeTableViewCell];
    [_tableView registerNib:[UINib nibWithNibName:cellNilName_MoreSpecialsTableViewCell bundle:nil] forCellReuseIdentifier:cellNilName_MoreSpecialsTableViewCell];
    [_tableView registerNib:[UINib nibWithNibName:cellNib_QAHomeTopicCell bundle:nil] forCellReuseIdentifier:cellNib_QAHomeTopicCell];
    [self addSubview:_tableView];
    
    _refreshControl=[[RefreshControl alloc] initWithScrollView:_tableView delegate:(id)self];
    _refreshControl.bottomEnabled=YES;
    _refreshControl.topEnabled=YES;
    
}

/* 重新加载 */
- (void) reloadQAIndexData
{
    _dataSource = [QuestionIndexItem MR_findAllSortedBy:@"timestamp" ascending:YES];
}

#pragma mark ------ UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSource.count + 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (EN_QA_INDEX_ASSESS == indexPath.row) {
        return 30.0;
    }
    else if (EN_QA_INDEX_MORE_SPECIAL == indexPath.row)
    {
        return 45.0;
    }
    else if (EN_QA_INDEX_SPECIAL_LIST == indexPath.row)
    {
        return 128.0;
    }
    else if (EN_QA_INDEX_NULL == indexPath.row)
    {
        return 10.0;
    }
    else
    {
        return 171.0;//return 148.0;
    }

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *returnCellPtr;
    if (EN_QA_INDEX_ASSESS == indexPath.row) {
        IMAssessNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNilName_IMAssessNoticeTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        returnCellPtr = cell;
    }
    else if (EN_QA_INDEX_RECOMMEND_ONE == indexPath.row)
    {
         if (_dataSource.count > 0)
         {
             QuestionIndexItem *f = _dataSource[0];
             
             if ([f.type isEqualToString:@"question"]) {
                 QAHomeQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNilName_QAHomeQuestionCell];
                 cell.selectionStyle = UITableViewCellSelectionStyleNone;
                 cell.layer.borderWidth = 0.5;
                 cell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
                 [cell setCellItemWithModel:f indexPath:indexPath Type:EN_QA_INDEX_ANSWER];
                 returnCellPtr = cell;
             }
             else if ([f.type isEqualToString:@"topics"])
             {
                 QAHomeTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNib_QAHomeTopicCell];
                 cell.selectionStyle = UITableViewCellSelectionStyleNone;
                 cell.layer.borderWidth = 0.5;
                 cell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
                 [cell setQAHomeTopicCellWithModel:f indexPath:indexPath];
                 returnCellPtr = cell;
             }
        }
        else
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            returnCellPtr = cell;
        }
        

    }
    else if (EN_QA_INDEX_RECOMMEND_TWO == indexPath.row)
    {
        if (_dataSource.count > 1) {
            QuestionIndexItem *f = _dataSource[1];
            if ([f.type isEqualToString:@"question"]) {
                QAHomeQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNilName_QAHomeQuestionCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.layer.borderWidth = 0.5;
                cell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
                [cell setCellItemWithModel:f indexPath:indexPath Type:EN_QA_INDEX_ANSWER];
                returnCellPtr = cell;
            }
            else if ([f.type isEqualToString:@"topics"])
            {
                QAHomeTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNib_QAHomeTopicCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.layer.borderWidth = 0.5;
                cell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
                [cell setQAHomeTopicCellWithModel:f indexPath:indexPath];
                
                returnCellPtr = cell;
            }
        }
        else
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            returnCellPtr = cell;
        }
    }
    else if (EN_QA_INDEX_MORE_SPECIAL == indexPath.row)
    {
        MoreSpecialsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNilName_MoreSpecialsTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        returnCellPtr = cell;
    }
    else if (EN_QA_INDEX_SPECIAL_LIST == indexPath.row)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        QASpeciaListView * specialListView = [[QASpeciaListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 128)];
        [specialListView QASpeciaListSet:[QASpecialList MR_findAllSortedBy:@"timestamp" ascending:YES]];
        [cell addSubview:specialListView];
        returnCellPtr = cell;
    }
    else if (EN_QA_INDEX_NULL == indexPath.row)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
        returnCellPtr = cell;
    }
    else
    {
        if (_dataSource.count > (indexPath.row - EN_QA_INDEX_NULL + 1)) {
            QuestionIndexItem *f = _dataSource[indexPath.row - EN_QA_INDEX_NULL + 1];
            if ([f.type isEqualToString:@"question"]) {
                QAHomeQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNilName_QAHomeQuestionCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.layer.borderWidth = 0.5;
                cell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
                [cell setCellItemWithModel:f indexPath:indexPath Type:EN_QA_INDEX_ANSWER];
                returnCellPtr = cell;
            }
            else if ([f.type isEqualToString:@"topics"])
            {
                QAHomeTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNib_QAHomeTopicCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.layer.borderWidth = 0.5;
                cell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
                [cell setQAHomeTopicCellWithModel:f indexPath:indexPath];
                returnCellPtr = cell;
            }
        }
        else
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            returnCellPtr = cell;
        }
    }
    
    if (nil == returnCellPtr) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        returnCellPtr = cell;

    }
    
    return returnCellPtr;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (EN_QA_INDEX_ASSESS == indexPath.row) {
//        
//    }
//    else if (EN_QA_INDEX_MORE_SPECIAL == indexPath.row)
//    {
//        
//    }
//    else if (EN_QA_INDEX_SPECIAL_LIST == indexPath.row)
//    {
//        
//    }
//    else if (EN_QA_INDEX_NULL == indexPath.row)
//    {
//        
//    }
//    else
//    {
//        
//    }
    [[NSNotificationCenter defaultCenter] postNotificationName:QA_INDEX_SELECT_TABLE_ITEM object:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    
    return nil;
    
}

#pragma mark ------ RefreshControlDelegate

-(void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{
    
    //NSLog(@" 刷新");
    
    if (direction == RefreshDirectionBottom){ // 底部上拉加载 且 有数据
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //[_manager requestHotViewDataWithStart:_currentPost getCount:_countPerReq];
            [[NSNotificationCenter defaultCenter] postNotificationName:QA_INDEX_REFRESH_BOTTOM object:nil];
            //[self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            
        });
        
    }
    else if (direction == RefreshDirectionTop) { // 顶部下拉刷新
        
        //NSLog(@" (direction == RefreshDirectionTop) ");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:QA_INDEX_REFRESH_TOP object:nil];
            //[refreshControl finishRefreshingDirection:RefreshDirectionTop];
            
        });
        
        return;
        
    }else{
        
        [refreshControl finishRefreshingDirection:direction isEmpty:YES];
        
    }
    
} 


@end
