//
//  SWKBaseViewController.m
//  hinabian
//
//  Created by hnbwyh on 16/8/16.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "SWKBaseViewController.h"
#import "LoginViewController.h"
#import "SWKTribeShowViewController.h"
#import "DataFetcher.h"
#import "WXApi.h"
#import "SWKQuestionShowViewController.h"
#import "QuestionListByLabelsViewController.h"
#import "IMQuestionViewController.h"
#import "PublicViewController.h"
#import "MyOnedayViewController.h"
#import "PersonalInfo.h"
#import "SWKIMProjectShowController.h"
#import "UserInfoController2.h"
#import "TribeShowNewController.h"
#import "IMAssessViewController.h"
#import "QuestionReplyDetailViewController.h"
#import "CouponViewController.h"
#import "HNBRichTextPostingVC.h" // 新版富文本发帖
#import "QAIndexViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "TribeDetailInfoViewController.h"
#import "CouponViewController.h"
#import "PublicRefreshViewController.h"
#import "SpecialActivityViewController.h"

#import "QASearchViewController.h"
#import "SWKTransactViewController.h"
#import "RcmSpecialListVC.h"

// 数据解析
#import "RSADataSigner.h"
#import "IMAssessVC.h"

// 分享
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

//在线咨询
#import "SWKConsultOnlineViewController.h"


@interface SWKBaseViewController ()
{
    NSURLConnection *_urlConnection;
    NSURLRequest *_request;
    BOOL _Authenticated;
}
@property (nonatomic,copy) NSString *currentLoadUrlString; // web 加载错误上报需要记录当前正在加载的 URLString
@property (nonatomic,assign) BOOL reDirectWebFlag; // 重定向标记

@end


@implementation SWKBaseViewController

#pragma mark ------------------------------------------------------ init - dealloc

- (instancetype)init
{
    self = [super init];
    if (self) {
        _Authenticated = NO;
        
        // 配置项初始化
        _isNativeNavBar = TRUE;
        _isNativeNavShowBackBtn = TRUE;
        _isNativeNavShowTitle = TRUE;
        _isNativeNavRightOnlyShowSharedBtn = TRUE;
        _isNativeNavRightOnlyShowTelBtn = FALSE;
        _isNativeNavRightShowTelBtnAndSharedBtn = FALSE;
        _isNativeNavShowConsultBtn = FALSE;
        _isNativeNavShowBackBtn = TRUE;
        _manualRefreshWhenBack = FALSE;
        _manualPushWhenLoading = TRUE;
        _isFirstLoadURL = TRUE;
        _isDirectAllow = FALSE;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor DDNormalBackGround];
    //浏览器窗口
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    NSURLRequest *req = [NSURLRequest requestWithURL:self.URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.wkWebView = [[HNBWKWebView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - rectNav.size.height - rectStatus.size.height)
                                                delegate:self
                                               superView:self.view
                                                     req:req
                                                  config:config];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
/** web 加载用的状态栏为黑色 */
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
/** 但航基本设置*/
    [self modifyDefaultNativeNav];
    
/** 分享 、返回 按钮*/
    [self modifyDefaultNativeSharedBtn];
    [self modifyDefaultNativeBackBtn];
    
    // js 交互
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:(id)self name:@"onGoBack"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:(id)self name:@"onShare"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:(id)self name:@"jumpToSpecialist"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:(id)self name:@"getAppStatusBarHeight"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 状态栏颜色设置
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.wkWebView webStopLoading];
    // 每个控制器结束之后必须关闭
    _reDirectWebFlag = FALSE;
    
    // 移除
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"onGoBack"];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"onShare"];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"jumpToSpecialist"];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"getAppStatusBarHeight"];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark 部分需要初始化的数据 - 默认导航栏 - 返回按钮 - 分享按钮
- (void)initSWKBaseData{

}

