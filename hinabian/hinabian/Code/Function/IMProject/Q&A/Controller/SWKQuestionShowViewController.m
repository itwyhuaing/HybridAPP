
//
//  SWKQuestionShowViewController.m
//  hinabian
//
//  Created by hnbwyh on 16/8/16.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "SWKQuestionShowViewController.h"
#import "RDVTabBarController.h"
#import "HNBUtils.h"
#import "DataFetcher.h"
#import "PersonalInfo.h"
#import "UIView+KeyboardObserver.h"
#import "LoginViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "IMQuestionViewController.h"
#import "FunctionTipView.h"
#import "HNBToast.h"

#define REPLY_INPUT_DISTANCE_TO_EDGE  12
#define COLLECT_BUTTON_SIZE   20
#define ASK_BUTTON_WIDTH 44
#define IN_PUT_VIEW_HEIGHT 44
#define IN_PUT_TEXT_HEIGHT 28
#define TEXTVIEW_LINE     6
#define SEND_BUTTON_WIDTH   34

@interface SWKQuestionShowViewController ()<UITextViewDelegate,FunctionTipViewDelegate>
{
    BOOL isAnserFloor;
    BOOL isInReply;
    NSString * isCollected;
    BOOL isLogin;
    
    int textRow;
    float textViewHeight;
    float keyBoardHeight;
}
@property (strong, nonatomic) UITextView *inputTextField;
@property (strong, nonatomic) UIView * inputView;
@property (strong, nonatomic) UIButton * sendButton;
@property (strong, nonatomic) UIButton * loginButton;
@property (strong, nonatomic) UIButton * askButton;
@property (strong, nonatomic) UIButton * collectButton;
@property (strong, nonatomic) UILabel * uilabel;
@property (nonatomic,strong) FunctionTipView *collectionMask;

@end

@implementation SWKQuestionShowViewController

#pragma mark ------ init - dealloc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor DDNormalBackGround];
    isAnserFloor = FALSE;
    isInReply = FALSE;
    
    //浏览器窗口
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    /* 增加回复框 */
    self.inputView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - IN_PUT_VIEW_HEIGHT - rectNav.size.height - rectStatus.size.height, SCREEN_WIDTH, IN_PUT_VIEW_HEIGHT)];
    self.inputView.backgroundColor = [UIColor DDNormalBackGround];
    
    self.askButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - ASK_BUTTON_WIDTH, 0, ASK_BUTTON_WIDTH, IN_PUT_VIEW_HEIGHT)];
    self.askButton.backgroundColor = [UIColor DDNavBarBlue];
    [self.askButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.askButton.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI24PX]];
    [self.askButton setTitle:@"提问" forState:UIControlStateNormal];
    [self.askButton addTarget:self action:@selector(goToAskQuestion) forControlEvents:UIControlEventTouchUpInside];
    
    self.collectButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - ASK_BUTTON_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE - COLLECT_BUTTON_SIZE, (IN_PUT_VIEW_HEIGHT - COLLECT_BUTTON_SIZE) / 2, COLLECT_BUTTON_SIZE, COLLECT_BUTTON_SIZE)];
    [self.collectButton setBackgroundImage:[UIImage imageNamed:@"detial_toolbar_mark_btn_default"] forState:UIControlStateNormal];
    [self.collectButton addTarget:self action:@selector(collectTheQuestion) forControlEvents:UIControlEventTouchUpInside];
    
    self.inputTextField = [[UITextView alloc] initWithFrame:CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT) / 2, self.collectButton.frame.origin.x - REPLY_INPUT_DISTANCE_TO_EDGE*2, IN_PUT_TEXT_HEIGHT)];
    self.inputTextField.layer.borderColor = [UIColor DDInputLightGray].CGColor;
    self.inputTextField.layer.borderWidth =1.0;
    self.inputTextField.layer.cornerRadius = 6;
    self.inputTextField.layer.masksToBounds = YES;
    self.inputTextField.delegate = (id)self;
    self.inputTextField.font = [UIFont systemFontOfSize:FONT_UI24PX];
    [self.inputView addSubview:self.inputTextField];
    [self.inputView addSubview:self.askButton];
    [self.inputView addSubview:self.collectButton];
    
    
    self.uilabel =  [[UILabel alloc] initWithFrame:CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE + 5, (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT) / 2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2, IN_PUT_TEXT_HEIGHT)];
    self.uilabel.text = @"想对TA的问题说点什么";
    self.uilabel.textColor = [UIColor DDInputLightGray];
    self.uilabel.enabled = NO;//lable必须设置为不可用
    self.uilabel.backgroundColor = [UIColor clearColor];
    self.uilabel.font = [UIFont systemFontOfSize:FONT_UI24PX];
    [self.inputView addSubview:self.uilabel];
  
    
    self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - SEND_BUTTON_WIDTH - 7*SCREEN_SCALE, (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT) / 2, SEND_BUTTON_WIDTH, IN_PUT_TEXT_HEIGHT)];
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
    
    textRow = 2;
    textViewHeight = self.inputTextField.frame.size.height;
    /*关闭IQKeyboardManager监听*/
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
    
