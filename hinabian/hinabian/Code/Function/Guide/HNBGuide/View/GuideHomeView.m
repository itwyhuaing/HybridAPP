//
//  GuideHomeView.m
//  hinabian
//
//  Created by 何松泽 on 2017/10/24.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "GuideHomeView.h"
#import "HNBIMAssessButton.h"
#import "GuideVCodeView.h"
#import "IMAssessItemsModel.h"
#import "IMNationCityModel.h"
#import "UIButton+ClickEventTime.h"
#import "HNBQuestionButtonView.h"
#import "IMNationCityModel.h"

#define TitleTopToHeadImage 60.f

@interface GuideHomeView()<GuideVCodeViewDelegate,HNBQuestionButtonViewDelegate>

//UI
@property (nonatomic, strong) UIImageView   *logo_imageView;
@property (nonatomic, strong) UIButton      *login_btn;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UIScrollView  *pagingView;

@property (nonatomic, strong) HNBIMAssessButton *IM_ED_btn;
@property (nonatomic, strong) HNBIMAssessButton *IM_ING_btn;
//
@property (nonatomic, strong)NSNumber *valueNumber;
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, assign)NSInteger wholePage;
//用于已移民
@property (nonatomic, strong)NSString *lastCountryID;

@end

static const float kNextBtnheight = 50.f;

@implementation GuideHomeView

-(id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setupMainView];
        self.pageNum = 0;
        self.isIM_ED = NO;
        self.optionsBtnArr = [NSMutableArray array];
        self.wholePage = gWithOutWorkPage;
        self.valueNumber = [NSNumber numberWithBool:NO];
    }
    
    return self;
}

- (void)setupMainView {
    
    self.logo_imageView.image = [UIImage imageNamed:@"GuideImassess_logo"];
    self.titleLabel.text = @"您使用海那边的目的?";
    self.IM_ING_btn.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self.titleLabel, 39.f)
    .widthIs(250)
    .heightIs(62);
    
    self.IM_ED_btn.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self.IM_ING_btn, 33.f)
    .widthIs(250)
    .heightIs(62);
    
    self.pagingView.hidden = YES;
}

/*想移民*/
- (void)setButtonsViewWithImageStr:(NSString *)imageStr attributtitle:(NSMutableAttributedString *)attributtitle page:(NSInteger)page wholePage:(NSInteger)wholePage{
    self.pageNum = page;
    self.logo_imageView.image = [UIImage imageNamed:imageStr];
    self.wholePage = wholePage;
    
    
    if (page == wholePage) {
        [self.nextBtn setTitle:@"生成移民方案" forState:UIControlStateNormal];
        self.nextBtn.custom_acceptEventInterval = 3.f; //防止连击
        [self setEnableBtn:self.nextBtn];
        [self.pagingView bringSubviewToFront:self.vCodeView];
    }
    self.vCodeView.sd_layout
    .topSpaceToView(self.pagingView,0)
    .leftSpaceToView(self.pagingView, wholePage*SCREEN_WIDTH)
    .widthIs(SCREEN_WIDTH)
    .heightIs(self.pagingView.size.height);
    
    if (!attributtitle) {
        self.titleLabel.hidden = YES;
    }else {
        self.titleLabel.hidden = NO;
        self.titleLabel.attributedText = attributtitle;
    }

    NSInteger line = 1;
    if (page == GuidePageCountry) {
        line = 3;
    }else{
        [self setLayoutWithOutTitle];

        if (page == GuidePagePurpose) {
            line = 2;
        }else {
            line = 1;
        }
    }
    
    self.HNBCountryView.hidden = NO;
    self.HNBPurposeView.hidden = NO;
    self.HNBExpenseView.hidden = NO;
    self.HNBLiveTimeView.hidden = NO;
    self.HNBEducationView.hidden = NO;
    self.HNBEnglishView.hidden = NO;
    self.HNBWorkingLifeView.hidden = NO;
    
}

