//
//  HNBHomePageV3MainView.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/18.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "HNBHomePageV3MainView.h"
#import "QuickViewCell.h"
#import "HomeTitleCell.h"
#import "RecommendSpecialistView.h"
#import "ScrollBannerView.h"
#import "FunctionsView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

#import "PersonalInfo.h"
#import "HomeBannerModel.h"
#import "LatestNewsModel.h"
#import "FunctionModel.h"
#import "RcmdSpecialModel.h"
#import "RcmdActivityModel.h"
#import "HotTopicModel.h"
#import "GreatTalkModel.h"
#import "HnbEditorTalkModel.h"
#import "PreferredPlanModel.h"
#import "OverSeaClassModel.h"
#import "ProjectStateModel.h"

#import "ProjectStateNoticeView.h"
#import "BigShotTalkView.h"
#import "IndexFunctionStatus.h"
#import "HinabianEditorTopicTableViewCell.h"
#import "HomeHotTopicCell.h"
#import "HomeRecommandActivityCell.h"
#import "PreferredPlanCell.h"
#import "LookAllAssessRltCell.h"
#import "OverSeaClassViewCell.h"

#import "ShowAllServicesModel.h"


@interface HNBHomePageV3MainView () <UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,ScrollBannerViewDelegate,RecommendSpecialistDelegate,FunctionsViewDelegate,BigShotTalkDelegate,OverSeaClassViewCellDelegate,ProjectStateNoticeViewDelegate,PreferredPlanCellDelegate>

@property (nonatomic,strong) UITableView *homeTable;
@property (nonatomic,strong) SDCycleScrollView *quickNewsView;
@property (nonatomic,strong) ScrollBannerView *yhbanner;
@property (nonatomic,strong) FunctionsView *yhFuncView;
@property (nonatomic,strong) RecommendSpecialistView *rcmspecialview;
@property (nonatomic,strong) BigShotTalkView *bigShotView;
@property (nonatomic,strong) ProjectStateNoticeView *proNoticeView;

@property (nonatomic,strong) NSMutableArray *bannerDataSource;
@property (nonatomic,strong) NSMutableArray *fucntionsDataSource;
@property (nonatomic,strong) NSMutableArray *plansDataSource;
@property (nonatomic,strong) NSMutableArray *latestNewsDataSource;
@property (nonatomic,strong) NSMutableArray *rcmspecialDataSource;
@property (nonatomic,strong) NSMutableArray *greatTalksDataSource;
@property (nonatomic,strong) NSMutableArray *hnbeditorTalksDataSource;
@property (nonatomic,strong) RcmdActivityModel *rcmActivity;
@property (nonatomic,strong) HotTopicModel *hotpic;
@property (nonatomic,strong) OverSeaClassModel *overSeaModel;

//是否有活动
@property (nonatomic,assign) BOOL haveAct;

@end

@implementation HNBHomePageV3MainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        //[self test];
        self.pageStyle = HNBHomePageV3MainViewStyleDefault;
        
        self.haveAct = YES;
    }
    return self;
}