- (void)modifyDefaultNativeNav{
    // 5. 默认底部 Tab 隐藏
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    // 基类统一设置导航栏及底部 Tab 的显示问题
    // 1. 显示原生导航栏
    [self.navigationController setNavigationBarHidden:YES animated:NO]; // 先隐藏再显示-解决导航栏标题重叠问题
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    // 2. 透明度设置
    self.navigationController.navigationBar.translucent = NO;
    // 3. 导航栏的 天蓝色 背景
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:[UIColor DDNavBarBlue]] forBarMetrics:UIBarMetricsDefault];
    // 4. 导航栏文字颜色 及 字体大小
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:NAV_TITLE_FONT_SIZE],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)modifyDefaultNativeSharedBtn{
    UIButton *sharebutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [sharebutton setBackgroundImage:[UIImage imageNamed:@"share_button_normal"]forState:UIControlStateNormal];
    [sharebutton addTarget:self action:@selector(shareContent)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *sharebuttonItem = [[UIBarButtonItem alloc] initWithCustomView:sharebutton];
    self.navigationItem.rightBarButtonItem = sharebuttonItem;
}

- (void)modifyNativeRightOnlyTelBtn{
    UIButton *telbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [telbutton setBackgroundImage:[UIImage imageNamed:@"icon_bohao"]forState:UIControlStateNormal];
    [telbutton addTarget:self action:@selector(telToUs) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *telItem = [[UIBarButtonItem alloc] initWithCustomView:telbutton];
    self.navigationItem.rightBarButtonItem = telItem;
}

- (void)modifyDefaultNativeBackBtn{
    
    [self.navigationItem hidesBackButton];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(goPreV_C);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
}

- (void)modifyNativeTelBtnAndSharedBtn{
    UIButton *sharebutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [sharebutton setBackgroundImage:[UIImage imageNamed:@"share_button_normal"]forState:UIControlStateNormal];
    [sharebutton addTarget:self action:@selector(shareContent)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *telbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [telbutton setBackgroundImage:[UIImage imageNamed:@"icon_bohao"]forState:UIControlStateNormal];
    [telbutton addTarget:self action:@selector(telToUs)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *tmp  = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 8, 8)];
    
    UIBarButtonItem *ButtonOne = [[UIBarButtonItem alloc] initWithCustomView:telbutton];
    UIBarButtonItem *ButtonTwo = [[UIBarButtonItem alloc] initWithCustomView:sharebutton];
    UIBarButtonItem *ButtonCenter = [[UIBarButtonItem alloc] initWithCustomView:tmp];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: ButtonTwo,ButtonCenter, ButtonOne,nil]];
}

#pragma mark  重写 setter 方法 ， 修改默认配置

-(void)setIsNativeNavBar:(BOOL)isNativeNavBar{
    _isNativeNavBar = isNativeNavBar;
    if (!isNativeNavBar) { // web 全屏设置
        
        //
        self.navigationController.navigationBarHidden = !isNativeNavBar;
        
        //
        CGRect rect = self.wkWebView.frame;
        rect.size.height = SCREEN_HEIGHT;
        [self.wkWebView setFrame:rect];
        
        //
        if (@available(iOS 11.0, *)) {
            self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            self.wkWebView.scrollView.scrollIndicatorInsets = self.wkWebView.scrollView.contentInset;
        } else {
            // Fallback on earlier versions
            self.edgesForExtendedLayout = -20.f;
        }
    }else{
        
        [self modifyDefaultNativeNav];
        
        CGRect rectNav = self.navigationController.navigationBar.frame;
        CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
        CGRect rect = self.wkWebView.frame;
        rect.size.height = SCREEN_HEIGHT - rectNav.size.height - rectStatus.size.height;
        [self.wkWebView setFrame:rect];
        
    }
    
    
}

-(void)setIsNativeNavShowBackBtn:(BOOL)isNativeNavShowBackBtn{
    _isNativeNavShowBackBtn = isNativeNavShowBackBtn;
    if (isNativeNavShowBackBtn) {
        [self modifyDefaultNativeBackBtn];
    } else {
        [self.navigationItem hidesBackButton];
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    }
}



-(void)setIsNativeNavShowTitle:(BOOL)isNativeNavShowTitle{
    _isNativeNavShowTitle = isNativeNavShowTitle;
    if (!isNativeNavShowTitle) {
        self.webTitle = @"";
    }
}

-(void)setIsNativeNavRightOnlyShowSharedBtn:(BOOL)isNativeNavRightOnlyShowSharedBtn{
    _isNativeNavRightOnlyShowSharedBtn = isNativeNavRightOnlyShowSharedBtn;
    if (!isNativeNavRightOnlyShowSharedBtn) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        [self modifyDefaultNativeSharedBtn];
    }
}

-(void)setIsNativeNavRightOnlyShowTelBtn:(BOOL)isNativeNavRightOnlyShowTelBtn{
    _isNativeNavRightOnlyShowTelBtn = isNativeNavRightOnlyShowTelBtn;
    if (isNativeNavRightOnlyShowTelBtn) {
        [self modifyNativeRightOnlyTelBtn];
    }else{
        self.navigationItem.rightBarButtonItem = nil;;
    }
}

- (void)setIsNativeNavRightShowTelBtnAndSharedBtn:(BOOL)isNativeNavRightShowTelBtnAndSharedBtn{
    _isNativeNavRightShowTelBtnAndSharedBtn = isNativeNavRightShowTelBtnAndSharedBtn;
    if (isNativeNavRightShowTelBtnAndSharedBtn) {
        [self modifyNativeTelBtnAndSharedBtn];
    }
}

-(void)setIsNativeNavShowConsultBtn:(BOOL)isNativeNavShowConsultBtn{
    _isNativeNavShowConsultBtn = isNativeNavShowConsultBtn;
    if (isNativeNavShowConsultBtn) {
        [self.wkWebView addView:self.appointButton];
    }else{
        [self.appointButton removeFromSuperview];
    }
}

