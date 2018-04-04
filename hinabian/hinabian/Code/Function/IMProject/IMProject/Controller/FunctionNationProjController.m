//
//  FunctionNationProjController.m
//  hinabian
//
//  Created by 何松泽 on 2017/11/22.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "FunctionNationProjController.h"
#import "SingleProjVisaView.h"
#import "IMFunctionView.h"
#import "DataFetcher.h"
#import "ScrollBannerView.h"
#import "IMHomeVisaModel.h"
#import "IMHomeBannerModel.h"
#import "IMHomeProjModel.h"
#import "TribeDetailInfoViewController.h"
#import "SWKTribeShowViewController.h"
#import "ProjectNationsModel.h"
#import "ConditionTestVC.h"
#import "IMHomeVisaCell.h"
#import "IMProjectVisaCell.h"
#import "RefreshControl.h"
#import "HNBPv.h"
#import "IMAssessVC.h"

#define BANNER_HEIGHT   150.f   //新图尺寸，原图尺寸169

enum IMNationHome_Item_Index
{
    IM_NATION_SHUFFLING_IMAGE = 0,
    IM_NATION_FUNCTION  = 1,
    IM_NATION_EMITY_ONE = 2,
    IM_NATION_EMITY_TWO,
    IM_NATION_VISA_TITLE,
};

@interface FunctionNationProjController ()<UITableViewDelegate,UITableViewDataSource,ScrollBannerViewDelegate,RefreshControlDelegate>

@property (nonatomic, strong)RefreshControl *refreshControl;
@property (nonatomic, strong)ScrollBannerView *yhbanner;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSArray *bannerDatas;
@property (nonatomic, strong)NSMutableArray *bannerUrls;
@property (nonatomic, strong)NSArray *projDatas;
@property (nonatomic, strong)NSArray *visaDatas;

@end

@implementation FunctionNationProjController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bannerDatas    = [[NSArray alloc] init];
    _bannerUrls     = [[NSMutableArray alloc] init];
    _projDatas      = [[NSArray alloc] init];
    _visaDatas      = [[NSArray alloc] init];
    
    // banner 控件
    _yhbanner = [[ScrollBannerView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   SCREEN_WIDTH,
                                                                   BANNER_HEIGHT * (SCREEN_WIDTH/SCREEN_WIDTH_5S)) autoPlayTimeInterval:5];
    _yhbanner.delegate = (id)self;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_STATUSHEIGHT - SCREEN_PROJ_NAVHEIGHT)];
    self.tableView.delegate = (id)self;
    self.tableView.dataSource = (id)self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [self.tableView registerClass:[IMHomeVisaCell class] forCellReuseIdentifier:cellNib_IMHomeVisaCell];
    //    [self.tableView registerClass:[IMProjectVisaCell class] forCellReuseIdentifier:cellNib_IMProjectVisaCell];
    [self.view addSubview:self.tableView];
    
    // 刷新控件
    _refreshControl=[[RefreshControl alloc] initWithScrollView:self.tableView topOffset:0.0 delegate:self];
    _refreshControl.topEnabled=YES;
    _refreshControl.bottomEnabled=NO;
    
    [self refreshData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //打点记录
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[dat timeIntervalSince1970];
    [HNBPv beginLogPageView:[NSString stringWithFormat:@"%@_%@",[self class],_f_id] Time:time IsH5:false];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //退出打点记录
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[dat timeIntervalSince1970];
    [HNBPv endLogPageView:[NSString stringWithFormat:@"%@_%@",[self class],_f_id] Time:time IsH5:false];
}

