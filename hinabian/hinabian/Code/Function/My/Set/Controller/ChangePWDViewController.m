//
//  ChangePWDViewController.m
//  hinabian
//
//  Created by 余坚 on 15/7/10.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "ChangePWDViewController.h"
#import "DataFetcher.h"
#import "PersonalInfo.h"
#import "RetrievePasswordViewController.h"
#import "RDVTabBarController.h"
#import "ThirdPartCompleteUserInfoViewController.h"
#import "HNBClick.h"

@interface ChangePWDViewController ()<UITextFieldDelegate>
{
    NSString *userInfTel;
}
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIButton *phoneCodeButton;
@property (strong, nonatomic) UITextField * OldPWDTextField;
@property (strong, nonatomic) UITextField * NewPWDTextField;
@property (strong, nonatomic) UITextField * ConfirmPWDTextField;

@end
#define ITEM_TOP_GAP 27
#define PWD_ITEM_HEIGHT  50
#define INPUT_ITEM_TO_EDGE 12

enum ControlTag
{
    OldPWDTextFieldTag = 11,
    NewPWDTextFieldTag = 12,
    ConfirmPWDTextFieldTag = 13,
    
};
@implementation ChangePWDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
    if (tmpPersonalInfoArry.count != 0) {
        UserInfo = tmpPersonalInfoArry[0];
        userInfTel = UserInfo.mobile_num;
    }
    
    // Do any additional setup after loading the view.
    for (int index = 0; index < 3; index++) {
        NSArray *nibUserName = [[NSBundle mainBundle]loadNibNamed:@"ChangePWDItem" owner:self options:nil]; 
        UIView *tmpView = [nibUserName objectAtIndex:0];
        tmpView.frame = CGRectMake(0, ITEM_TOP_GAP + PWD_ITEM_HEIGHT*index, SCREEN_WIDTH, PWD_ITEM_HEIGHT);
        UILabel * tmpTitle = (UILabel *)[tmpView viewWithTag:100];
        switch (index) {
            case 0:
                self.OldPWDTextField = (UITextField *)[tmpView viewWithTag:200];
                self.OldPWDTextField.placeholder = @"请输入当前密码";
                self.OldPWDTextField.secureTextEntry = YES;
                self.OldPWDTextField.delegate = (id)self;
                self.OldPWDTextField.tag = OldPWDTextFieldTag;
                self.OldPWDTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                tmpTitle.text = @"当前密码";
                break;
            case 1:
                self.NewPWDTextField = (UITextField *)[tmpView viewWithTag:200];
                self.NewPWDTextField.placeholder = @"请输入新密码";
                self.NewPWDTextField.secureTextEntry = YES;
                self.NewPWDTextField.delegate = (id)self;
                self.NewPWDTextField.tag = NewPWDTextFieldTag;
                self.NewPWDTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                tmpTitle.text = @"新  密  码";
                break;
            case 2:
                self.ConfirmPWDTextField = (UITextField *)[tmpView viewWithTag:200];
                self.ConfirmPWDTextField.placeholder = @"请再次输入新密码";
                self.ConfirmPWDTextField.secureTextEntry = YES;
                self.ConfirmPWDTextField.delegate = (id)self;
                self.ConfirmPWDTextField.tag = ConfirmPWDTextFieldTag;
                self.ConfirmPWDTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                tmpTitle.text = @"确认新密码";
                break;
                
            default:
                break;
        }
        [self.view addSubview:tmpView];
    }
    
    _submitButton = [[UIButton alloc]initWithFrame:CGRectMake(INPUT_ITEM_TO_EDGE, 60*SCREEN_SCALE + PWD_ITEM_HEIGHT*3, SCREEN_WIDTH - INPUT_ITEM_TO_EDGE*2, 44)];
    _submitButton.backgroundColor = [UIColor DDR63_G162_B255ColorWithalph:0.6f];
    _submitButton.layer.cornerRadius = 5;
    _submitButton.titleLabel.font = [UIFont systemFontOfSize:FONT_UI28PX];
    [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor DDInputLightGray] forState:UIControlStateHighlighted];
    [_submitButton addTarget:self action:@selector(touchSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    _submitButton.enabled = FALSE;
    [self.view addSubview:_submitButton];
    
    /*不同颜色的文字*/
    UILabel *retrieveLabel = [[UILabel alloc]initWithFrame:CGRectMake(INPUT_ITEM_TO_EDGE, 60*SCREEN_SCALE + PWD_ITEM_HEIGHT*3 + 44 + 15, SCREEN_WIDTH, 15)];
    retrieveLabel.textAlignment = NSTextAlignmentLeft;
    retrieveLabel.textColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1.0];
    retrieveLabel.font = [UIFont systemFontOfSize:FONT_UI24PX];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"使用手机验证码找回密码"];
    NSRange blackRange = NSMakeRange([[str string] rangeOfString:@"手机验证码"].location, [[str string] rangeOfString:@"手机验证码"].length);
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:50/255.0f green:50/255.0f blue:50/255.0f alpha:1.0] range:blackRange];
    [retrieveLabel setAttributedText: str];
    
    _phoneCodeButton = [[UIButton alloc]initWithFrame:CGRectMake(INPUT_ITEM_TO_EDGE, 60*SCREEN_SCALE + PWD_ITEM_HEIGHT*3 + 44 + 15, SCREEN_WIDTH/2, 15)];
    [_phoneCodeButton setTitle:@"" forState:UIControlStateNormal];
    [_phoneCodeButton addTarget:self action:@selector(findPWDByPhone) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:retrieveLabel];
    [self.view addSubview:_phoneCodeButton];
    // Observer 输入状态
    [_OldPWDTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_ConfirmPWDTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_NewPWDTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)touchSubmitButton
{
    [HNBClick event:@"149011" Content:nil];
    
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
    if (tmpPersonalInfoArry.count != 0) {
        UserInfo = tmpPersonalInfoArry[0];
        [DataFetcher doChangePWD:UserInfo.id oldPWD:_OldPWDTextField.text newPWD:_NewPWDTextField.text confirmPWD:_ConfirmPWDTextField.text withSucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            NSLog(@"errCode = %d",errCode);
            if (errCode == 0) {
                NSLog(@"发送成功");
                [self.navigationController popViewControllerAnimated:YES];
            }
        } withFailHandler:^(id error) {
            
        }];
    }
}

-(void)findPWDByPhone
{
    [HNBClick event:@"149012" Content:nil];
    
    if ([userInfTel isEqualToString:@""]) {
        ThirdPartCompleteUserInfoViewController *vc = [[ThirdPartCompleteUserInfoViewController alloc]init];
        vc.isFindPWD = TRUE;
        //            [vc isRegister:FALSE];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        RetrievePasswordViewController *vc = [[RetrievePasswordViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back_main);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_OldPWDTextField resignFirstResponder];
    [_NewPWDTextField resignFirstResponder];
    [_ConfirmPWDTextField resignFirstResponder];
}

-(void) back_main
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (_ConfirmPWDTextField.text.length > 0 && _NewPWDTextField.text.length > 0 && _OldPWDTextField.text.length > 0) {
        _submitButton.enabled = TRUE;
        _submitButton.backgroundColor = [UIColor DDR63_G162_B255ColorWithalph:1.0f];
        _submitButton.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:1.0f].CGColor;
        
    }else{
        _submitButton.enabled = FALSE;
        _submitButton.backgroundColor = [UIColor DDR63_G162_B255ColorWithalph:0.6f];
        _submitButton.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:0.6f].CGColor;
        
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
