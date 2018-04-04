//
//  SWKTribeShowViewController.m
//  hinabian
//
//  Created by hnbwyh on 16/8/16.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "SWKTribeShowViewController.h"
#import "LoginViewController.h"
#import "RDVTabBarController.h"
#import "SWKSingleReplyViewController.h"
#import "HNBUtils.h"
#import "DataFetcher.h"
#import "PersonalInfo.h"
#import "UIView+KeyboardObserver.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "ReplyView.h"
#import "HNBToast.h"
#import "HNBTribeShowActionSheet.h"
#import "HNBTipMask.h"
// rain - 站内链接
#import "TribeShowNewController.h"
//#import "IMAssessViewController.h"
#import "RDVTabBarController.h"
#import "QAIndexViewController.h"


#define REPLY_INPUT_DISTANCE_TO_EDGE  10
#define PRAISE_ICON_DISTANCE_TO_EDG 8
#define PRAISE_ICON_SIZE 35
#define SEND_BUTTON_SIZE 34
#define PAGE_VIEW_WIDTH   (134*SCREEN_SCALE)
#define PAGE_VIEW_HEIGHT  36
#define PAGE_BUTTON_EDGE  5

@interface SWKTribeShowViewController ()<HNBReplyViewDelegate,UIPickerViewDelegate,HNBTipMaskDelegate>
{
    BOOL isAnserFloor;
    BOOL isLZ;
    BOOL isZan;
    BOOL isJumpIntoSingleReply;
    
    NSString * shareURL;
    NSString * shareTitle;
    NSString * shareFriendTitle;
    NSString * shareDesc;
    NSString * shareImageUrl;
    NSString * isCollected;
    NSString * currentPage;
    NSString * totlePage;
    
    NSURLConnection *_urlConnection;
    NSURLRequest *_request;
    BOOL _Authenticated;
    BOOL isInReply;
    
    
}

@property (strong, nonatomic) UIButton * rightButton;
@property (strong, nonatomic) UIButton * loginButton;
@property (strong,nonatomic) ReplyView * replyInputView;
@property (strong,nonatomic) UIView *pageShowView;
@property (strong,nonatomic) UIButton *pageButton;
@property (strong,nonatomic) NSURL *currentUrl; // 当前显示的帖子 URL
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *pickerArray;
@property (nonatomic, strong) UIImageView *jumpPage;
@property (nonatomic, strong) HNBTipMask *mask;
@property (nonatomic) BOOL isShow;
@end

@implementation SWKTribeShowViewController

#pragma mark ------ init - dealloc

