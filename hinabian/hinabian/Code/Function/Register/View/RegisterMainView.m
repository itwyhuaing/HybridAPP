//
//  RegisterMainView.m
//  hinabian
//
//  Created by 何松泽 on 16/9/7.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#define ITEM_TOP_GAP 27
#define ITEM_HEIGHT 44
#define ITEM_LEADING_GAP 12
#define VISABLE_BTN_WIDTH   20*SCREEN_SCALE
#define THIRD_PART_ITEM_HEIGT 110

#import "RegisterMainView.h"
#import "NationCodesView.h"
#import "UIButton+ClickEventTime.h"

@interface RegisterMainView () <NationCodesViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>{
    BOOL isVisble;
    BOOL isAgree;
}

@property (strong, nonatomic) NationCodesView *nationCodeTable;

@end

@implementation RegisterMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadViewWithFame:frame];
    }
    return self;
}


- (void)loadViewWithFame:(CGRect)frame{
    
    NSArray *phoneArr = [[NSBundle mainBundle] loadNibNamed:@"LoginItemBtnStyle" owner:self options:nil];
    UIView *phoneItem = [phoneArr objectAtIndex:0];
    [phoneItem setFrame:CGRectMake(0, ITEM_TOP_GAP, SCREEN_WIDTH, ITEM_HEIGHT)];
    [self addSubview:phoneItem];
    
    _countryCode = [phoneItem viewWithTag:10];
    
    _nationCodeBtn = [phoneItem viewWithTag:15];
    [_nationCodeBtn addTarget:self action:@selector(clickEventButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _phoneNumInput = [phoneItem viewWithTag:13];
    _phoneNumInput.delegate = (id)self;
    _phoneNumInput.keyboardType = UIKeyboardTypePhonePad;
    _phoneNumInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _confirmBtn = [phoneItem viewWithTag:14];
    _confirmBtn.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0;
    _confirmBtn.layer.borderWidth = 1.0f;
    _confirmBtn.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:1.0].CGColor;
    [_confirmBtn setTitleColor:[UIColor DDR63_G162_B255ColorWithalph:1.0] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(clickEventButton:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *codeArr = [[NSBundle mainBundle] loadNibNamed:@"LoginItemTextStytle" owner:self options:nil];
    UIView *codeItem = [codeArr objectAtIndex:0];
    [codeItem setFrame:CGRectMake(0, ITEM_TOP_GAP + ITEM_HEIGHT, SCREEN_WIDTH, ITEM_HEIGHT)];
    [self addSubview:codeItem];
    _confirmCode = [codeItem viewWithTag:21];
    _confirmCode.keyboardType = UIKeyboardTypePhonePad;
    _confirmCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    /*密码btn*/
    NSArray *pwdArr = [[NSBundle mainBundle] loadNibNamed:@"RegisterItemTextStytle" owner:self options:nil];
    UIView *pwdItem = [pwdArr objectAtIndex:0];
    [pwdItem setFrame:CGRectMake(0, ITEM_TOP_GAP + ITEM_HEIGHT*2, SCREEN_WIDTH, ITEM_HEIGHT)];
    [self addSubview:pwdItem];
    
    _pwdLabel = [pwdItem viewWithTag:20];
    _pwdInput = [pwdItem viewWithTag:21];
    _pwdInput.delegate = (id)self;
    _pwdInput.secureTextEntry = YES;
    _pwdInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    _visibleImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"reg_code_eye_btn_default"]];
    [_visibleImage setFrame:CGRectMake(SCREEN_WIDTH - ITEM_LEADING_GAP - VISABLE_BTN_WIDTH, ITEM_HEIGHT/2 - 4, VISABLE_BTN_WIDTH, 8*SCREEN_SCALE)];
    _visableBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - ITEM_LEADING_GAP - VISABLE_BTN_WIDTH, 0, VISABLE_BTN_WIDTH, ITEM_HEIGHT)];
    _visableBtn.tag = RegisterVisableBtnTag;
    [_visableBtn addTarget:self action:@selector(clickEventButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [pwdItem addSubview:_visibleImage];
    [pwdItem addSubview:_visableBtn];
    
    
    /*注册btn*/
    _completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(ITEM_LEADING_GAP,ITEM_TOP_GAP + ITEM_HEIGHT * 3 + 28, SCREEN_WIDTH - ITEM_LEADING_GAP*2, 38)];
    _completeBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_UI28PX];
    _completeBtn.titleLabel.textColor = [UIColor whiteColor];
    _completeBtn.backgroundColor = [UIColor DDR63_G162_B255ColorWithalph:0.6];
    _completeBtn.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0;
    _completeBtn.tag = RegisterBtnTag;
    [_completeBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_completeBtn addTarget:self action:@selector(clickEventButton:) forControlEvents:UIControlEventTouchUpInside];
    _confirmBtn.custom_acceptEventInterval = 2.f; // 防止抖动频繁点击
    [self addSubview:_completeBtn];
    
    /*同意Label*/
    _nikeBtn = [[UIButton alloc]initWithFrame:CGRectMake(ITEM_LEADING_GAP, _completeBtn.frame.origin.y + _completeBtn.frame.size.height + 15, 10, 10)];
    _nikeBtn.tag = RegisterNikeBtnTag;
    [_nikeBtn setImage:[UIImage imageNamed:@"reg_content_agree_btn_default"] forState:UIControlStateNormal];
    [_nikeBtn addTarget:self action:@selector(clickEventButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *agreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(ITEM_LEADING_GAP + 10 + 4,  _completeBtn.frame.origin.y + _completeBtn.frame.size.height + 15, 200, 10)];
    agreeLabel.font = [UIFont systemFontOfSize:FONT_UI28PX];
    agreeLabel.textColor = [UIColor colorWithRed:50/255.0f green:50/255.0f blue:50/255.0f alpha:1.0];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"同意 海那边用户使用条款"];
    NSRange grayRange = NSMakeRange([[str string] rangeOfString:@"同意"].location, [[str string] rangeOfString:@"同意"].length);
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1.0] range:grayRange];
    [agreeLabel setAttributedText: str];
    
    UIButton *agreeBtn = [[UIButton alloc]initWithFrame:CGRectMake(ITEM_LEADING_GAP + 25, _completeBtn.frame.origin.y + _completeBtn.frame.size.height + 15, SCREEN_WIDTH/2 -30, 10)];
    agreeBtn.tag = RegisterAgreeBtnTag;
    [agreeBtn setBackgroundColor:[UIColor clearColor]];
    [agreeBtn addTarget:self action:@selector(clickEventButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_nikeBtn];
    [self addSubview:agreeLabel];
    [self addSubview:agreeBtn];
    
    // 国家码列表
    _nationCodeTable = [[NationCodesView alloc] initWithDelegate:self];
    //密码是否可见
    isVisble = FALSE;
    //默认同意条款
    isAgree = TRUE;
    // Observer 输入状态
    [_phoneNumInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_confirmCode addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_pwdInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark ------ click event

- (void)clickEventButton:(UIButton *)btn{
    [self endEditing:YES];
    if (btn.tag == RegisterNationCodeBtnTag) { // 展示国家吗列表
        [_nationCodeTable showNationCodesTableView];
    }else if (btn.tag == RegisterVisableBtnTag){
        if (isVisble) {
            [_visibleImage setImage:[UIImage imageNamed:@"reg_code_eye_btn_default"]];
            [_visibleImage setFrame:CGRectMake(SCREEN_WIDTH - ITEM_LEADING_GAP - VISABLE_BTN_WIDTH, ITEM_HEIGHT/2 - 4*SCREEN_SCALE, VISABLE_BTN_WIDTH, 8*SCREEN_SCALE)];
            _pwdInput.secureTextEntry = TRUE;
            [_pwdInput becomeFirstResponder];
            isVisble = FALSE;
        }else{
            [_visibleImage setImage:[UIImage imageNamed:@"reg_content_agree_btn_perssed"]];
            [_visibleImage setFrame:CGRectMake(SCREEN_WIDTH - ITEM_LEADING_GAP - VISABLE_BTN_WIDTH, ITEM_HEIGHT/2 - 6*SCREEN_SCALE, VISABLE_BTN_WIDTH, 11*SCREEN_SCALE)];
            _pwdInput.secureTextEntry = FALSE;
            [_pwdInput becomeFirstResponder];
            isVisble = TRUE;
        }
    }else if (btn.tag == RegisterNikeBtnTag){
        if (isAgree) {//如果原本同意，点击后不同意
            [_nikeBtn setImage:[UIImage imageNamed:@"reg_content_agree_btn_nonselect"] forState:UIControlStateNormal];
            isAgree = FALSE;
            _completeBtn.enabled = FALSE;
            _completeBtn.backgroundColor = [UIColor DDR63_G162_B255ColorWithalph:0.6f];
            _completeBtn.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:0.6f].CGColor;
        }else{//如果原本不同意，点击后同意
            [_nikeBtn setImage:[UIImage imageNamed:@"reg_content_agree_btn_default"] forState:UIControlStateNormal];
            isAgree = TRUE;
            if (_phoneNumInput.text.length >= 5 && _confirmCode.text.length > 0 && _pwdInput.text.length > 0){
                _completeBtn.enabled = TRUE;
                _completeBtn.backgroundColor = [UIColor DDR63_G162_B255ColorWithalph:1.0f];
                _completeBtn.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:1.0f].CGColor;
            }
        }
    }
    else{
        if (self.vcblock) {
            self.vcblock(btn);
        }
        
    }
    
}

#pragma mark ------ TextFieldDelegate

- (void)textFieldDidChange:(UITextField *)textField{
    
    if (_phoneNumInput.text.length >= 5 && _confirmCode.text.length > 0 && _pwdInput.text.length > 0 && isAgree) {
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