- (void)setCanRefreshWhenBack:(BOOL)canRefreshWhenBack{
    _canRefreshWhenBack = canRefreshWhenBack;
    if (canRefreshWhenBack) {
        [self.wkWebView webReload];
    }
}

#pragma mark ------------------------------------------------------ delegate
#pragma mark ------ WKUIDelegate
/**
 *  WKUIDelegate - createWebViewWithConfiguration : 支持 JS : window.open()
 */
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
    
}

/**
 * runJavaScriptAlertPanelWithMessage : 支持 JS : alert()
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    if ([webView.UIDelegate isKindOfClass:[UIViewController class]]) {
        
        UIViewController *vc = (UIViewController *)webView.UIDelegate;
        [vc presentViewController:alertController animated:YES completion:^{
            
        }];
    }
    
}

#pragma mark ------ WKNavigationDelegate

/**
 * 子类可能重写代理方法，所以需要处理的公共部分可以单独抽出来并提供外部接口
 * decidePolicyForNavigationAction
 * didStartProvisionalNavigation
 * baseToolMethodWithWebDidFinishLoad
 * didFailNavigation
 */

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    // 更新当前加载的 urlstring
    WKNavigationActionPolicy tmp = [self baseToolMethodWithWKWeb:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    decisionHandler(tmp);
    
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self baseToolMethodWithWebDidStartLoad:webView navigation:navigation];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self baseToolMethodWithWebDidFinishLoad:webView navigation:navigation];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [self baseToolMethodWithWKWeb:webView didFailWithError:error];
}

#pragma mark ------  publick base Method

#pragma mark WKNavigationDelegate


- (WKNavigationActionPolicy)baseToolMethodWithWKWeb:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    //return WKNavigationActionPolicyAllow;
    
    NSString *httpsurl = navigationAction.request.URL.absoluteString;
    _currentLoadUrlString = [NSString stringWithFormat:@"%@",httpsurl];
    // 统计 URL 
    [DataFetcher uploadWebURLString:httpsurl withSucceedHandler:nil withFailHandler:nil];
    
    NSLog(@" \n \n  =================================> start 拦截 httpsurl : %@ \n \n ",httpsurl);
    WKNavigationActionPolicy actPolicy = WKNavigationActionPolicyAllow;
    
    if (!_isDirectAllow) {
        if ([httpsurl rangeOfString:@"tel:"].location != NSNotFound){
            //打电话处理
            
            NSString *strTel = [httpsurl stringByReplacingOccurrencesOfString:@"tel:" withString:@""];
            [HNBUtils telThePhone:strTel];
            actPolicy = WKNavigationActionPolicyCancel;
        }else if ([httpsurl rangeOfString:@"itunes.apple.com"].location != NSNotFound) {
            
            //跳转到applestore处理
//            [HNBUtils gotoAppStoreWithUrl:httpsurl];
            [HNBUtils openScheme:[NSURL URLWithString:httpsurl] options:@{} complete:^(BOOL success) {
                
            }];
            actPolicy = WKNavigationActionPolicyCancel;
        }else if ([httpsurl hasPrefix:@"alipay"]) {
            // 跳转支付宝
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"alipay://"]];
            actPolicy = WKNavigationActionPolicyCancel;
        }else if ([@"ios" isEqualToString:navigationAction.request.URL.scheme]) {
            // 说明协议头是ios
            
            NSString *url = navigationAction.request.URL.absoluteString;
            NSRange range = [url rangeOfString:@":"];
            NSString *method = [navigationAction.request.URL.absoluteString substringFromIndex:range.location + 1];
            
            range = [method rangeOfString:@":"];
            
            if (range.length > 0) {
                NSString * methodTemp = [method substringToIndex:range.location];
                methodTemp = [methodTemp stringByAppendingString:@":"];
                
                NSString * argument = [method substringFromIndex:range.location + 1];
                NSArray * tmpArgunment = [HNBUtils getAllParameterForJS:argument];
                
                SEL selector = NSSelectorFromString(methodTemp);
                if ([self respondsToSelector:selector]) {
                    [self performSelector:selector withObject:tmpArgunment];
                }
            }
            else
            {
                SEL selector = NSSelectorFromString(method);
                
                if ([self respondsToSelector:selector]) {
                    [self performSelector:selector];
                }
            }
            
            actPolicy = WKNavigationActionPolicyCancel;
        }else if([httpsurl isEqualToString:@"about:blank"]){
            
            actPolicy = WKNavigationActionPolicyCancel;
            
        }else if (![self.webManger isHinabianComWithURLString:httpsurl]){
            NSLog(@" =================================> 非 .hinabian.com 直接处理");
            [self.webManger directLoadWebWithURLString:httpsurl nav:self.navigationController];
            actPolicy = WKNavigationActionPolicyCancel;
        }else if (![self.webManger isInterceptWithURLString:httpsurl]){
            
            /*
             _is_intercept  用于拓展后台管控是否应该拦截处理的能力
             V3.1.0 版本 https://m.hinabian.com/visa/save 是一个接口，不准许拦截
             */
            
        }else{
            /**< V3.0.1 之后 web 加载重构>*/
            /**
             1. 对比判断 : shouldPushNativeCtrlFromCurCtrlUTLString
             2. web 会退不处理 : isWebGoingBack
             3. 手动强制设置不处理 : manualPushWhenLoading
             4. web 堆栈数组 <= 1 : isFirstLoadURL
             5. 重定向不需处理
             */
            BOOL isPush = [self.webManger shouldPushNativeCtrlFromCurCtrlUTLString:httpsurl url:self.URL];
            BOOL isRunHandleFunc = isPush && !self.wkWebView.isWebGoingBack && self.manualPushWhenLoading && !self.isFirstLoadURL && !_reDirectWebFlag;
            NSLog(@" =================================> 站内 \n fenxiurl:%d , \n self.wkWebView.isWebGoingBack : %d , \n self.manualPushWhenLoading:%d , \n self.isFirstLoadURL:%d ,\n_reDirectWebFlag:%d, \n isRunHandleFunc:%d",isPush,self.wkWebView.isWebGoingBack,self.manualPushWhenLoading,self.isFirstLoadURL,_reDirectWebFlag,isRunHandleFunc);
            if (isRunHandleFunc) {
                BOOL isHandle = [self.webManger decideToHandleBusinessWithURL:httpsurl nav:self.navigationController];
                if(isHandle){
                    actPolicy = WKNavigationActionPolicyCancel;
                }
            }
        }
        
        if (!_reDirectWebFlag) {
            _reDirectWebFlag = [self.webManger isInsideThePageWithURLString:httpsurl];
        }
        self.wkWebView.isWebGoingBack = FALSE; // 判断是否是web goBack 及时关闭
    }
    
    NSLog(@" =================================> end - actPolicy:%ld ,_reDirectWebFlag : %d",actPolicy,_reDirectWebFlag);
    return actPolicy;
}


