//
//  IMAssessHomeView.h
//  hinabian
//
//  Created by 何松泽 on 2017/11/24.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#pragma mark ---- TextString
#define WANTIM_CountryString    @"您想去的国家？"
#define WANTIM_TargetString     @"您为什么想移民？"
#define SubTitleString          @"（最多可以选择3个）"

#pragma mark ---- ImageName
#define Guide_Image_Logo        @"GuideImassess_logo"
#define Guide_Image_Work        @"GuideImassess_work"
#define Guide_Image_Userinfo    @"GuideImassess_userinfo"

#import <UIKit/UIKit.h>

@class IMAssessHomeView;
@class GuideVCodeView;
@class HNBIMAssessButton;
@protocol IMAssessHomeViewDelegate<NSObject>

@optional
-(void)IMAssessHomeViewNext:(id)sender;
-(void)IMAssessHomeViewGetIMCase;
-(void)IMAssessHomeViewGetVCode:(id)sender vCodeView:(GuideVCodeView *)vCodeView;
-(void)IMAssessHomeViewGetIMCaseWithLogin;
-(void)IMAssessHomeChoseSingleBtn:(HNBIMAssessButton *)hnbBtn;
@end

@class HNBIMAssessButton;
@class GuideVCodeView;

static const int gChoseCountryPage = 0;
static const int gChoseTargetPage = 1;
static const int gWithOutWorkPage = 6;
static const int gWholePage = 7;

@interface IMAssessHomeView : UIView

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
    IMState_ING_IM = 1,
    IMState_ED_IM,
} IMStateChose;

@property (nonatomic, strong) UIImageView *logo_imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *login_btn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIScrollView *pagingView;
@property (nonatomic, strong) NSMutableArray *optionsBtnArr;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) GuideVCodeView *vCodeView;
@property (nonatomic, weak) id<IMAssessHomeViewDelegate> delegate;

-(void)backLastedPage;
/*想移民*/
- (void)setButtonsViewWithData:(NSArray *)datas imageStr:(NSString *)imageStr attributtitle:(NSMutableAttributedString *)attributtitle page:(NSInteger)page wholePage:(NSInteger)wholePage;

@end

