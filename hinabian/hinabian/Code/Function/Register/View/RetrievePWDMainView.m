//
//  RetrievePWDMainView.m
//  hinabian
//
//  Created by 何松泽 on 16/9/5.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#define ITEM_TOP_GAP 27
#define ITEM_HEIGHT 44
#define ITEM_LEADING_GAP 12

#import "RetrievePWDMainView.h"
#import "NationCodesView.h"
#import "UIButton+ClickEventTime.h"

@interface RetrievePWDMainView () <NationCodesViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *pagingView; //用于找回密码

@property (strong, nonatomic) NationCodesView *nationCodeTable;

@end

@implementation RetrievePWDMainView

- (instancetype)initWithFrame:(CGRect)frame withPhoneNum:(NSString *)phoneNum
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadViewWithFame:frame withPhoneNum:phoneNum];
    }
    return self;
}


- (void)loadViewWithFame:(CGRect)frame withPhoneNum:(NSString *)phoneNum{
    //加入分页
    self.pagingView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, (float)SCREEN_WIDTH, (float)SCREEN_HEIGHT)];
    self.pagingView.backgroundColor = [UIColor whiteColor];
    self.pagingView.delegate = self;
    self.pagingView.showsHorizontalScrollIndicator = false;
    self.pagingView.pagingEnabled = true;
    self.pagingView.contentSize = CGSizeMake(self.pagingView.frame.size.width * 3,  self.pagingView.frame.size.height );
    self.pagingView.scrollEnabled = FALSE;
    [self addSubview:self.pagingView];
    
    NSArray *phoneArr = [[NSBundle mainBundle] loadNibNamed:@"LoginItemBtnStyle" owner:self options:nil];
    UIView *phoneItem = [phoneArr objectAtIndex:0];
    [phoneItem setFrame:CGRectMake(0, ITEM_TOP_GAP, SCREEN_WIDTH, ITEM_HEIGHT)];
    [self.pagingView addSubview:phoneItem];
    
    _countryCode = [phoneItem viewWithTag:10];
    
    _nationCodeBtn = [phoneItem viewWithTag:15];
    [_nationCodeBtn addTarget:self action:@selector(clickEventButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _phoneNumInput = [phoneItem viewWithTag:13];
    _phoneNumInput.delegate = (id)self;
    _phoneNumInput.keyboardType = UIKeyboardTypePhonePad;
    if (![phoneNum isEqualToString:@""] && phoneNum != nil) {
        _phoneNumInput.text = phoneNum;
        _phoneNumInput.enabled = FALSE;
    }else{
        _phoneNumInput.enabled = TRUE;
        _phoneNumInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    
    _confirmBtn = [phoneItem viewWithTag:14];
    _confirmBtn.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0;
    _confirmBtn.layer.borderWidth = 1.0f;
    _confirmBtn.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:1.0].CGColor;
    [_confirmBtn setTitleColor:[UIColor DDR63_G162_B255ColorWithalph:1.0] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(clickEventButton:) forControlEvents:UIControlEventTouchUpInside];
    _confirmBtn.custom_acceptEventInterval = 2.f; // 防止抖动频繁点击
    
    NSArray *codeArr = [[NSBundle mainBundle] loadNibNamed:@"LoginItemTextStytle" owner:self options:nil];
    UIView *codeItem = [codeArr objectAtIndex:0];
    [codeItem setFrame:CGRectMake(0, ITEM_TOP_GAP + ITEM_HEIGHT, SCREEN_WIDTH, ITEM_HEIGHT)];
    [self.pagingView addSubview:codeItem];
    _confirmCode = [codeItem viewWithTag:21];
    _confirmCode.keyboardType = UIKeyboardTypePhonePad;
    _confirmCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(ITEM_LEADING_GAP,ITEM_TOP_GAP + ITEM_HEIGHT + ITEM_HEIGHT + 28, SCREEN_WIDTH - ITEM_LEADING_GAP*2, 38)];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_UI28PX];
    _nextBtn.titleLabel.textColor = [UIColor whiteColor];
    _nextBtn.backgroundColor = [UIColor DDR63_G162_B255ColorWithalph:0.6];
    _nextBtn.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0;
    _nextBtn.layer.borderWidth = 0.5f;
    _nextBtn.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:0.6].CGColor;
    _nextBtn.tag = RetrieveNextBtnTag;
    
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(clickEventButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.pagingView addSubview:_nextBtn];
    
    // 国家码列表
    _nationCodeTable = [[NationCodesView alloc] initWithDelegate:self];
    
    // Observer 输入状态
    [_phoneNumInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_confirmCode addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self addNewPWDPage];
}

#pragma mark ------ click event