-(void)setIMEDViewWithImageStr:(NSString *)imageStr title:(NSString *)title page:(NSInteger)page wholePage:(NSInteger)wholePage {
    self.pageNum = page;
    self.logo_imageView.image = [UIImage imageNamed:imageStr];
    self.wholePage = wholePage;
    
    if (!title) {
        _titleLabel.hidden = YES;
        [self setLayoutWithOutTitle];
    }else {
        _titleLabel.hidden = NO;
        _titleLabel.text = title;
    }
    
    self.HNBIMEDCountryView.hidden = NO;
    if (page == wholePage) {
        self.HNBIMEDCityView.hidden = NO;
    }

}

- (void)setLayoutWithOutTitle {
    self.logo_imageView.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self, 95)
    .widthIs(SCREEN_WIDTH)
    .heightIs(SCREEN_WIDTH/2.3);
    
    self.titleLabel.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self.logo_imageView, TitleTopToHeadImage - (SCREEN_WIDTH/2.3 - 115))
    .widthIs(SCREEN_WIDTH)
    .heightIs(40);

    _pagingView.sd_layout
    .topSpaceToView(self.titleLabel, 0)
    .leftSpaceToView(self, 0)
    .widthIs(SCREEN_WIDTH)
    .heightIs(SCREEN_HEIGHT - CGRectGetMaxY(self.titleLabel.frame) - kNextBtnheight - SUIT_IPHONE_X_HEIGHT);
}


#pragma mark -- Lazy Load

- (UIImageView *)logo_imageView {
    if (!_logo_imageView) {
        _logo_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GuideImassess_logo"]];
        [self addSubview:_logo_imageView];
        
        _logo_imageView.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(self, 95)
        .widthIs(145)
        .heightIs(115);
    }
    return _logo_imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 220 + TitleTopToHeadImage, SCREEN_WIDTH, 40)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.f*SCREEN_WIDTHRATE_6];
        _titleLabel.textColor = [UIColor DDR102_G102_B102ColorWithalph:1.0f];
        [self addSubview:_titleLabel];
        
        _titleLabel.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(self.logo_imageView, TitleTopToHeadImage)
        .widthIs(SCREEN_WIDTH)
        .heightIs(40);
    }
    return _titleLabel;
}

- (HNBIMAssessButton *)IM_ING_btn {
    if (!_IM_ING_btn) {
        _IM_ING_btn = [[HNBIMAssessButton alloc] initWithDescribeFrame:CGRectMake(0, 0, 250, 62)];
        _IM_ING_btn.describe = @"查阅资料，了解移民项目";
        _IM_ING_btn.title = @"我要移民";
        _IM_ING_btn.titleFont = [UIFont boldSystemFontOfSize:21*SCREEN_WIDTHRATE_6];
        _IM_ING_btn.layer.borderWidth = 1.0f;
        _IM_ING_btn.tag = IMState_ING_IM;
        [_IM_ING_btn addTarget:self action:@selector(choseIMState:) forControlEvents:UIControlEventTouchUpInside];
        [_IM_ING_btn setOriginalBtn];
        [self addSubview:_IM_ING_btn];
    }
    return _IM_ING_btn;
}

- (HNBIMAssessButton *)IM_ED_btn {
    if (!_IM_ED_btn) {
        _IM_ED_btn = [[HNBIMAssessButton alloc] initWithDescribeFrame:CGRectMake(0, 0, 250, 62)];
        _IM_ED_btn.describe = @"想找志同道合的朋友";
        _IM_ED_btn.title = @"我已移民";
        _IM_ED_btn.titleFont = [UIFont boldSystemFontOfSize:21*SCREEN_WIDTHRATE_6];
        _IM_ED_btn.layer.borderWidth = 1.0f;
        _IM_ED_btn.tag = IMState_ED_IM;
        [_IM_ED_btn addTarget:self action:@selector(choseIMState:) forControlEvents:UIControlEventTouchUpInside];
        [_IM_ED_btn setOriginalBtn];
        [self addSubview:_IM_ED_btn];
    }
    return _IM_ED_btn;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.custom_acceptEventInterval = 0.3f; //防止连击
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
        [self setUnableBtn:_nextBtn];
        [self addSubview:_nextBtn];
        
        _nextBtn.sd_layout
        .centerYEqualToView(self)
        .bottomSpaceToView(self, SUIT_IPHONE_X_HEIGHT)
        .widthIs(SCREEN_WIDTH)
        .heightIs(kNextBtnheight);
    }
    return _nextBtn;
}

