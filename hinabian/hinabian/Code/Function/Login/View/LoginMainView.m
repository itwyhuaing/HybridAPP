//
//  LoginMainView.m
//  hinabian
//
//  Created by hnbwyh on 16/9/1.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "LoginMainView.h"
#import "PhoneRegisterInputView.h"
#import "NationCodesView.h"
#import "UIButton+ClickEventTime.h"

#define ITEM_TOP_GAP 27 //35 - 8

@interface LoginMainView () <NationCodesViewDelegate>
@property (nonatomic,strong) UILabel *countryCode;
@property (nonatomic,strong) UILabel *confirmTitle;
@property (nonatomic,strong) UILabel *thirdLoginTitle;
@property (nonatomic,strong) UIButton *nationCodeBtn;
@property (nonatomic,strong) UIButton *userLoginBtn;
@property (strong, nonatomic) NationCodesView *nationCodeTable;

@end

@implementation LoginMainView

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
    _countryCode.textColor = [UIColor DDR50_G50_B50ColorWithalph:1.0f];
    _phoneNumInput = [phoneItem viewWithTag:13];
    _phoneNumInput.keyboardType = UIKeyboardTypePhonePad;
    _phoneNumInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    //_phoneNumInput.textColor = [UIColor DDR204_G204_B204ColorWithalph:1.0f];
    _confirmBtn = [phoneItem viewWithTag:14];
    _nationCodeBtn = [phoneItem viewWithTag:15];
    _confirmBtn.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0;
    _confirmBtn.layer.borderWidth = 1.0f;
    _confirmBtn.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:1.0].CGColor;
    [_confirmBtn setTitleColor:[UIColor DDR63_G162_B255ColorWithalph:1.0] forState:UIControlStateNormal];
    [_nationCodeBtn addTarget:self action:@selector(clickEventButton:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBtn addTarget:self action:@selector(clickEventButton:) forControlEvents:UIControlEventTouchUpInside];
    _nationCodeBtn.custom_acceptEventInterval = 2.f; // 防止抖动频繁点击
    _confirmBtn.custom_acceptEventInterval = 2.f; // 防止抖动频繁点击
    
    NSArray *codeArr = [[NSBundle mainBundle] loadNibNamed:@"LoginItemTextStytle" owner:self options:nil];
    UIView *codeItem = [codeArr objectAtIndex:0];
    [codeItem setFrame:CGRectMake(0, CGRectGetMaxY(phoneItem.frame), SCREEN_WIDTH, ITEM_HEIGHT)];
    [self addSubview:codeItem];
    _confirmTitle = [codeItem viewWithTag:20];
    _confirmTitle.textColor = [UIColor DDR50_G50_B50ColorWithalph:1.0f];
    _confirmCode = [codeItem viewWithTag:21];
    _confirmCode.keyboardType = UIKeyboardTypeNumberPad;
    _confirmCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    //_confirmCode.textColor = [UIColor DDR204_G204_B204ColorWithalph:1.0f];
    
    CGRect rect = CGRectZero;
    rect.origin.x = ITEM_LEADING_GAP;
    rect.origin.y = CGRectGetMaxY(codeItem.frame) + 28.f;
    rect.size.height = LOGIN_BTN_HEIGHT;// * SCREEN_SCALE;
    rect.size.width = SCREEN_WIDTH - 2 * ITEM_LEADING_GAP;
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn setFrame:rect];
    _loginBtn.tag = LoginBtnTag;
    [_loginBtn addTarget:self action:@selector(clickEventButton:) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.custom_acceptEventInterval = 1.5f; // 防止抖动频繁点击
    [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI28PX]];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn setEnabled:NO];
    _loginBtn.backgroundColor = [UIColor DDRegisterButtonEnable];
    _loginBtn.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0;
    [self addSubview:_loginBtn];
    
    rect.origin.y = CGRectGetMaxY(_loginBtn.frame) + 10.0;
    _userLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_userLoginBtn setFrame:rect];
    _userLoginBtn.tag = LoginUserBtnTag;
    [_userLoginBtn addTarget:self action:@selector(clickEventButton:) forControlEvents:UIControlEventTouchUpInside];
    _userLoginBtn.custom_acceptEventInterval = 1.5f; // 防止抖动频繁点击
    [_userLoginBtn.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI28PX]];
    [_userLoginBtn setTitle:@"账号登录" forState:UIControlStateNormal];
    [_userLoginBtn setTitleColor:[UIColor DDR63_G162_B255ColorWithalph:1.0] forState:UIControlStateNormal];
    _userLoginBtn.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0;
    _userLoginBtn.layer.borderWidth = 1.0;
    _userLoginBtn.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:1.0].CGColor;
    [self addSubview:_userLoginBtn];
    
    // 第三方登录
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"LoginThirdParty" owner:self options:nil];
    UIView *thirdItemView = [nibs objectAtIndex:0];
    /*对第三方登录view位置进行适配*/
    float scale = 1.0f;
    float distance = 0.f;
    if (SCREEN_HEIGHT == 736) {
        scale = 0.95f;
        distance = 15.f;
        [thirdItemView setFrame:CGRectMake(SCREEN_WIDTH*(1-scale)/2, SCREEN_HEIGHT - THIRD_PART_ITEM_HEIGT - SCREEN_NAVHEIGHT - SCREEN_STATUSHEIGHT - 23 - distance - SCREEN_HEIGHT*0.05, SCREEN_WIDTH *scale, THIRD_PART_ITEM_HEIGT + distance)];
    }else if(SCREEN_HEIGHT == 667){
        distance = 10.f;
        [thirdItemView setFrame:CGRectMake(SCREEN_WIDTH*(1-scale)/2, SCREEN_HEIGHT - THIRD_PART_ITEM_HEIGT - SCREEN_NAVHEIGHT - SCREEN_STATUSHEIGHT - 23 - distance - SCREEN_HEIGHT*0.03, SCREEN_WIDTH *scale, THIRD_PART_ITEM_HEIGT + distance)];
    }else{
        [thirdItemView setFrame:CGRectMake(SCREEN_WIDTH*(1-scale)/2, SCREEN_HEIGHT - THIRD_PART_ITEM_HEIGT - SCREEN_NAVHEIGHT - SCREEN_STATUSHEIGHT - 23 - distance - SCREEN_HEIGHT*0.01, SCREEN_WIDTH *scale, THIRD_PART_ITEM_HEIGT + distance)];
    }
    
    _thirdLoginTitle = (UILabel *)[thirdItemView viewWithTag:30];
    [_thirdLoginTitle setTextColor:[UIColor DDR204_G204_B204ColorWithalph:1.0]];
    _qqLoginBtn = (UIButton *)[thirdItemView viewWithTag:10];
