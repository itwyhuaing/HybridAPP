//
//  GuideVCodeView.m
//  hinabian
//
//  Created by 何松泽 on 2017/10/26.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "GuideVCodeView.h"
#import "MMNumberKeyboard.h"
#import "UIButton+ClickEventTime.h"
#import "HNBUtils.h"

@interface GuideVCodeView()<UITextFieldDelegate,MMNumberKeyboardDelegate>
{
    UIColor *textColor;
    UIFont *font;
    UIView *codeView;
    UIImageView *maleImage;
    UIImageView *femaleImage;
    
    BOOL isShowVcode;
}

@property (strong, nonatomic)MMNumberKeyboard *numKeyboard;
@property (strong, nonatomic)MMNumberKeyboard *codeKeyboard;
@property (strong, nonatomic)UILabel *detailLabel;

@end

static const NSInteger kFemaleTag = 0;
static const NSInteger kMaleTag = 1;
static const float kTextFieldHeight = 18.f;

@implementation GuideVCodeView

-(id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        textColor = [UIColor DDR51_G51_B51ColorWithalph:1.0f];
        font = SCREEN_WIDTH >= SCREEN_WIDTH_6 ? [UIFont boldSystemFontOfSize:FONT_UI32PX] : [UIFont boldSystemFontOfSize:FONT_UI28PX];
        [self setupMainView];
        [self setupCodeView];
        isShowVcode = NO;
    }
    
    return self;
}

- (void)setupMainView {
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = [NSString stringWithFormat:@" 姓 名"];
    nameLabel.textColor = textColor;
    nameLabel.font = font;
    [self addSubview:nameLabel];
    nameLabel.sd_layout
    .topSpaceToView(self, 5)
    .leftSpaceToView(self, 29)
    .widthIs(50.f)
    .heightIs(16);
    
    self.nameTextfield.sd_layout
    .topSpaceToView(self, 5)
    .leftSpaceToView(nameLabel, 5)
    .widthIs(120.f)
    .heightIs(kTextFieldHeight);
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectZero];
    line1.backgroundColor = [UIColor clearColor];
    line1.layer.borderWidth = 0.25f;
    line1.layer.borderColor = [UIColor DDEdgeGray].CGColor;
    [self addSubview:line1];
    line1.sd_layout
    .topSpaceToView(nameLabel, 10)
    .leftSpaceToView(self, 18)
    .widthIs(180.f*SCREEN_WIDTHRATE_6)
    .heightIs(0.5f);
    
    //默认选中男士
    maleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GuideImassess_selected"]];
    [self addSubview:maleImage];
    maleImage.sd_layout
    .topSpaceToView(self, 10)
    .leftSpaceToView(line1, 10)
    .widthIs(20)
    .heightIs(20);
    
    UILabel *maleLabel = [[UILabel alloc] init];
    maleLabel.text = [NSString stringWithFormat:@"先生"];
    maleLabel.textColor = textColor;
    maleLabel.font = SCREEN_WIDTH >= SCREEN_WIDTH_6 ? [UIFont systemFontOfSize:FONT_UI32PX] : [UIFont systemFontOfSize:FONT_UI28PX];
    [self addSubview:maleLabel];
    maleLabel.sd_layout
    .topSpaceToView(self, 10)
    .leftSpaceToView(maleImage, 5)
    .widthIs(34.f)
    .heightIs(16);
    
    
    femaleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GuideImassess_unSelected"]];
    [self addSubview:femaleImage];
    femaleImage.sd_layout
    .topSpaceToView(self, 10)
    .leftSpaceToView(maleLabel, 20)
    .widthIs(20)
    .heightIs(20);
    
    UILabel *femaleLabel = [[UILabel alloc] init];
    femaleLabel.text = [NSString stringWithFormat:@"女士"];
    femaleLabel.textColor = textColor;
    femaleLabel.font = SCREEN_WIDTH >= SCREEN_WIDTH_6 ? [UIFont systemFontOfSize:FONT_UI32PX] : [UIFont systemFontOfSize:FONT_UI28PX];;
    [self addSubview:femaleLabel];
    femaleLabel.sd_layout
    .topSpaceToView(self, 10)
    .leftSpaceToView(femaleImage, 5)
    .widthIs(34.f)
    .heightIs(16);
    
    [self addSubview:self.maleBtn];
    self.maleBtn.sd_layout
    .topSpaceToView(self, 10)
    .leftSpaceToView(line1, 10)
    .widthIs(50)
    .heightIs(30);
    
    [self addSubview:self.femaleBtn];
    self.femaleBtn.sd_layout
    .topSpaceToView(self, 10)
    .leftSpaceToView(maleLabel, 20)
    .widthIs(50)
    .heightIs(30);
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.text = [NSString stringWithFormat:@"手机号"];
    phoneLabel.textColor = textColor;
    phoneLabel.font = font;
    [self addSubview:phoneLabel];
    phoneLabel.sd_layout
    .topSpaceToView(line1, 30)
    .leftSpaceToView(self, 29)
    .widthIs(50.f)
    .heightIs(16);
    
    self.phoneTextfield.sd_layout
    .topSpaceToView(line1, 30)
    .leftSpaceToView(phoneLabel, 5)
    .widthIs(180.f)
    .heightIs(kTextFieldHeight);
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectZero];
    line2.backgroundColor = [UIColor clearColor];
    line2.layer.borderWidth = 0.5f;
    line2.layer.borderColor = [UIColor DDEdgeGray].CGColor;
    [self addSubview:line2];
    line2.sd_layout
    .topSpaceToView(phoneLabel, 10)
    .leftSpaceToView(self, 18)
    .widthIs(SCREEN_WIDTH - 18*2)
    .heightIs(0.5f);
    
    self.detailLabel.sd_layout
    .topSpaceToView(line2, 18)
    .leftSpaceToView(self, 20)
    .widthIs(SCREEN_WIDTH - 20*2)
    .heightIs(30.f);
}