- (UIScrollView *)pagingView {
    if (!_pagingView) {
        _pagingView = [[UIScrollView alloc] init];
        _pagingView.backgroundColor = [UIColor whiteColor];
        _pagingView.showsHorizontalScrollIndicator = false;
        _pagingView.pagingEnabled = true;
        _pagingView.contentOffset = CGPointMake(-SCREEN_WIDTH, 0);
        _pagingView.contentSize = CGSizeMake(SCREEN_WIDTH * 8,  (float)SCREEN_HEIGHT - CGRectGetMaxY(self.titleLabel.frame) - kNextBtnheight - SUIT_IPHONE_X_HEIGHT);
        _pagingView.scrollEnabled = FALSE;
        [self addSubview:_pagingView];
        
        _pagingView.sd_layout
        .topSpaceToView(self.titleLabel, 0)
        .leftSpaceToView(self, 0)
        .widthIs(SCREEN_WIDTH)
        .heightIs(SCREEN_HEIGHT - CGRectGetMaxY(self.titleLabel.frame) - kNextBtnheight + 10 - SUIT_IPHONE_X_HEIGHT);
    }
    return _pagingView;
}

- (GuideVCodeView *)vCodeView {
    if (!_vCodeView) {
        _vCodeView = [[GuideVCodeView alloc] initWithFrame:CGRectZero];
        _vCodeView.backgroundColor = [UIColor whiteColor];
        _vCodeView.delegate = (id<GuideVCodeViewDelegate>)self;
        [self.pagingView addSubview:_vCodeView];
    }
    return _vCodeView;
}

- (HNBQuestionButtonView *)HNBCountryView {
    if (!_HNBCountryView) {
        if (self.allQuestionsArr.count > GuidePageCountry) {
            
            IMAssessItemsModel *model = self.allQuestionsArr[GuidePageCountry];
            NSArray *optionsArr = [NSMutableArray arrayWithArray:model.option];
            
            _HNBCountryView = [HNBQuestionButtonView questionViewWithFrame:CGRectMake(GuidePageCountry*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.pagingView.frame.size.height) ButtonLines:HNBQuestionButtonLineThree dataArr:self.allQuestionsArr[GuidePageCountry] delegate:self];
            [_HNBCountryView setButtonWithArray:optionsArr titleKey:@"name" valueKey:@"value"];
            [self.pagingView addSubview:_HNBCountryView];
        }
    }
    return _HNBCountryView;
}

- (HNBQuestionButtonView *)HNBPurposeView {
    if (!_HNBPurposeView) {
        if (self.allQuestionsArr.count > GuidePagePurpose) {
            
            IMAssessItemsModel *model = self.allQuestionsArr[GuidePagePurpose];
            NSArray *optionsArr = [NSMutableArray arrayWithArray:model.option];
            
            _HNBPurposeView = [HNBQuestionButtonView questionViewWithFrame:CGRectMake(GuidePagePurpose*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.pagingView.frame.size.height) ButtonLines:HNBQuestionButtonLineTwo dataArr:self.allQuestionsArr[GuidePagePurpose] delegate:self];
            [_HNBPurposeView setButtonWithArray:optionsArr titleKey:@"name" valueKey:@"value"];
            [self.pagingView addSubview:_HNBPurposeView];
        }
    }
    return _HNBPurposeView;
}

