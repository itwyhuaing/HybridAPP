//
//  HNBHomePageV3MainView.h
//  hinabian
//
//  Created by hnbwyh on 2017/10/18.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectStateModel;

#define HomeBannerCellIdentify @"HomeBannerCell"
#define HomeAsccessConsultCellIdentify @"HomeAsccessConsultCell"
#define HomeRecommendSpecialistCellIdentify @"HomeRecommendSpecialistCell"
#define HomeBigShotTalkCellIdentify @"HomeBigShotTalkCell"

#define HAssessConsultHeight        140.f*SCREEN_WIDTHRATE_6
#define HRecommendSpecialistHeight  215.f
#define HLargeImage                 150.f*SCREEN_WIDTHRATE_6
#define HBigShotRalkHeight          180.f
#define HTitleHeight                40.f
#define HIMMigrantAllRltHeight      47.f
#define HBlankHeight                7.f
#define HBannerHeight               174.0*SCREEN_WIDTHRATE_6
#define HFunctionHeight             119.0*SCREEN_WIDTHRATE_6     //97.0*SCREEN_WIDTHRATE_6
#define HPreferredPlan31Height      249.0*SCREEN_WIDTHRATE_6

/**
 * 首页类型 - A - 立即查看(未登陆)、B - 最佳方案、Default/C - 大数据评估、D - 已移民
 */
typedef enum : NSUInteger {
    HNBHomePageV3MainViewStyleDefault = 60000,
    HNBHomePageV3MainViewStyleA,
    HNBHomePageV3MainViewStyleB,
    HNBHomePageV3MainViewStyleC,
    HNBHomePageV3MainViewStyleD,
} HNBHomePageV3MainViewStyle;


/**
 * 首页不同点击事件区分
 */
typedef enum : NSUInteger {
    HomePageClickFunctionLatestNewsList = 80000,
    HomePageClickFunctionLookAssessResult,
    HomePageClickFunctionRcmSpecialsList,
    HomePageClickFunctionGreatTalkList,
    HomePageClickFunctionHnbEditorTalkList,
    HomePageClickFunctionRcmSpecialConsult,
    HomePageClickFunctionBigDataAssess,
    HomePageClickFunctionOverSeaClass,
} HomePageClickFunction;

/**
 * 最佳方案区分点击事件
 */
#define cLOOKALLRLTS @"click.look.all.result"
#define cREASSESS @"re.assess"

/**
 * 视图分区 - setion
 * banner、func、快讯   ---  最佳方案/评估/结果  ---  推荐专家/推荐活动/热门话题/大咖说  ---  小编说 
 */
typedef enum : NSUInteger {
    HomeTableIndexSetion0 = 0,
    HomeTableIndexSetion1,
    HomeTableIndexSetion2,
    HomeTableIndexSetion3,
    HomeTableIndexSetionCount,
} HomeTableIndexSetion;

/**
 * 视图分区 - setion0 - row
 */

typedef enum : NSUInteger {
    HomeTableIndexSetion0Row0 = 0,
    HomeTableIndexSetion0Row1,
    HomeTableIndexSetion0Row2,
    HomeTableIndexSetion0Row3,
    HomeTableIndexSetion0Count,
} HomeTableIndexSetion0Row;

typedef enum : NSUInteger {
    HomeTableIndexHomeTableIndexSetion1Row0 = 0,
} HomeTableIndexSetion1Row;

typedef enum : NSUInteger {
    HomeTableIndexSetion2Row0 = 0,
    HomeTableIndexSetion2Row1,
    HomeTableIndexSetion2Row2,
    HomeTableIndexSetion2Row3,
    HomeTableIndexSetion2Row4,
    HomeTableIndexSetion2Row5,
    HomeTableIndexSetion2Row6,
    HomeTableIndexSetion2Row7,
    HomeTableIndexSetion2Row8,
    HomeTableIndexSetion2Row9,
    HomeTableIndexSetion2Row10,
    HomeTableIndexSetion2Row11,
    HomeTableIndexSetion2Row12,
    HomeTableIndexSetion2Row13,
    HomeTableIndexSetion2Count,
} HomeTableIndexSetion2Row;