#pragma tableview代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *returnCellPtr = [[UITableViewCell alloc] init];
    if (IM_NATION_SHUFFLING_IMAGE == indexPath.row) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeBannerCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeBannerCell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:self.yhbanner];
        }
        [self.yhbanner reFreshBannerViewWithDataSource:_bannerUrls];
        
        returnCellPtr = cell;
        
    }
    else if (IM_NATION_FUNCTION == indexPath.row) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMFunctionCell"];
        IMFunctionView *functionView = [[IMFunctionView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 120.f)];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IMFunctionCell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:functionView];
        }
        NSDictionary *dic = [[NSDictionary alloc] init];
        if (self.f_id) {
            dic = @{@"f_national": self.f_id};
        }
        functionView.clickWalkIN = ^{
            /*数据上报*/
            [HNBClick event:@"172031" Content:dic];

            SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
            NSString *tmpString = [NSString stringWithFormat:@"%@/native/wiki/country/?countryId=%@&countryName=%@",H5APIURL,_f_id,_f_title];
            //包含中文url转义
            NSString* encodedString = [tmpString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            vc.URL = [vc.webManger configNativeNavWithURLString:encodedString ctle:@"1" csharedBtn:@"0" ctel:@"0" cfconsult:@"1"];
            [self.navigationController pushViewController:vc animated:YES];
        };
        functionView.clickStrategy = ^{
            /*数据上报*/
            [HNBClick event:@"172032" Content:dic];

            SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
            NSString *tmpString = [NSString stringWithFormat:@"%@/native/talentPlan/?countryId=%@",H5APIURL,_f_id];
            
            vc.URL = [vc.webManger configNativeNavWithURLString:tmpString ctle:@"1" csharedBtn:@"1" ctel:@"0" cfconsult:@"1"];
            [self.navigationController pushViewController:vc animated:YES];
        };
        [functionView setClickIMassess:^{
            /*数据上报*/
            [HNBClick event:@"172033" Content:dic];
            IMAssessVC *vc = [[IMAssessVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [functionView setClickTest:^{
            /*数据上报*/
            [HNBClick event:@"172034" Content:dic];
            ConditionTestVC *vc = [[ConditionTestVC alloc] init];
            vc.model = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [functionView setNationName:_f_title];
        returnCellPtr = cell;
    }
    else if (IM_NATION_EMITY_ONE == indexPath.row || IM_NATION_EMITY_TWO + _projDatas.count == indexPath.row) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor DDR245_G245_B245ColorWithalph:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        returnCellPtr = cell;
    }
    /*项目数据*/
    else if (indexPath.row > IM_NATION_EMITY_ONE) {
        IMProjectVisaCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNib_IMProjectVisaCell];
        if (cell == nil) {
            cell = [[IMProjectVisaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNib_IMProjectVisaCell];
        }
        NSInteger index = indexPath.row - IM_NATION_EMITY_ONE - 1;
        IMHomeProjModel *model = _projDatas[index];
        [cell setProjModel:model];
        returnCellPtr = cell;
    }
    
    return returnCellPtr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSUInteger tempNum = IM_NATION_EMITY_ONE + _projDatas.count + 1;
    
    return tempNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == IM_NATION_SHUFFLING_IMAGE) {
        return BANNER_HEIGHT*SCREEN_SCALE;
    }else if (indexPath.row == IM_NATION_FUNCTION) {
        return 120.f;
    }else if (indexPath.row == IM_NATION_EMITY_ONE) {
        return 10.f;
    }
    return 250.f * SCREEN_SCALE;
}

-(void)scrollBannerView:(ScrollBannerView *)banner didSelectedImageViewAtIndex:(NSInteger)index {
    if (index < 1 || index > _bannerDatas.count) {
        return;
    }
    NSString* tmpString = Nil;
    IMHomeBannerModel * f = self.bannerDatas[index - 1];
    tmpString = f.url;
    
    /*链接不存在*/
    if ([tmpString isEqualToString:@""] || !tmpString) {
        return;
    }
    /*点击上报*/
    if (self.f_id) {
        NSDictionary *dic = @{@"f_national" : self.f_id,
                              @"f_pos"      : [NSString stringWithFormat:@"%lu",(long)index],
                              @"f_url"      : f.url};
        [HNBClick event:@"172021" Content:dic];
    }

    
    if ([[HNBWebManager defaultInstance] isHinabianThemeDetailWithURLString:tmpString]) {
        
        NSString *isNativeString = [HNBUtils sandBoxGetInfo:[NSString class] forKey:TRIBEDETAILTHEME_NATIVEUI_WEB];
        if ([isNativeString isEqualToString:@"1"]) {
            
            TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
            vc.URL = [[NSURL alloc] withOutNilString:tmpString];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
            
            SWKTribeShowViewController *vc = [[SWKTribeShowViewController alloc] init];
            vc.URL = [[NSURL alloc] withOutNilString:tmpString];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }else{
        
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [NSURL URLWithString:tmpString];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row > IM_NATION_EMITY_ONE) {
        NSInteger index = indexPath.row - IM_NATION_EMITY_ONE - 1;
        IMHomeProjModel *model = _projDatas[index];
        //NSString *URLString = [NSString stringWithFormat:@"%@/%@?project_id=%@",H5URL,IMProjectDetail_Native,model.proj_id];
        /*数据上报*/
        if (self.f_id && model.proj_id) {
            NSDictionary *dic = @{@"f_national" : self.f_id,
                                  @"f_project"  : model.proj_id};
            [HNBClick event:@"172041" Content:dic];
        }
        
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        
        vc.URL = [NSURL URLWithString:model.url];
        [self.navigationController pushViewController:vc animated:TRUE];
    }
    
}

#pragma mark ------ RefreshControlDelegate

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{
    
    if (direction == RefreshDirectionTop) { // 顶部下拉刷新
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self refreshData];
            [_refreshControl finishRefreshingDirection:direction isEmpty:YES];
        });
        return;
        
    } else { // 底部上拉加载
        [refreshControl finishRefreshingDirection:direction isEmpty:YES];
    }
    
}

- (void)refreshData {
    [DataFetcher getInfoByTabInIMProjectHomeWithID:_f_id withSucceedHandler:^(id JSON) {
        NSDictionary *tmpDic = JSON;
        if ([tmpDic valueForKey:IMHOME_VISA]) {
            _visaDatas = [tmpDic valueForKey:IMHOME_VISA];
        }
        if ([tmpDic valueForKey:IMHOME_PROJECT]) {
            _projDatas = [tmpDic valueForKey:IMHOME_PROJECT];
        }
        if ([tmpDic valueForKey:IMHOME_BANNER]) {
            _bannerDatas = [tmpDic valueForKey:IMHOME_BANNER];
            _bannerUrls = [NSMutableArray array];
            for (int i = 0;i < _bannerDatas.count;i++) {
                IMHomeBannerModel *model = _bannerDatas[i];
                [_bannerUrls addObject:model.img_url];
            }
        }
        [self.tableView reloadData];
    } withFailHandler:^(id error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