-(void)baseToolMethodWithWebDidStartLoad:(id)webView navigation:(WKNavigation *)navigation{
    //NSLog(@" baseToolMethodWithWebDidStartLoad ");
}

-(void)baseToolMethodWithWebDidFinishLoad:(id)webView navigation:(WKNavigation *)navigation{
    
    NSLog(@" ++++++++++++++++++++++++++++++++++++ Finish ");
    // 标题
    [self.wkWebView evaluateJavaScriptFromString:@"document.title" hanleComplete:^(NSString *resultString) {
        self.webTitle = resultString;
        if (_isNativeNavShowTitle) {
            self.title = self.webTitle;
        }else{
            self.title = @"";
        }
    }];
    
    // 读取分享参数
    [self readSharedData];
    
    // 读取电话号码参数 
    [self.wkWebView evaluateJavaScriptFromString:@"window.TEL_NUM" hanleComplete:^(NSString *resultString) {
        self.telNumb = resultString;
    }];
    
    // 确认返回按钮返回方法
    //[self modifyDefaultNativeBackBtn];
    
    //
    [self getUrl];
    
    // 关闭
    _reDirectWebFlag = FALSE;
    self.isFirstLoadURL = FALSE;

}



- (void)baseToolMethodWithWKWeb:(id)webView didFailWithError:(NSError *)error{
    
    NSLog(@" ++++++++++++++++++++++++++++++++++++ Fail ");
    
    if (101 != error.code && 102 != error.code && error.code != NSURLErrorCancelled){
        [DataFetcher doSendWebOpenFailureWithErrorURLStr:_currentLoadUrlString error:error errDes:[NSString stringWithFormat:@"SWKBase-%@",[self class]]];
    }

    _reDirectWebFlag = FALSE;
    self.isFirstLoadURL = FALSE;

}


#pragma mark ------ connection

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
{
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
    [self.wkWebView webLoadRequest:_request];
    /*移除兼容适配*/
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[_request URL] absoluteString]]];
    NSString *cookie = [HNBUtils reqCurrentCookie];
    NSLog(@" %s - HNBSESSIONID-connection :%@",__FUNCTION__,cookie);
    [request addValue:cookie forHTTPHeaderField:@"Cookie"];
    [self.wkWebView loadRequest:request];
    /*===========*/
    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    [_urlConnection cancel];
}

// We use this method is to accept an untrusted site which unfortunately we need to do, as our PVM servers are self signed.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

