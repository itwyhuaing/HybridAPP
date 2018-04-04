//
//  QuestionReplyDetailViewController.m
//  hinabian
//
//  Created by 余坚 on 16/7/29.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "QuestionReplyDetailViewController.h"
#import "RDVTabBarController.h"
#import "HNBUtils.h"
#import "DataFetcher.h"
#import "PersonalInfo.h"
#import "UIView+KeyboardObserver.h"
#import "LoginViewController.h"
#import "IQKeyboardManager.h"

#define REPLY_INPUT_DISTANCE_TO_EDGE  10
#define SEND_BUTTON_WIDTH   34
#define IN_PUT_TEXT_HEIGHT  28
#define IN_PUT_VIEW_HEIGHT  44
#define TEXTVIEW_LINE       6
#define INPUT_FONT          12

@interface QuestionReplyDetailViewController ()<UITextViewDelegate>
{
    int textRow;
    float textViewHeight;
    float inputViewY;
    float keyBoardHeight;
}
@property (strong, nonatomic) UITextView *inputTextField;
@property (strong, nonatomic) UIView *inputView;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UILabel *uilabel;
@end

@implementation QuestionReplyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //浏览器窗口
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];

    /* 增加回复框 */
    self.inputView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - IN_PUT_VIEW_HEIGHT - rectNav.size.height - rectStatus.size.height, SCREEN_WIDTH, IN_PUT_VIEW_HEIGHT)];
    self.inputView.backgroundColor = [UIColor DDNormalBackGround];
    self.inputTextField = [[UITextView alloc] initWithFrame:CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT)/2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2, IN_PUT_TEXT_HEIGHT)];
    self.inputTextField.layer.borderColor = [UIColor DDInputLightGray].CGColor;
    self.inputTextField.layer.borderWidth =1.0;
    self.inputTextField.layer.cornerRadius = 6;
    self.inputTextField.layer.masksToBounds = YES;
    self.inputTextField.delegate = (id)self;
    self.inputTextField.font = [UIFont systemFontOfSize:FONT_UI24PX];
    [self.inputView addSubview:self.inputTextField];
    
    self.uilabel =  [[UILabel alloc] initWithFrame:CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE + 5, (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT)/2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2, IN_PUT_TEXT_HEIGHT)];
    self.uilabel.text = @"想对TA的回答说点什么";
    self.uilabel.textColor = [UIColor DDInputLightGray];
    self.uilabel.enabled = NO;//lable必须设置为不可用
    self.uilabel.backgroundColor = [UIColor clearColor];
    self.uilabel.font = [UIFont systemFontOfSize:FONT_UI24PX];
    [self.inputView addSubview:self.uilabel];
    
    
    self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - SEND_BUTTON_WIDTH - 4, (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT)/2, SEND_BUTTON_WIDTH, IN_PUT_TEXT_HEIGHT)];
    self.sendButton.backgroundColor = [UIColor DDNavBarBlue];
    self.sendButton.layer.cornerRadius = 5;
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:INPUT_FONT];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor DDInputLightGray] forState:UIControlStateHighlighted];
    [self.sendButton addTarget:self action:@selector(touchSendButton) forControlEvents:UIControlEventTouchUpInside];
    self.sendButton.hidden = TRUE;
    
    self.inputView.hidden = TRUE;
    [self.inputView addSubview:self.sendButton];
    
    [self.view addSubview:self.inputView];

    /* 输入框 随键盘谈起 */
    //[self.inputView addKeyboardObserver];
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight; //默认向右
    [self.view addGestureRecognizer:swipeGesture];
    
    textRow = 2;
    textViewHeight = self.inputTextField.frame.size.height;
    /*关闭IQKeyboardManager监听*/
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat curkeyBoardHeight = [[[notification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    CGRect begin = [[[notification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    // 第三方键盘回调三次问题，监听仅执行最后一次
    if(begin.size.height>0 && (begin.origin.y-end.origin.y>0)){
        keyBoardHeight = curkeyBoardHeight;
        [self showKeyboard:notification];
    }
}

- (void)showKeyboard:(NSNotification *)notification {
    
    CGSize size = [_inputTextField sizeThatFits:CGSizeMake(SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2 - SEND_BUTTON_WIDTH - (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT),MAXFLOAT)];
    UIFont *font = [UIFont systemFontOfSize:INPUT_FONT];
    NSInteger tempRow = (NSInteger)size.height / font.lineHeight;
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    if (tempRow <= TEXTVIEW_LINE) {
        self.inputView.frame = CGRectMake(0,SCREEN_HEIGHT - keyBoardHeight - rectNav.size.height - rectStatus.size.height - size.height - (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT), SCREEN_WIDTH, size.height + (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT));
        self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE,  (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT)/2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2 - SEND_BUTTON_WIDTH - (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT), size.height);
    }else{
        self.inputView.frame = CGRectMake(0,SCREEN_HEIGHT - keyBoardHeight - rectNav.size.height - rectStatus.size.height - textViewHeight - (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT), SCREEN_WIDTH, textViewHeight + (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT));
        self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE,  (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT)/2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2 - SEND_BUTTON_WIDTH -(IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT), textViewHeight);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 滑动窗口时，键盘隐藏

-(void)swipeGesture:(id)sender
{
    UISwipeGestureRecognizer *swipe = sender;
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_inputTextField resignFirstResponder];
}

/* 按下发送按钮 */
- (void)touchSendButton
{
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
    if (tmpPersonalInfoArry.count != 0) {
        UserInfo = tmpPersonalInfoArry[0];
        
        [DataFetcher doAnswerQuestion:UserInfo.id QID:self.Q_ID AID:self.A_ID content:self.inputTextField.text withSucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            NSLog(@"errCode = %d",errCode);
            /* 跳回前向页面 */
            if (errCode == 0) {
                NSLog(@"发送成功");
                [self.wkWebView webReload];
                [self afterSendSuccessed];
            }
            
            
        } withFailHandler:^(NSError* error) {
            NSLog(@"errCode = %ld",(long)error.code);
        }];
        
        
    }
    
}


-(void) afterSendSuccessed
{
    [self.inputTextField resignFirstResponder];
    [self.inputTextField setText:@""];
    if (self.inputTextField.text.length == 0) {
        self.uilabel.text = @"想对TA的回答说点什么";
    }else{
        self.uilabel.text = @"";
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];

    if (![HNBUtils isLogin]) {
        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _inputView.frame.size.width, _inputView.frame.size.height)];
        _loginButton.backgroundColor = [UIColor clearColor];
        [_loginButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchDown];
        [_inputView addSubview:_loginButton];
    }
    else
    {
        if (_loginButton) {
            [_loginButton removeFromSuperview];
        }
    }
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    /** 如果从login界面跳转需要重新加载 */
    NSString * isFromLogin = [HNBUtils sandBoxGetInfo:[NSString class] forKey:login_change_to_assess];
    if ([isFromLogin isEqualToString:@"1"]) {
        [self.wkWebView webReload];
        [HNBUtils sandBoxSaveInfo:@"0" forKey:login_change_to_assess];
    }
    
}

-(void) loginButtonPressed
{
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //清除UIWebView的缓存
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    
    /*恢复IQKeyboard*/
    [[IQKeyboardManager sharedManager] setEnable:YES];
    /*移除键盘弹出监听*/
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [self.inputView removeKeyboardObserver];
}

/* */
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [HNBClick event:@"123003" Content:nil];
    self.sendButton.hidden = FALSE;
    inputViewY = self.inputView.frame.origin.y;
    self.uilabel.text = @"";
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{

    self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT)/2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2, IN_PUT_TEXT_HEIGHT);
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    CGSize size = [_inputTextField sizeThatFits:CGSizeMake(SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2,MAXFLOAT)];
    UIFont *font = [UIFont systemFontOfSize:INPUT_FONT];
    NSInteger tempRow = (NSInteger)size.height / font.lineHeight;
    
    if (tempRow <= TEXTVIEW_LINE) {
        self.inputView.frame = CGRectMake(0,SCREEN_HEIGHT - rectStatus.size.height - rectNav.size.height - size.height - (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT), SCREEN_WIDTH, size.height + (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT));
        self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE,  (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT)/2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2, size.height);
    }else{
        self.inputView.frame = CGRectMake(0,SCREEN_HEIGHT - rectStatus.size.height - rectNav.size.height - textViewHeight - (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT), SCREEN_WIDTH, textViewHeight + (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT));
        self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE,  (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT)/2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2, textViewHeight);
    }
    self.sendButton.hidden = TRUE;
    if (textView.text.length == 0) {
        self.uilabel.text = @"想对TA的回答说点什么";
    }else{
        self.uilabel.text = @"";
    }
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    inputViewY = self.inputView.frame.origin.y;
    //self.examineText =  textView.text;
    if (textView.text.length == 0) {
        self.uilabel.text = @"想对TA的回答说点什么";
    }else{
        UIFont *font = [UIFont systemFontOfSize:INPUT_FONT];
        CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width,MAXFLOAT)];
        /*获取textview当前行数*/
        NSInteger tempRow = (NSInteger)size.height / font.lineHeight;
        
        if (tempRow < TEXTVIEW_LINE && tempRow > textRow) {
            self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT) / 2, textView.frame.size.width, size.height);
            self.inputView.frame = CGRectMake(0, inputViewY - font.lineHeight, SCREEN_WIDTH, size.height + IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT);
            textViewHeight = self.inputTextField.frame.size.height;
            [self.inputTextField setContentOffset:CGPointMake(0, -5)];
            textRow ++;
        }else if (tempRow <= TEXTVIEW_LINE && tempRow < textRow){
            self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT) / 2, textView.frame.size.width, size.height);
            self.inputView.frame = CGRectMake(0, inputViewY + font.lineHeight, SCREEN_WIDTH, size.height + IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT);
            textViewHeight = self.inputTextField.frame.size.height;
            textRow --;
        }
        
        self.uilabel.text = @"";
    }
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self baseToolMethodWithWebDidFinishLoad:webView navigation:navigation];
    
    [self.wkWebView evaluateJavaScriptFromString:@"document.title" hanleComplete:^(NSString *resultString) {
        self.title = resultString;
        }];
        
    [self.wkWebView evaluateJavaScriptFromString:@"window.Q_ID" hanleComplete:^(NSString *resultString) {
            self.Q_ID = resultString;
        }];
            
    [self.wkWebView evaluateJavaScriptFromString:@"window.A_ID" hanleComplete:^(NSString *resultString) {
            self.A_ID = resultString;
        }];

    self.inputView.hidden = FALSE;
}


- (void)btnclick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)anserSomeFloor:(NSArray *)inPutArry
{
    
    if (inPutArry.count > 2) {
        self.Q_ID = inPutArry[0];
        self.A_ID= inPutArry[1];
    }
    if (![self.inputTextField isFirstResponder]) {
        [self.inputTextField becomeFirstResponder];
    }
    
    [self.wkWebView setWebUserInteractionEnabled:FALSE];
    self.view.userInteractionEnabled = FALSE;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.wkWebView setWebUserInteractionEnabled:TRUE];
        self.view.userInteractionEnabled = TRUE;
    });
}

- (void)login:(NSArray *)inPutArry
{
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
