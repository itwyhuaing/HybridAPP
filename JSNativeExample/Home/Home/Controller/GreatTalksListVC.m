//
//  GreatTalksListVC.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/25.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "GreatTalksListVC.h"
#import "ListGreatTalkCell.h"
#import "GreatTalksListManager.h"
#import "TribeDetailInfoViewController.h"

#import "GreatTalkModel.h"

@interface GreatTalksListVC ()<UITableViewDelegate,UITableViewDataSource,GreatTalksListManagerDelegate>

@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *listDataSource;
@property (nonatomic,strong) GreatTalksListManager *manager;

@end

@implementation GreatTalksListVC

#pragma mark ------ life

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"大咖说";
    
    _manager = [[GreatTalksListManager alloc] init];
    _manager.delegate = self;
    [_manager reqGreatTalksListData];
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
    return HGreatTalkCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%@_ListCell",cell_ListGreatTalkCell];
    ListGreatTalkCell *cell = [_table dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ListGreatTalkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.borderWidth = 0.5f;
        cell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
    }
    [cell setModel:self.listDataSource[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@" indexPath : %@",indexPath);
    GreatTalkModel *f = self.listDataSource[indexPath.row];
    TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
    vc.URL = [NSURL URLWithString:f.talk_link];
    [self.navigationController pushViewController:vc animated:TRUE];
}

#pragma mark ------ GreatTalksListManagerDelegate

-(void)greatTalksListManagerReqNetSucWithDataSource:(id)dataSource reqStatus:(BOOL)rs{
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


@end