#pragma mark WKScriptMessageHandler

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"onGoBack"]) {
        [self goPreV_C];
    }else if ([message.name isEqualToString:@"onShare"]){
        [self shareContent];
    }else if ([message.name isEqualToString:@"jumpToSpecialist"]) {
        RcmSpecialListVC *vc = [[RcmSpecialListVC alloc] init];
        [self.navigationController pushViewController:vc animated:TRUE];
        _manualPushWhenLoading = FALSE;
    }else if ([message.name isEqualToString:@"getAppStatusBarHeight"]) {
        //把状态栏高度传给js，适配Iphone_X
        NSInteger multiple = 2;
        if (SCREEN_HEIGHT >= SCREEN_HEIGHT_PLUSE) {
            multiple = 3;
        }
        NSString *heightStr = [NSString stringWithFormat:@"%f",SCREEN_STATUSHEIGHT*multiple];
        NSString *js = [NSString stringWithFormat:@"getAppStatusBarHeight_callback(\"%@\");",heightStr];
        [self.wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable rulest, NSError * _Nullable error) {
            if (error) {
                NSLog(@"错误:%@", error.localizedDescription);
            }
        }];
    }
}


#pragma mark AppointmentButtonDelegate

- (void)consultOnlineEvent:(AppointmentButton *)appointmentButton{
    [self consultOnline];
}

- (void)consultPhoneEvent:(AppointmentButton *)appointmentButton{
    [self telToUs];
}

#pragma mark ------ UIGestureRecognizerDelegate
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    NSLog(@" gestureRecognizerShouldBegin : %@ \n %@",gestureRecognizer,[gestureRecognizer class]);
    BOOL isAllow = TRUE;
    if ([self.wkWebView webCanGoBack] && [gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        [self.wkWebView webGoBack];
        isAllow = FALSE;
    }
    return isAllow;
}


#pragma mark ------------------------------------------------------ private Method
#pragma mark 交互处理
- (void)telToUs{
    if (!self.telNumb || [self.telNumb isKindOfClass:[NSNull class]] || [self.telNumb isEqualToString:@"(null)"]) {
        self.telNumb = DEFAULT_TELNUM;
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.telNumb];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)consultOnline{
    
    /*
     https://static.meiqia.com/dist/standalone.html?_=t&eid=1875&groupid=7ab95cefc1046cabbdb4628399c56f9a
     */
    NSString *str = [NSString stringWithFormat:@"https://eco-api.meiqia.com/dist/standalone.html?eid=1875"];
    // 解析当前参数_jump_overseas_house_consult ，是否咨询海房
    
    _isOverseasHouseConsult = [self.webManger isOverseasHouseConsultWithURLString:self.URL.absoluteString];
    if (_isOverseasHouseConsult) {
        str = [NSString stringWithFormat:@"https://static.meiqia.com/dist/standalone.html?_=t&eid=1875&groupid=7ab95cefc1046cabbdb4628399c56f9a"];
    }
    SWKConsultOnlineViewController *vc = [[SWKConsultOnlineViewController alloc]init];
    vc.URL = [[NSURL alloc] withOutNilString:str];
    vc.manualPushWhenLoading = FALSE;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)goPreV_C{
    if ([self.wkWebView webCanGoBack]) {
        [self.wkWebView webGoBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (void) businessJump:(NSArray *)url
{
    if (url && url.count  > 1) {
        NSString * tmpUrl = [NSString stringWithFormat:@"%@:%@",url[0],url[1]];
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:tmpUrl];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void) testApplicationRequirements:(NSArray *)url
{
    if (url && url.count  > 1) {
        NSString * tmpUrl = [NSString stringWithFormat:@"%@:%@",url[0],url[1]];
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:tmpUrl];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 参数处理

#warning 应该冗余代码 - 暂且保留
- (void)getUrl{
    
    [self.wkWebView evaluateJavaScriptFromString:@"location.href" hanleComplete:^(NSString *resultString) {
        if (resultString)
        {
            self.URL = [NSURL URLWithString:resultString];
        }
        else
        {
            self.URL = nil;
        }
    }];
    
}

-(void) shareContent
{
    CGFloat t = 0.2;
    [self readSharedData];
    
    NSLog(@"分享数据获取延时 %f",t);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(t * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
        [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.isShow = NO;
        //调用分享面板
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            
            
            if (platformType == UMSocialPlatformType_Sina) {
                
                UMSocialMessageObject *msgObj = [UMSocialMessageObject messageObject];
                msgObj.text = [NSString stringWithFormat:@"%@ %@",self.shareTitle,self.shareURL];
                
                UMShareImageObject *sharedObj = [[UMShareImageObject alloc] init];
                sharedObj.thumbImage = [HNBUtils getImageFromURL:self.shareImageUrl];
                sharedObj.shareImage = [HNBUtils getImageFromURL:self.shareImageUrl];
                msgObj.shareObject = sharedObj;
                
                [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                    messageObject:msgObj
                                            currentViewController:self
                                                       completion:nil];
                
            }else if (platformType == UMSocialPlatformType_WechatSession){
                UMSocialMessageObject *msgObj = [UMSocialMessageObject messageObject];
                
                UMShareWebpageObject *sharedObj = [UMShareWebpageObject shareObjectWithTitle:self.shareFriendTitle
                                                                                       descr:self.shareDesc
                                                                                   thumImage:[HNBUtils getImageFromURL:self.shareImageUrl]];
                sharedObj.webpageUrl = self.shareURL;
                msgObj.shareObject = sharedObj;
                
                [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                    messageObject:msgObj
                                            currentViewController:self
                                                       completion:nil];
            } else {
                
                UMSocialMessageObject *msgObj = [UMSocialMessageObject messageObject];
                
                UMShareWebpageObject *sharedObj = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle
                                                                                       descr:self.shareDesc
                                                                                   thumImage:[HNBUtils getImageFromURL:self.shareImageUrl]];
                sharedObj.webpageUrl = self.shareURL;
                msgObj.shareObject = sharedObj;
                
                [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                    messageObject:msgObj
                                            currentViewController:self
                                                       completion:nil];
                
            }
            
        }];
        
    });
    
    
}

- (void)readSharedData{
    
    // 分享参数读取
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_SHARE_TITLE" hanleComplete:^(NSString *resultString) {
        self.shareTitle = resultString;
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_SHARE_FRIEND_DESC" hanleComplete:^(NSString *resultString) {
        self.shareDesc = resultString;
    }];
    

    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_SHARE_URL" hanleComplete:^(NSString *resultString) {
        self.shareURL = resultString;
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_SHARE_FRIEND_TITLE" hanleComplete:^(NSString *resultString) {
        self.shareFriendTitle = resultString;
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_SHARE_IMG" hanleComplete:^(NSString *resultString) {
        self.shareImageUrl = resultString;
    }];
    
}

