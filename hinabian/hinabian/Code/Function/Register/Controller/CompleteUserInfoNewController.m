//
//  CompleteUserInfoNewController.m
//  hinabian
//
//  Created by 何松泽 on 17/4/11.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "CompleteUserInfoNewController.h"
#import "RDVTabBarController.h"
#import "NationCode.h"
#import "PersonalInfo.h"
#import "NationButtonView.h"
#import "DataFetcher.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "HNBClick.h"

#define DistanceToBorder    15
#define COUNT_IN_ONE_ROW    3
#define BUTTON_WIDTH        (SCREEN_WIDTH - DistanceToBorder*(COUNT_IN_ONE_ROW+1))/COUNT_IN_ONE_ROW

static const float kCornerRadius     = 6.f;
static const float kSureViewHeight   = 65.f;

@interface CompleteUserInfoNewController ()<UITextFieldDelegate,NationButtonViewDelegate>
{
    UILabel     *nickNameLabel;
    UILabel     *imStatusLabel;
    UILabel     *nationLabel;
    UIView      *textView;
    UIButton    *moreBtn;
    UIButton    *hideKeyboardBtn;
    NationButtonView *nationView;
}

@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic, strong) UIView            *sureView;
@property (nonatomic, strong) UIButton          *sureButton;
@property (nonatomic, strong) UITextField       *nickNameTextField;
@property (nonatomic, strong) NSMutableArray    *selectedIMStatus;
@property (nonatomic, strong) NSMutableArray    *imButtonArray;
@property (nonatomic, strong) NSArray           *imStatusArray;

@end

@implementation CompleteUserInfoNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor DDNormalBackGround];
    self.title = @"完善个人信息";
    _imStatusArray      = @[@"想移民",@"已移民"];
    _selectedIMStatus   = [[NSMutableArray alloc] init];
    _imButtonArray      = [[NSMutableArray alloc] init];
    
    [self setLayout];
}

- (void)setLayout {
    
    CGRect frame = CGRectZero;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = SCREEN_HEIGHT - kSureViewHeight - SCREEN_NAVHEIGHT - SCREEN_STATUSHEIGHT;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.backgroundColor = [UIColor clearColor];
    
    /*昵称*/
    frame.origin.x = DistanceToBorder;
    frame.origin.y = 20;
    frame.size.width = 100;
    frame.size.height = 36;
    nickNameLabel = [[UILabel alloc]initWithFrame:frame];
    nickNameLabel.font = [UIFont systemFontOfSize:FONT_UI32PX];
    nickNameLabel.text = @"您的昵称";
    
    frame.origin.y = CGRectGetMaxY(nickNameLabel.frame) + 8;
    frame.size.width = (SCREEN_WIDTH - DistanceToBorder *2);
    frame.size.height = 40;
    textView = [[UIView alloc]initWithFrame:frame];
    textView.layer.cornerRadius = kCornerRadius;
    textView.layer.masksToBounds = YES;
    textView.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    textView.layer.borderWidth = 0.5f;
    
    _nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake( 10, 0, frame.size.width - 10*2, frame.size.height)];
    _nickNameTextField.font = [UIFont systemFontOfSize:FONT_UI30PX];
    _nickNameTextField.delegate = (id)self;
    _nickNameTextField.placeholder = @"请输入昵称";
    [_nickNameTextField addTarget:self action:@selector(observeUserInfo) forControlEvents:UIControlEventEditingChanged];
    
    /*移民状态*/
    frame.origin.y = CGRectGetMaxY(textView.frame) + 20;
    frame.size.width = 100;
    frame.size.height = 36;
    imStatusLabel = [[UILabel alloc] initWithFrame:frame];
    imStatusLabel.font = [UIFont systemFontOfSize:FONT_UI32PX];
    imStatusLabel.text = @"您的移民状态";
    
    /*完成*/
    frame.origin.x = 0;
    frame.origin.y = SCREEN_HEIGHT - kSureViewHeight - SCREEN_NAVHEIGHT - SCREEN_STATUSHEIGHT;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = kSureViewHeight;
    _sureView = [[UIView alloc]initWithFrame:frame];
    _sureView.backgroundColor = [UIColor whiteColor];
    _sureView.layer.borderColor = [UIColor DDEdgeGray].CGColor;
    _sureView.layer.borderWidth = 0.5f;
    
    frame.origin.x = DistanceToBorder;
    frame.origin.y = 10;
    frame.size.width = SCREEN_WIDTH - DistanceToBorder * 2;
    frame.size.height = kSureViewHeight - 10 * 2;
    _sureButton = [[UIButton alloc]initWithFrame:frame];
    [_sureButton setTitle:@"我填完啦" forState:UIControlStateNormal];
    [self setUnableBtn:_sureButton];
    
    [self addIMButton];
    [self setNationLayout];
    
    [_sureView addSubview:_sureButton];
    [textView addSubview:_nickNameTextField];
    
    [_scrollView addSubview:nickNameLabel];
    [_scrollView addSubview:textView];
    [_scrollView addSubview:imStatusLabel];
    [self.view addSubview:_scrollView];
    [self.view addSubview:_sureView];
}

