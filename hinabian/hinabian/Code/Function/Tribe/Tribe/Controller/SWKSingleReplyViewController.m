//
//  SWKSingleReplyViewController.m
//  hinabian
//
//  Created by hnbwyh on 16/8/16.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "SWKSingleReplyViewController.h"
#import "LoginViewController.h"
#import "RDVTabBarController.h"
#import "SWKTribeShowViewController.h"
#import "TribeDetailInfoViewController.h"
#import "MyOnedayViewController.h"
#import "HNBUtils.h"
#import "DataFetcher.h"
#import "PersonalInfo.h"
#import "UIView+KeyboardObserver.h"
#import "HNBToast.h"
#import "IQKeyboardManager.h"

#define REPLY_INPUT_DISTANCE_TO_EDGE  10
#define SEND_BUTTON_HEIGHT 23
#define SEND_BUTTON_WIDTH 48
#define TEXTVIEW_LINE     5
#define INPUT_FONT          16

@interface SWKSingleReplyViewController ()
{
    BOOL isJumpToThem;
    NSURLConnection *_urlConnection;
    NSURLRequest *_request;
    BOOL _Authenticated;
    
    int textRow;
    float textViewHeight;
    float inputViewY;
    float keyBoardHeight;
}
@property (nonatomic, strong) NSString * T_URL;
@property (nonatomic, strong) NSString * T_timestamp;
@property (strong, nonatomic) UITextView *inputTextField;
@property (strong, nonatomic) UIView * inputView;
@property (strong, nonatomic) UIButton * sendButton;
@property (strong, nonatomic) UIButton * rightButton;
@property (strong, nonatomic) UILabel * uilabel;

@end

@implementation SWKSingleReplyViewController

#pragma mark ------ init - dealloc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"回复详情";
    self.view.backgroundColor = [UIColor DDNormalBackGround];
    _Authenticated = NO;
    //浏览器窗口
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];

    self.inputView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44 - rectNav.size.height - rectStatus.size.height, SCREEN_WIDTH, 44)];
    self.inputView.backgroundColor = [UIColor DDNormalBackGround];
    self.inputTextField = [[UITextView alloc] initWithFrame:CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, 2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2, 40)];
    self.inputTextField.layer.borderColor = [UIColor DDInputLightGray].CGColor;
    self.inputTextField.layer.borderWidth =1.0;
    self.inputTextField.layer.cornerRadius = 6;
    self.inputTextField.layer.masksToBounds = YES;
    self.inputTextField.delegate = (id)self;
    self.inputTextField.font = [UIFont systemFontOfSize:INPUT_FONT];
    [self.inputView addSubview:self.inputTextField];
    
    
    self.uilabel =  [[UILabel alloc] initWithFrame:CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE + 4, 2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2, 40)];
    self.uilabel.text = @"对TA说点什么吧";
    self.uilabel.textColor = [UIColor DDInputLightGray];
    self.uilabel.enabled = NO;//lable必须设置为不可用
    self.uilabel.backgroundColor = [UIColor clearColor];
    self.uilabel.font = [UIFont systemFontOfSize:16];
    [self.inputView addSubview:self.uilabel];
    
    
    
    self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE - SEND_BUTTON_WIDTH, (self.inputView.frame.size.height - SEND_BUTTON_HEIGHT) / 2, SEND_BUTTON_WIDTH, SEND_BUTTON_HEIGHT)];
    self.sendButton.backgroundColor = [UIColor DDNavBarBlue];
    self.sendButton.layer.cornerRadius = 5;
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor DDInputLightGray] forState:UIControlStateHighlighted];
    [self.sendButton addTarget:self action:@selector(touchSendButton) forControlEvents:UIControlEventTouchUpInside];
    //self.sendButton.enabled = FALSE;
    self.sendButton.hidden = TRUE;
    [self.inputView addSubview:self.sendButton];
    
    [self.view addSubview:self.inputView];
    /* 输入框 随键盘谈起 */