#pragma mark ------------------------------------------------------ jumpInto 与 支付

// 微信支付
- (void)jumpIntoPay:(NSArray *)inputArry
{

    
    if (inputArry.count < 2) {
    return;
    }
    NSString * order_no = inputArry[0];
    [HNBUtils sandBoxSaveInfo:order_no forKey:wx_pay_order];
    
    NSString * pay_method = inputArry[1];
    
    [DataFetcher dogetVisaPayInfo:order_no Method:pay_method withSucceedHandler:^(id JSON) {
    int errCode = [[JSON valueForKey:@"state"] intValue];
    if (errCode == 0) {
    //调起微信支付
    id data = [JSON objectForKey:@"data"];
    NSMutableString *stamp  = [data objectForKey:@"timestamp"];
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [data valueForKey:@"appId"];
    req.partnerId           = [data valueForKey:@"partnerid"];
    req.prepayId            = [data valueForKey:@"prepayid"];
    req.nonceStr            = [data valueForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             =  @"Sign=WXPay";
    req.sign                = [data valueForKey:@"sign"];
    [WXApi sendReq:req];
    }
    
    } withFailHandler:^(id error) {
    
    }];
    
    
}

// 支付宝支付
- (void)jumpIntoAliPay:(NSArray *)inputArry
{
    
    if (inputArry.count < 2) {
        return;
    }
    NSString * order_no = [inputArry firstObject];
    NSString * pay_method = [inputArry lastObject];
    
    NSLog(@" 支付宝支付 inputArry :%@ - order_no: %@ - pay_method :%@",inputArry,order_no,pay_method);
    
    // 网络接口请求所需数据组装数据模型
    [DataFetcher dogetVisaPayInfo:order_no Method:pay_method withSucceedHandler:^(id JSON) {
        
        int state = [[JSON valueForKey:@"state"] intValue];
        if (state == 0) {
            
            NSDictionary *dataDic = (NSDictionary *)[JSON valueForKey:@"data"];
            NSString *bizString = [dataDic returnValueWithKey:@"biz_content"];
            NSData *bizData= [bizString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *bizDic = [NSJSONSerialization JSONObjectWithData:bizData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:nil];
            
            //将商品信息赋予AlixPayOrder的成员变量
            Order* order = [Order new];
            // NOTE: app_id设置
            order.app_id = [dataDic returnValueWithKey:@"app_id"];  //@"2017051807275825";
            order.charset = [dataDic returnValueWithKey:@"charset"];
            order.format = [dataDic returnValueWithKey:@"format"];
            order.method = [dataDic returnValueWithKey:@"method"];
            order.notify_url = [dataDic returnValueWithKey:@"notify_url"];
            order.sign_type = [dataDic returnValueWithKey:@"sign_type"];
            order.timestamp = [dataDic returnValueWithKey:@"timestamp"];
            order.version = [dataDic returnValueWithKey:@"version"];
            
            order.biz_content = [BizContent new];
            order.biz_content.product_code = [bizDic returnValueWithKey:@"product_code"];
            order.biz_content.seller_id = [bizDic returnValueWithKey:@"seller_id"];
            order.biz_content.out_trade_no = [bizDic returnValueWithKey:@"out_trade_no"];
            order.biz_content.total_amount = [bizDic returnValueWithKey:@"total_amount"];
            order.biz_content.subject = [bizDic returnValueWithKey:@"subject"];
            order.biz_content.body = [bizDic returnValueWithKey:@"body"];
            
            // private_key sign
            //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
            NSString *appScheme = @"alipay2017051807275825";
            NSString *orderInfo = [order orderInfoEncoded:NO];
            NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
            NSString *signedString = [dataDic returnValueWithKey:@"sign"];
            NSString *private_key = [dataDic returnValueWithKey:@"private_key"];
            
            RSADataSigner * signer = [[RSADataSigner alloc] initWithPrivateKey:private_key];
            signedString = [signer signString:orderInfo withRSA2:YES];
            
            // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                     orderInfoEncoded, signedString];
            
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@" 支付结果回调Block，用于wap支付结果回调（非跳转钱包支付）reslut = %@",resultDic);
            }];
            
            
        }
        
    } withFailHandler:^(id error) {
        
    }];
    
}