- (void)addIMButton
{
    for (int index = 0; index < _imStatusArray.count; index++) {
        UIButton * tmpButton = [[UIButton alloc] init];
        tmpButton.frame = CGRectMake(
                                     ((index % COUNT_IN_ONE_ROW) + 1)*DistanceToBorder + (index % COUNT_IN_ONE_ROW)* BUTTON_WIDTH,
                                     CGRectGetMaxY(imStatusLabel.frame) + (index / COUNT_IN_ONE_ROW)*10 + 8 + (index / COUNT_IN_ONE_ROW)* 36,
                                     BUTTON_WIDTH,
                                     36
                                     );
        [tmpButton setTitle:_imStatusArray[index] forState:UIControlStateNormal];
        tmpButton.titleLabel.font = [UIFont systemFontOfSize:FONT_UI32PX];
        tmpButton.titleLabel.numberOfLines = 2;
        [self setOriginalBtn:tmpButton];
        [tmpButton addTarget:self action:@selector(clickIMButton:) forControlEvents:UIControlEventTouchUpInside];
        [_imButtonArray addObject:tmpButton];
        [_scrollView addSubview:tmpButton];
    }
}

- (void)setNationLayout
{
    CGRect frame = CGRectZero;
    frame.origin.x = DistanceToBorder;
    frame.origin.y = CGRectGetMaxY(imStatusLabel.frame) + 36 + 20;
    frame.size.width = 100;
    frame.size.height = 36;
    
    nationLabel = [[UILabel alloc]initWithFrame:frame];
    nationLabel.font = [UIFont systemFontOfSize:FONT_UI32PX];
    nationLabel.text = @"您的意向国家";
    nationLabel.textColor = [UIColor blackColor];
    
    frame.origin.x = CGRectGetMaxX(nationLabel.frame);
    frame.origin.y = frame.origin.y + 3;
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:frame];
    alertLabel.font = [UIFont systemFontOfSize:FONT_UI24PX];
    alertLabel.text = @"(可选择1-3个)";
    alertLabel.textColor = [UIColor DDCouponTextGray];
    
    frame.origin.x = 0;
    frame.origin.y = CGRectGetMaxY(nationLabel.frame);
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = SCREEN_HEIGHT - CGRectGetMaxY(nationLabel.frame) - (kSureViewHeight + 10*2);
    nationView = [[NationButtonView alloc]initWithFrame:frame];
    nationView.delegate = (id)self;
    
    [_scrollView addSubview:nationLabel];
    [_scrollView addSubview:alertLabel];
    [_scrollView addSubview:nationView];
    
}

- (void)setOriginalBtn:(UIButton *)sender
{
    sender.backgroundColor = [UIColor clearColor];
    sender.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    sender.layer.borderWidth = 0.5;
    sender.layer.cornerRadius = kCornerRadius;
    [sender setTitleColor:[UIColor DDNavBarBlue] forState:UIControlStateNormal];
}

- (void)setSelectedBtn:(UIButton *)sender
{
    sender.backgroundColor = [UIColor DDNavBarBlue];
    sender.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    sender.layer.borderWidth = 0.5;
    sender.layer.cornerRadius = kCornerRadius;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setUnableBtn:(UIButton *)sender
{
    [sender setEnabled:NO];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(completeUserinfo) forControlEvents:UIControlEventTouchUpInside];
    sender.backgroundColor = [UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1.f];
    sender.layer.borderColor = [UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1.f].CGColor;
    sender.layer.borderWidth = 0.5;
    sender.layer.cornerRadius = kCornerRadius;
}

#pragma mark - Click Event

