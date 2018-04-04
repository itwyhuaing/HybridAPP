//
//  OverSeaHouseVC.m
//  hinabian
//
//  Created by 何松泽 on 2018/1/11.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "OverSeaHouseVC.h"
#import "OverSeaClassModel.h"
#import "HNBClassesCell.h"
#import "DataFetcher.h"
#import "RefreshControl.h"
#import "LoginViewController.h"
#import "TribeDetailInfoViewController.h"
#import "OverSeaClassModel.h"
#import "OverSeaClassesManager.h"

#define PageNum                     @"5"        //分页拉取数据条数
#define HLargeImage                 150.f*SCREEN_WIDTHRATE_6

#define UnCareText                  @"点此关注，随时获取最新课堂信息"
#define CareText                    @"您正徜徉在知识的海洋里"

@interface OverSeaHouseVC ()<UITableViewDelegate,UITableViewDataSource,RefreshControlDelegate,OverSeaClassesManagerDelegate>

@property (nonatomic, strong) RefreshControl *refreshControl;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) OverSeaClassesManager *manager;
@property (nonatomic, strong) UILabel *careLabel;
@property (nonatomic, strong) UIButton *careBtn;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger allPost;        //数据总数
@property (nonatomic, assign) NSInteger currentPage;    //当前页数
@property (nonatomic, assign) BOOL isFollow;            //是否关注

@end

@implementation OverSeaHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _allPost = 0;
    _currentPage = 1;
    
    _dataArray = [[NSArray alloc] init];
    [self loadData];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_STATUSHEIGHT - 52.f)];
    self.tableView.delegate = (id)self;
    self.tableView.dataSource = (id)self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.tableView.frame];
    backgroundImageView.image = [UIImage imageNamed:@"OverSea_HouseBG"];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundImageView];
    [self.view addSubview:self.tableView];
    
    // 导航栏是否透明设置刷新控件的顶部偏移
    _refreshControl=[[RefreshControl alloc] initWithScrollView:_tableView delegate:self];
    _refreshControl.bottomEnabled=YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [HNBClick event:@"206013" Content:nil];
    
    if ([HNBUtils isLogin]) {
        [DataFetcher doGetPersonalIsFollow:overseaclass_haifangjun_id WithSucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            
            if (errCode == 0) {
                int isFollow = [[JSON valueForKey:@"data"] intValue];
                if (isFollow == 1) { //已关注
                    self.careLabel.text = CareText;
                    _isFollow = YES;
                }else if (isFollow == 0) { //未关注
                    self.careLabel.text = UnCareText;
                    _isFollow = NO;
                }
            }
        } withFailHandler:^(id error) {
            
        }];
    }else {
        self.careLabel.text = UnCareText;
    }
}

- (void)loadData{
    
//    [DataFetcher doGetListOverSeaClassWithType:overseaclass_house page:@"1" num:PageNum WithSucceedHandler:^(id JSON) {
//        _dataArray = [JSON valueForKey:overseaclass_data];
//        _allPost = [[JSON valueForKey:overseaclass_total] integerValue];
//        [[HNBLoadingMask shareManager] dismiss];
//        [self.tableView reloadData];
//    } withFailHandler:^(id error) {
//    }];
    
    [self.manager reqNetDataWithType:overseaclass_house
                                page:@"1"
                                 num:PageNum];
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AsianTalkTitle"];
        if (!cell) {
            cell = [[UITableViewCell alloc] init];
            UILabel *lastestLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 35)];
            lastestLabel.text = @"海房课堂";
            lastestLabel.textColor = [UIColor whiteColor];
            lastestLabel.font = [UIFont boldSystemFontOfSize:32];
            lastestLabel.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:lastestLabel];
            
            [cell addSubview:self.careLabel];
            [cell addSubview:self.careBtn];
            
            self.careLabel.sd_layout
            .topSpaceToView(lastestLabel, 30)
            .centerXEqualToView(cell)
            .widthIs(240)
            .heightIs(30);
            
            self.careBtn.sd_layout
            .topSpaceToView(lastestLabel, 30)
            .centerXEqualToView(cell)
            .widthIs(240)
            .heightIs(30);
        }
    }else{
        HNBClassesCell *hnbClassCell = [_tableView dequeueReusableCellWithIdentifier:cell_HNBClassesCell];
        if(!hnbClassCell){
            hnbClassCell = [[HNBClassesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_HNBClassesCell];
            hnbClassCell.delegate = (id)self;
        }
        if (_dataArray.count > 0) {
            OverSeaClassModel *model = _dataArray[indexPath.row - 1];
            [hnbClassCell setCellModel:model];
        }
        cell = hnbClassCell;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 170.f *SCREEN_WIDTHRATE_6;
    }
    return HLargeImage + 220.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 1) {
        TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
        OverSeaClassModel *model = _dataArray[indexPath.row - 1];
        vc.URL = [NSURL URLWithString:model.url];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)clickCareBtn
{
    if (![HNBUtils isLogin]) {
        [self gotoLogin];
        return;
    }
    NSString *tmpState = @"1";
    if (_isFollow) {
        [DataFetcher removeFollowWithParameter:overseaclass_haifangjun_id withSucceedHandler:^(id JSON) {
            _careLabel.text = UnCareText;
            _isFollow = NO;
        } withFailHandler:^(id error) {
            _careLabel.text = CareText;
            _isFollow = YES;
        }];
        tmpState = @"0";
    }else {
        [DataFetcher addFollowWithParameter:overseaclass_haifangjun_id withSucceedHandler:^(id JSON) {
            _careLabel.text = CareText;
            _isFollow = YES;
        } withFailHandler:^(id error) {
            _careLabel.text = UnCareText;
            _isFollow = NO;
        }];
    }
    NSDictionary *dict = @{
                           @"state":tmpState
                           };
    [HNBClick event:@"206021" Content:dict];
}

