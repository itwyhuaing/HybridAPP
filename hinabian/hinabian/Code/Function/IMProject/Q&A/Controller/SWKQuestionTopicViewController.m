//
//  SWKQuestionTopicViewController.m
//  hinabian
//
//  Created by hnbwyh on 16/8/16.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "SWKQuestionTopicViewController.h"
#import "RDVTabBarController.h"
#import "HNBUtils.h"
#import "DataFetcher.h"
#import "PersonalInfo.h"
#import "UIView+KeyboardObserver.h"
#import "LoginViewController.h"

#define REPLY_INPUT_DISTANCE_TO_EDGE  10
#define IN_PUT_TEXT_HEIGHT 28
#define IN_PUT_VIEW_HEIGHT 44

@interface SWKQuestionTopicViewController ()<UITextViewDelegate>
{
    NSString * subjectId;
    NSString * specialId;
    NSString * labelsString;
    BOOL isInReply;
}
@property (strong, nonatomic) UITextView *inputTextField;
@property (strong, nonatomic) UIView *inputView;
@property (strong, nonatomic) UIButton * sendButton;
@property (strong, nonatomic) UIButton * loginButton;
@property (strong, nonatomic) UILabel * uilabel;

@end

@implementation SWKQuestionTopicViewController

#pragma mark ------ init - dealloc

- (void)viewDidLoad {
    [super viewDidLoad];
    isInReply = FALSE;
    
    //浏览器窗口
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
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
    self.uilabel.text = @"向TA提问吧";
    self.uilabel.textColor = [UIColor DDInputLightGray];
    self.uilabel.enabled = NO;//lable必须设置为不可用
    self.uilabel.backgroundColor = [UIColor clearColor];
    self.uilabel.font = [UIFont systemFontOfSize:FONT_UI24PX];
    [self.inputView addSubview:self.uilabel];
    
    
    self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 38, (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT)/2, 34, IN_PUT_TEXT_HEIGHT)];
    self.sendButton.backgroundColor = [UIColor DDNavBarBlue];
    self.sendButton.layer.cornerRadius = 5;
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor DDInputLightGray] forState:UIControlStateHighlighted];
    [self.sendButton addTarget:self action:@selector(touchSendButton) forControlEvents:UIControlEventTouchUpInside];
    //self.sendButton.enabled = FALSE;
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


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //清除UIWebView的缓存
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    
    [self.inputView removeKeyboardObserver];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------ private Method

-(void)swipeGesture:(id)sender
{
    UISwipeGestureRecognizer *swipe = sender;
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/* 按下发送按钮 */
- (void)touchSendButton
{
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
    if (tmpPersonalInfoArry.count != 0) {
        UserInfo = tmpPersonalInfoArry[0];
        
        NSMutableArray *tmpMutableArry = [[NSMutableArray alloc] init];
        
        NSArray * tmpArry = [labelsString componentsSeparatedByString: @","];
        for (int index = 0; index < tmpArry.count; index++) {
            [tmpMutableArry addObject:tmpArry[index]];
        }
        
        
        [DataFetcher doSubmitQuestion:UserInfo.id Title:self.inputTextField.text content:@"" Label:tmpMutableArry AnswerId:specialId SubjectId:subjectId withSucceedHandler:^(id JSON) {
            
            int errCode = [[JSON valueForKey:@"state"] intValue];
            NSLog(@"errCode = %d",errCode);
            isInReply = FALSE;
            //[self.webView reload];
            [self.wkWebView webReload];
            [self afterSendSuccessed];
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
        self.uilabel.text = @"向TA提问吧";
    }else{
        self.uilabel.text = @"";
    }
}

-(void) loginButtonPressed
{
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnclick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)login:(NSArray *)inPutArry
{
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

/* 调起回复 */
-(void) callReply
{
    if (![HNBUtils isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [_inputTextField becomeFirstResponder];
    
}

#pragma mark ------ UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [HNBClick event:@"124002" Content:nil];
    isInReply = TRUE;
    
    self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT)/2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2 - 38, IN_PUT_TEXT_HEIGHT);
    self.sendButton.hidden = FALSE;
    self.uilabel.text = @"";
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT)/2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2, IN_PUT_TEXT_HEIGHT);
    self.sendButton.hidden = TRUE;
    if (textView.text.length == 0) {
        self.uilabel.text = @"向TA提问吧";
    }else{
        self.uilabel.text = @"";
    }
    
    if (isInReply) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(500 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            isInReply = FALSE;
        });
    }
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    //self.examineText =  textView.text;
    if (textView.text.length == 0) {
        self.uilabel.text = @"向TA提问吧";
    }else{
        self.uilabel.text = @"";
    }
}

#pragma mark ------ Base Publick

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self baseToolMethodWithWebDidFinishLoad:webView navigation:navigation];

    [self.wkWebView evaluateJavaScriptFromString:@"document.title" hanleComplete:^(NSString *resultString) {
       self.title = resultString;
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.SUBJECT_ID" hanleComplete:^(NSString *resultString) {
       subjectId = resultString;
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.SPECIALIST" hanleComplete:^(NSString *resultString) {
       specialId = resultString;
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.LABEL" hanleComplete:^(NSString *resultString) {
       labelsString = resultString;
    }];

    self.inputView.hidden = FALSE;
    
}


@end