- (void)clickIMButton:(UIButton *)sender
{
    if (_selectedIMStatus.count == 1) {
        NSString *tmpTitle = (NSString *)[_selectedIMStatus firstObject];
        if ([sender.titleLabel.text isEqualToString:tmpTitle]) {
            return;
        }else{
            for (int index = 0; index < _imButtonArray.count; index++) {
                UIButton *btn = (UIButton *)_imButtonArray[index];
                if ([tmpTitle isEqualToString:btn.titleLabel.text]) {
                    [self setOriginalBtn:btn];
                }
            }
            [_selectedIMStatus replaceObjectAtIndex:0 withObject:sender.titleLabel.text];
            [self setSelectedBtn:sender];
        }
    }else{
        [_selectedIMStatus addObject:sender.titleLabel.text];
        [self setSelectedBtn:sender];
    }
    [self observeUserInfo];
}

- (void)completeUserinfo
{
    /* 数据统计 */
    [HNBClick event:@"161011" Content:nil];
    
    NSString *nationCodeStr;
    NSString *nationTextStr;
    for (NSString *str in nationView.selectedNationsCode) {
        if (nationCodeStr) {
            nationCodeStr = [NSString stringWithFormat:@"%@,%@",nationCodeStr,str];
        }else{
            nationCodeStr = str;
        }
    }
    for (NSString *str in nationView.selectedNationString) {
        if (nationTextStr) {
            nationTextStr = [NSString stringWithFormat:@"%@,%@",nationTextStr,str];
        }else{
            nationTextStr = str;
        }
    }
    
    [DataFetcher doCompleteUserInfo:_nickNameTextField.text
                           IMNation:nationView.selectedNationsCode
                            IMState:[self CodeForIMStateForCode:[_selectedIMStatus firstObject]]  withSucceedHandler:^(id JSON) {
        int errCode = [[JSON valueForKey:@"state"] intValue];
        NSLog(@"errCode = %d",errCode);
        if (errCode == 0) {
            
            NSArray * tmpPersonalInfoArray = [PersonalInfo MR_findAll];
            
            PersonalInfo * f = [tmpPersonalInfoArray objectAtIndex:0];
            f.name = _nickNameTextField.text;
            f.im_state_cn = [_selectedIMStatus firstObject];
            if ([f.im_state_cn isEqualToString:@"移民中"]) {
                f.im_state_cn = @"已移民";
            }
            f.im_nation_cn = nationTextStr;
            f.im_nation = nationCodeStr;
            [HNBUtils sandBoxSaveInfo:nationCodeStr forKey:IM_NATION_LOCAL];
            
            NSArray *vcArr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
            NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:vcArr];
            for (NSInteger i = vcArr.count - 2; i>0; i--) {
                /*除去栈内的注册、登录VC*/
                UIViewController *tempVC = vcArr[i];
                if ([tempVC isKindOfClass:[RegisterViewController class]]) {
                    [tmpArr removeObject:tempVC];
                    self.navigationController.viewControllers = tmpArr;
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } withFailHandler:^(id error) {
        
    }];
    
}

#pragma mark - NationButtonViewDelegate

-(void)clickNationButton
{
    [self observeUserInfo];
}

- (void)clickMoreButton
{
    if (nationView.newHeight > nationView.size.height) {
        [nationView setHeight:nationView.newHeight];
        /*如果手机屏幕不够显示则支持滑动*/
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,CGRectGetMaxY(nationLabel.frame) + nationView.newHeight)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back_main);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
}

-(void) back_main
{
    [HNBClick event:@"161012" Content:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //显示tabbar
    [[self rdv_tabBarController] setTabBarHidden:FALSE animated:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!hideKeyboardBtn) {
        hideKeyboardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [hideKeyboardBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        hideKeyboardBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [hideKeyboardBtn setBackgroundColor:[UIColor clearColor]];
        [hideKeyboardBtn addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:hideKeyboardBtn];
    }else {
        hideKeyboardBtn.hidden = NO;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    hideKeyboardBtn.hidden = YES;
}

-(void)hideKeyboard {
    [_nickNameTextField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (1 == range.length) {//按下回格键
        return YES;
    }
    if (([textField.text length] + [string length]) > 12) {//判断字符个数
        return NO;
    }
    return YES;
}

-(void)observeUserInfo
{
    if(![_nickNameTextField.text isEqualToString:@""] && _selectedIMStatus.count != 0 && nationView.selectedNationsCode.count != 0){
        [self setSelectedBtn:_sureButton];
        [_sureButton setEnabled:YES];
    }else{
        [self setUnableBtn:_sureButton];
    }
}

-(NSString *) CodeForIMStateForCode : (NSString*)IMState
{
    NSString * tmpCodeString;

    if([IMState isEqualToString:@"想移民"])
    {
        tmpCodeString = @"WANT_IM";
    }else{
        tmpCodeString = @"IMED";
    }
    
    
    return tmpCodeString;
}

@end



