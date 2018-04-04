//
//  BindingMainView.m
//  hinabian
//
//  Created by 何松泽 on 16/9/6.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#define ITEM_TOP_GAP 27
#define ITEM_HEIGHT 44
#define ITEM_LEADING_GAP 12
#define PHONE_IMAGE_HEIGT 130

#import "BindingMainView.h"
#import "NationCodesView.h"
#import "BindingSuccessView.h"


@interface BindingMainView () <NationCodesViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *pagingView; //用于找回密码
@property (nonatomic,strong) BindingSuccessView *successView;

@property (strong, nonatomic) NationCodesView *nationCodeTable;

@end

@implementation BindingMainView

- (instancetype)initWithFrame:(CGRect)frame
                   andFindPWD:(BOOL)isFindPWD
{
    self = [super initWithFrame:frame];
    if (self) {
        _isFindPWD = isFindPWD;
        [self loadViewWithFame:frame];
    }
    return self;
}

- (void)loadViewWithFame:(CGRect)frame{
    //加入分页
    self.pagingView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, (float)SCREEN_WIDTH, (float)SCREEN_HEIGHT)];
    self.pagingView.backgroundColor = [UIColor whiteColor];
    self.pagingView.delegate = self;
    self.pagingView.showsHorizontalScrollIndicator = false;
    self.pagingView.pagingEnabled = true;
    self.pagingView.contentSize = CGSizeMake(self.pagingView.frame.size.width * 3,  self.pagingView.frame.size.height );
    self.pagingView.scrollEnabled = FALSE;
    [self addSubview:self.pagingView];
    
    float topDistance = 0;
    if (_isFindPWD) {
        topDistance = 75;
        UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ITEM_TOP_GAP/2, SCREEN_WIDTH, 75)];
        topLabel.numberOfLines = 2;
        topLabel.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.0];
        /*行间距*/
        NSString *labelStr = @"您当前账号未绑定手机号\n需要在此页面完成绑定才可找回密码";
        [self setLabelSpace:topLabel withValue:labelStr withFont:[UIFont systemFontOfSize:FONT_UI24PX]withLineSpacing:4.f];
        
        [self.pagingView addSubview:topLabel];
    }else{
        topDistance = 0;
    }
    
    NSArray *phoneArr = [[NSBundle mainBundle] loadNibNamed:@"LoginItemBtnStyle" owner:self options:nil];
    UIView *phoneItem = [phoneArr objectAtIndex:0];
    [phoneItem setFrame:CGRectMake(0, ITEM_TOP_GAP + topDistance, SCREEN_WIDTH, ITEM_HEIGHT)];
    [self.pagingView addSubview:phoneItem];
    
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
    _confirmBtn.custom_acceptEventInterval = 2.f; // 防止抖动频繁点击

    
    NSArray *codeArr = [[NSBundle mainBundle] loadNibNamed:@"LoginItemTextStytle" owner:self options:nil];
    UIView *codeItem = [codeArr objectAtIndex:0];
    [codeItem setFrame:CGRectMake(0, ITEM_TOP_GAP + ITEM_HEIGHT + topDistance, SCREEN_WIDTH, ITEM_HEIGHT)];
    [self.pagingView addSubview:codeItem];
    
    _confirmCode = [codeItem viewWithTag:21];
    _confirmCode.delegate = (id)self;
    _confirmCode.keyboardType = UIKeyboardTypePhonePad;
    _confirmCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(ITEM_LEADING_GAP,ITEM_TOP_GAP + ITEM_HEIGHT + ITEM_HEIGHT + 28 + topDistance, SCREEN_WIDTH - ITEM_LEADING_GAP*2, 38)];
    _completeBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_UI28PX];
    _completeBtn.titleLabel.textColor = [UIColor whiteColor];
    _completeBtn.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0;
    _completeBtn.enabled = FALSE;
    _completeBtn.backgroundColor = [UIColor DDR63_G162_B255ColorWithalph:0.6];
    _completeBtn.tag = BindingCompleteBtnTag;
    if (_isFindPWD) {
        [_completeBtn setTitle:@"提交" forState:UIControlStateNormal];
    }else{
        [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    [_completeBtn addTarget:self action:@selector(clickEventButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.pagingView addSubview:_completeBtn];
    
    // 国家码列表
    _nationCodeTable = [[NationCodesView alloc] initWithDelegate:self];
    
    // Observer 输入状态
    [_phoneNumInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_confirmCode addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

//给UILabel设置行间距和字间距
-(void)setLabelSpace:(UILabel*)label
           withValue:(NSString*)str
            withFont:(UIFont*)font
     withLineSpacing:(float)lineSpacing{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineSpacing = lineSpacing; //设置行间距
    //设置字间距 NSKernAttributeName:@1.f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}

#pragma mark ------ click event

- (void)clickEventButton:(UIButton *)btn{
        [self endEditing:YES];
    if (btn.tag == BindingNationCodeBtnTag) { // 展示国家吗列表
        [_nationCodeTable showNationCodesTableView];
    }else{
        
        if (self.vcblock) {
            self.vcblock(btn);
        }
        
    }
}

- (void)nextOperation:(NSString *)phoneNum
{
//    _successView.phoneNum = phoneNum;
    _successView = [[BindingSuccessView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withPhoneNum:phoneNum];
    [self.pagingView addSubview:_successView];
    
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