- (HNBQuestionButtonView *)HNBExpenseView {
    if (!_HNBExpenseView) {
        if (self.allQuestionsArr.count > GuidePageExpense) {
            
            IMAssessItemsModel *model = self.allQuestionsArr[GuidePageExpense];
            NSArray *optionsArr = [NSMutableArray arrayWithArray:model.option];
            
            _HNBExpenseView = [HNBQuestionButtonView questionViewWithFrame:CGRectMake(GuidePageExpense*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.pagingView.frame.size.height) ButtonLines:HNBQuestionButtonLineOne dataArr:self.allQuestionsArr[GuidePageExpense] delegate:self];
            [_HNBExpenseView setButtonWithArray:optionsArr titleKey:@"name" valueKey:@"value"];
            [self.pagingView addSubview:_HNBExpenseView];
        }
    }
    return _HNBExpenseView;
}

- (HNBQuestionButtonView *)HNBLiveTimeView {
    if (!_HNBLiveTimeView) {
        if (self.allQuestionsArr.count > GuidePageLiveTime) {
            
            IMAssessItemsModel *model = self.allQuestionsArr[GuidePageLiveTime];
            NSArray *optionsArr = [NSMutableArray arrayWithArray:model.option];
            
            _HNBLiveTimeView = [HNBQuestionButtonView questionViewWithFrame:CGRectMake(GuidePageLiveTime*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.pagingView.frame.size.height) ButtonLines:HNBQuestionButtonLineOne dataArr:self.allQuestionsArr[GuidePageLiveTime] delegate:self];
            [_HNBLiveTimeView setButtonWithArray:optionsArr titleKey:@"name" valueKey:@"value"];
            [self.pagingView addSubview:_HNBLiveTimeView];
        }
    }
    return _HNBLiveTimeView;
}

- (HNBQuestionButtonView *)HNBEducationView {
    if (!_HNBEducationView) {
        if (self.allQuestionsArr.count > GuidePageEducation) {
            
            IMAssessItemsModel *model = self.allQuestionsArr[GuidePageEducation];
            NSArray *optionsArr = [NSMutableArray arrayWithArray:model.option];
            
            _HNBEducationView = [HNBQuestionButtonView questionViewWithFrame:CGRectMake(GuidePageEducation*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.pagingView.frame.size.height) ButtonLines:HNBQuestionButtonLineOne dataArr:self.allQuestionsArr[GuidePageEducation] delegate:self];
            [_HNBEducationView setButtonWithArray:optionsArr titleKey:@"name" valueKey:@"value"];
            [self.pagingView addSubview:_HNBEducationView];
        }
    }
    return _HNBEducationView;
}

- (HNBQuestionButtonView *)HNBEnglishView {
    if (!_HNBEnglishView) {
        if (self.allQuestionsArr.count > GuidePageEducation) {
            
            IMAssessItemsModel *model = self.allQuestionsArr[GuidePageEnglish];
            NSArray *optionsArr = [NSMutableArray arrayWithArray:model.option];
            
            _HNBEnglishView = [HNBQuestionButtonView questionViewWithFrame:CGRectMake(GuidePageEnglish*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.pagingView.frame.size.height) ButtonLines:HNBQuestionButtonLineOne dataArr:self.allQuestionsArr[GuidePageEnglish] delegate:self];
            [_HNBEnglishView setButtonWithArray:optionsArr titleKey:@"name" valueKey:@"value"];
            [self.pagingView addSubview:_HNBEnglishView];
        }
    }
    return _HNBEnglishView;
}

- (HNBQuestionButtonView *)HNBWorkingLifeView {
    if (!_HNBWorkingLifeView) {
        if (self.allQuestionsArr.count > GuidePageWorkingLife) {
            
            IMAssessItemsModel *model = self.allQuestionsArr[GuidePageWorkingLife];
            NSArray *optionsArr = [NSMutableArray arrayWithArray:model.option];
            
            _HNBWorkingLifeView = [HNBQuestionButtonView questionViewWithFrame:CGRectMake(GuidePageWorkingLife*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.pagingView.frame.size.height) ButtonLines:HNBQuestionButtonLineOne dataArr:_allQuestionsArr[GuidePageWorkingLife] delegate:self];
            [_HNBWorkingLifeView setButtonWithArray:optionsArr titleKey:@"name" valueKey:@"value"];
            [self.pagingView addSubview:_HNBWorkingLifeView];
        }
    }
    return _HNBWorkingLifeView;
}