- (void)viewDidLoad {
    
    if (!self.URL) {
        self.URL = [[NSURL alloc] withOutNilString:@"https://m.hinabian.com/theme/detail2/6190695448912018069.html"];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"帖子详情";
    self.view.backgroundColor = [UIColor DDNormalBackGround];
    isAnserFloor = FALSE;
    isLZ = FALSE;
    _Authenticated = NO;
    isInReply = FALSE;
    
    _currentUrl = self.URL;
    //浏览器窗口
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - rectNav.size.height - rectStatus.size.height - 44);
    [self.wkWebView setWebFrame:rect];
    
    _replyInputView = [[ReplyView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44 - rectNav.size.height - rectStatus.size.height, SCREEN_WIDTH, 44)];
    _replyInputView.superViewController = self;
    _replyInputView.delegate = (id)self;
    _replyInputView.backgroundColor = [UIColor DDNormalBackGround];
    [_replyInputView replyViewEnable:FALSE];
    [self.view addSubview:_replyInputView];
    _isShow = YES;
    [self addPageView];
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(horizontalSwipeGesture:)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight; //默认向右
    [self.view addGestureRecognizer:swipeGesture];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.wkWebView addGestureRecognizer:singleTap];
    singleTap.delegate = (id)self;
    singleTap.cancelsTouchesInView = NO;
    
    
    isJumpIntoSingleReply = FALSE;

}
-(void)swipeGesture:(id)sender
{
    UISwipeGestureRecognizer *swipe = sender;
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUpNav];
    
    /* 如果从login界面跳转需要重新加载 */
    NSString * isFromLogin = [HNBUtils sandBoxGetInfo:[NSString class] forKey:login_change_to_assess];
    if ([isFromLogin isEqualToString:@"1"]) {
        [self.wkWebView webReload];
        [HNBUtils sandBoxSaveInfo:@"0" forKey:login_change_to_assess];
    }
    
    NSString * isLogin = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_is_login];
    if (isLogin == nil) {
        isLogin = @"0";
    }
    
    if ([isLogin isEqualToString:@"0"]) {
        if (!_loginButton) {
            _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _replyInputView.inputTextField.frame.size.width, _replyInputView.frame.size.height)];
            _loginButton.backgroundColor = [UIColor clearColor];
            [_loginButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchDown];
            [_replyInputView addSubview:_loginButton];
        }
    }
    else
    {
        if (_loginButton) {
            [_loginButton removeFromSuperview];
        }
    }
    
    if(isJumpIntoSingleReply)
    {
        [self.wkWebView webReload];
        isJumpIntoSingleReply = FALSE;
    }
    
    [MobClick beginLogPageView:@"TribeShow"];
    // 友盟统计点击此次数
    _replyInputView.from = @"1";
    _replyInputView.curUrlStr = [NSString stringWithFormat:@"%@",_currentUrl];
    
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:_replyInputView
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //清除UIWebView的缓存
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    
    [self.inputView removeKeyboardObserver];
    
    [MobClick endLogPageView:@"TribeShow"];
    
    // 管控新功能提醒
    _isShow = NO;
    if (_mask != nil && !_mask.hidden) {
        _mask.hidden = YES;
    }
    
    if (_jumpPage != nil && !_jumpPage.hidden) {
        _jumpPage.hidden = YES;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:_replyInputView name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}



-(void)keyboardWillShow:(NSNotification *)notification
{
    /*
        该类已废弃
     */
}


#pragma mark ------ private Method

- (void)setUpNav{
    
    UIButton *sharebutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [sharebutton setBackgroundImage:[UIImage imageNamed:@"share_button_normal"]forState:UIControlStateNormal];
    [sharebutton addTarget:self action:@selector(shareContent)
          forControlEvents:UIControlEventTouchUpInside];
    UIButton *v  = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 43, 18)];
    [v setBackgroundImage:[UIImage imageNamed:@"tribe_show_lz"]forState:UIControlStateNormal];
    [v addTarget:self action:@selector(lookLZ) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton = v;
    UIButton *tmp  = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 8, 8)];
    UIBarButtonItem *ButtonOne = [[UIBarButtonItem alloc] initWithCustomView:v];
    UIBarButtonItem *ButtonTwo = [[UIBarButtonItem alloc] initWithCustomView:sharebutton];
    UIBarButtonItem *ButtonCenter = [[UIBarButtonItem alloc] initWithCustomView:tmp];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: ButtonTwo, ButtonCenter, ButtonOne,nil]];
}


