//
//  NewPwdViewController.m
//  hinabian
//
//  Created by 余坚 on 15/8/11.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "NewPwdViewController.h"
#import "DataFetcher.h"
#import "PersonalInfo.h"

@interface NewPwdViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) UIButton *submitButton;
//@property (strong, nonatomic) UITextField * OldPWDTextField;
@property (strong, nonatomic) UITextField * NewPWDTextField;
@property (strong, nonatomic) UITextField * ConfirmPWDTextField;
@end

#define PWD_ITEM_HEIGHT  50
#define INPUT_ITEM_TO_EDGE 20

enum ControlTag
{
    //OldPWDTextFieldTag = 11,
    NewPWDTextFieldTag = 12,
    ConfirmPWDTextFieldTag = 13,
    
};

@implementation NewPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建新密码";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    for (int index = 0; index < 2; index++) {
        NSArray *nibUserName = [[NSBundle mainBundle]loadNibNamed:@"ChangePWDItem" owner:self options:nil];
        UIView *tmpView = [nibUserName objectAtIndex:0];
        tmpView.frame = CGRectMake(0, 40 + PWD_ITEM_HEIGHT*index, SCREEN_WIDTH, PWD_ITEM_HEIGHT);
        UILabel * tmpTitle = (UILabel *)[tmpView viewWithTag:100];
        switch (index) {
            case 0:
                self.NewPWDTextField = (UITextField *)[tmpView viewWithTag:200];
                self.NewPWDTextField.placeholder = @"请输入新的密码";
                self.NewPWDTextField.secureTextEntry = YES;
                self.NewPWDTextField.delegate = (id)self;
                self.NewPWDTextField.tag = NewPWDTextFieldTag;
                self.NewPWDTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                tmpTitle.text = @"新密码";
                break;
            case 1:
                self.ConfirmPWDTextField = (UITextField *)[tmpView viewWithTag:200];
                self.ConfirmPWDTextField.placeholder = @"请再次输入新的密码";
                self.ConfirmPWDTextField.secureTextEntry = YES;
                self.ConfirmPWDTextField.delegate = (id)self;
                self.ConfirmPWDTextField.tag = ConfirmPWDTextFieldTag;
                self.ConfirmPWDTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                tmpTitle.text = @"确认密码";
                break;
                
            default:
                break;
        }
        
        
        [self.view addSubview:tmpView];
    }
    
    _submitButton = [[UIButton alloc]initWithFrame:CGRectMake(INPUT_ITEM_TO_EDGE, 80 + PWD_ITEM_HEIGHT*3, SCREEN_WIDTH - INPUT_ITEM_TO_EDGE*2, 44)];
    _submitButton.backgroundColor = [UIColor DDRegisterButtonEnable];
    _submitButton.layer.cornerRadius = 5;
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor DDInputLightGray] forState:UIControlStateHighlighted];
    [_submitButton addTarget:self action:@selector(touchSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    _submitButton.enabled = FALSE;
    [self.view addSubview:_submitButton];
    
    // Observer 输入状态
    [_NewPWDTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_ConfirmPWDTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

-(void)touchSubmitButton
{
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];

    if (tmpPersonalInfoArry.count != 0) {
 
        [DataFetcher doNewPWD:_NewPWDTextField.text confirmPWD:_ConfirmPWDTextField.text withSucceedHandler:^(id JSON) {
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
    [_NewPWDTextField resignFirstResponder];
    [_ConfirmPWDTextField resignFirstResponder];
}

-(void) back_main
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (_ConfirmPWDTextField.text.length > 0 && _NewPWDTextField.text.length > 0) {
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
