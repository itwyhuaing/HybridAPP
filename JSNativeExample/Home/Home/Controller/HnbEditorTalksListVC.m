//
//  HnbEditorTalksListVC.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/25.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "HnbEditorTalksListVC.h"
#import "HinabianEditorTopicTableViewCell.h"
#import "HnbEditorTalksListManager.h"
#import "TribeDetailInfoViewController.h"

#import "HnbEditorTalkModel.h"

@interface HnbEditorTalksListVC () <UITableViewDelegate,UITableViewDataSource,HnbEditorTalksListManagerDelegate>

@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *listDataSource;
@property (nonatomic,strong) HnbEditorTalksListManager *manager;

@end

@implementation HnbEditorTalksListVC

#pragma mark ------ life

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小边说";
    
    _manager = [[HnbEditorTalksListManager alloc] init];
    _manager.delegate = self;
    [_manager reqHnbEditorTalksListData];
    [self.view addSubview:self.table];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpNav];
    
}

- (void)setUpNav{
    [self addTabBarButton];
}

- (void)addTabBarButton{
    
    // 返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_fanhui"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(back_preVC)];
    self.navigationItem.leftBarButtonItem = backItem;
}


#pragma mark ------

- (void)back_preVC{
    [self.navigationController popViewControllerAnimated:TRUE];
}


#pragma mark ------ UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listDataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HHnbEditorCellHeight; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%@_ListCell",cell_HinabianEditorTopicTableViewCell];
    HinabianEditorTopicTableViewCell *cell = [_table dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[HinabianEditorTopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.borderWidth = 0.5f;
        cell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
    }
    [cell setModel:self.listDataSource[indexPath.row]];
    [cell reSetUnderLineDisplayWithState:TRUE];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@" indexPath : %@",indexPath);
    HnbEditorTalkModel *f = self.listDataSource[indexPath.row];
    TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
    vc.URL = [NSURL URLWithString:f.link_url];
    [self.navigationController pushViewController:vc animated:TRUE];
    
}

#pragma mark ------ HnbEditorTalksListManagerDelegate

-(void)hnbEditorTalksListReqNetSucWithDataSource:(id)dataSource reqStatus:(BOOL)rs{
    NSArray *tmp = (NSArray *)dataSource;
    _listDataSource = [[NSMutableArray alloc] initWithArray:tmp];
    [self.table reloadData];
}

#pragma mark ------ 懒加载

-(UITableView *)table{
    if (!_table) {
        
        CGRect rect = self.view.bounds;
        rect.size.height = SCREEN_HEIGHT - SCREEN_NAVHEIGHT - SCREEN_STATUSHEIGHT;
        _table = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorStyle = UITableViewCellSelectionStyleNone;
        
    }
    return _table;
}

#pragma mark ------ 加载数据

- (void)loadData{
    // 1. 先读本地
    
    // 2. 刷新
    
    // 3. 网络请求
    
    // 4. 更新本地
    
    // 5. 依据时间或其他条件判断是否需要刷新
    
    
    
    
}

@end