- (void)initUI{
    CGRect rect = self.frame;
    rect.size.height -= SCREEN_TABHEIGHT;
    [self setFrame:rect];
    
//    rect.origin.y = -64;
//    rect.size.height += 64;
    
    _homeTable = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _homeTable.backgroundColor = [UIColor DDR245_G245_B245ColorWithalph:1.0];
    _homeTable.delegate = self;
    _homeTable.dataSource = self;
    [_homeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // banner 控件
    _yhbanner = [[ScrollBannerView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   SCREEN_WIDTH,
                                                                   HBannerHeight) autoPlayTimeInterval:5];
    _yhbanner.delegate = self;
    
    // func 功能区
    _yhFuncView = [[FunctionsView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  SCREEN_WIDTH,
                                                                  HFunctionHeight)];
    
    _yhFuncView.delegate = self;
    
    // 推荐专家
    _rcmspecialview = [[RecommendSpecialistView alloc] initWithFrame:CGRectMake(0,
                                                                                0,
                                                                                SCREEN_WIDTH,
                                                                                HRecommendSpecialistHeight)];
    _rcmspecialview.delegate = self;
    
    // 大咖说
    _bigShotView = [[BigShotTalkView alloc] initWithFrame:CGRectMake(0, 2.5, SCREEN_WIDTH, HBigShotRalkHeight)];
    _bigShotView.delegate = self;
    
    [self addSubview:_homeTable];
    
}

#pragma mark ------ UITableViewDelegate,UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    /**
     轮播图 - 功能区 - 快讯
     查看评估结果／最佳项目
     推荐专家 - 推荐活动 - 热门话题 - 大咖说
     小边说
     */
    return HomeTableIndexSetionCount;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount = 0;
    if (section == HomeTableIndexSetion0) {
        rowCount = HomeTableIndexSetion0Count;
    }else if (section == HomeTableIndexSetion1){
        
        rowCount = 1;
        if (self.pageStyle == HNBHomePageV3MainViewStyleD) {
            rowCount = 0;
        }else if (self.pageStyle == HNBHomePageV3MainViewStyleB){
            rowCount = self.plansDataSource.count+1;// + 2;
            // 以防获取最佳方案为空
            if (self.plansDataSource.count <= 0) {
                rowCount = 0;
            }
        }
        

    }else if (section == HomeTableIndexSetion2){
        rowCount = HomeTableIndexSetion2Count;
    }else if (section == HomeTableIndexSetion3){
        rowCount = self.hnbeditorTalksDataSource.count + 2;
    }
    return rowCount;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == HomeTableIndexSetion0) {
        
        if(indexPath.row == HomeTableIndexSetion0Row0){
            return HBannerHeight;
        }else if (indexPath.row == HomeTableIndexSetion0Row1) {
            return HFunctionHeight;
        }else if (indexPath.row == HomeTableIndexSetion0Row2) {
            /*快讯*/
            return 37.f;
        }
        
    }
    else if (indexPath.section == HomeTableIndexSetion1) {
        
        CGFloat tmpRowHeight = HAssessConsultHeight;
        if (self.pageStyle == HNBHomePageV3MainViewStyleD) {
            tmpRowHeight = 0;
        }else if (self.pageStyle == HNBHomePageV3MainViewStyleB){
            
            // v3.0.0
//            tmpRowHeight = HTitleHeight;
//            if (indexPath.row > 0 && indexPath.row <= 3) {
//                tmpRowHeight = HIMMigrantProjectHeight;
//            }else if (indexPath.row > 3){
//                tmpRowHeight = HIMMigrantAllRltHeight;
//            }
            
            // v3.1.0
            tmpRowHeight = HTitleHeight;
            if (indexPath.row == 1) {
                tmpRowHeight = HPreferredPlan31Height;
            }
            
        }
        
        return tmpRowHeight;
        
    }
    else if (indexPath.section == HomeTableIndexSetion2) {
        
        CGFloat tmpHeightS2 = 0.0;
        if (indexPath.row == HomeTableIndexSetion2Row0 || indexPath.row == HomeTableIndexSetion2Row3 || indexPath.row == HomeTableIndexSetion2Row6 || indexPath.row == HomeTableIndexSetion2Row9 || indexPath.row == HomeTableIndexSetion2Row12) {
            tmpHeightS2 =  HTitleHeight;
        }else if (indexPath.row == HomeTableIndexSetion2Row1) {
            tmpHeightS2 =  HRecommendSpecialistHeight;
        }else if (indexPath.row == HomeTableIndexSetion2Row2 || indexPath.row == HomeTableIndexSetion2Row5 || indexPath.row == HomeTableIndexSetion2Row8 || indexPath.row == HomeTableIndexSetion2Row11) {
            tmpHeightS2 =  HBlankHeight;
        }else if (indexPath.row == HomeTableIndexSetion2Row4) {
            tmpHeightS2 =  HRcmActCellHeight;//HLargeImage + 55.0f;
        }
        else if (indexPath.row == HomeTableIndexSetion2Row7) {
            tmpHeightS2 =  HLargeImage + 185.f;
        }else if (indexPath.row == HomeTableIndexSetion2Row10) {
            tmpHeightS2 =  HLargeImage + 15.f;
        }else if (indexPath.row == HomeTableIndexSetion2Row13) {
            tmpHeightS2 =  HBigShotRalkHeight;
        }
        
        // 区分首页
        if (self.pageStyle == HNBHomePageV3MainViewStyleD && indexPath.row <= 2) {
            // 隐藏推荐专家板块
            tmpHeightS2 = 0.0;
        }
        // 无上架活动时隐藏 推荐活动版块
        if (!_haveAct) {
            if (indexPath.row == HomeTableIndexSetion2Row2 || indexPath.row == HomeTableIndexSetion2Row3 || indexPath.row == HomeTableIndexSetion2Row4) {
                tmpHeightS2 = 0.0;
            }
        }
        return tmpHeightS2;
        
    }else if (indexPath.section == HomeTableIndexSetion3) {
        if(indexPath.row == 0){
            return HTitleHeight;
        
        }else if(indexPath.row >= 1 && indexPath.row <= _hnbeditorTalksDataSource.count){
            
           return 222.0/2.0 * SCREEN_WIDTHRATE_6;
            
        }else{
            
           return HBlankHeight;
            
        }
        
        
        
    }
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat tmpHeight = 0.f;
    
    if (section == HomeTableIndexSetion1) {
        tmpHeight = HBlankHeight;
        
        if (self.pageStyle == HNBHomePageV3MainViewStyleD) {
            tmpHeight = 0.f;
        }
        
        if (self.plansDataSource.count <= 0
            && self.pageStyle == HNBHomePageV3MainViewStyleB) {
            tmpHeight = 0.f;
        }
    }
    
    if (section == HomeTableIndexSetion2) {
        tmpHeight = HBlankHeight;
    }
    
    if (section == HomeTableIndexSetion3) {
        tmpHeight = HBlankHeight;
    }
    
    return tmpHeight;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == HomeTableIndexSetion2) {
//        return HBlankHeight;
//    }
//    return 0.f;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [[UIView alloc] init];
    if (section == HomeTableIndexSetion1 || section == HomeTableIndexSetion2 || section == HomeTableIndexSetion3) {
        [headView setBackgroundColor:[UIColor DDR245_G245_B245ColorWithalph:1.0]];
    }
    return headView;
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *footerView = [[UIView alloc] init];
//    if (section == HomeTableIndexSetion1 || section == HomeTableIndexSetion2) {
//        /*评估结果*/
//        [footerView setBackgroundColor:[UIColor DDR245_G245_B245ColorWithalph:1.0]];
//    }
//    //footerView.backgroundColor = [UIColor purpleColor];
//    return footerView;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if (indexPath.section == HomeTableIndexSetion0) {
        cell = [self cellForRowAtSection0IndexPath:indexPath];
    }
    else if (indexPath.section == HomeTableIndexSetion1){
        cell = [self cellForRowAtSection1IndexPath:indexPath];
    }
    else if (indexPath.section == HomeTableIndexSetion2){
        cell = [self cellForRowAtSection2IndexPath:indexPath];
    }
    else if(indexPath.section == HomeTableIndexSetion3){
        cell = [self cellForRowAtSection3IndexPath:indexPath];
        
    }
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    if (section == HomeTableIndexSetion0) {
        [self clickSection0AtIndex:indexPath];
    }else if (section == HomeTableIndexSetion1){
        [self clickSection1AtIndex:indexPath];
    }else if (section == HomeTableIndexSetion2){
        [self clickSection2AtIndex:indexPath];
    }else if (section == HomeTableIndexSetion3){
        [self clickSection3AtIndex:indexPath];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScrollWithCurrentOffset:)]){
        [_delegate scrollViewDidScrollWithCurrentOffset:scrollView.contentOffset.y];
    }
}