#pragma mark ------ jumpInto

#pragma mark ios:login
- (void)login
{
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    //NSLog(@"\n \n %s \n - \n %@ \n \n",__func__,self.navigationController.viewControllers);
}

#pragma mark ios:back 这种样式下使用
-(void) back
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ios:login:anserSomeFloor:' + qId + ":" + aId + ":" + name;
- (void)login:(NSArray *)inPutArry
{
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)jumpIntoTheme:(NSArray *)inputArry
{
    if (inputArry.count < 3) {
        return;
    }
    NSString * url = [NSString  stringWithFormat:@"%@/%@",H5URL,inputArry[0]];
    NSString * url_lz = [NSString  stringWithFormat:@"%@/%@",H5URL,inputArry[2]];
    
    NSString *isNativeString = [HNBUtils sandBoxGetInfo:[NSString class] forKey:TRIBEDETAILTHEME_NATIVEUI_WEB];
    if ([isNativeString isEqualToString:@"1"]) {
        
        TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:url];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        
        SWKTribeShowViewController *vc = [[SWKTribeShowViewController alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:url];
        vc.T_ID = inputArry[1];
        vc.LZURL = [[NSURL alloc] withOutNilString:url_lz];
        [self.navigationController pushViewController:vc animated:YES];
        
    }

}