- (HNBQuestionButtonView *)HNBIMEDCountryView {
    if (!_HNBIMEDCountryView) {
        _HNBIMEDCountryView = [HNBQuestionButtonView questionViewWithFrame:CGRectMake(GuidePageIMEDCountry*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.pagingView.frame.size.height) ButtonLines:HNBQuestionButtonLineThree dataArr:_allQuestionsArr delegate:self];
        [_HNBIMEDCountryView setIMEDNationButtonWithArray:_allQuestionsArr];
        [self.pagingView addSubview:_HNBIMEDCountryView];
    }
    return _HNBIMEDCountryView;
}

- (HNBQuestionButtonView *)HNBIMEDCityView {
    
    if (!_HNBIMEDCityView) {
        NSArray *tempArr = _optionsBtnArr[0];
        HNBIMAssessButton *tempBtn =tempArr[0];
        self.lastCountryID = tempBtn.idTag;
        for (IMNationCityModel *f in _allQuestionsArr) {
            if ([f.fID isEqualToString: tempBtn.idTag]) {
                if (f.city > 0) {
                    _HNBIMEDCityView = [HNBQuestionButtonView questionViewWithFrame:CGRectMake(GuidePageIMEDCity*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.pagingView.frame.size.height) ButtonLines:HNBQuestionButtonLineThree dataArr:f.city delegate:self];
                    [_HNBIMEDCityView setButtonWithArray:f.city titleKey:@"f_name_cn" valueKey:@"f_id"];
                    [self.pagingView addSubview:_HNBIMEDCityView];
                    break;
                }
            }
        }
    }
    return _HNBIMEDCityView;
}

#pragma mark -- Click Event

- (void)next:(id)sender {
    if (!_isIM_ED) {
        if (_pageNum != _wholePage) {
            if (_delegate && [_delegate respondsToSelector:@selector(GuideHomeViewNext)]) {
                [_delegate GuideHomeViewNext];
                
                [UIView animateWithDuration:0.5f animations:^{
                    [self.pagingView setContentOffset:CGPointMake(_pageNum*SCREEN_WIDTH, 0)];
                }];
                /*不能放在delegate前*/
                [self observeNextBtn];
            }
        }else {
            if (![HNBUtils evaluateIsPhoneNum:_vCodeView.phoneTextfield.text]) {
                [[HNBToast shareManager] toastWithOnView:nil msg:@"请输入正确的手机号" afterDelay:1.0 style:HNBToastHudFailure];
            }else if (_vCodeView.nameTextfield.text.length <= 0) {
                [[HNBToast shareManager] toastWithOnView:nil msg:@"请输入您的姓名" afterDelay:1.0 style:HNBToastHudFailure];
            }else if (_vCodeView.vCodeTextField.text.length < 4) {
                [[HNBToast shareManager] toastWithOnView:nil msg:@"请输入正确的验证码" afterDelay:1.0 style:HNBToastHudFailure];
            }else if ([HNBUtils evaluateIsPhoneNum:_vCodeView.phoneTextfield.text] && _vCodeView.nameTextfield.text.length > 0 &&(_vCodeView.femaleBtn.isSelected || _vCodeView.maleBtn.isSelected)) {
                /*获取移民方案*/
                if (_delegate && [_delegate respondsToSelector:@selector(GuideHomeViewGetIMCase)]) {
                    [_delegate GuideHomeViewGetIMCase];
                }
            }
        }
        
    }else {
        if (_delegate && [_delegate respondsToSelector:@selector(GuideHomeViewIMEDNext)]) {
            [_delegate GuideHomeViewIMEDNext];
            
            [UIView animateWithDuration:0.5f animations:^{
                [self.pagingView setContentOffset:CGPointMake(_pageNum*SCREEN_WIDTH, 0)];
            }];
            /*不能放在delegate前*/
            [self observeNextBtn];
        }
    }
}