- (void)gotoLogin
{
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshData{
//    [DataFetcher doGetListOverSeaClassWithType:overseaclass_house page:[NSString stringWithFormat:@"%ld",_currentPage] num:PageNum WithSucceedHandler:^(id JSON) {
//        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:_dataArray];
//        [tempArr addObjectsFromArray:[JSON valueForKey:overseaclass_data]];
//        _dataArray = tempArr;
//        _allPost = [[JSON valueForKey:overseaclass_total] integerValue];
//        [self.tableView reloadData];
//        //设置下拉刷新
//        if (_allPost <= _dataArray.count) {
//            [_refreshControl finishRefreshingDirection:RefreshDirectionBottom isEmpty:YES];
//            _refreshControl.bottomEnabled = NO;
//        } else {
//            [_refreshControl finishRefreshingDirection:RefreshDirectionBottom];
//            _refreshControl.bottomEnabled = YES;
//        }
//
//    } withFailHandler:^(id error) {
//    }];
    
    [self.manager reqNetDataWithType:overseaclass_house
                                page:[NSString stringWithFormat:@"%ld",_currentPage]
                                 num:PageNum];
    
}

#pragma mark ------ HNBClassesDelegate

- (void)lookClassess:(OverSeaClassModel *)model{
    TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
    vc.URL = [NSURL URLWithString:model.url];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------ RefreshControlDelegate

-(void)refreshControlIgnoreNetStatus:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{
    if (direction == RefreshDirectionBottom && _dataArray.count < _allPost){ // 底部上拉加载 且 有数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _currentPage++;
            [self refreshData];
        });
    }else{
        [refreshControl finishRefreshingDirection:direction isEmpty:YES];
    }
}


#pragma mark ------ OverSeaClassesManagerDelegate

-(void)OverSeaClassesWithType:(NSString *)type curPage:(NSString *)page data:(id)data isCache:(BOOL)isCache{
    NSInteger curPage = [page integerValue];
    if (curPage <= 1) { // 1 - 第一页数据回来
        
        _dataArray = [data returnValueWithKey:overseaclass_data];
        _allPost = [[data returnValueWithKey:overseaclass_total] integerValue];
        [[HNBLoadingMask shareManager] dismiss];
        [self.tableView reloadData];
        
    } else {
        
        _dataArray = [self.manager filterDataSource:_dataArray extraData:[data valueForKey:overseaclass_data]];
        _allPost = [[data valueForKey:overseaclass_total] integerValue];
        [self.tableView reloadData];
        //设置下拉刷新
        if (_allPost <= _dataArray.count) {
            [_refreshControl finishRefreshingDirection:RefreshDirectionBottom isEmpty:YES];
            _refreshControl.bottomEnabled = NO;
        } else {
            [_refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            _refreshControl.bottomEnabled = YES;
        }
        
        //        for (OverSeaClassModel *f in _dataArray) {
        //            NSLog(@" \n ============= id : %@  ,title :%@ \n \n \n",f.f_id,f.title);
        //        }
        
    }
    
}


#pragma mark ------ 懒加载

- (UILabel *)careLabel {
    if (!_careLabel) {
        _careLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        _careLabel.clipsToBounds = YES;
        _careLabel.layer.cornerRadius = RRADIUS_LAYERCORNE * 6.0 * SCREEN_WIDTHRATE_6;
        _careLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _careLabel.layer.borderWidth = 1.f;
        _careLabel.textAlignment = NSTextAlignmentCenter;
        _careLabel.textColor = [UIColor whiteColor];
        _careLabel.font = [UIFont systemFontOfSize:FONT_UI28PX];
    }
    return _careLabel;
}

- (UIButton *)careBtn {
    if (!_careBtn) {
        _careBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _careBtn.backgroundColor = [UIColor clearColor];
        [_careBtn addTarget:self action:@selector(clickCareBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _careBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(OverSeaClassesManager *)manager{
    if (!_manager) {
        _manager = [[OverSeaClassesManager alloc] init];
        _manager.delegate = self;
    }
    return _manager;
}

@end