//    [self.inputTextField addKeyboardObserver];
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight; //默认向右
    [self.view addGestureRecognizer:swipeGesture];
    
    isJumpToThem = TRUE;
    textRow = 1;
    textViewHeight = self.inputTextField.frame.size.height;
    /*关闭IQKeyboardManager监听*/
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
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
    
    CGSize size = [_inputTextField sizeThatFits:CGSizeMake(SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*3 - SEND_BUTTON_WIDTH,MAXFLOAT)];
    UIFont *font = [UIFont systemFontOfSize:INPUT_FONT];
    NSInteger tempRow = (NSInteger)size.height / font.lineHeight;
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    if (tempRow <= TEXTVIEW_LINE) {
        self.inputView.frame = CGRectMake(0,SCREEN_HEIGHT - keyBoardHeight - rectNav.size.height - rectStatus.size.height - size.height - 4, SCREEN_WIDTH, size.height + 4);
        self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, 2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*3 - SEND_BUTTON_WIDTH, size.height);
    }else{
        self.inputView.frame = CGRectMake(0,SCREEN_HEIGHT - keyBoardHeight - rectNav.size.height - rectStatus.size.height - textViewHeight - 4, SCREEN_WIDTH, textViewHeight + 4);
        self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, 2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*3 - SEND_BUTTON_WIDTH, textViewHeight);
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    /* 如果从login界面跳转需要重新加载 */
    NSString * isFromLogin = [HNBUtils sandBoxGetInfo:[NSString class] forKey:login_change_to_assess];
    if ([isFromLogin isEqualToString:@"1"]) {
        
        [self.wkWebView webReload];
        [HNBUtils sandBoxSaveInfo:@"0" forKey:login_change_to_assess];
        
    }
    
    /* 是否设置产看主题按钮 0 为设置 1为不设置 */
    if ([_isJumpFromTribe isEqualToString:@"0"]) {
        UIButton *v  = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 60, 66)];
        v.backgroundColor = [UIColor clearColor];
        [v setTitle:@"查看主题" forState:UIControlStateNormal];
        [v.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        //v.titleLabel.textAlignment = NSTextAlignmentLeft;
        v.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [v setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        
        [v setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [v setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [v addTarget:self action:@selector(lookTheme) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:v];
        self.navigationItem.rightBarButtonItem = barButton;
    }
    
    [MobClick beginLogPageView:@"TribeShow"];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //清除UIWebView的缓存
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];

    /*开启IQKeyboardManager监听*/
    [[IQKeyboardManager sharedManager] setEnable:YES];
    /*移除keyboard弹出通知*/
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [MobClick endLogPageView:@"TribeShow"];
}

#pragma mark ------ private Method

- (void)btnclick
{
    [self.navigationController popViewControllerAnimated:YES];
}


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
        NSString * tmpC_id = @"";
        
        tmpC_id = self.C_ID;
        //输入内容为空判断
        if([self.inputTextField.text isEqualToString:@""] || nil == self.inputTextField.text)
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"对TA说点什么吧" afterDelay:1.0 style:HNBToastHudFailure];
        }
        else
        {
            [DataFetcher doReplyPost:UserInfo.id TID:self.T_ID CID:tmpC_id content:self.inputTextField.text ImageList:nil withSucceedHandler:^(id JSON) {
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
    
}

-(void) afterSendSuccessed
{
    [self.inputTextField resignFirstResponder];
    [self.inputTextField setText:@""];
    if (self.inputTextField.text.length == 0) {
        self.uilabel.text = @"对TA说点什么吧";
    }else{
        self.uilabel.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* 跳到帖子页面 */
-(void) lookTheme
{
    NSString * url = [NSString stringWithFormat:@"%@%@",H5APIURL,self.T_URL];
    /* 跳帖子 */
    if(isJumpToThem)
    {
        
        NSString *isNativeString = [HNBUtils sandBoxGetInfo:[NSString class] forKey:TRIBEDETAILTHEME_NATIVEUI_WEB];
        if ([isNativeString isEqualToString:@"1"]) {
            
            TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
            vc.URL = [[NSURL alloc] withOutNilString:url];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
            
            SWKTribeShowViewController *vc = [[SWKTribeShowViewController alloc] init];
            vc.URL = [[NSURL alloc] withOutNilString:url];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }
    else  /* 跳华人的一天 */
    {
        //NSString * timestamp = inputArry[1];
        MyOnedayViewController *vc = [[MyOnedayViewController alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:url];
        vc.TimeStamp = self.T_timestamp;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

/* */
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSString * isLogin = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_is_login];
    if (isLogin == nil) {
        isLogin = @"0";
    }
    
    if ([isLogin isEqualToString:@"0"]) {
        [self.inputTextField resignFirstResponder];
        [self.inputTextField setText:@""];
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else
    {
        NSLog(@"textFieldDidBeginEditing");
        inputViewY = self.inputView.frame.origin.y;
        
        self.sendButton.hidden = FALSE;
        self.uilabel.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"textFieldDidEndEditing");
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    CGSize size = [_inputTextField sizeThatFits:CGSizeMake(SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2,MAXFLOAT)];
    UIFont *font = [UIFont systemFontOfSize:INPUT_FONT];
    NSInteger tempRow = (NSInteger)size.height / font.lineHeight;
    
    if (tempRow <= TEXTVIEW_LINE) {
        self.inputView.frame = CGRectMake(0,SCREEN_HEIGHT - rectStatus.size.height - rectNav.size.height - size.height - 4, SCREEN_WIDTH, size.height + 4);
        self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, 2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2, size.height);
    }else{
        self.inputView.frame = CGRectMake(0,SCREEN_HEIGHT - rectStatus.size.height - rectNav.size.height - textViewHeight - 4, SCREEN_WIDTH, textViewHeight + 4);
        self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, 2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2, textViewHeight);
    }
    
    self.sendButton.hidden = TRUE;
    if (textView.text.length == 0) {
        self.uilabel.text = @"对TA说点什么吧";
    }else{
        self.uilabel.text = @"";
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    inputViewY = self.inputView.frame.origin.y;
    //self.examineText =  textView.text;
    if (textView.text.length == 0) {
        self.uilabel.text = @"对TA说点什么吧";
    }else{
        UIFont *font = [UIFont systemFontOfSize:INPUT_FONT];
        CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width,MAXFLOAT)];
        /*获取textview当前行数*/
        NSInteger tempRow = (NSInteger)size.height / font.lineHeight;
        
        if (tempRow < TEXTVIEW_LINE && tempRow > textRow) {
            self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, 2, textView.frame.size.width, size.height);
            self.inputView.frame = CGRectMake(0, inputViewY - font.lineHeight, SCREEN_WIDTH, size.height + 4);
            [self.inputTextField setContentOffset:CGPointMake(0, -5)];
            textViewHeight = self.inputTextField.frame.size.height;
            textRow ++;
        }else if (textRow <= TEXTVIEW_LINE && tempRow < textRow){
            self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, 2, textView.frame.size.width, size.height);
            self.inputView.frame = CGRectMake(0, inputViewY + font.lineHeight, SCREEN_WIDTH, size.height + 4);
            textViewHeight = self.inputTextField.frame.size.height;
            textRow --;
        }
        self.uilabel.text = @"";
    }
}

 #pragma mark ------ Base Publick
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_THEME_ID" hanleComplete:^(NSString *resultString) {
        
       self.T_ID = resultString;
        
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_COMMENT_ID" hanleComplete:^(NSString *resultString) {
        
       self.C_ID = resultString;
        
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_THEME_URL" hanleComplete:^(NSString *resultString) {
        
       self.T_URL = resultString;
        
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"APP_THEME_TIMESTAMP" hanleComplete:^(NSString *resultString) {
        
       self.T_timestamp = resultString;
        
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"APP_IS_CHINESE_DAY" hanleComplete:^(NSString *resultString) {
        
        NSString *isChineseDay = resultString;
        if ([isChineseDay isEqualToString:@"1"]) {
            isJumpToThem = FALSE;
        }
        else
        {
            isJumpToThem = TRUE;
        }
        
    }];

}

#pragma mark ------ connection
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
{
    NSLog(@"WebController Got auth challange via NSURLConnection");
    
    if ([challenge previousFailureCount] == 0)
    {
        _Authenticated = YES;
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        
    } else
    {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    _Authenticated = YES;
    NSLog(@"load https");
    // remake a webview call now that authentication has passed ok.
    //[self.webView loadRequest:_request];
    [self.wkWebView webLoadRequest:_request];
    
    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    [_urlConnection cancel];
}

// We use this method is to accept an untrusted site which unfortunately we need to do, as our PVM servers are self signed.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

@end