- (void) addPageView
{
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    _pageShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PAGE_VIEW_WIDTH, PAGE_VIEW_HEIGHT)];
    _pageShowView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2];
    _pageShowView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 44 - rectNav.size.height - rectStatus.size.height - PAGE_VIEW_HEIGHT/2);
    _pageShowView.layer.cornerRadius = RRADIUS_LAYERCORNE;
    _pageShowView.hidden = TRUE;
    [self.view addSubview:_pageShowView];

    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (_pageShowView.frame.size.height - PAGE_VIEW_HEIGHT)/2, PAGE_VIEW_HEIGHT, PAGE_VIEW_HEIGHT)];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftPageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(PAGE_VIEW_WIDTH - PAGE_VIEW_HEIGHT, (_pageShowView.frame.size.height - PAGE_VIEW_HEIGHT)/2, PAGE_VIEW_HEIGHT, PAGE_VIEW_HEIGHT)];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightPageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    CGRect rect = CGRectZero;
    rect.size.width = 14.0;
    rect.size.height = rect.size.width;
    rect.origin.x = 13.0;
    rect.origin.y = leftButton.frame.size.height/2.0 - rect.size.height/2.0;
    UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:rect];
    [leftImgView setImage:[UIImage imageNamed:@"forePage"]];
    [leftButton addSubview:leftImgView];
    rect.origin.x = rightButton.frame.size.width - 13.0 - rect.size.width;
    UIImageView *rightImgView = [[UIImageView alloc] initWithFrame:rect];
    [rightImgView setImage:[UIImage imageNamed:@"backPage"]];
    [rightButton addSubview:rightImgView];

    _pageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, PAGE_VIEW_HEIGHT)];
    [_pageButton setTitle:@"200/300" forState:UIControlStateNormal];
    [_pageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _pageButton.titleLabel.font = [UIFont systemFontOfSize:FONT_UI24PX];
    [_pageButton addTarget:self action:@selector(HNBReplyViewJumpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _pageButton.center = CGPointMake((_pageShowView.frame.size.width)/2, _pageShowView.frame.size.height/2);
    
    [_pageShowView addSubview:leftButton];
    [_pageShowView addSubview:rightButton];
    [_pageShowView addSubview:_pageButton];
}

/* 上一页 */
-(void) leftPageButtonPressed
{
    [HNBClick event:@"107031" Content:nil];
    NSInteger pageIndex = [currentPage integerValue];
    if (pageIndex >1) {
        NSString *urlString = [NSString stringWithFormat:@"https://m.hinabian.com/theme/detail/%@/%ld",_T_ID, (pageIndex-1)];
        NSURL *tmpURL = [[NSURL alloc] withOutNilString:urlString];
        NSURLRequest *req = [NSURLRequest requestWithURL:tmpURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
        //[self.webView loadRequest:req];
        [self.wkWebView webLoadRequest:req];
    }
}

/* 下一页 */
-(void) rightPageButtonPressed
{
    [HNBClick event:@"107032" Content:nil];
    NSInteger pageIndex = [currentPage integerValue];
    if (pageIndex < [totlePage intValue]) {
        NSString *urlString = [NSString stringWithFormat:@"https://m.hinabian.com/theme/detail/%@/%ld",_T_ID, (pageIndex+1)];
        NSURL *tmpURL = [[NSURL alloc] withOutNilString:urlString];
        NSURLRequest *req = [NSURLRequest requestWithURL:tmpURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
        //[self.webView loadRequest:req];
        [self.wkWebView webLoadRequest:req];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [_replyInputView fallAllView];
}


-(void)horizontalSwipeGesture:(id)sender
{
    UISwipeGestureRecognizer *swipe = sender;
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self.navigationController popViewControllerAnimated:YES];
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
/* 点击分享按钮（重写） - 点击分享的上报*/
-(void) shareContent
{
    if (![shareTitle isEqualToString:@""] && shareTitle != Nil)
    {
        NSDictionary *dict = @{@"url" : shareURL};
        [HNBClick event:@"107012" Content:dict];
        NSString *curUrlStrForShare = [NSString stringWithFormat:@"%@",_currentUrl];
        NSDictionary *dic = @{@"idForThem":curUrlStrForShare};
        [MobClick event:@"clickShare" attributes:dic];
        
        [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
        [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.isShow = NO;
        //调用分享面板
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            
            
            if (platformType == UMSocialPlatformType_Sina) {
                
                UMSocialMessageObject *msgObj = [UMSocialMessageObject messageObject];
                msgObj.text = [NSString stringWithFormat:@"%@ %@",shareTitle,shareURL];
                
                UMShareImageObject *sharedObj = [[UMShareImageObject alloc] init];
                sharedObj.thumbImage = [HNBUtils getImageFromURL:shareImageUrl];
                sharedObj.shareImage = [HNBUtils getImageFromURL:shareImageUrl];
                msgObj.shareObject = sharedObj;
                
                [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                    messageObject:msgObj
                                            currentViewController:self
                                                       completion:nil];
                
            }else if (platformType == UMSocialPlatformType_WechatSession){
                UMSocialMessageObject *msgObj = [UMSocialMessageObject messageObject];
                
                UMShareWebpageObject *sharedObj = [UMShareWebpageObject shareObjectWithTitle:shareFriendTitle
                                                                                       descr:shareDesc
                                                                                   thumImage:[HNBUtils getImageFromURL:shareImageUrl]];
                sharedObj.webpageUrl = shareURL;
                msgObj.shareObject = sharedObj;
                
                [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                    messageObject:msgObj
                                            currentViewController:self
                                                       completion:nil];
            } else {
                
                UMSocialMessageObject *msgObj = [UMSocialMessageObject messageObject];
                
                UMShareWebpageObject *sharedObj = [UMShareWebpageObject shareObjectWithTitle:shareTitle
                                                                                       descr:shareDesc
                                                                                   thumImage:[HNBUtils getImageFromURL:shareImageUrl]];
                sharedObj.webpageUrl = shareURL;
                msgObj.shareObject = sharedObj;
                
                [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                    messageObject:msgObj
                                            currentViewController:self
                                                       completion:nil];
                
            }
            
        }];
        
    }
}

-(void) lookLZ
{
    if (!isLZ && self.LZURL != nil) {
        NSLog(@"LZURL = %@",self.LZURL);
        NSURLRequest *req = [NSURLRequest requestWithURL:self.LZURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
        //[self.webView loadRequest:req];
        [self.wkWebView webLoadRequest:req];
        isLZ = TRUE;
        //[self.rightButton setTitle:@"全部帖子" forState:UIControlStateNormal];
        [self.rightButton setBackgroundImage:[UIImage imageNamed:@"tribe_show_all"]forState:UIControlStateNormal];
        NSString *curUrlStrForLZ = [NSString stringWithFormat:@"%@",self.LZURL];
        NSDictionary *dic = @{@"urlForThem":curUrlStrForLZ};
        [MobClick event:@"clicklookLZ" attributes:dic];
        _currentUrl = self.LZURL;
        NSDictionary *dict = @{@"state" : @"0"};
        [HNBClick event:@"107011" Content:dict];
    }
    else
    {
        NSLog(@"URL = %@",self.URL);
        NSURLRequest *req = [NSURLRequest requestWithURL:self.URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
        //[self.webView loadRequest:req];
        [self.wkWebView webLoadRequest:req];
        isLZ = FALSE;
        //[self.rightButton setTitle:@"只看楼主" forState:UIControlStateNormal];
        [self.rightButton setBackgroundImage:[UIImage imageNamed:@"tribe_show_lz"]forState:UIControlStateNormal];
        NSString *curUrlStr0 = [NSString stringWithFormat:@"%@",self.URL];
        NSDictionary *dic = @{@"urlForThem":curUrlStr0};
        [MobClick event:@"clicklookLZ" attributes:dic];
        _currentUrl = self.URL;
        NSDictionary *dict = @{@"state" : @"1"};
        [HNBClick event:@"107011" Content:dict];
    }
    
}

/* 开始输入回复 增加蒙版 */
-(void) startReplyEditing
{
    isInReply = TRUE;
}

/* 开始输入回复 取消蒙版 */
-(void) endReplyEditing
{
    if (isInReply) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(500 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            isInReply = FALSE;
        });
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_replyInputView fallAllView];
}

//-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
//{
//    [_progressView setProgress:progress animated:NO];
//}

-(void)done:(NSString *)chosePage{
    
    NSInteger pageIndex = [chosePage integerValue];
    if (pageIndex >=0 && pageIndex < [totlePage integerValue] ) {
        NSString *urlString = [NSString stringWithFormat:@"https://m.hinabian.com/theme/detail/%@/%ld",_T_ID, (pageIndex+1)];
        NSURL *tmpURL = [[NSURL alloc] withOutNilString:urlString];
        NSURLRequest *req = [NSURLRequest requestWithURL:tmpURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
        //[self.webView loadRequest:req];
        [self.wkWebView webLoadRequest:req];
    }
}

-(void) jumpToFirstPage
{
    NSString *urlString = [NSString stringWithFormat:@"https://m.hinabian.com/theme/detail/%@/1",_T_ID];
    NSURL *tmpURL = [[NSURL alloc] withOutNilString:urlString];
    NSURLRequest *req = [NSURLRequest requestWithURL:tmpURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    //[self.webView loadRequest:req];
     [self.wkWebView webLoadRequest:req];
}

-(void) jumpToLastPage
{
    NSString *urlString = [NSString stringWithFormat:@"https://m.hinabian.com/theme/detail/%@/%@",_T_ID,totlePage];
    NSURL *tmpURL = [[NSURL alloc] withOutNilString:urlString];
    NSURLRequest *req = [NSURLRequest requestWithURL:tmpURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    //[self.webView loadRequest:req];
     [self.wkWebView webLoadRequest:req];
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
    
    NSString *first_tribe_jumpPage = [HNBUtils sandBoxGetInfo:[NSString class] forKey:tribedetailshowview_newFunction_jumppage];
    if ((![first_tribe_jumpPage isEqualToString:@"1"]) && _isShow) {
        [HNBUtils sandBoxSaveInfo:@"1" forKey:tribedetailshowview_newFunction_jumppage];
        //[self showNewFunction];
    }
    
    //self.T_ID = [webView stringByEvaluatingJavaScriptFromString:@"window.APP_THEME_ID"];
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_THEME_ID" hanleComplete:^(NSString *resultString) {
        self.T_ID = resultString;
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_LZ_URL" hanleComplete:^(NSString *resultString) {
        
        NSString * url_lz = [NSString  stringWithFormat:@"%@/%@",H5URL,resultString];
        self.LZURL = [[NSURL alloc] withOutNilString:url_lz];
        
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_IS_PRAISE" hanleComplete:^(NSString *resultString) {
        
        if ([resultString isEqualToString:@"1"]) {
            isZan = TRUE;
            [self.replyInputView.zanImageView setImage:[UIImage imageNamed:@"tribe_show_zan_pressed"]];
        }
        else
        {
            isZan = FALSE;
            [self.replyInputView.zanImageView setImage:[UIImage imageNamed:@"tribe_show_zan"]];
        }
        
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_IS_FAVORITE" hanleComplete:^(NSString *resultString) {
        
        isCollected =  resultString;
        if ([isCollected isEqualToString:@"1"]) {
            //收藏按钮图标
            [self.replyInputView.collectImageView setImage:[UIImage imageNamed:@"detial_toolbar_mark_btn_default2"]];
        }
        else
        {
            //没收藏按钮图标
            [self.replyInputView.collectImageView setImage:[UIImage imageNamed:@"detial_toolbar_mark_btn_default"]];
        }
    }];

    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_CURRENT_PAGE" hanleComplete:^(NSString *resultString) {
        currentPage = resultString;
        
        if([currentPage integerValue] != 1)   //第一页不显示
        {
            _pageShowView.hidden = FALSE;
        }
        else
        {
            _pageShowView.hidden = TRUE;
        }
        
        [_pageButton setTitle:[NSString stringWithFormat:@"%@/%@",currentPage,totlePage] forState:UIControlStateNormal];
        
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_TOTAL_PAGE" hanleComplete:^(NSString *resultString) {
        totlePage = resultString;
    }];
    
    [_replyInputView replyViewEnable:TRUE];
    
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
     [self.wkWebView webLoadRequest:_request];
    
    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    [_urlConnection cancel];
}

// We use this method is to accept an untrusted site which unfortunately we need to do, as our PVM servers are self signed.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}


- (BOOL) isSameTribeId:(NSString *) tribeUrl
{
    NSUInteger location = [[self.URL absoluteString] rangeOfString:@"detail"].location;
    if (location == NSNotFound) {
        return FALSE;
    }
    NSString * tmpStringA = [[self.URL absoluteString] substringFromIndex:location];
    tmpStringA = [tmpStringA stringByReplacingOccurrencesOfString:@".html" withString:@""];
    location = [tribeUrl rangeOfString:@"detail"].location;
    if (location == NSNotFound) {
        return FALSE;
    }
    NSString * tmpStringB = [tribeUrl substringFromIndex:location];
    tmpStringB = [tmpStringB stringByReplacingOccurrencesOfString:@".html" withString:@""];
    if ([tmpStringB rangeOfString:tmpStringA].location != NSNotFound
        || [tmpStringA rangeOfString:tmpStringB].location != NSNotFound) {
        return TRUE;
    }
    return FALSE;
}

- (void)btnclick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reflashPage:(NSArray *)inPutArry
{
    currentPage = inPutArry[0];
    [_pageButton setTitle:[NSString stringWithFormat:@"%@/%@",currentPage,totlePage] forState:UIControlStateNormal];
}

- (void)anserSomeFloor:(NSArray *)inPutArry
{
    // 友盟统计 － 回复回帖
    NSString *curURL = [NSString stringWithFormat:@"%@",_currentUrl];
    NSDictionary *dic = @{@"idForThem":curURL};
    [MobClick event:@"clickReply" attributes:dic];
    /* 是否登录  */
    if (![HNBUtils isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    isAnserFloor = TRUE;
    
    if (inPutArry.count > 0) {
        self.C_ID = inPutArry[0];
    }
    
    //self.webView.userInteractionEnabled = FALSE;
    self.wkWebView.webUserInteractionEnabled = FALSE;
    self.view.userInteractionEnabled = FALSE;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //self.webView.userInteractionEnabled = TRUE;
        self.wkWebView.webUserInteractionEnabled = TRUE;
        self.view.userInteractionEnabled = TRUE;
        self.replyInputView.from = @"2";
        [self.replyInputView replyBecomeFirstResponder];
    });
}

- (void) jumpIntoFloor:(NSArray *)inPutArry
{
    NSString * urlstring = [NSString  stringWithFormat:@"%@/%@",H5URL,inPutArry[0]];
    NSURL * URL = [[NSURL alloc] withOutNilString:urlstring];
    
    isJumpIntoSingleReply = TRUE;
    
    SWKSingleReplyViewController *vc = [[SWKSingleReplyViewController alloc] init];
    vc.URL = URL;
    vc.T_ID = self.T_ID;
    [self.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"jumpIntoFloor");
}



#pragma mark - HNBReplyViewDelegate
-(void) HNBReplyViewZanButtonPressed
{
    NSString *curUrlStrForZan = [NSString stringWithFormat:@"%@",_currentUrl];
    NSDictionary *dic = @{@"idForThem":curUrlStrForZan};
    [MobClick event:@"clickZanButton" attributes:dic];
    /* 是否登录  */
    if (![HNBUtils isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
    if (tmpPersonalInfoArry.count != 0) {
        UserInfo = tmpPersonalInfoArry[0];
        
        if (isZan) {
            NSDictionary *dict = @{@"state" : @"1"};
            [HNBClick event:@"107022" Content:dict];
            [DataFetcher doCancelPraiseTheme:UserInfo.id TID:self.T_ID withSucceedHandler:^(id JSON) {
                int errCode = [[JSON valueForKey:@"state"] intValue];
                NSLog(@"errCode = %d",errCode);
                if (errCode == 0) {
                    NSLog(@"发送成功");
                    [self.replyInputView.zanImageView setImage:[UIImage imageNamed:@"tribe_show_zan"]];
                    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
                    k.values = @[@(0.1),@(1.0),@(1.3)];
                    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
                    k.calculationMode = kCAAnimationLinear;
                    [self.replyInputView.zanButton.layer addAnimation:k forKey:@"SHOW"];
                    isZan = FALSE;
                    [[HNBToast shareManager] toastWithOnView:nil msg:@"取消点赞成功" afterDelay:1.0 style:HNBToastHudSuccession];
                }
                
                
            } withFailHandler:^(NSError* error) {
                NSLog(@"errCode = %ld",(long)error.code);
                [[HNBToast shareManager] toastWithOnView:nil msg:@"取消点赞失败" afterDelay:1.0 style:HNBToastHudFailure];
            }];
        }
        else
        {
            NSDictionary *dict = @{@"state" : @"0"};
            [HNBClick event:@"107022" Content:dict];
            [DataFetcher doPraiseTheme:UserInfo.id TID:self.T_ID withSucceedHandler:^(id JSON) {
                int errCode = [[JSON valueForKey:@"state"] intValue];
                NSLog(@"errCode = %d",errCode);
                if (errCode == 0) {
                    NSLog(@"发送成功");
                    [self.replyInputView.zanImageView setImage:[UIImage imageNamed:@"tribe_show_zan_pressed"]];
                    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
                    k.values = @[@(0.1),@(1.0),@(1.3)];
                    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
                    k.calculationMode = kCAAnimationLinear;
                    [self.replyInputView.zanButton.layer addAnimation:k forKey:@"SHOW"];
                    isZan = TRUE;
                    [[HNBToast shareManager] toastWithOnView:nil msg:@"点赞成功" afterDelay:1.0 style:HNBToastHudSuccession];
                }
                
            } withFailHandler:^(NSError* error) {
                NSLog(@"errCode = %ld",(long)error.code);
                [[HNBToast shareManager] toastWithOnView:nil msg:@"点赞失败" afterDelay:1.0 style:HNBToastHudFailure];
            }];
        }
    }
    
}

-(void) HNBReplyViewCollectButtonPressed
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
        [HNBClick event:@"107049" Content:dict];
        [DataFetcher doGetCollectTheme:self.T_ID CanceleOrCollect:FALSE withSucceedHandler:^(id JSON) {
            [self.replyInputView.collectImageView setImage:[UIImage imageNamed:@"detial_toolbar_mark_btn_default"]];
            isCollected = @"0";
            CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            k.values = @[@(0.1),@(1.0),@(1.3)];
            k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
            k.calculationMode = kCAAnimationLinear;
            [self.replyInputView.collectButton.layer addAnimation:k forKey:@"SHOW"];
           [[HNBToast shareManager] toastWithOnView:nil msg:@"已取消收藏" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        } withFailHandler:^(id error) {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"取消收藏失败,请稍后重试" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }];
    }
    else
    {
        NSDictionary *dict = @{@"state" : @"1"};
        [HNBClick event:@"107049" Content:dict];
        //收藏
        [DataFetcher doGetCollectTheme:self.T_ID CanceleOrCollect:TRUE withSucceedHandler:^(id JSON) {
            [self.replyInputView.collectImageView setImage:[UIImage imageNamed:@"detial_toolbar_mark_btn_default2"]];
            isCollected = @"1";
            CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            k.values = @[@(0.1),@(1.0),@(1.3)];
            k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
            k.calculationMode = kCAAnimationLinear;
            [self.replyInputView.collectButton.layer addAnimation:k forKey:@"SHOW"];
            [[HNBToast shareManager] toastWithOnView:nil msg:@"收藏成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
            
        } withFailHandler:^(id error) {
           [[HNBToast shareManager] toastWithOnView:nil msg:@"收藏失败,请稍后重试" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }];
    }

}

-(void) HNBReplyViewJumpButtonPressed
{
    [HNBClick event:@"107033" Content:nil];
    //_pickerArray = [NSArray arrayWithObjects:@"第1页",@"第2页",@"第3页",@"第4页", nil];
    HNBTribeShowActionSheet *sheet = [[HNBTribeShowActionSheet alloc] initWithView:[totlePage integerValue] currentPage:[currentPage integerValue]  AndHeight:244];
    sheet.doneDelegate = (id)self;
    [sheet showInView:self.view];
}

-(void) HNBReplyViewSendButtonPressed:(ReplyView*)view TEXT:(NSString*)text IMAGE:(NSArray *)imageList
{
    NSLog(@"text to send:%@",text);
    [HNBClick event:@"107043" Content:nil];
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
    if (tmpPersonalInfoArry.count != 0) {
        UserInfo = tmpPersonalInfoArry[0];
        NSString * tmpC_id = @"";
        if (isAnserFloor) {
            tmpC_id = self.C_ID;
        }
        //输入内容为空判断
        if(([text isEqualToString:@""] || nil == text) && imageList.count == 0)
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"请输入内容" afterDelay:1.0 style:HNBToastHudOnlyText];
        }
        else
        {
            [DataFetcher doReplyPost:UserInfo.id TID:self.T_ID CID:tmpC_id content:text ImageList:imageList withSucceedHandler:^(id JSON) {
                int errCode = [[JSON valueForKey:@"state"] intValue];
                NSLog(@"errCode = %d",errCode);
                /* 跳回前向页面 */
                if (errCode == 0) {
                    NSLog(@"发送成功");
                    [self.wkWebView webReload];
                }
                
            } withFailHandler:^(NSError* error) {
                NSLog(@"errCode = %ld",(long)error.code);
            }];
        }
        
    }
    isAnserFloor = FALSE;
}



#pragma mark ------ 新功能展示

- (void)showNewFunction{
    
    // 计算相对坐标
    CGPoint point = [_replyInputView convertPoint:_replyInputView.jumpButton.center toView:nil];
    CGRect rect = [_replyInputView convertRect:_replyInputView.jumpButton.frame toView:nil];
    _mask = [[HNBTipMask alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _mask.delegate = self;
    
    CGRect locationRect = CGRectZero;
    CGFloat w = rect.size.width > _replyInputView.frame.size.height ? _replyInputView.frame.size.height: rect.size.width;
    locationRect.size.width = w - 10.0 *SCREEN_SCALE;
    locationRect.size.height = locationRect.size.width;
    locationRect.origin.x = point.x - locationRect.size.width/2.0;
    locationRect.origin.y = point.y - locationRect.size.height/2.0;
    
    CGRect imgRect = CGRectZero;
    imgRect.size.width = (459.0 / 2.0) * SCREEN_SCALE;
    imgRect.size.height = 114.0 * SCREEN_SCALE;
    imgRect.origin.x = point.x - imgRect.size.width;
    imgRect.origin.y = locationRect.origin.y - imgRect.size.height - 5.0 * SCREEN_SCALE;
    _jumpPage = [[UIImageView alloc] initWithFrame:imgRect];
    [_jumpPage setImage:[UIImage imageNamed:@"newFunction_tip_jumppage"]];
    
    _mask.maskType = HNBTipMaskRoundType;
    _mask.superViewRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _mask.holeRect = locationRect;
    _mask.opaque = NO;
    _mask.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:_mask];
    [[UIApplication sharedApplication].keyWindow addSubview:_jumpPage];
}

#pragma mark ------ HNBTipMaskDelegate

- (void)touchEventOnView:(HNBTipMask *)tipView{
    
    tipView.hidden = YES;
    _jumpPage.hidden = YES;
    
}

@end
