//
//  RcmSpecialListVC.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/25.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "RcmSpecialListVC.h"
#import "UserInfoController2.h"
#import "ListSpecialCell.h"
#import "RcmSpecialListManager.h"
#import "SWKConsultOnlineViewController.h"
#import "LoginViewController.h"
#import <NIMSDK/NIMSDK.h>
#import "NETEaseViewController.h"

// 数据模型
#import "RcmdSpecialModel.h"
#import "PersonalInfo.h"

@interface RcmSpecialListVC ()<UITableViewDelegate,UITableViewDataSource,RcmSpecialListManagerDelegate>

@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *listDataSource;
@property (nonatomic,strong) RcmSpecialListManager *manager;

@end

@implementation RcmSpecialListVC

#pragma mark ------ life

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专家列表";
    
    _manager = [[RcmSpecialListManager alloc] init];
    _manager.delegate = self;
    [_manager reqRcmSpecialListData];
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
    return HRcmSpecialCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%@_ListCell",cell_ListSpecialCell];
    ListSpecialCell *cell = [_table dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ListSpecialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.borderWidth = 0.5f;
        cell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
    }
    [cell setModel:self.listDataSource[indexPath.row]];
    cell.consultBlock = ^(id info) {
        RcmdSpecialModel *f = self.listDataSource[indexPath.row];
        [self jumpConsult:f.netease_im_id];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSLog(@" indexPath : %@",indexPath);
    
    RcmdSpecialModel *f = self.listDataSource[indexPath.row];
    PersonalInfo *pf = [[PersonalInfo MR_findAll] firstObject];
    if (![f.specialID isEqualToString:pf.id] && f.specialID != nil) {
     
        UserInfoController2 *vc = [[UserInfoController2 alloc]init];
        vc.personid = f.specialID;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

#pragma mark ------ RcmSpecialListManagerDelegate

-(void)rcmSpecialListManagerReqNetSucWithDataSource:(id)dataSource reqStatus:(BOOL)rs{
    NSArray *tmp = (NSArray *)dataSource;
    _listDataSource = [[NSMutableArray alloc] initWithArray:tmp];
    [self.table reloadData];
}

- (void)jumpConsult:(NSString *)imid{
    
    if ([HNBUtils isLogin]) {
        if (imid && ![imid isEqualToString:@""]) {
            NIMSession *session = [NIMSession session:imid type:NIMSessionTypeP2P];
            NETEaseViewController *chatVC = [[NETEaseViewController alloc] initWithSession:session];
            chatVC.isAllow_Chat = YES;
            [self.navigationController pushViewController:chatVC animated:YES];
        }
    } else {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