- (void)setupCodeView {
    codeView = [[UIView alloc] initWithFrame:CGRectZero];
    codeView.alpha = 0.f;
    codeView.hidden = YES;
    [codeView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:codeView];
    
    codeView.sd_layout
    .topSpaceToView(_detailLabel, 18)
    .leftSpaceToView(self, 20)
    .widthIs(SCREEN_WIDTH - 20*2)
    .heightIs(30.f);
    
    UILabel *vCodeLabel = [[UILabel alloc] init];
    vCodeLabel.text = [NSString stringWithFormat:@"验证码"];
    vCodeLabel.textColor = textColor;
    vCodeLabel.font = font;
    [codeView addSubview:vCodeLabel];
    vCodeLabel.sd_layout
    .topSpaceToView(codeView, 0)
    .leftSpaceToView(codeView, 10)
    .widthIs(50.f)
    .heightIs(16);
    
    self.vCodeTextField.sd_layout
    .topSpaceToView(codeView, 0)
    .leftSpaceToView(vCodeLabel, 5)
    .widthIs(150.f)
    .heightIs(kTextFieldHeight);
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor clearColor];
    line.layer.borderWidth = 0.5f;
    line.layer.borderColor = [UIColor DDEdgeGray].CGColor;
    [codeView addSubview:line];
    line.sd_layout
    .topSpaceToView(vCodeLabel, 10)
    .leftSpaceToView(codeView, 0)
    .widthIs(SCREEN_WIDTH - 160)
    .heightIs(0.5f);
    
    [codeView addSubview:self.vCodeBtn];
    self.vCodeBtn.sd_layout
    .topSpaceToView(codeView, -10)
    .leftSpaceToView(line, 10)
    .widthIs(80.f)
    .heightIs(30);
}

#pragma mark -- Lazy Load