#pragma mark ------ 不同 section 的 cell


- (UITableViewCell *)cellForRowAtSection0IndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    if (indexPath.row == HomeTableIndexSetion0Row0){
        UITableViewCell *bannerCell = [_homeTable dequeueReusableCellWithIdentifier:HomeBannerCellIdentify];
        if (bannerCell == nil) {
            bannerCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HomeBannerCellIdentify];
            bannerCell.backgroundColor = [UIColor clearColor];
            [bannerCell addSubview:self.yhbanner];
        }
        //NSLog(@" bannerCell : %@",bannerCell);
        cell = bannerCell;
    
    }else if(indexPath.row == HomeTableIndexSetion0Row1){
        UITableViewCell *funcCell = [_homeTable dequeueReusableCellWithIdentifier:@"HomeFunctionCell"];
        if (funcCell == nil) {
            funcCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeFunctionCell"];
            funcCell.backgroundColor = [UIColor whiteColor];
            [funcCell addSubview:_yhFuncView];
        }
        [_yhFuncView refreshCollectionWithV30Data:_fucntionsDataSource];
        cell = funcCell;
    }else if (indexPath.row == HomeTableIndexSetion0Row2) {
        /*快讯*/
        QuickViewCell *quickCell = [_homeTable dequeueReusableCellWithIdentifier:cellNib_QuickViewCell];;
        if (!quickCell) {
            quickCell = [[QuickViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNib_QuickViewCell];
            quickCell.layer.borderWidth = 1.0;
            quickCell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
        }
        quickCell.quickNewsView.titlesGroup = [_latestNewsDataSource copy];
        quickCell.quickNewsView.autoScroll = TRUE;
        quickCell.quickNewsView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            [self clickSection0AtIndex:indexPath];
        };
        cell = quickCell;
    }
    
    
    return cell;
    
}

- (UITableViewCell *)cellForRowAtSection1IndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if (self.pageStyle == HNBHomePageV3MainViewStyleA
        || self.pageStyle == HNBHomePageV3MainViewStyleC
        || self.pageStyle == HNBHomePageV3MainViewStyleDefault) {
        
        UITableViewCell *lookRltCell = [_homeTable dequeueReusableCellWithIdentifier:HomeAsccessConsultCellIdentify];
        NSString *backImageName = @"homepage_bigdataaccess";
        if (self.pageStyle == HNBHomePageV3MainViewStyleA) {
            backImageName = @"generate_usr_plans";
        }
        if (!lookRltCell) {
            lookRltCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HomeAsccessConsultCellIdentify];
            UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:backImageName]];
            backgroundImage.contentMode = UIViewContentModeScaleAspectFit;
            [backgroundImage setFrame:CGRectMake(10.0*SCREEN_WIDTHRATE_6, 10.0*SCREEN_WIDTHRATE_6, SCREEN_WIDTH - 20.0*SCREEN_WIDTHRATE_6, HAssessConsultHeight-20.0*SCREEN_WIDTHRATE_6)];
            [lookRltCell.contentView addSubview:backgroundImage];
            
        }