- (void)backLastedPage {
    if (_pageNum > 0) {
        _pageNum --;
        self.nextBtn.custom_acceptEventInterval = 0.3f; //防止连击
        [UIView animateWithDuration:0.5f animations:^{
            [self.pagingView setContentOffset:CGPointMake(_pageNum*SCREEN_WIDTH, 0)];
        }];
        [self observeNextBtn];
        if (_pageNum == GuidePageCountry) {
            self.logo_imageView.sd_layout
            .centerXEqualToView(self)
            .topSpaceToView(self, 95)
            .widthIs(145)
            .heightIs(115);
            
            _titleLabel.sd_layout
            .centerXEqualToView(self)
            .topSpaceToView(self.logo_imageView, TitleTopToHeadImage)
            .widthIs(SCREEN_WIDTH)
            .heightIs(40);
            
            _pagingView.sd_layout
            .topSpaceToView(self.titleLabel, 0)
            .leftSpaceToView(self, 0)
            .widthIs(SCREEN_WIDTH)
            .heightIs(SCREEN_HEIGHT - CGRectGetMaxY(self.titleLabel.frame) - kNextBtnheight - SUIT_IPHONE_X_HEIGHT);
        }
    }
}

- (void)choseIMState:(UIButton *)sender {
    
    if (sender.tag == IMState_ING_IM) {
        self.isIM_ED = NO;
        //移民状态标识
        [HNBUtils sandBoxSaveInfo:@"WANT_IM" forKey:IM_INTENTION_LOCAL];
    }else if (sender.tag == IMState_ED_IM){
        self.isIM_ED = YES;
        //移民状态标识
        [HNBUtils sandBoxSaveInfo:@"IMED" forKey:IM_INTENTION_LOCAL];
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        [_titleLabel setCenterX:-SCREEN_WIDTH/2];
        [_IM_ING_btn setCenterX:-SCREEN_WIDTH/2];
        [_IM_ED_btn setCenterX:-SCREEN_WIDTH/2];
        _pagingView.hidden = NO;
    } completion:^(BOOL finished) {
        if (_delegate && [_delegate respondsToSelector:@selector(GuideHomeViewChoseIMState:)]) {
            [_delegate GuideHomeViewChoseIMState:sender];
        }
        [_titleLabel setCenterX:SCREEN_WIDTH+SCREEN_WIDTH/2];
        self.nextBtn.hidden = NO;
        [UIView animateWithDuration:0.5f animations:^{
            [_titleLabel setCenterX:SCREEN_WIDTH/2];
            [self.pagingView setContentOffset:CGPointMake(0, 0)];
        }];
    }];
}

- (void)hnbQuestionChoose:(HNBIMAssessButton *)hnbBtn {
    //只要点击就上报
    [self uploadClickBtn:hnbBtn];
    
    if (_optionsBtnArr.count <= _pageNum) {
        /*没有数据*/
        [hnbBtn setSelectedBtn];
        NSMutableArray *tempArr = [NSMutableArray arrayWithObject:hnbBtn];
        [_optionsBtnArr addObject:tempArr];
        [self observeNextBtn];
        
        if ((_pageNum != GuidePageCountry && _pageNum != GuidePagePurpose && _pageNum != _wholePage) || _isIM_ED) {
            //除多选题以及想移民的最后一题 直接跳转下一页
            [self next:_nextBtn];
        }
    }else{
        NSMutableArray *tempArr = [_optionsBtnArr objectAtIndex:_pageNum];
        if (hnbBtn.isSelected) {
            [tempArr removeObject:hnbBtn];
            [hnbBtn setOriginalBtn];
        }else{
            
            NSInteger limitedCount = 1; //默认单选题
            /*前两道为多选题，最多3个选项*/
            if ((_pageNum == GuidePageCountry || _pageNum == GuidePagePurpose) && !_isIM_ED) {
                limitedCount = 3;
            }
            if (tempArr.count < limitedCount) {
                [tempArr addObject:hnbBtn];
            }else{
                HNBIMAssessButton *tempBtn = [tempArr objectAtIndex:limitedCount - 1];
                [tempBtn setOriginalBtn];
                [tempArr replaceObjectAtIndex:limitedCount - 1 withObject:hnbBtn];
            }
            
            if (((_pageNum != GuidePageCountry && _pageNum != GuidePagePurpose) || _isIM_ED) && _pageNum != _wholePage) {
                [self next:_nextBtn];
            }
            
            [hnbBtn setSelectedBtn];
        }
        [self observeNextBtn];
    }
}

