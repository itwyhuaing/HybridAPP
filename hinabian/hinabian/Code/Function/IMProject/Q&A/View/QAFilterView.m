//
//  QAFilterView.m
//  hinabian
//
//  Created by 余坚 on 16/7/25.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "QAFilterView.h"
#import "QALabelSelectView.h"
#import "QAHomeQuestionCell.h"
#import "QuestionFilterItem.h"
#import "HKKTagWriteView.h"
#import "QuestionIndexItem.h"
#import "Label.h"
#import "LabelCate.h"

#define TAGWRITEVIEW_HEIGHT 40*SCREEN_SCALE

@interface QAFilterView ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,RefreshControlDelegate,HKKTagWriteViewDelegate>
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic, strong)  HKKTagWriteView *tagWriteView;
@property (nonatomic, strong)  QALabelSelectView *labelSelectView;
@property (nonatomic, strong)  NSMutableArray *tagsArray;
@end

@implementation QAFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _tagsArray = [[NSMutableArray alloc] init];
        [self loadFilterLableView];
        [self loadFilterViewWithFame:frame];
        [self loadViewWithFame:frame];
    }
    return self;
}

- (void)loadViewWithFame:(CGRect)frame
{
    CGRect labeSelectRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _labelSelectView = [[QALabelSelectView alloc] initWithFrame:labeSelectRect];
    [self addSubview:_labelSelectView];
}

- (void)loadFilterViewWithFame:(CGRect)frame{
    
    CGRect rect = frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TAGWRITEVIEW_HEIGHT, frame.size.width, frame.size.height-TAGWRITEVIEW_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = (id)self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor beigeColor];
    [_tableView registerNib:[UINib nibWithNibName:cellNilName_QAHomeQuestionCell bundle:nil] forCellReuseIdentifier:cellNilName_QAHomeQuestionCell];
//    [_tableView registerNib:[UINib nibWithNibName:cellNilName_IMAssessNoticeTableViewCell bundle:nil] forCellReuseIdentifier:cellNilName_IMAssessNoticeTableViewCell];
//    [_tableView registerNib:[UINib nibWithNibName:cellNilName_MoreSpecialsTableViewCell bundle:nil] forCellReuseIdentifier:cellNilName_MoreSpecialsTableViewCell];
    [self addSubview:_tableView];
    
    _refreshControl=[[RefreshControl alloc] initWithScrollView:_tableView delegate:(id)self];
    _refreshControl.bottomEnabled=YES;

    
}

- (void)loadFilterLableView
{
    /* 显示栏 */
    self.tagWriteView = [[HKKTagWriteView alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH - 24, TAGWRITEVIEW_HEIGHT)];
    [self.tagWriteView setBackgroundColor:[UIColor clearColor]];
    [self.tagWriteView setTagBackgroundColor:[UIColor whiteColor]];
    [self.tagWriteView setTagTextColor:[UIColor DDNavBarBlue]];
    [self.tagWriteView setTag:11];
    [self.tagWriteView setTagsLimitNum:200];
    [[self.tagWriteView layer]setCornerRadius:10.0];
    self.tagWriteView.delegate = (id)self;
    [self addSubview:_tagWriteView];
    //分割线
    UIView * separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, TAGWRITEVIEW_HEIGHT - 0.5 , SCREEN_WIDTH, 0.5)];
    separatorLine.backgroundColor = [UIColor clearColor];
    separatorLine.layer.borderWidth = 0.5;
    separatorLine.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
    [self addSubview:separatorLine];
}

/* 重新加载 */
- (void) reloadQAFilterData
{
   _dataSource = [QuestionFilterItem MR_findAllSortedBy:@"timestamp" ascending:YES];
    [_tagsArray removeAllObjects];
    _tagsArray = [NSMutableArray arrayWithArray:_labelSelectView.labelsArray];
    [_tagWriteView removeAllTags];
    [_tagWriteView addTags:_tagsArray];
    [_tagWriteView setScrollOffsetToLeft];
    [_tableView reloadData];
}
- (void) ShowFilterView
{
    [HNBClick event:@"108017" Content:nil];
    [_labelSelectView updateTagWrite:_tagsArray];
    _labelSelectView.hidden = FALSE;
}

- (void) hideFilterView
{
    _labelSelectView.hidden = TRUE;
}

- (BOOL) isSelectLabelEmpty
{
    if (_tagsArray.count == 0 || _tagsArray == nil) {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
#pragma mark ------ UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150.0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *returnCellPtr;
    QAHomeQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNilName_QAHomeQuestionCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
    [cell setCellItemWithModel:_dataSource[indexPath.row] indexPath:indexPath Type:EN_QA_INDEX_ANSWER];
    returnCellPtr = cell;
  
    return returnCellPtr;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:QA_FILTER_SELECT_TABLE_ITEM object:[NSString stringWithFormat:@"%ld",indexPath.row]];
    
    return nil;
    
}

#pragma mark ------ RefreshControlDelegate

-(void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{
    
    //NSLog(@" 刷新");
    
    if (direction == RefreshDirectionBottom){ // 底部上拉加载 且 有数据
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //[_manager requestHotViewDataWithStart:_currentPost getCount:_countPerReq];
            [[NSNotificationCenter defaultCenter] postNotificationName:QA_INDEX_REFRESH_FILTER_BOTTOM object:nil];
            [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            
        });
        
    }else{
        
        [refreshControl finishRefreshingDirection:direction isEmpty:YES];
        
    }
    
}

#pragma mark ------ HKKTagWriteViewDelegate
- (void)tagWriteView:(HKKTagWriteView *)view didRemoveTag:(NSString *)tag
{
    [_tagsArray removeObject:tag];
    if (_tagsArray.count == 0) {
        [self ShowFilterView];
    }
    else
    {
        _labelSelectView.labelsArray =[NSArray arrayWithArray:_tagsArray];
        NSArray * tmpArry = _tagsArray;
        NSString * tmpNation = @"";
        for (int index = 0; index < tmpArry.count; index++) {
            Label * f = [Label MR_findFirstByAttribute:@"name" withValue:tmpArry[index]];
            tmpNation = [tmpNation stringByAppendingString:f.value];
            if (index != (tmpArry.count - 1)) {
                tmpNation = [tmpNation stringByAppendingString:@","];
            }
        }
        
        NSLog(@"%@",tmpNation);
        [[NSNotificationCenter defaultCenter] postNotificationName:QA_FILTER_OK_PREESED object:tmpNation];
    }
}




@end