//        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homepage_bigdataaccess"]];
//        backgroundImage.contentMode = UIViewContentModeScaleAspectFit;
//        if (self.pageStyle == HNBHomePageV3MainViewStyleA) {
//            [backgroundImage setImage:[UIImage imageNamed:@"generate_usr_plans"]];
//        }
//        [backgroundImage setFrame:CGRectMake(10.0*SCREEN_WIDTHRATE_6, 10.0*SCREEN_WIDTHRATE_6, SCREEN_WIDTH - 20.0*SCREEN_WIDTHRATE_6, HAssessConsultHeight-20.0*SCREEN_WIDTHRATE_6)];
//        [lookRltCell.contentView addSubview:backgroundImage];
        cell = lookRltCell;
    }else if (self.pageStyle == HNBHomePageV3MainViewStyleB){
        
        if (indexPath.row == 0) {
            
            HomeTitleCell *titleCell = [_homeTable dequeueReusableCellWithIdentifier:@"HomeTitleCell1"];
            if (!titleCell) {
                titleCell = [[HomeTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeTitleCell1"];
            }
            [titleCell setcellTitle:@"最佳方案" detailTitle:@"重新评估" arrow:@"icon_you"];
            cell = titleCell;
            
        } else if(indexPath.row == 1){
            
            PreferredPlanCell *preferredCell = [_homeTable dequeueReusableCellWithIdentifier:cell_PreferredPlanCell];
            if (!preferredCell) {
                preferredCell = [[PreferredPlanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_PreferredPlanCell];
            }
            preferredCell.delegate = self;
            [preferredCell setUpItemCellWithModel:self.plansDataSource[indexPath.row - 1]];
            cell = preferredCell;
            
        }
        
        
    }else{
        cell = [[UITableViewCell alloc] init];
    }
    
    return cell;
    
}

- (UITableViewCell *)cellForRowAtSection2IndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    if (indexPath.row == HomeTableIndexSetion2Row0) {
        HomeTitleCell *titleCell = [_homeTable dequeueReusableCellWithIdentifier:@"HomeTitleCell2"];
        if (!titleCell) {
            titleCell = [[HomeTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeTitleCell2"];
            titleCell.layer.borderWidth = 1.0;
            titleCell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
        }
        [titleCell setcellTitle:@"推荐专家" detailTitle:@"查看全部" arrow:@"icon_you"];
        cell = titleCell;
    }
    else if (indexPath.row == HomeTableIndexSetion2Row1) {
        UITableViewCell *rcmSpecialCell = [_homeTable dequeueReusableCellWithIdentifier:HomeRecommendSpecialistCellIdentify];
        if (!rcmSpecialCell) {
            rcmSpecialCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HomeRecommendSpecialistCellIdentify];
            [rcmSpecialCell addSubview:_rcmspecialview];
            [rcmSpecialCell addSubview:_rcmspecialview];
        }
        [_rcmspecialview reFreshViewWithDataSource:_rcmspecialDataSource];
        cell = rcmSpecialCell;

    }
    else if (indexPath.row == HomeTableIndexSetion2Row2 || indexPath.row == HomeTableIndexSetion2Row5 || indexPath.row == HomeTableIndexSetion2Row8 || indexPath.row == HomeTableIndexSetion2Row11) {
        cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor DDR245_G245_B245ColorWithalph:1.0];
    }
    else if (indexPath.row == HomeTableIndexSetion2Row3) {
        
        HomeTitleCell *titleCell = [_homeTable dequeueReusableCellWithIdentifier:@"HomeTitleCell3"];
        if (!titleCell) {
            titleCell = [[HomeTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeTitleCell3"];
        }
        [titleCell setcellTitle:@"推荐活动" detailTitle:@"" arrow:nil];
        [titleCell setHiddenCell:!_haveAct];
        cell = titleCell;
    }
    else if (indexPath.row == HomeTableIndexSetion2Row4) {
        HomeRecommandActivityCell *recommandActCell = [_homeTable dequeueReusableCellWithIdentifier:cell_HomeRecommandActivityCell];
        if(!recommandActCell){
            recommandActCell = [[HomeRecommandActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_HomeRecommandActivityCell];
        }
        recommandActCell.clickCellBtnBlock = ^(UIButton *btn) {
            if (_rcmActivity.actLink != nil && _delegate && [_delegate respondsToSelector:@selector(homePageV3RcmActLink:)]) {
                [_delegate homePageV3RcmActLink:_rcmActivity.actLink];
            }
        };
        [recommandActCell setUpItemCellWithModel:_rcmActivity];
        [recommandActCell setHiddenCell:!_haveAct];
        cell = recommandActCell;
    }
    else if (indexPath.row == HomeTableIndexSetion2Row6) {
        HomeTitleCell *titleCell = [_homeTable dequeueReusableCellWithIdentifier:@"HomeTitleCell4"];
        if (!titleCell) {
            titleCell = [[HomeTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeTitleCell4"];
        }
        [titleCell setcellTitle:@"海外课堂" detailTitle:@"查看全部" arrow:@"icon_you"];
        cell = titleCell;
    }else if(indexPath.row == HomeTableIndexSetion2Row7){
        OverSeaClassViewCell *overSeaClassCell = [_homeTable dequeueReusableCellWithIdentifier:cell_OverSeaClassViewCell];
        if(!overSeaClassCell){
            overSeaClassCell = [[OverSeaClassViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_OverSeaClassViewCell];
            overSeaClassCell.delegate = (id)self;
        }
        [overSeaClassCell setCellModel:_overSeaModel];
        cell = overSeaClassCell;
    }
    else if (indexPath.row == HomeTableIndexSetion2Row9) {
        HomeTitleCell *titleCell = [_homeTable dequeueReusableCellWithIdentifier:@"HomeTitleCell5"];
        if (!titleCell) {
            titleCell = [[HomeTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeTitleCell5"];
            
        }
        [titleCell setcellTitle:@"热门话题" detailTitle:@"" arrow:nil];
        cell = titleCell;
    }else if(indexPath.row == HomeTableIndexSetion2Row10){
        HomeHotTopicCell *hotTopicCell = [_homeTable dequeueReusableCellWithIdentifier:cell_HomeHotTopicCell];
        if(!hotTopicCell){
            hotTopicCell = [[HomeHotTopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_HomeHotTopicCell];
        }
        [hotTopicCell setUpItemCellWithModel:_hotpic];
        cell = hotTopicCell;
    }
    else if (indexPath.row == HomeTableIndexSetion2Row12) {
        HomeTitleCell *titleCell = [_homeTable dequeueReusableCellWithIdentifier:@"HomeTitleCell6"];
        if (!titleCell) {
            titleCell = [[HomeTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeTitleCell6"];
            titleCell.layer.borderWidth = 1.0;
            titleCell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
        }
        [titleCell setcellTitle:@"大咖说" detailTitle:@"查看全部" arrow:@"icon_you"];
        cell = titleCell;
    }
    else if (indexPath.row == HomeTableIndexSetion2Row13) {
        UITableViewCell *greatTalkCell = [_homeTable dequeueReusableCellWithIdentifier:HomeBigShotTalkCellIdentify];
        if (!greatTalkCell) {
            greatTalkCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HomeBigShotTalkCellIdentify];
            [greatTalkCell addSubview:_bigShotView];
        }
        [_bigShotView reFreshViewWithDataSource:_greatTalksDataSource];
        cell = greatTalkCell;
    }
    
    
    // 区分首页
    if (self.pageStyle == HNBHomePageV3MainViewStyleD && indexPath.row <= 2) {
        // 隐藏推荐专家板块
        UITableViewCell *blankCell = [_homeTable dequeueReusableCellWithIdentifier:@"blankCellID"];
        if (!blankCell) {
            blankCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"blankCellID"];
        }
        cell = blankCell;
    }
    
    
    return cell;
}


- (UITableViewCell *)cellForRowAtSection3IndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.row == HomeTableIndexHomeTableIndexSetion3Row0) {
        HomeTitleCell *titleCell = [_homeTable dequeueReusableCellWithIdentifier:@"HomeTitleCell6"];
        if (!titleCell) {
            titleCell = [[HomeTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeTitleCell6"];
            titleCell.layer.borderWidth = 1.0;
            titleCell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
        }
        [titleCell setcellTitle:@"小边说" detailTitle:@"查看全部" arrow:@"icon_you"];
        cell = titleCell;
    }else if(indexPath.row >= 1 && indexPath.row <= _hnbeditorTalksDataSource.count){
        
        HinabianEditorTopicTableViewCell *editorCell = [_homeTable dequeueReusableCellWithIdentifier:cell_HinabianEditorTopicTableViewCell];
        if(!editorCell){
            editorCell = [[HinabianEditorTopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_HinabianEditorTopicTableViewCell];
        }
        [editorCell setModel:_hnbeditorTalksDataSource[indexPath.row - 1]];
        [editorCell reSetUnderLineDisplayWithState:FALSE];
        cell = editorCell;
    
    }else{
        
        cell = [_homeTable dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellID"];
            cell.backgroundColor = [UIColor DDR245_G245_B245ColorWithalph:1.0];
        }
        
    }
    return cell;
}


#pragma mark ------ 更新数据后回调刷新界面

-(void)reFreshHomeViewWithBannerData:(NSArray *)bannerData preferredplans:(NSArray *)plansData funcData:(NSArray *)funcData news:(NSArray *)newsData specials:(NSArray *)specials rcmActData:(id)rcmActModel hotTopic:(id)topicModel{
    
    if(bannerData != nil && bannerData.count > 0){
        NSMutableArray *images = [[NSMutableArray alloc] init];
        _bannerDataSource = [[NSMutableArray alloc] initWithArray:bannerData];
        for (NSInteger cou = 0;cou < bannerData.count;cou ++) {
            HomeBannerModel *f = bannerData[cou];
            [images addObject:f.image_url];
        }
        [self.yhbanner reFreshBannerViewWithDataSource:images];
    }
    
    _fucntionsDataSource = [[NSMutableArray alloc] initWithArray:funcData];
    [self preferredPlansDataSource:plansData];
    
    if(newsData != nil && newsData.count > 0){
        _latestNewsDataSource = [[NSMutableArray alloc] init];
        for (NSInteger cou = 0;cou < newsData.count;cou ++) {
            LatestNewsModel *f = newsData[cou];
            [_latestNewsDataSource addObject:f.title];
        }
    }
    
    _rcmspecialDataSource = [[NSMutableArray alloc] initWithArray:specials];
    _hotpic = (HotTopicModel *)topicModel;
    _rcmActivity = (RcmdActivityModel *)rcmActModel;
    if (_rcmActivity) {
        _haveAct = YES;
    }else {
        _haveAct = NO;
    }
    
    [self refreshHomePageAllView];
    
}

- (void)reFreshHomeViewWithGreatTalks:(NSArray *)greatTalks editorTalks:(NSArray *)editorTalks{
    
    _greatTalksDataSource = [[NSMutableArray alloc] initWithArray:greatTalks];
    _hnbeditorTalksDataSource = [[NSMutableArray alloc] initWithArray:editorTalks];
    
    [self refreshHomePageAllView];
    
}

- (void)reFreshHomeViewWithOverSeaClasses:(NSArray *)overSeaclasses{
    if (overSeaclasses) {
        _overSeaModel = [overSeaclasses firstObject];
    }
    [self refreshHomePageAllView];
}

- (void)reFreshHomeViewWithPreferredplans:(NSArray *)plansData{
    [self preferredPlansDataSource:plansData];
    [self refreshHomePageAllView];
    
}

- (void)refreshHomePageAllView{
    //NSLog(@" test888 %s --- self.pageStyle :%ld ",__FUNCTION__,self.pageStyle);
    [_homeTable reloadData];
}

- (void)refreshHomeViewAtSection:(NSInteger)section{
//    NSLog(@" test888 %s --- %@ ",__FUNCTION__,_homeTable);
//    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
//    [_homeTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (UITableView *)getCurrentTableView{
    UITableView *curTableView = _homeTable;
    return curTableView;
}

-(void)testHomePageStyle:(NSString *)txt{
    
    [[HNBToast shareManager] toastWithOnView:nil msg:[NSString stringWithFormat:@"%@ - 最佳方案个数：%ld",txt,self.plansDataSource.count] afterDelay:5.0 style:HNBToastHudOnlyText];
    
}

- (void)modifyTableViewContentOffset:(CGPoint)point{
    [_homeTable setContentOffset:point];
}

- (void)displayProjectStateNoticeWithData:(ProjectStateModel *)model{
    [self addSubview:self.proNoticeView];
    [self.proNoticeView modifyViewWithData:model];
}

#pragma mark ------ 最佳方案数据展示方案，v3.1.0 轮流展示

- (void)preferredPlansDataSource:(NSArray *)data{
    
    if (data != nil && data.count > 0) {
        // 三个轮流展示
        [self.plansDataSource removeAllObjects];
        NSInteger openCount = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:OpenAPPCountFlag] integerValue];
        NSInteger tmpFlag = (openCount - 1) < 0 ? 0 : (openCount - 1);
        NSInteger location = tmpFlag % data.count; // v3.1 约定最佳方案为3个轮流展示
        if(data.count > 1){
            [self.plansDataSource addObject:data[location]];
        }else{
            [self.plansDataSource addObject:data[0]];
        }
    }
}

#pragma mark ------ banner 点击事件

- (void)scrollBannerView:(ScrollBannerView *)banner didSelectedImageViewAtIndex:(NSInteger)index{
    
    if(index > _bannerDataSource.count || index < 1){
        return;
    }
    HomeBannerModel *f = _bannerDataSource[index - 1];
    NSString *link = f.link_url;
    if(_delegate && [_delegate respondsToSelector:@selector(homePageV3BannerAtIndex:link:)]){
        [_delegate homePageV3BannerAtIndex:index link:link];
    }
    
}

#pragma mark ------ 功能区 点击事件
//-(void)functionsViewDidSelectedModel:(id)model{
//    IndexFunctionStatus *f = (IndexFunctionStatus *)model;
//    if(_delegate && [_delegate respondsToSelector:@selector(homePageV3FunctionAtItem:num:isLocal:link:)]){
//        [_delegate homePageV3FunctionAtItem:f.name num:f.no isLocal:f.isLocal link:f.url];
//    }
//}

-(void)functionsViewDidSelectedV30Model:(id)model{
    // V3.0
//    FunctionModel *f = (FunctionModel *)model;
//    if(_delegate && [_delegate respondsToSelector:@selector(homePageV3FunctionAtItem:isLocal:link:)]){
//        [_delegate homePageV3FunctionAtItem:f.name isLocal:f.isLocal link:f.url];
//    }
    // v3.2
    ShowAllServicesModel *f = (ShowAllServicesModel *)model;
    if (_delegate && [_delegate respondsToSelector:@selector(homePageV3FunctionAtItem:isLocal:link:)]) {
        [_delegate homePageV3FunctionAtItem:f.name isLocal:@"0" link:f.url];
    }
}
//v 3.2
- (void)functionsViewToAllShowServices{
    if (_delegate && [_delegate respondsToSelector:@selector(homePageV3FunctionAtAll)]) {
        [_delegate homePageV3FunctionAtAll];
    }
}


#pragma mark ------ 推荐专家 点击事件

-(void)recommendSpecialistConsult:(NSInteger)index{
    //NSLog(@" %s ",__FUNCTION__);
    if (_delegate && [_delegate respondsToSelector:@selector(homePageV3RcmSpecialConsultWithID:imId:specialName:)]) {
        RcmdSpecialModel *f = self.rcmspecialDataSource[index];
        [_delegate homePageV3RcmSpecialConsultWithID:f.specialID imId:f.netease_im_id specialName:f.specialName];
    }
}

- (void)recommendSpecialistCheckAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row >= self.rcmspecialDataSource.count && _delegate &&
        [_delegate respondsToSelector:@selector(homePageV3MainView:didSelectRowAtIndexPath:functionTag:)]) { // 推荐专家查看全部
        [_delegate homePageV3MainView:self didSelectRowAtIndexPath:indexPath functionTag:HomePageClickFunctionRcmSpecialsList];
        return;
    }
    
    RcmdSpecialModel *f = _rcmspecialDataSource[indexPath.row];
    PersonalInfo *pf = [[PersonalInfo MR_findAll] firstObject];
    if (![f.specialID isEqualToString:pf.id] &&
        f.specialID != nil && _delegate &&
        [_delegate respondsToSelector:@selector(homePageV3RcmSpecialId:)]) {
        [_delegate homePageV3RcmSpecialId:f.specialID];
    }
    
}

#pragma mark ------ 不同 section 点击处理

- (void)clickSection0AtIndex:(NSIndexPath *)index{
    if (index.row == HomeTableIndexSetion0Row2) { // 快讯列表
        if (_delegate && [_delegate respondsToSelector:@selector(homePageV3MainView:didSelectRowAtIndexPath:functionTag:)]) {
            [_delegate homePageV3MainView:self didSelectRowAtIndexPath:index functionTag:HomePageClickFunctionLatestNewsList];
        }
    }
}

- (void)clickSection1AtIndex:(NSIndexPath *)index{
    
    if (self.pageStyle == HNBHomePageV3MainViewStyleA) {
    
        if (_delegate && [_delegate respondsToSelector:@selector(homePageV3MainView:didSelectRowAtIndexPath:functionTag:)]) {
            [_delegate homePageV3MainView:self didSelectRowAtIndexPath:index functionTag:HomePageClickFunctionLookAssessResult];
        }
        
    }else if (self.pageStyle == HNBHomePageV3MainViewStyleC || self.pageStyle == HNBHomePageV3MainViewStyleDefault){
        
        if (_delegate && [_delegate respondsToSelector:@selector(homePageV3MainView:didSelectRowAtIndexPath:functionTag:)]) {
            [_delegate homePageV3MainView:self didSelectRowAtIndexPath:index functionTag:HomePageClickFunctionBigDataAssess];
        }
        
    }else if (self.pageStyle == HNBHomePageV3MainViewStyleB){
        
        if (index.row == 0) {
            
            if (_delegate && [_delegate respondsToSelector:@selector(homePageBV3MainView:didSelectRowAtIndex:)]) {
                [_delegate homePageBV3MainView:self didSelectRowAtIndex:cREASSESS];
            }
            
        }else {
            
            if (_delegate && [_delegate respondsToSelector:@selector(homePageV3PreferredPlansWithURLString:)]) {
                PreferredPlanModel *f = self.plansDataSource[index.row - 1];
                [_delegate homePageV3PreferredPlansWithURLString:f.url];
            }
            
        }

        
        //NSLog(@" %s - index.row:%ld",__FUNCTION__,index.row);
        
    }
    
}

- (void)clickSection2AtIndex:(NSIndexPath *)index{
    if (index.row == HomeTableIndexSetion2Row4 || index.row == HomeTableIndexSetion2Row3){ // 3 4
        
        if (_rcmActivity.actLink != nil && _delegate && [_delegate respondsToSelector:@selector(homePageV3RcmActLink:)]) {
            [_delegate homePageV3RcmActLink:_rcmActivity.actLink];
        }
        
    }else if (index.row == HomeTableIndexSetion2Row6){
        // 海外课堂查看全部
        if (_delegate && [_delegate respondsToSelector:@selector(homePageV3MainView:didSelectRowAtIndexPath:functionTag:)]) {
            [_delegate homePageV3MainView:self didSelectRowAtIndexPath:index functionTag:HomePageClickFunctionOverSeaClass];
        }
    }else if (index.row == HomeTableIndexSetion2Row7){
        // 海外课堂查看详情
        if (_delegate && [_delegate respondsToSelector:@selector(homePageV3OverSeaClassLink:eventSource:)]) {
            [_delegate homePageV3OverSeaClassLink:_overSeaModel.url eventSource:nil];
        }
    }else if (index.row == HomeTableIndexSetion2Row9 || index.row == HomeTableIndexSetion2Row10){ // 9 10
        
        if (_delegate && _hotpic.url != nil && [_delegate respondsToSelector:@selector(homePageV3HotTopicLink:)]) {
            [_delegate homePageV3HotTopicLink:_hotpic.topicId];
        }
        
    }else if (index.row == HomeTableIndexSetion2Row12){
        // 大咖说查看全部
        if (_delegate && [_delegate respondsToSelector:@selector(homePageV3MainView:didSelectRowAtIndexPath:functionTag:)]) {
            [_delegate homePageV3MainView:self didSelectRowAtIndexPath:index functionTag:HomePageClickFunctionGreatTalkList];
        }
    }else if (index.row == HomeTableIndexSetion2Row0){
        // 推荐专家查看全部
        if (_delegate && [_delegate respondsToSelector:@selector(homePageV3MainView:didSelectRowAtIndexPath:functionTag:)]) {
            [_delegate homePageV3MainView:self didSelectRowAtIndexPath:index functionTag:HomePageClickFunctionRcmSpecialsList];
        }
        
    }
    
}


- (void)clickSection3AtIndex:(NSIndexPath *)index{

    if (index.row <= 0) { // 小边查看全部
        
        if (_delegate && [_delegate respondsToSelector:@selector(homePageV3MainView:didSelectRowAtIndexPath:functionTag:)]) {
            [_delegate homePageV3MainView:self didSelectRowAtIndexPath:index functionTag:HomePageClickFunctionHnbEditorTalkList];
        }
        
    }else if(index.row > 0 && index.row <= self.hnbeditorTalksDataSource.count){
        
        HnbEditorTalkModel *f = self.hnbeditorTalksDataSource[index.row - 1];
        if (_delegate && [_delegate respondsToSelector:@selector(homePageV3HnbEditorLink:index:)]) {
            [_delegate homePageV3HnbEditorLink:f.link_url index:index.row - 1];
        }
        
    }

}

- (void)lookClassess{
    // 海外课堂查看全部
    if (_delegate && [_delegate respondsToSelector:@selector(homePageV3OverSeaClassLink:eventSource:)]) {
        [_delegate homePageV3OverSeaClassLink:_overSeaModel.url eventSource:@"btn"];//区分点击按钮
    }
}

#pragma mark ------ 最佳方案，查看全部

- (void)clickEventLookAllRlts:(UIButton *)btn{
    if (_delegate && [_delegate respondsToSelector:@selector(homePageBV3MainView:didSelectRowAtIndex:)]) {
        [_delegate homePageBV3MainView:self didSelectRowAtIndex:cLOOKALLRLTS];
    }
    //NSLog(@" %s ",__FUNCTION__);
}

#pragma mark ------ 大咖说 点击处理

-(void)bigShotTalkClick:(NSIndexPath *)indexPath{
    
    GreatTalkModel *f = _greatTalksDataSource[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(homePageV3GreatTalkLink:index:)]) {
        [_delegate homePageV3GreatTalkLink:f.talk_link index:indexPath.row];
    }
}

#pragma mark ------ 海外课堂 点击处理

- (void)lookClassessWithEventSource:(UIButton *)btn{
    // 海外课堂查看全部
    if (_delegate && [_delegate respondsToSelector:@selector(homePageV3OverSeaClassLink:eventSource:)]) {
        [_delegate homePageV3OverSeaClassLink:_overSeaModel.url eventSource:btn];
    }
}


#pragma mark ------ lazy

-(ProjectStateNoticeView *)proNoticeView{
    if (!_proNoticeView) {
        _proNoticeView = [[ProjectStateNoticeView alloc] init];
        _proNoticeView.delegate = self;
    }
    return _proNoticeView;
}

-(NSMutableArray *)plansDataSource{
    if(!_plansDataSource){
        _plansDataSource = [[NSMutableArray alloc] init];
    }
    return _plansDataSource;
}

#pragma mark ------ ProjectStateNoticeViewDelegate

- (void)touchProjectStateNoticeEvent:(UIButton *)btn info:(NSDictionary *)info{
    NSLog(@" %s ",__FUNCTION__);
    if (_delegate && [_delegate respondsToSelector:@selector(homePageV3ProjectStateNotice:)]) {
        [_delegate homePageV3ProjectStateNotice:info];
    }
}

#pragma mark ------ 其他

- (CGFloat)getCurrentTableOffsetY{
    return _homeTable.contentOffset.y;
}



#pragma mark ------  测试

- (void)test{
    
    //self.backgroundColor = [UIColor greenColor];
    //_homeTable.backgroundColor = [UIColor yellowColor];
    //_yhFuncView.backgroundColor = [UIColor greenColor];
    
}

@end
