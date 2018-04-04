//
//  RegisterView.m
//  hinabian
//
//  Created by 何松泽 on 16/1/14.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#define INPUT_ITEM_TO_EDGE 15
#define INPUT_ITEM_HEIGHT 44
#define INPUT_ITEM_FIRST_X_POSITION 100
#define DISTACNE_FROM_EACH_ITEM 10

#import "RegisterView.h"
#import "DataFetcher.h"

enum ControlTag
{
    IDTextFieldTag = 11,
    PWDTextFieldTag = 12,
    VCodeTextFieldTag = 13,
    
};

@implementation RegisterView

-(id)initWithIDImageNormalName:(NSString *)IDNormal
            IDImagePressedName:(NSString *)IDPressed
               VCodeNormalName:(NSString *)CODENormal
              VCodePressedName:(NSString *)CODEPressed
                 PWDNormalName:(NSString *)PWDNormal
                PWDPressedName:(NSString *)PWDPressed
             IDPlaceholdString:(NSString *)IDPlacehold
{
    if (self = [super init]) {
        idImageNormal = IDNormal;
        idImagePressed = IDPressed;
        vCodeImageNormal = CODENormal;
        vCodeImagePressed = CODEPressed;
        PWDImageNormal = PWDNormal;
        PWDImagePressed = PWDPressed;
        idPlacehold = IDPlacehold;
        [self addInputItem];
        [self addButtonItem];
    }
    return self;
}


/* 布局输入框 */
- (void)addInputItem
{

    if ([idPlacehold isEqualToString:@"请输入手机号"]) { // 手机
        NSArray *nibTEL = [[NSBundle mainBundle]loadNibNamed:@"RegisterViewItemPhone" owner:self options:nil];
        _phInputView = [nibTEL objectAtIndex:0];
        [_phInputView setFrame:CGRectMake(INPUT_ITEM_TO_EDGE,
                                          INPUT_ITEM_FIRST_X_POSITION,
                                          SCREEN_WIDTH - INPUT_ITEM_TO_EDGE*2,
                                          INPUT_ITEM_HEIGHT)];
        self.IDTextField = (UITextField *)[_phInputView viewWithTag:2];
        self.IDTextField.placeholder = idPlacehold;
        [self.IDTextField setTag:IDTextFieldTag];
        self.IDTextField.delegate = self;
        self.IDImageView = (UIImageView *)[_phInputView viewWithTag:1];
        self.IDImageView.image = [UIImage imageNamed:idImageNormal];
        [self addSubview:_phInputView];
    }else{
    
        NSArray *nibTEL = [[NSBundle mainBundle]loadNibNamed:@"RegisterViewItem" owner:self options:nil];
        UIView *tmpTELView = [nibTEL objectAtIndex:0];
        tmpTELView.layer.borderWidth = 1;
        tmpTELView.layer.borderColor = [[UIColor DDInputLightGray] CGColor];
        tmpTELView.frame = CGRectMake(INPUT_ITEM_TO_EDGE, INPUT_ITEM_FIRST_X_POSITION, SCREEN_WIDTH - INPUT_ITEM_TO_EDGE*2, INPUT_ITEM_HEIGHT);
        self.IDTextField = (UITextField *)[tmpTELView viewWithTag:2];
        self.IDTextField.placeholder = idPlacehold;
        [self.IDTextField setTag:IDTextFieldTag];
        //    self.IDTextField.keyboardType = UIKeyboardTypeNamePhonePad;
        self.IDTextField.delegate = self;
        self.IDImageView = (UIImageView *)[tmpTELView viewWithTag:1];
        self.IDImageView.image = [UIImage imageNamed:idImageNormal];
        [self addSubview:tmpTELView];
        
    }
    
    NSArray *nibVCode = [[NSBundle mainBundle]loadNibNamed:@"RegisterViewItem" owner:self options:nil];
    UIView *tmpVCodeView = [nibVCode objectAtIndex:0];
    tmpVCodeView.layer.borderWidth = 1;
    tmpVCodeView.layer.borderColor = [[UIColor DDInputLightGray] CGColor];
    tmpVCodeView.frame = CGRectMake(INPUT_ITEM_TO_EDGE, INPUT_ITEM_FIRST_X_POSITION + INPUT_ITEM_HEIGHT * 2 + DISTACNE_FROM_EACH_ITEM * 2, SCREEN_WIDTH - INPUT_ITEM_TO_EDGE*2, INPUT_ITEM_HEIGHT);
    self.VCodeTextField = (UITextField *)[tmpVCodeView viewWithTag:2];
    self.VCodeTextField.placeholder = @"请输入验证码";
    [self.VCodeTextField setTag:VCodeTextFieldTag];
    self.VCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.VCodeTextField.delegate = self;
    self.VCodeImageView = (UIImageView *)[tmpVCodeView viewWithTag:1];
    self.VCodeImageView.image = [UIImage imageNamed:vCodeImageNormal];
    [self addSubview:tmpVCodeView];
    
    NSArray *nibPWD = [[NSBundle mainBundle]loadNibNamed:@"RegisterViewItem" owner:self options:nil];
    UIView *tmpPWDView = [nibPWD objectAtIndex:0];
    tmpPWDView.layer.borderWidth = 1;
    tmpPWDView.layer.borderColor = [[UIColor DDInputLightGray] CGColor];
    tmpPWDView.frame = CGRectMake(INPUT_ITEM_TO_EDGE, INPUT_ITEM_FIRST_X_POSITION + INPUT_ITEM_HEIGHT * 3 + DISTACNE_FROM_EACH_ITEM * 3, SCREEN_WIDTH-INPUT_ITEM_TO_EDGE*2, INPUT_ITEM_HEIGHT);
    self.PWDTextField = (UITextField *)[tmpPWDView viewWithTag:2];
    self.PWDTextField.placeholder = @"请输入密码";
    [self.PWDTextField setTag:PWDTextFieldTag];
    self.PWDTextField.secureTextEntry = YES;
    self.PWDTextField.delegate = self;
    self.PWDImageView = (UIImageView *)[tmpPWDView viewWithTag:1];
    self.PWDImageView.image = [UIImage imageNamed:PWDImageNormal];
    [self addSubview:tmpPWDView];
}