- (void)clickEventButton:(UIButton *)btn{
    [self endEditing:YES];
    if (btn.tag == RetrieveNationCodeBtnTag) { // 展示国家吗列表
        [_nationCodeTable showNationCodesTableView];
    }else{
        
        if (self.vcblock) {
            self.vcblock(btn);
        }
        
    }
    
}

//添加编辑新密码页面
- (void)addNewPWDPage
{
    NSArray *pwdArr = [[NSBundle mainBundle] loadNibNamed:@"RetrievePWDTextStyle" owner:self options:nil];
    UIView *pwdItem = [pwdArr objectAtIndex:0];
    [pwdItem setFrame:CGRectMake(SCREEN_WIDTH, ITEM_TOP_GAP, SCREEN_WIDTH, ITEM_HEIGHT)];
    [self.pagingView addSubview:pwdItem];
    
    _pwdLabel = [pwdItem viewWithTag:20];
    _pwdLabel.text = @"新 密 码";
    
    _pwdInput = [pwdItem viewWithTag:21];
    _pwdInput.placeholder = @"请输入新密码";
    _pwdInput.delegate = (id)self;
    _pwdInput.secureTextEntry = TRUE;
    _pwdInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    /*-------------------------------------*/
    NSArray *sureArr = [[NSBundle mainBundle] loadNibNamed:@"RetrievePWDTextStyle" owner:self options:nil];
    UIView *sureItem = [sureArr objectAtIndex:0];
    [sureItem setFrame:CGRectMake(SCREEN_WIDTH, ITEM_TOP_GAP + ITEM_HEIGHT, SCREEN_WIDTH, ITEM_HEIGHT)];
    [self.pagingView addSubview:sureItem];
    
    _surePWDLabel = [sureItem viewWithTag:20];
    _surePWDLabel.text = @"确认新密码";
    
    _surePWDInput = [sureItem viewWithTag:21];
    _surePWDInput.placeholder = @"请再次输入新密码";
    _surePWDInput.delegate = (id)self;
    _surePWDInput.secureTextEntry = TRUE;
    _surePWDInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH+ITEM_LEADING_GAP,ITEM_TOP_GAP + ITEM_HEIGHT + ITEM_HEIGHT + 28, SCREEN_WIDTH - ITEM_LEADING_GAP*2, 38)];
    _completeBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_UI28PX];
    _completeBtn.titleLabel.textColor = [UIColor whiteColor];
    _completeBtn.backgroundColor = [UIColor DDR63_G162_B255ColorWithalph:0.6];
    _completeBtn.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0;
    _completeBtn.tag = RetrieveCompleteBtnTag;
    
    [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_completeBtn addTarget:self action:@selector(clickEventButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.pagingView addSubview:_completeBtn];
    // Observer 输入状态
    [_pwdInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_surePWDInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)nextOperation
{
    [self.pagingView endEditing:YES];
    CGPoint pt = self.pagingView.contentOffset;
    if(pt.x == SCREEN_WIDTH * 2){
        [self.pagingView setContentOffset:CGPointMake(0, 0)];
        [self.pagingView scrollRectToVisible:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT) animated:YES];
    }else{
        pt.x += SCREEN_WIDTH;
        [self.pagingView setContentOffset:pt animated:YES];
    }
}

#pragma mark ------ TextFieldDelegate

- (void)textFieldDidChange:(UITextField *)textField{
    
    if (_phoneNumInput.text.length >= 5 && _confirmCode.text.length > 0) {
        _nextBtn.enabled = TRUE;
        _nextBtn.backgroundColor = [UIColor DDR63_G162_B255ColorWithalph:1.0f];
        _nextBtn.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:1.0f].CGColor;
        
    }else{
        _nextBtn.enabled = FALSE;
        _nextBtn.backgroundColor = [UIColor DDR63_G162_B255ColorWithalph:0.6f];
        _nextBtn.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:0.6f].CGColor;
        
    }
    if (_pwdInput.text.length > 0 && _surePWDInput.text.length > 0) {
        _completeBtn.enabled = TRUE;
        _completeBtn.backgroundColor = [UIColor DDR63_G162_B255ColorWithalph:1.0f];
        _completeBtn.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:1.0f].CGColor;
        
    }else{
        _completeBtn.enabled = FALSE;
        _completeBtn.backgroundColor = [UIColor DDR63_G162_B255ColorWithalph:0.6f];
        _completeBtn.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:0.6f].CGColor;
        
    }
    
}

#pragma mark ------ NationCodesViewDelegate

-(void)nationCodesView:(NationCodesView *)ncview didSelectedNationCode:(NSString *)selectedCode{
    
    _countryCode.text = [NSString stringWithFormat:@"+ %@",selectedCode];
    
}

@end