- (void)jumpIntoQuestion:(NSArray *)inputArry
{
    NSString * url = [NSString  stringWithFormat:@"%@%@",H5URL,inputArry[0]];
    SWKQuestionShowViewController *vc = [[SWKQuestionShowViewController alloc] init];
    vc.URL = [[NSURL alloc] withOutNilString:url];
    vc.Q_ID = inputArry[1];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)jumpIntoLabelList:(NSArray *)inputArry
{
    if (inputArry.count < 1) {
        return;
    }
    NSString * labelsIdString = inputArry[0];
    QuestionListByLabelsViewController *vc = [[QuestionListByLabelsViewController alloc] init];
    vc.labelsString = labelsIdString;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)createNewQa
{
    IMQuestionViewController *vc = [[IMQuestionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createNewQa:(NSArray *)inputArry
{
    if (inputArry.count < 2) {
        return;
    }
    NSString * uidString = inputArry[0];
    NSString * nameString = [inputArry[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    IMQuestionViewController *vc = [[IMQuestionViewController alloc] init];
    vc.answererUid = uidString;
    vc.answererName = nameString;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)creatNewTheme
{
    HNBRichTextPostingVC *vc = [[HNBRichTextPostingVC alloc] init];
    vc.choseTribeCode = @"";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpIntoQA
{
    QAIndexViewController *vc = [[QAIndexViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 公用跳转
- (void)jumpIntoPublic:(NSArray *)inputArry
{
    if (inputArry.count < 1) {
        return;
    }
    NSString * tmpUrl = inputArry[0];
    NSString * url = [tmpUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    PublicViewController * vc = [[PublicViewController alloc] init];
    vc.URL = [[NSURL alloc] withOutNilString:url];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)jumpIntoCOD:(NSArray *)inputArry
{
    
    if (inputArry.count < 2) {
        return;
    }
    NSString * url = [NSString  stringWithFormat:@"%@%@",H5URL,inputArry[0]];
    NSString * timestamp = inputArry[1];
    MyOnedayViewController *vc = [[MyOnedayViewController alloc] init];
    vc.URL = [[NSURL alloc] withOutNilString:url];
    vc.TimeStamp = timestamp;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)jumpIntoVideo:(NSArray *)inputArry
{
    if (inputArry.count < 2) {
        return;
    }
    if([inputArry[0] isEqualToString:@""])
    {
        return;
    }
    NSString * videdourl = [NSString stringWithFormat:@"%@:%@",inputArry[0],inputArry[1]];
    NSURL *videoURL = [NSURL URLWithString:videdourl];
    [self playVideoWithURL:videoURL];
}

- (void)playVideoWithURL:(NSURL *)url
{
//    if (!self.videoController) {
//        CGFloat width = [UIScreen mainScreen].bounds.size.width;
//        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, width, width*(9.0/16.0))];
//        __weak typeof(self)weakSelf = self;
//        [self.videoController setDimissCompleteBlock:^{
//            weakSelf.videoController = nil;
//        }];
//        [self.videoController showInWindow];
//    }
//    self.videoController.contentURL = url;
}

- (void)jumpIntoUserInfo:(NSArray *)inputArry
{
    if (inputArry.count < 1) {
        return;
    }
    if([inputArry[0] isEqualToString:@""])
    {
        return;
    }
    NSString * id = inputArry[0];
    
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
    if (tmpPersonalInfoArry.count != 0) {
        UserInfo = tmpPersonalInfoArry[0];
    }
    
    if (![UserInfo.id isEqualToString:id] || UserInfo == NULL) {
        // 原生
        UserInfoController2 *vc = [[UserInfoController2 alloc] init];
        vc.personid = id;
        [self.navigationController pushViewController:vc animated:YES];
        NSDictionary *dic = @{@"idForUser":vc.personid};
        [MobClick event:@"clickIcon" attributes:dic];
    }
    else
    {
        //        [self rdv_tabBarController].selectedIndex = 3;
        //        [[self rdv_tabBarController] selectedViewController];
    }
    
}

- (void)jumpIntoSingleTribe:(NSArray *)inputArry
{
    if (inputArry.count < 1) {
        return;
    }
    if([inputArry[0] isEqualToString:@""])
    {
        return;
    }
    NSString * id = inputArry[0];
    TribeShowNewController * vc = [[TribeShowNewController alloc] init];
    vc.tribeId = id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) jumpIntoProject:(NSArray *)inputArry
{
    if (inputArry.count < 2) {
        return;
    }
    if([inputArry[0] isEqualToString:@""])
    {
        return;
    }
    NSString * url = [NSString stringWithFormat:@"%@:%@",inputArry[0],inputArry[1]];
    SWKIMProjectShowController * vc = [[SWKIMProjectShowController alloc] init];
    vc.URL = [NSURL URLWithString:url];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 海外房产
- (void)jumpIntoNation:(NSArray *)inputArry
{
    if (inputArry.count < 2) {
        return;
    }
    if([inputArry[0] isEqualToString:@""])
    {
        return;
    }
    NSString * url = [NSString stringWithFormat:@"%@:%@",inputArry[0],inputArry[1]];
    if([url rangeOfString:@"/policy"].location != NSNotFound || [url rangeOfString:@"/immRaiders"].location != NSNotFound ||
       [url rangeOfString:@"/lifeGuide"].location != NSNotFound)
    {
        PublicRefreshViewController* vc = [[PublicRefreshViewController alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:url];
        vc.manualPushWhenLoading = FALSE;
        [self.navigationController pushViewController:vc animated:YES];
    }

    else
    {
        
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:url];
        vc.manualPushWhenLoading = FALSE;
        [self.navigationController pushViewController:vc animated:YES];

    }
}

- (void) jumpIntoIMAssess
{
    if([[HNBUtils sandBoxGetInfo:[NSString class] forKey:im_assess_type] isEqualToString:@"1"])    //原生
    {
        if (IOS_VERSION < 8.0) { // 版本低于 8.0 时调用 web页
            IMAssessViewController * vc = [[IMAssessViewController alloc] init]; // skiplow － web页
            vc.URL = [NSURL URLWithString:@"https://m.hinabian.com/assess.html"];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            IMAssessVC * vc = [[IMAssessVC alloc] init];           // 原生化
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    else
    {
        IMAssessViewController * vc = [[IMAssessViewController alloc] init]; // skiplow － web页
        vc.URL = [NSURL URLWithString:@"https://m.hinabian.com/assess.html"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) jumpIntoQuestionReply:(NSArray *)inputArry
{
    if (inputArry.count < 1) {
        return;
    }
    NSString * url = [NSString stringWithFormat:@"https://m.hinabian.com%@",inputArry[0]];
    QuestionReplyDetailViewController* vc = [[QuestionReplyDetailViewController alloc] init];
    vc.URL = [NSURL URLWithString:url];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------------------------------------------------------ 懒加载

-(AppointmentButton *)appointButton{
    if (!_appointButton) {
        // 预约按钮 - 默认显示
        float scale = SCREEN_WIDTH/SCREEN_WIDTH_6;
        float btnWidth = 53.0f*scale;
        float btnHeight = 53.0f*scale;
        self.appointButton = [[AppointmentButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - btnWidth - 15*scale, SCREEN_HEIGHT - btnHeight - 128, btnWidth, btnHeight)];
        self.appointButton.delegate = (id)self;
    }
    return _appointButton;
}

-(HNBWebManager *)webManger{
    if (!_webManger) {
        _webManger = [[HNBWebManager alloc] init];
    }
    return _webManger;
}

@end