//    [_qqLoginBtn setBackgroundImage:[UIImage imageNamed:@"login_qq_normal"] forState:UIControlStateNormal];
    [_qqLoginBtn setBackgroundImage:[UIImage imageNamed:@"login_qq_pressed"] forState:UIControlStateNormal];
    [_qqLoginBtn addTarget:self action:@selector(clickEventButton:) forControlEvents:UIControlEventTouchUpInside];
    _wechatLoginBtn = (UIButton *)[thirdItemView viewWithTag:20];
//    [_wechatLoginBtn setBackgroundImage:[UIImage imageNamed:@"login_wechat_normal"] forState:UIControlStateNormal];
    [_wechatLoginBtn setBackgroundImage:[UIImage imageNamed:@"login_wechat_pressed"] forState:UIControlStateNormal];
    [_wechatLoginBtn addTarget:self action:@selector(clickEventButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:thirdItemView];
    
    // 国家码列表
    _nationCodeTable = [[NationCodesView alloc] initWithDelegate:self];
    _nationCode = @"86";
    
    // Observer 输入状态
    [_phoneNumInput addTarget:self action:@selector(valuesChange:) forControlEvents:UIControlEventEditingChanged];
    [_confirmCode addTarget:self action:@selector(valuesChange:) forControlEvents:UIControlEventEditingChanged];
    
}


#pragma mark ------ Observer

- (void)valuesChange:(UITextField *)textField{

    if (_phoneNumInput.text.length >= 5 && _confirmCode.text.length > 0) {

        [_loginBtn setEnabled:YES];
        [_loginBtn setBackgroundColor:[UIColor DDR63_G162_B255ColorWithalph:1.0]];

    }else{

        [_loginBtn setEnabled:NO];
        [_loginBtn setBackgroundColor:[UIColor DDRegisterButtonEnable]];
        
    }
    
}

#pragma mark ------ click event

- (void)clickEventButton:(UIButton *)btn{

    [self endEditing:YES];
    
    if (btn.tag == LoginNationCodeBtnTag) { // 展示国家吗列表
        [_nationCodeTable showNationCodesTableView];
    }else{
        
        if (self.vcblock) {
            self.vcblock(btn);
        }
        
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self endEditing:YES];
    
}

#pragma mark ------ NationCodesViewDelegate

-(void)nationCodesView:(NationCodesView *)ncview didSelectedNationCode:(NSString *)selectedCode{

    //NSLog(@" %s ------ %@",__FUNCTION__,selectedCode);
    _nationCode = selectedCode;
    _countryCode.text = [NSString stringWithFormat:@"+ %@",selectedCode];

}

@end