//    CGSize size = [_inputTextField sizeThatFits:CGSizeMake(SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2 - SEND_BUTTON_WIDTH,MAXFLOAT)];
//    UIFont *font = [UIFont systemFontOfSize:FONT_UI24PX];
//    NSInteger tempRow = (NSInteger)size.height / font.lineHeight;
//    CGRect rectNav = self.navigationController.navigationBar.frame;
//    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
//    
//    
//    if (tempRow <= TEXTVIEW_LINE) {
//        self.inputView.frame = CGRectMake(0,SCREEN_HEIGHT - rectNav.size.height - rectStatus.size.height - size.height - (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT), SCREEN_WIDTH, size.height + (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT));
//        self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT) / 2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2 - SEND_BUTTON_WIDTH, size.height);
//    }else{
//        self.inputView.frame = CGRectMake(0,SCREEN_HEIGHT - rectNav.size.height - rectStatus.size.height - textViewHeight - (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT), SCREEN_WIDTH, textViewHeight + (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT));
//        self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT) / 2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2 - SEND_BUTTON_WIDTH, textViewHeight);
//    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    if (![HNBUtils isLogin]) {
        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _inputView.frame.size.width, _inputView.frame.size.height)];
        _loginButton.backgroundColor = [UIColor clearColor];
        [_loginButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchDown];
        [_inputView addSubview:_loginButton];
        isLogin = FALSE;
    }
    else
    {
        if (_loginButton) {
            [_loginButton removeFromSuperview];
        }
        if (!isLogin) {
            [self.wkWebView webReload];
            isLogin = TRUE;
        }
    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //清除UIWebView的缓存
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    
    [self.inputView removeKeyboardObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    if (_collectionMask != nil) {
        [_collectionMask removeFromSuperview];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

#pragma mark ------ private Method

- (void)btnclick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)anserSomeFloor:(NSArray *)inPutArry
{
    isAnserFloor = TRUE;
    
    if (inPutArry.count > 2) {
        self.Q_ID = inPutArry[0];
        self.A_ID= inPutArry[1];
    }
    if (![self.inputTextField isFirstResponder]) {
        [self.inputTextField becomeFirstResponder];
    }
    
    //self.webView.userInteractionEnabled = FALSE;
    self.wkWebView.webUserInteractionEnabled = FALSE;
    self.view.userInteractionEnabled = FALSE;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //self.webView.userInteractionEnabled = TRUE;
        self.wkWebView.webUserInteractionEnabled = TRUE;
        self.view.userInteractionEnabled = TRUE;
    });
}

- (void)login:(NSArray *)inPutArry
{
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
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
    [self.inputTextField resignFirstResponder];
    
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
    if (tmpPersonalInfoArry.count != 0) {
        UserInfo = tmpPersonalInfoArry[0];
        NSString * tmpA_id = @"";
        if (isAnserFloor) {
            tmpA_id = self.A_ID;
        }
        
        [DataFetcher doAnswerQuestion:UserInfo.id QID:self.Q_ID AID:tmpA_id content:self.inputTextField.text withSucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            NSLog(@"errCode = %d",errCode);
            /* 跳回前向页面 */
            if (errCode == 0) {
                NSLog(@"发送成功");
                isInReply = FALSE;
                [self afterSendSuccessed];
            }
            
            
        } withFailHandler:^(NSError* error) {
            NSLog(@"errCode = %ld",(long)error.code);
        }];
        
        
    }
    isAnserFloor = FALSE;
    
}

