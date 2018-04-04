//
//  IMAssessHomeView.m
//  hinabian
//
//  Created by 何松泽 on 2017/11/24.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "IMAssessHomeView.h"
#import "HNBIMAssessButton.h"
#import "GuideVCodeView.h"
#import "IMAssessItemsModel.h"
#import "IMNationCityModel.h"
#import "UIButton+ClickEventTime.h"

#define TitleTopToHeadImage 60.f

@interface IMAssessHomeView()<GuideVCodeViewDelegate>

@property (nonatomic, strong)NSNumber *valueNumber;
@property (nonatomic, assign)NSUInteger wholePage;

@end

static const float kNextBtnheight = 50.f;

@implementation IMAssessHomeView

-(id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setupMainView];
        self.pageNum = 0;
        self.optionsBtnArr = [NSMutableArray array];
        self.wholePage = gWithOutWorkPage;
        self.valueNumber = [NSNumber numberWithBool:TRUE];
        self.pagingView.hidden = NO;
    }
    
    return self;
}

- (void)setupMainView {
    
    self.logo_imageView.image = [UIImage imageNamed:@"GuideImassess_logo"];
    self.titleLabel.text = @"您想去的国家？（最多可以选择3个）";
    self.pagingView.hidden = YES;
}

/*想移民*/
- (void)setButtonsViewWithData:(NSArray *)datas imageStr:(NSString *)imageStr attributtitle:(NSMutableAttributedString *)attributtitle page:(NSInteger)page wholePage:(NSInteger)wholePage{
    /*将当前页数赋值到tag里*/
    self.nextBtn.tag = page;
    self.pageNum = page;
    self.logo_imageView.image = [UIImage imageNamed:imageStr];
    self.wholePage = wholePage;
    
    
    if (![HNBUtils isLogin]) {
        if (page == wholePage) {
            [self.nextBtn setTitle:@"生成移民方案" forState:UIControlStateNormal];
            self.nextBtn.custom_acceptEventInterval = 3.f; //防止连击
            [self setEnableBtn:self.nextBtn];
            [self.pagingView bringSubviewToFront:self.vCodeView];
            [self observeNextBtn];
        }
        self.vCodeView.sd_layout
        .topSpaceToView(self.pagingView,0)
        .leftSpaceToView(self.pagingView, wholePage*SCREEN_WIDTH)
        .widthIs(SCREEN_WIDTH)
        .heightIs(self.pagingView.size.height);
    }else {
        if (page == wholePage) {
            [self.nextBtn setTitle:@"生成移民方案" forState:UIControlStateNormal];
            self.nextBtn.custom_acceptEventInterval = 3.f; //防止连击
            [self observeNextBtn];
        }else {
            [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
            self.nextBtn.custom_acceptEventInterval = 0.3f; //防止连击
            [self observeNextBtn];
        }
        
    }
    
    if (!attributtitle) {
        self.titleLabel.hidden = YES;
    }else {
        self.titleLabel.hidden = NO;
        self.titleLabel.attributedText = attributtitle;
    }
    float distanceToBorder = 0.f;
    NSInteger line = 1;
    if (page == gChoseCountryPage) {
        distanceToBorder = 19.f;
        line = 3;
    }else{
        [self setLayoutWithOutTitle];
        
        if (page == gChoseTargetPage) {
            distanceToBorder = 35.f;
            line = 2;
        }else {
            distanceToBorder = 60.f;
            line = 1;
        }
    }
    if ([HNBUtils isLogin]) {
        if ((_optionsBtnArr.count >= _pageNum + 1 && _pageNum != 0) || (_optionsBtnArr.count > _pageNum && _pageNum == 0)) {
            return;
        }
    }else {
        if (_pageNum == wholePage || (_optionsBtnArr.count >= _pageNum + 1 && _pageNum != 0) || (_optionsBtnArr.count > _pageNum && _pageNum == 0)) {
            return;
        }
    }
    
    UIScrollView *verScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(_pageNum*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.pagingView.frame.size.height)];
    verScrollView.backgroundColor = [UIColor whiteColor];
    verScrollView.showsVerticalScrollIndicator = false;
    verScrollView.contentSize = CGSizeMake(SCREEN_WIDTH,  self.pagingView.frame.size.height);
    verScrollView.scrollEnabled = FALSE;
    [self.pagingView addSubview:verScrollView];
    
    for (NSInteger index = 0; index < datas.count; index++) {
        float buttonWidth = (SCREEN_WIDTH - distanceToBorder*(line + 1))/line;
        CGRect rect = CGRectZero;
        rect.origin.x   = ((index % line) + 1)*distanceToBorder + (index % line)* buttonWidth;
        rect.origin.y   = (index / line + 1)*19 + (index / line)* 45;
        rect.size.width = buttonWidth;
        rect.size.height= 45;
        
        if (index == datas.count - 1) {
            //            NSLog(@"Y======>%f,MAX========>%f,CONTENTSIZE=====>%f",rect.origin.y + 45 , self.pagingView.frame.size.height,self.pagingView.contentSize.height);
            if (rect.origin.y + 45 >self.pagingView.frame.size.height) {
                verScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, rect.origin.y + 45 + 10);
                verScrollView.scrollEnabled = YES;
            }
        }
        
        HNBIMAssessButton * tmpButton = [[HNBIMAssessButton alloc] initWithFrame:rect];
        tmpButton.title = [datas[index] valueForKey:@"name"]; /*标题*/
//        tmpButton.tag = [[datas[index] valueForKey:@"value"] longValue]; /*选项值*/
        tmpButton.idTag = [NSString stringWithFormat:@"%d",[[datas[index] valueForKey:@"value"] integerValue]];
        [tmpButton setOriginalBtn];
        [tmpButton addTarget:self action:@selector(choseButton:) forControlEvents:UIControlEventTouchUpInside];
        [verScrollView addSubview:tmpButton];
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

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _nextBtn.custom_acceptEventInterval = 0.3f; //防止连击
        [self setUnableBtn:_nextBtn];
        [_nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
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

- (UIView *)vCodeView {
    if (!_vCodeView) {
        _vCodeView = [[GuideVCodeView alloc] initWithFrame:CGRectZero];
        _vCodeView.backgroundColor = [UIColor whiteColor];
        _vCodeView.delegate = (id<GuideVCodeViewDelegate>)self;
        [self.pagingView addSubview:_vCodeView];
    }
    return _vCodeView;
}

#pragma mark -- Click Event

- (void)next:(id)sender {
    if (_pageNum != _wholePage) {
        if (_delegate && [_delegate respondsToSelector:@selector(IMAssessHomeViewNext:)]) {
            [_delegate IMAssessHomeViewNext:sender];
            
            [UIView animateWithDuration:0.5f animations:^{
                [self.pagingView setContentOffset:CGPointMake(_pageNum*SCREEN_WIDTH, 0)];
            }];
            /*不能放在delegate前*/
            [self observeNextBtn];
        }
    }else {
        if (![HNBUtils isLogin]) {
            if (![HNBUtils evaluateIsPhoneNum:_vCodeView.phoneTextfield.text]) {
                [[HNBToast shareManager] toastWithOnView:nil msg:@"请输入正确的手机号" afterDelay:1.0 style:HNBToastHudFailure];
            }else if (_vCodeView.nameTextfield.text.length <= 0) {
                [[HNBToast shareManager] toastWithOnView:nil msg:@"请输入您的姓名" afterDelay:1.0 style:HNBToastHudFailure];
            }else if (!_vCodeView.maleBtn.isSelected && !_vCodeView.femaleBtn.isSelected ) {
                [[HNBToast shareManager] toastWithOnView:nil msg:@"请选择您的性别" afterDelay:1.0 style:HNBToastHudFailure];
            }else if (_vCodeView.vCodeTextField.text.length < 4) {
                [[HNBToast shareManager] toastWithOnView:nil msg:@"请输入正确的验证码" afterDelay:1.0 style:HNBToastHudFailure];
            }else if ([HNBUtils evaluateIsPhoneNum:_vCodeView.phoneTextfield.text] && _vCodeView.nameTextfield.text.length > 0 &&(_vCodeView.femaleBtn.isSelected || _vCodeView.maleBtn.isSelected)) {
                /*获取移民方案*/
                if (_delegate && [_delegate respondsToSelector:@selector(IMAssessHomeViewGetIMCase)]) {
                    [_delegate IMAssessHomeViewGetIMCase];
                }
            }
        }else {
            //已登录的直接生成移民方案
            if (_delegate && [_delegate respondsToSelector:@selector(IMAssessHomeViewGetIMCaseWithLogin)]) {
                [_delegate IMAssessHomeViewGetIMCaseWithLogin];
            }
        }
        
    }
}

- (void)backLastedPage {
    if (_pageNum > 0) {
        _pageNum --;
        self.nextBtn.tag --;
        self.nextBtn.custom_acceptEventInterval = 0.3f; //防止连击
        [UIView animateWithDuration:0.5f animations:^{
            [self.pagingView setContentOffset:CGPointMake(_pageNum*SCREEN_WIDTH, 0)];
        }];
        [self observeNextBtn];
        if (_pageNum == gChoseCountryPage) {
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

- (void)choseButton:(HNBIMAssessButton *)hnbBtn {
    //只要点击就上报
    [self uploadClickBtn:hnbBtn];
    
    if (_optionsBtnArr.count <= _pageNum) {
        /*没有数据*/
        [hnbBtn setSelectedBtn];
        NSMutableArray *tempArr = [NSMutableArray arrayWithObject:hnbBtn];
        [_optionsBtnArr addObject:tempArr];
        [self observeNextBtn];
        if (_pageNum != gChoseCountryPage && _pageNum != gChoseTargetPage && _pageNum != _wholePage) {
            //除多选题外选择后直接跳转下一页
            [self next:_nextBtn];
        }
    }else{
        NSMutableArray *tempArr = [_optionsBtnArr objectAtIndex:_pageNum];
        if (hnbBtn.isSelected) {
            [tempArr removeObject:hnbBtn];
            [hnbBtn setOriginalBtn];
            [self observeNextBtn];
        }else{
            if ((_pageNum == gChoseCountryPage || _pageNum == gChoseTargetPage)) {
                /*前两道为多选题，最多3个选项*/
                if (tempArr.count < 3) {
                    /*选择不多于3个*/
                    [hnbBtn setSelectedBtn];
                    [tempArr addObject:hnbBtn];
                }else{
                    HNBIMAssessButton *tempBtn = [tempArr objectAtIndex:2];
                    [tempBtn setOriginalBtn];
                    [tempArr replaceObjectAtIndex:2 withObject:hnbBtn];
                    [hnbBtn setSelectedBtn];
                }
                [self observeNextBtn];
            }else{
                if (tempArr.count < 1) {
                    [hnbBtn setSelectedBtn];
                    [tempArr addObject:hnbBtn];
                    [self observeNextBtn];
                    
                    if (_pageNum != _wholePage) {
                        //如果不是最后一题，选择后直接跳转下一页
                        [self next:_nextBtn];
                    }
                }else{
                    HNBIMAssessButton *tempBtn = [tempArr objectAtIndex:0];
                    [tempBtn setOriginalBtn];
                    [tempArr replaceObjectAtIndex:0 withObject:hnbBtn];
                    [hnbBtn setSelectedBtn];
                    [self observeNextBtn];
                    if (_pageNum != _wholePage) {
                        //如果不是最后一题，选择后直接跳转下一页
                        [self next:_nextBtn];
                    }
                }
                
            }
            
        }
    }
    //    [self observeNextBtn];
}
//点击上报事件
- (void)uploadClickBtn:(HNBIMAssessButton *)btn {
    if (_pageNum == GuidePageCountry) {
        //未移民的选择国家
        NSDictionary *dic = @{@"f_national":btn.title,
                              @"value":_valueNumber,
                              };
        [HNBClick event:@"200004" Content:dic];
    }else if (_pageNum == GuidePagePurpose) {
        //未移民的为移民目的
        NSDictionary *dic = @{@"f_objective":btn.title,
                              @"value":_valueNumber,
                              };
        [HNBClick event:@"200011" Content:dic];
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
        if (_pageNum != _wholePage || [HNBUtils isLogin]) {
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
    if (_delegate && [_delegate respondsToSelector:@selector(IMAssessHomeViewGetVCode:vCodeView:)]) {
        [_delegate IMAssessHomeViewGetVCode:sender vCodeView:self.vCodeView];
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