/*数字键盘*/
- (MMNumberKeyboard *)numKeyboard {
    if (!_numKeyboard) {
        _numKeyboard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
        _numKeyboard.allowsDecimalPoint = YES;
        _numKeyboard.delegate = self;
    }
    return _numKeyboard;
}

- (MMNumberKeyboard *)codeKeyboard {
    if (!_codeKeyboard) {
        _codeKeyboard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
        _codeKeyboard.allowsDecimalPoint = YES;
        _codeKeyboard.delegate = self;
    }
    return _codeKeyboard;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.text = [NSString stringWithFormat:@"您的联系方式我们绝对保密，仅用于保存您的评估结果，方便您下次查看"];
        _detailLabel.font = [UIFont systemFontOfSize:FONT_UI24PX];
        _detailLabel.numberOfLines = 2;
        _detailLabel.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0f];
        [self addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UITextField *)nameTextfield {
    if (!_nameTextfield) {
        _nameTextfield = [[UITextField alloc] init];
        _nameTextfield.delegate = (id<UITextFieldDelegate>)self;
        _nameTextfield.textColor = textColor;
        _nameTextfield.font = [UIFont systemFontOfSize:FONT_UI32PX];
        [self addSubview:_nameTextfield];
        
    }
    return _nameTextfield;
}

- (UITextField *)phoneTextfield {
    if (!_phoneTextfield) {
        _phoneTextfield = [[UITextField alloc] init];
        _phoneTextfield.delegate = (id<UITextFieldDelegate>)self;
        _phoneTextfield.textColor = textColor;
        _phoneTextfield.inputView = self.numKeyboard;
        _phoneTextfield.font = [UIFont systemFontOfSize:FONT_UI32PX];
        [self addSubview:_phoneTextfield];
        
    }
    return _phoneTextfield;
}

- (UITextField *)vCodeTextField {
    if (!_vCodeTextField) {
        _vCodeTextField = [[UITextField alloc] init];
        [_vCodeTextField setBackgroundColor:[UIColor clearColor]];
        _vCodeTextField.delegate = (id<UITextFieldDelegate>)self;
        _vCodeTextField.textColor = textColor;
        _vCodeTextField.inputView = self.codeKeyboard;
        _vCodeTextField.font = [UIFont systemFontOfSize:FONT_UI32PX];
        [codeView addSubview:_vCodeTextField];
        
    }
    return _vCodeTextField;
}

- (UIButton *)maleBtn {
    if (!_maleBtn) {
        _maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _maleBtn.tag = kMaleTag;
        [_maleBtn setBackgroundColor:[UIColor clearColor]];
        [_maleBtn addTarget:self action:@selector(chooseSex:) forControlEvents:UIControlEventTouchUpInside];
//        [_maleBtn setImage:[UIImage imageNamed: @"GuideImassess_unSelected"] forState:UIControlStateNormal];
        //默认选中男士
        [_maleBtn setSelected:YES];
    }
    return _maleBtn;
}

- (UIButton *)femaleBtn {
    if (!_femaleBtn) {
        _femaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _femaleBtn.tag = kFemaleTag;
        [_femaleBtn setBackgroundColor:[UIColor clearColor]];
        [_femaleBtn addTarget:self action:@selector(chooseSex:) forControlEvents:UIControlEventTouchUpInside];
        [_femaleBtn setSelected:NO];
//        [_femaleBtn setImage:[UIImage imageNamed: @"GuideImassess_unSelected"] forState:UIControlStateNormal];
//        [_femaleBtn setImage:[UIImage imageNamed:@"GuideImassess_selected"] forState:UIControlStateSelected];
    }
    return _femaleBtn;
}