/* 去提问 */
-(void)goToAskQuestion
{
    [HNBClick event:@"109007" Content:nil];
    /* 是否登录  */
    if (![HNBUtils isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    IMQuestionViewController *vc = [[IMQuestionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/* 收藏或取消收藏问题 */
-(void)collectTheQuestion
{
    /* 是否登录  */
    if (![HNBUtils isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([isCollected isEqualToString:@"1"]) {
        //取消收藏
        NSDictionary *dict = @{@"state" : @"0"};
        [HNBClick event:@"109009" Content:dict];
        [DataFetcher doGetCollectQuestion:self.Q_ID CanceleOrCollect:FALSE withSucceedHandler:^(id JSON) {
            
            [self.collectButton setBackgroundImage:[UIImage imageNamed:@"detial_toolbar_mark_btn_default"] forState:UIControlStateNormal];
            isCollected = @"0";
            CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            k.values = @[@(0.1),@(1.0),@(1.3)];
            k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
            k.calculationMode = kCAAnimationLinear;
            [self.collectButton.layer addAnimation:k forKey:@"SHOW"];
            [[HNBToast shareManager] toastWithOnView:nil msg:@"已取消收藏" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
            
        } withFailHandler:^(id error) {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"取消收藏失败,请稍后重试" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }];
    }
    else
    {
        NSDictionary *dict = @{@"state" : @"1"};
        [HNBClick event:@"109009" Content:dict];
        //收藏
        [DataFetcher doGetCollectQuestion:self.Q_ID CanceleOrCollect:TRUE withSucceedHandler:^(id JSON) {
            [self.collectButton setBackgroundImage:[UIImage imageNamed:@"detial_toolbar_mark_btn_default2"] forState:UIControlStateNormal];
            isCollected = @"1";
            CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            k.values = @[@(0.1),@(1.0),@(1.3)];
            k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
            k.calculationMode = kCAAnimationLinear;
            [self.collectButton.layer addAnimation:k forKey:@"SHOW"];
           [[HNBToast shareManager] toastWithOnView:nil msg:@"收藏成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
            
        } withFailHandler:^(id error) {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"收藏失败,请稍后重试" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }];
    }
}

-(void) afterSendSuccessed
{
    //[self.webView reload];
    [self.wkWebView webReload];
    [self.inputTextField resignFirstResponder];
    [self.inputTextField setText:@""];
    if (self.inputTextField.text.length == 0) {
        self.uilabel.text = @"想对TA的问题说点什么";
    }else{
        self.uilabel.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) loginButtonPressed
{
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------ UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [HNBClick event:@"109021" Content:nil];
    NSLog(@"textFieldDidBeginEditing");

    self.sendButton.hidden = FALSE;
    self.askButton.hidden = TRUE;
    self.collectButton.hidden = TRUE;
    isInReply = TRUE;
    self.uilabel.text = @"";
    
    CGSize size = [_inputTextField sizeThatFits:CGSizeMake(SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2 - SEND_BUTTON_WIDTH,MAXFLOAT)];
    UIFont *font = [UIFont systemFontOfSize:FONT_UI24PX];
    NSInteger tempRow = (NSInteger)size.height / font.lineHeight;
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];

    if (tempRow <= TEXTVIEW_LINE) {
        self.inputView.frame = CGRectMake(0,SCREEN_HEIGHT - rectNav.size.height - rectStatus.size.height - size.height - (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT), SCREEN_WIDTH, size.height + (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT));
        self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT) / 2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2 - SEND_BUTTON_WIDTH, size.height);
    }else{
        self.inputView.frame = CGRectMake(0,SCREEN_HEIGHT - rectNav.size.height - rectStatus.size.height - textViewHeight - (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT), SCREEN_WIDTH, textViewHeight + (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT));
        self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT) / 2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2 - SEND_BUTTON_WIDTH, textViewHeight);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"textFieldDidEndEditing");
//    self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT)/2, self.collectButton.frame.origin.x - REPLY_INPUT_DISTANCE_TO_EDGE*2, IN_PUT_TEXT_HEIGHT);
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    CGSize size = [_inputTextField sizeThatFits:CGSizeMake(SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2 - SEND_BUTTON_WIDTH - 4,MAXFLOAT)];
    UIFont *font = [UIFont systemFontOfSize:FONT_UI24PX];
    NSInteger tempRow = (NSInteger)size.height / font.lineHeight;
    
    if (tempRow <= TEXTVIEW_LINE) {
        self.inputView.frame = CGRectMake(0,SCREEN_HEIGHT - rectStatus.size.height - rectNav.size.height - size.height - (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT), SCREEN_WIDTH, size.height + (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT));
        self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT) / 2, self.collectButton.frame.origin.x - REPLY_INPUT_DISTANCE_TO_EDGE*2, size.height);
    }else{
        self.inputView.frame = CGRectMake(0,SCREEN_HEIGHT - rectStatus.size.height - rectNav.size.height - textViewHeight - (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT), SCREEN_WIDTH, textViewHeight + (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT));
        self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT) / 2,self.collectButton.frame.origin.x - REPLY_INPUT_DISTANCE_TO_EDGE*2, textViewHeight);
    }
    
    self.sendButton.hidden = TRUE;
    self.askButton.hidden = FALSE;
    self.collectButton.hidden = FALSE;
    if (textView.text.length == 0) {
        self.uilabel.text = @"想对TA的问题说点什么";
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
    float inputViewY = self.inputView.frame.origin.y;
    //self.examineText =  textView.text;
    if (textView.text.length == 0) {
        self.uilabel.text = @"想对TA的问题说点什么";
    }else{
        UIFont *font = [UIFont systemFontOfSize:FONT_UI24PX];
        CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width,MAXFLOAT)];
        /*获取textview当前行数*/
        NSInteger tempRow = (NSInteger)size.height / font.lineHeight;
        
            if (tempRow < TEXTVIEW_LINE && tempRow > textRow) {
                self.inputTextField.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, (IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT) / 2, textView.frame.size.width, size.height);
                self.inputView.frame = CGRectMake(0, inputViewY - font.lineHeight, SCREEN_WIDTH, size.height + IN_PUT_VIEW_HEIGHT - IN_PUT_TEXT_HEIGHT);
                [self.inputTextField setContentOffset:CGPointMake(0, -5)];
                textViewHeight = self.inputTextField.frame.size.height;
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

#pragma mark ------ Base Publick

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    if (isInReply) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        WKNavigationActionPolicy policy = [self baseToolMethodWithWKWeb:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
        decisionHandler(policy);
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
    
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_IS_FAVORITE" hanleComplete:^(NSString *resultString) {
        
        isCollected =  resultString;
        if ([isCollected isEqualToString:@"1"]) {
            //收藏按钮图标
            [self.collectButton setBackgroundImage:[UIImage imageNamed:@"detial_toolbar_mark_btn_default2"] forState:UIControlStateNormal];
        }
        else
        {
            //没收藏按钮图标
            [self.collectButton setBackgroundImage:[UIImage imageNamed:@"detial_toolbar_mark_btn_default"] forState:UIControlStateNormal];
        }
    }];

    self.inputView.hidden = FALSE;

    NSString *show_collection = [HNBUtils sandBoxGetInfo:[NSString class] forKey:qa_detail_show_collection];
    if (![show_collection isEqualToString:@"1"]) {
        [HNBUtils sandBoxSaveInfo:@"1" forKey:qa_detail_show_collection];
        [self showNewFunction];
    }
    
}