/* 布局按钮 */
- (void)addButtonItem
{
    /* 获取验证码按钮 */
    _vCodeButton = [[UIButton alloc]initWithFrame:CGRectMake(INPUT_ITEM_TO_EDGE, INPUT_ITEM_FIRST_X_POSITION + INPUT_ITEM_HEIGHT + DISTACNE_FROM_EACH_ITEM, SCREEN_WIDTH - INPUT_ITEM_TO_EDGE*2, INPUT_ITEM_HEIGHT)];
    _vCodeButton.backgroundColor = [UIColor DDRegisterButtonEnable];
    _vCodeButton.layer.cornerRadius = 5;
    [_vCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_vCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_vCodeButton setTitleColor:[UIColor DDInputLightGray] forState:UIControlStateHighlighted];
//    [_vCodeButton addTarget:self action:@selector(touchVcodeButton) forControlEvents:UIControlEventTouchUpInside];
    _vCodeButton.enabled = FALSE;
    [self addSubview:_vCodeButton];
    
    _submitButton = [[UIButton alloc]initWithFrame:CGRectMake(INPUT_ITEM_TO_EDGE, INPUT_ITEM_FIRST_X_POSITION + INPUT_ITEM_HEIGHT*5 + DISTACNE_FROM_EACH_ITEM*5, SCREEN_WIDTH - INPUT_ITEM_TO_EDGE*2, INPUT_ITEM_HEIGHT)];
    _submitButton.backgroundColor = [UIColor DDRegisterButtonEnable];
    _submitButton.layer.cornerRadius = 5;
    [_submitButton setTitle:@"注册" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor DDInputLightGray] forState:UIControlStateHighlighted];
//    [_submitButton addTarget:self action:@selector(touchSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    _submitButton.enabled = FALSE;
    [self addSubview:_submitButton];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    [_IDTextField resignFirstResponder];
    [_VCodeTextField resignFirstResponder];
    [_PWDTextField resignFirstResponder];
}

#pragma mark TextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSInteger tag = textField.tag;
    if (tag == IDTextFieldTag) {
        /* 点亮获取注册码按钮 */
//       _vCodeButton.enabled = TRUE;
//       _vCodeButton.backgroundColor = [UIColor DDRegisterButtonNormal];
//        
//       _IDImageView.image = [UIImage imageNamed:idImagePressed];
    }
    else if(tag == PWDTextFieldTag)
    {
        if (![_IDTextField.text isEqualToString:@""] && ![_VCodeTextField.text isEqualToString:@""]) {
            _submitButton.enabled = TRUE;
            _submitButton.backgroundColor = [UIColor DDRegisterButtonNormal];
        }
        _PWDImageView.image = [UIImage imageNamed:PWDImagePressed];
        
    }
    else if(tag == VCodeTextFieldTag)
    {
        _VCodeImageView.image = [UIImage imageNamed:vCodeImagePressed];
    }
    
    if (![_IDTextField.text isEqualToString:@""] &&![_PWDTextField.text isEqualToString:@""] && ![_VCodeTextField.text isEqualToString:@""]) {
        _submitButton.enabled = TRUE;
        _submitButton.backgroundColor = [UIColor DDRegisterButtonNormal];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    NSInteger tag = textField.tag;
    if (tag == IDTextFieldTag) {
        /* 点亮获取注册码按钮 */
        if ([_IDTextField.text isEqualToString:@""]) {
            _vCodeButton.enabled = FALSE;
            _vCodeButton.backgroundColor = [UIColor DDRegisterButtonEnable];
            _IDImageView.image = [UIImage imageNamed:idImageNormal];
        }
        
    }
    else if (tag == PWDTextFieldTag)
    {
        if ([_PWDTextField.text isEqualToString:@""]) {
            
            _PWDImageView.image = [UIImage imageNamed:PWDImageNormal];
        }
    }
    else if (tag == VCodeTextFieldTag)
    {
        if ([_VCodeTextField.text isEqualToString:@""]) {
            _VCodeImageView.image = [UIImage imageNamed:vCodeImageNormal];
        }
    }
    
    if (![_IDTextField.text isEqualToString:@""] &&![_PWDTextField.text isEqualToString:@""] && ![_VCodeTextField.text isEqualToString:@""]) {
        _submitButton.enabled = TRUE;
        _submitButton.backgroundColor = [UIColor DDRegisterButtonNormal];
    }
    else
    {
        _submitButton.enabled = FALSE;
        _submitButton.backgroundColor = [UIColor DDRegisterButtonEnable];
    }
    
}

@end