- (UIButton *)vCodeBtn {
    if (!_vCodeBtn) {
        _vCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vCodeBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState: UIControlStateNormal];
        [_vCodeBtn addTarget:self action:@selector(getVcode:) forControlEvents:UIControlEventTouchUpInside];
        [_vCodeBtn setTitleColor:[UIColor DDNavBarBlue] forState:UIControlStateNormal];
        [_vCodeBtn setBackgroundColor:[UIColor whiteColor]];
        _vCodeBtn.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
        _vCodeBtn.layer.borderWidth = 0.5f;
        _vCodeBtn.layer.cornerRadius = 4.f;
        _vCodeBtn.layer.masksToBounds = YES;
        _vCodeBtn.custom_acceptEventInterval = 2.f; //防止连击
        [_vCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI24PX]];
    }
    return _vCodeBtn;
}

#pragma mark -- Observe

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _nameTextfield) {
        [HNBClick event:@"200024" Content:nil];
    } else if (textField == _phoneTextfield) {
        [HNBClick event:@"200025" Content:nil];
    } else if (textField == _vCodeTextField) {
        [HNBClick event:@"200029" Content:nil];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField == _nameTextfield) {
        if (textField.text.length > 12) return NO;
    }
    
    return YES;
}

#pragma mark -- Click Event

- (void)chooseSex:(UIButton *)sender {
    if (sender.tag == kFemaleTag) { //女性
        _maleBtn.selected = NO;
        _femaleBtn.selected = YES;
        
        [femaleImage setImage:[UIImage imageNamed:@"GuideImassess_selected"]];
        [maleImage setImage:[UIImage imageNamed:@"GuideImassess_unSelected"]];
    }else{
        _maleBtn.selected = YES;
        _femaleBtn.selected = NO;
        [femaleImage setImage:[UIImage imageNamed:@"GuideImassess_unSelected"]];
        [maleImage setImage:[UIImage imageNamed:@"GuideImassess_selected"]];
    }
}

- (void)showVCodeView {
    [UIView animateWithDuration:0.1f animations:^{
        codeView.hidden = NO;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f animations:^{
            self.detailLabel.center = CGPointMake(self.detailLabel.center.x, self.detailLabel.center.y + 40);
            codeView.alpha = 1.0f;
            codeView.center = CGPointMake(codeView.center.x, codeView.center.y - 40);
        }];
    }];
}

- (void)hideVCodeView {
    [UIView animateWithDuration:0.1f animations:^{
        self.detailLabel.center = CGPointMake(self.detailLabel.center.x, self.detailLabel.center.y - 40);
        codeView.alpha = 0.f;
        codeView.center = CGPointMake(codeView.center.x, codeView.center.y + 40);
    } completion:^(BOOL finished) {
        codeView.hidden = YES;
    }];
}

- (void)getVcode:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(GuideVCodeViewGetVCode:)]) {
        [_delegate GuideVCodeViewGetVCode:sender];
    }
}

#pragma mark - MMNumberKeyboardDelegate.

- (BOOL)numberKeyboardShouldReturn:(MMNumberKeyboard *)numberKeyboard
{
    // Do something with the done key if neeed. Return YES to dismiss the keyboard.
    return YES;
}

- (BOOL)numberKeyboard:(MMNumberKeyboard *)numberKeyboard shouldInsertText:(NSString *)text
{
    if (numberKeyboard == self.numKeyboard) {
        if ([_phoneTextfield.text length] + text.length == 11 && [HNBUtils evaluateIsPhoneNum:[_phoneTextfield.text stringByAppendingString:text]]) {
            [self showVCodeView];
            isShowVcode = YES;
            return YES;
        }
        if ([_phoneTextfield.text length] >= 11) {
            return NO;
        }
    }else if (numberKeyboard == self.codeKeyboard) {
        if ([_vCodeTextField.text length] >= 6) {/* 6位的验证码 */
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)numberKeyboardShouldDeleteBackward:(MMNumberKeyboard *)numberKeyboard
{
    if (numberKeyboard == self.numKeyboard) {
        if ([_phoneTextfield.text length] == 11 && isShowVcode) {
            [self hideVCodeView];
            isShowVcode = NO;
        }
    }
    return YES;
}

@end