#pragma mark ------ 新功能提醒

- (void)showNewFunction{
    
    CGFloat gap = 10.0 * SCREEN_WIDTHRATE_6;
    CGRect rect = CGRectZero;
    CGRect imgRect = CGRectZero;
    CGRect tmpRect = [self.inputView convertRect:self.collectButton.frame toView:nil];
    rect.size.width = tmpRect.size.width + gap;
    rect.size.height = rect.size.width;
    rect.origin.x = tmpRect.origin.x - gap / 2.0;
    rect.origin.y = tmpRect.origin.y - gap / 2.0;
    
    imgRect.size.width = (296.0 / 2.0) * SCREEN_WIDTHRATE_6;
    imgRect.size.height = (341.0 / 2.0) * SCREEN_WIDTHRATE_6;
    imgRect.origin.y = rect.origin.y - imgRect.size.height;
    imgRect.origin.x = rect.origin.x - imgRect.size.width + gap;
    
    _collectionMask = [[FunctionTipView alloc] initWithHollowRectA:rect tipRectB:imgRect];
    _collectionMask.delegate = self;
    _collectionMask.lineType = SolidLineType;
    _collectionMask.shapeType = CircleType;
    _collectionMask.tipImageName = @"qa_detail_collect";
    [[UIApplication sharedApplication].keyWindow addSubview:_collectionMask];
    
}


-(void)functionTipView:(FunctionTipView *)tipView didTouchEvent:(UITouch *)touch{

    [tipView removeFromSuperview];
    
}

@end
