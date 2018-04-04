//
//  GuideHomeView.h
//  hinabian
//
//  Created by 何松泽 on 2017/10/24.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#pragma mark ---- TextString
#define WANTIM_CountryString    @"您想去的国家？"
#define WANTIM_TargetString     @"您为什么想移民？"
#define SubTitleString          @"（最多可以选择3个）"
#define IMED_CountryString      @"您已移民的国家？"
#define SKIP_String             @"跳过"

#pragma mark ---- ImageName
#define Guide_Image_Logo        @"GuideImassess_logo"
#define Guide_Image_Work        @"GuideImassess_work"
#define Guide_Image_Userinfo    @"GuideImassess_userinfo"

#import <UIKit/UIKit.h>

@class GuideHomeView;
@class GuideVCodeView;
@class HNBQuestionButtonView;
@protocol GuideHomeViewDelegate<NSObject>

@optional
-(void)GuideHomeViewChoseIMState:(UIButton *)sender;
-(void)GuideHomeViewNext;
-(void)GuideHomeViewGetIMCase;
-(void)GuideHomeViewGetVCode:(id)sender vCodeView:(GuideVCodeView *)vCodeView;
-(void)GuideHomeViewIMEDNext;
//-(void)GuideHomeViewGetIMCaseWithLogin;
//-(void)GuideHomeChoseSingleBtn:(HNBIMAssessButton *)hnbBtn;
@end

static const int gWithOutWorkPage = 6;
static const int gWholePage = 7;

@interface GuideHomeView : UIView

typedef enum : NSUInteger {
    GuidePageCountry = 0,
    GuidePagePurpose,
    GuidePageExpense,
    GuidePageLiveTime,
    GuidePageEducation,
    GuidePageEnglish,
    GuidePageWorkingLife,
    GuidePageUserInfo,
} GuidePage;

typedef enum : NSUInteger {
    GuidePageIMEDCountry = 0,
    GuidePageIMEDCity = 1,
} GuidePageIMED;

typedef enum : NSUInteger {
    IMState_ING_IM = 1,
    IMState_ED_IM,
} IMStateChose;

@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) NSMutableArray *optionsBtnArr;

@property (nonatomic, strong) GuideVCodeView *vCodeView;
@property (nonatomic, weak) id<GuideHomeViewDelegate> delegate;

@property (nonatomic, assign) BOOL isIM_ED;//是否已移民

/*重构新属性*/
@property (nonatomic, strong) NSArray *allQuestionsArr; //全部问题

//WantIM
@property (nonatomic, strong)HNBQuestionButtonView *HNBCountryView;
@property (nonatomic, strong)HNBQuestionButtonView *HNBPurposeView;
@property (nonatomic, strong)HNBQuestionButtonView *HNBExpenseView;
@property (nonatomic, strong)HNBQuestionButtonView *HNBLiveTimeView;
@property (nonatomic, strong)HNBQuestionButtonView *HNBEducationView;
@property (nonatomic, strong)HNBQuestionButtonView *HNBEnglishView;
@property (nonatomic, strong)HNBQuestionButtonView *HNBWorkingLifeView;

//IMED
@property (nonatomic, strong)HNBQuestionButtonView *HNBIMEDCountryView;
@property (nonatomic, strong)HNBQuestionButtonView *HNBIMEDCityView;

/*end*/

-(void)observeNextBtn;
-(void)backLastedPage;
/*已移民*/
-(void)setIMEDViewWithImageStr:(NSString *)imageStr title:(NSString *)title page:(NSInteger)page wholePage:(NSInteger)wholePage;
/*想移民*/
- (void)setButtonsViewWithImageStr:(NSString *)imageStr attributtitle:(NSMutableAttributedString *)attributtitle page:(NSInteger)page wholePage:(NSInteger)wholePage;

@end