//点击上报事件
- (void)uploadClickBtn:(HNBIMAssessButton *)btn {
    if (_pageNum == GuidePageCountry) {
        if (!_isIM_ED) {
            //未移民的选择国家
            NSDictionary *dic = @{@"f_national":btn.title,
                                  @"value":_valueNumber,
                                  };
            [HNBClick event:@"200004" Content:dic];
        }else {
            //已移民的选择国家
            NSDictionary *dic = @{@"f_national":btn.title,
                                  @"value":_valueNumber,
                                  };
            [HNBClick event:@"200006" Content:dic];
        }
    }else if (_pageNum == GuidePagePurpose) {
        if (!_isIM_ED) {
            //未移民的为移民目的
            NSDictionary *dic = @{@"f_objective":btn.title,
                                  @"value":_valueNumber,
                                  };
            [HNBClick event:@"200011" Content:dic];
        }else {
            //已移民的为移民城市
            NSDictionary *dic = @{@"value":_valueNumber,};
            [HNBClick event:@"200008" Content:dic];
        }
    }else if (_pageNum == GuidePageExpense) {
        NSDictionary *dic = @{@"value":_valueNumber,};
        [HNBClick event:@"200013" Content:dic];
    }else if (_pageNum == GuidePageLiveTime) {
        NSDictionary *dic = @{@"value":_valueNumber,};
        [HNBClick event:@"200015" Content:dic];
    }else if (_pageNum == GuidePageEducation) {
        NSDictionary *dic = @{@"value":_valueNumber,};
        [HNBClick event:@"200017" Content:dic];
    }else if (_pageNum == GuidePageEnglish) {
        NSDictionary *dic = @{@"value":_valueNumber,};
        [HNBClick event:@"200019" Content:dic];
    }else if (_pageNum == GuidePageWorkingLife) {
        NSDictionary *dic = @{@"value":_valueNumber,};
        [HNBClick event:@"200021" Content:dic];
    }
}

- (void)observeNextBtn {
    if (_optionsBtnArr.count <= _pageNum) {
        if (_pageNum != _wholePage || _isIM_ED) {
            /*
             ** 除了需要填验证码的题目，都不允许最后一题点击
             */
            [self setUnableBtn:self.nextBtn];
        }
    }else {
        NSMutableArray *tempArr = [_optionsBtnArr objectAtIndex:_pageNum];
        if (tempArr.count == 0) {
            [self setUnableBtn:self.nextBtn];
        }else{
            [self setEnableBtn:self.nextBtn];
        }
    }
}

#pragma mark -- GuideVCodeViewDelegate
-(void)GuideVCodeViewGetVCode:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(GuideHomeViewGetVCode:vCodeView:)]) {
        [_delegate GuideHomeViewGetVCode:sender vCodeView:self.vCodeView];
    }
}


- (void)setUnableBtn:(UIButton *)sender {
    [sender setEnabled:NO];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1.f];
}

- (void)setEnableBtn:(UIButton *)sender {
    [sender setEnabled:YES];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor DDNavBarBlue]];
}

@end
