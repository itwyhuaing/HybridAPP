//
//  TribeShowQAView.m
//  hinabian
//
//  Created by hnbwyh on 17/4/17.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "TribeShowQAView.h"
#import "QAHomeQuestionCell.h"
#import "TribeShowQAModel.h"
#import "HNBToast.h"

@interface TribeShowQAView () <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,RefreshControlDelegate,TribeShowQAManagerDelegate>

@end

@implementation TribeShowQAView

-(instancetype)initWithFrame:(CGRect)frame tribeID:(NSString *)tribeID superVC:(UIViewController *)superVC{
    self = [super initWithFrame:frame];
    if (self) {
        
        _dataSource = [[NSMutableArray alloc] init];
        
        _manager = [[TribeShowQAManager alloc] init];
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
    [_tableView registerNib:[UINib nibWithNibName:cellNilName_QAHomeQuestionCell bundle:nil] forCellReuseIdentifier:cellNilName_QAHomeQuestionCell_TribeShow];
    
    
    // 导航栏是否透明设置刷新控件的顶部偏移 透明 - 64.0 、不透明 - 0.0
    _refreshControl=[[RefreshControl alloc] initWithScrollView:_tableView delegate:self];
    //_refreshControl.topEnabled=YES;
    _refreshControl.bottomEnabled=YES;
    
}

-(void)getData:(NSArray *)data{
    
    [self filterRepeatedTribeQAModelWithDataSource:data];
    [_tableView reloadData];
    
    _currentPost = _countPerReq > data.count ? _countPerReq : data.count;
    _allPost = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:tribeshow_total_qaitems_count] integerValue];
    
}

#pragma mark ------ UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 171.0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QAHomeQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNilName_QAHomeQuestionCell_TribeShow];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
//    DetailTribeQAitem *f = _dataSource[indexPath.row];
    TribeShowQAModel *f = _dataSource[indexPath.row];
    [cell setTribeShowCellItemWithModel:f indexPath:indexPath Type:EN_TRIBESHOW_QA_INDEX];
    return cell;
    
//    UITableViewCell *returncell = [tableView dequeueReusableCellWithIdentifier:@"cellQAID"];
//    if (returncell == nil) {
//        returncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellQAID"];
//        returncell.backgroundColor = [UIColor greenColor];
//        returncell.selectionStyle = UITableViewCellSelectionStyleNone;
//        returncell.layer.borderWidth = 0.5;
//        returncell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
//        returncell.textLabel.text = [NSString stringWithFormat:@"%ld - QA",indexPath.row];
//    }
//    return returncell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@" hotest ---- > %@",indexPath);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TRIBESHOW_QA_TABLEVIEW_NOTIFICATION object:_dataSource[indexPath.row]];
    
    return nil;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_delegate && [_delegate respondsToSelector:@selector(scrollTribeShowQAView:resetFrameWithYOffset:)]) {
        [_delegate scrollTribeShowQAView:self resetFrameWithYOffset:scrollView.contentOffset.y];
    }
}


#pragma mark ------ RefreshControlDelegate

-(void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{
    
    if (direction == RefreshDirectionBottom && _currentPost < _allPost){ // 底部上拉加载 且 有数据
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [_manager requestTribeShowQAViewDataWithStart:_currentPost getCount:_countPerReq];
            
        });
        
    }else{
        
        [refreshControl finishRefreshingDirection:direction isEmpty:YES];
        
    }
    
}

#pragma mark ------ TribeShowProjectManagerDelegate

- (void)completeThenRefreshViewWithDataSource:(NSArray *)data{
    
    if (_allPost <= 0 ) {
        _allPost = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:tribeshow_total_qaitems_count] integerValue];
    }
    
    [self filterRepeatedTribeQAModelWithDataSource:data];
    _currentPost = _dataSource.count;
    if (data == nil || data.count <= 0) { // 说明此次并没有请求到新的数据
        _currentPost = _allPost;
    }
    
    if (_allPost <= _currentPost) {
        [_refreshControl finishRefreshingDirection:RefreshDirectionBottom isEmpty:YES];
    } else {
        [_refreshControl finishRefreshingDirection:RefreshDirectionBottom];
    }
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

- (void)filterRepeatedTribeQAModelWithDataSource:(NSArray *)data{
    
    [_dataSource addObjectsFromArray:data];
    
    // 数据查重
    NSMutableArray *tmpData = [[NSMutableArray alloc] initWithArray:_dataSource];
    for (NSInteger cou = 0; cou < data.count; cou ++) {
        NSInteger countNum = 0;
        TribeShowQAModel *f = data[cou];
        //NSLog(@" QA 新增数据标题 ：%@",f.title);
        for (NSInteger idx = 0; idx < tmpData.count; idx++) {
            TribeShowQAModel *s = tmpData[idx];
            if ([f.questionid isEqualToString:s.questionid]) {
                countNum ++;
                if (countNum >= 2) {
                    [_dataSource removeObject:s];
                }
            }
        }
    }
}

@end