typedef enum : NSUInteger {
    HomeTableIndexHomeTableIndexSetion3Row0 = 0,
} HomeTableIndexSetion3Row;

/**
 * 视图点击交互传递至控制器
 */
@class HNBHomePageV3MainView;
@protocol HNBHomePageV3MainViewDelegate <NSObject>
@optional

/**
 * 点击 cell - 快讯、推荐专家-查看全部、大咖说-查看全部
 */
- (void)homePageV3MainView:(HNBHomePageV3MainView *)homeView didSelectRowAtIndexPath:(NSIndexPath *)indexPath functionTag:(HomePageClickFunction)clickTag;

/**
 * B 模式下点击 前往评估
 */
- (void)homePageBV3MainView:(HNBHomePageV3MainView *)homeView didSelectRowAtIndex:(NSString *)flag;

/**
 * 点击 最佳方案
 */
- (void)homePageV3PreferredPlansWithURLString:(NSString *)URLString;

/**
 * 点击 首页推荐专家咨询
 */
- (void)homePageV3RcmSpecialConsultWithID:(NSString *)specialid imId:(NSString *)imid specialName:(NSString *)specialName;

/**
 * 导航处理
 */
- (void)scrollViewDidScrollWithCurrentOffset:(CGFloat)offset;

/**
 * 点击banner
 */
- (void)homePageV3BannerAtIndex:(NSInteger)idx link:(NSString *)link;

/**
 * 点击功能区
 */
- (void)homePageV3FunctionAtItem:(NSString *)itemName num:(NSString *)num isLocal:(NSString *)isLocal link:(NSString *)link;
- (void)homePageV3FunctionAtItem:(NSString *)itemName isLocal:(NSString *)isLocal link:(NSString *)link;
//v 3.2
- (void)homePageV3FunctionAtAll;

/**
 * 点击推荐专家
 */
- (void)homePageV3RcmSpecialId:(NSString *)perid;

/**
 * 点击首页 推荐活动
 */
- (void)homePageV3RcmActLink:(NSString *)link;

/**
 * 点击首页 热门话题
 */
-(void)homePageV3HotTopicLink:(NSString *)link;

/**
 * 点击首页 大咖说
 */
-(void)homePageV3GreatTalkLink:(NSString *)link index:(NSInteger)index;

/**
 * 点击首页 小边说
 */
-(void)homePageV3HnbEditorLink:(NSString *)link index:(NSInteger)index;

/**
 * 点击首页 海外课堂
 */
-(void)homePageV3OverSeaClassLink:(NSString *)link eventSource:(id)es;

/**
 * 点击首页 项目进度通知立即查看
 */
-(void)homePageV3ProjectStateNotice:(NSDictionary *)infoDic;

@end


@interface HNBHomePageV3MainView : UIView

@property (nonatomic,assign) HNBHomePageV3MainViewStyle pageStyle;
@property (nonatomic,weak) id<HNBHomePageV3MainViewDelegate> delegate;

- (CGFloat)getCurrentTableOffsetY;

- (void)reFreshHomeViewWithBannerData:(NSArray *)bannerData
                       preferredplans:(NSArray *)plansData
                           funcData:(NSArray *)funcData
                               news:(NSArray *)newsData
                           specials:(NSArray *)specials
                         rcmActData:(id)rcmActModel
                           hotTopic:(id)topicModel;


- (void)reFreshHomeViewWithPreferredplans:(NSArray *)plansData;

- (void)reFreshHomeViewWithGreatTalks:(NSArray *)greatTalks
                       editorTalks:(NSArray *)editorTalks;

- (void)reFreshHomeViewWithOverSeaClasses:(NSArray *)overSeaclasses;

- (void)refreshHomePageAllView;

- (void)refreshHomeViewAtSection:(NSInteger)section;

- (void)displayProjectStateNoticeWithData:(ProjectStateModel *)model;

- (UITableView *)getCurrentTableView;

-(void)testHomePageStyle:(NSString *)txt;

/**
 * 在 iOS 9.2 上 首页刷新之后 tableview 参数 contentOffset 会被修改，故在此修改修正该参数以适配
 **/
- (void)modifyTableViewContentOffset:(CGPoint)point;

@end
