//
//  GiveBirthInUSAViewController.m
//  hinabian
//
//  Created by 余坚 on 15/11/4.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "GiveBirthInUSAViewController.h"
#import "LoginViewController.h"
#import "HNBRichTextPostingVC.h" // 新版富文本发帖
#import "RDVTabBarController.h"
#import "HNBNetRemindView.h"

@interface GiveBirthInUSAViewController ()<HNBNetRemindViewDelegate>

@property (nonatomic,strong) NSURLRequest *currentReq;
@property (nonatomic,readwrite) BOOL isback;

@end

@implementation GiveBirthInUSAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor DDNormalBackGround];
    //浏览器窗口
    if (!self.URL) {
        NSString* tmpURLString = [NSString  stringWithFormat:@"%@/%@",H5URL,@"bia.html"];
        self.URL = [[NSURL alloc] withOutNilString:tmpURLString];
    }
    _currentReq = [NSURLRequest requestWithURL:self.URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.isback = false;
    
    /* 如果从login界面跳转需要重新加载 */
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ------ Base Publick webview每次加载之前都会调用这个方法

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self baseToolMethodWithWebDidStartLoad:webView navigation:navigation];
    
    NSString *urlSatisfiedStr = _currentReq.URL.absoluteString;
    NSRange range = [urlSatisfiedStr rangeOfString:@"http://www.healthgrades.com"];

    //加载医生满意度的网站就不用蒙版
    if (!self.isback && range.length == 0) {
        [[HNBLoadingMask shareManager] loadingMaskWithSuperView:self.view loadingMaskType:LoadingMaskTypeExtendTabBar yoffset:0.0];
    }
    self.isback = false;
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self baseToolMethodWithWebDidFinishLoad:webView navigation:navigation];
    
    [[HNBLoadingMask shareManager] dismiss];
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    [self baseToolMethodWithWKWeb:webView didFailWithError:error];
    
    [self.wkWebView evaluateJavaScriptFromString:@"document.title" hanleComplete:^(NSString *resultString) {
        self.title = resultString;
    }];
    
    CGRect rect = [HNBLoadingMask shareManager].frame;
    rect.origin.y = 0.0;
    HNBNetRemindView *showFailNetReqView = [[HNBNetRemindView alloc] init];
    [showFailNetReqView loadWithFrame:rect
                            superView:self.view
                             showType:HNBNetRemindViewShowFailNetReq
                             delegate:self];
    
    [[HNBLoadingMask shareManager] dismiss];
    
}


#pragma mark ------ 网络状况

- (void)clickOnNetRemindView:(HNBNetRemindView *)remindView{

    if (remindView.tag == HNBNetRemindViewShowFailNetReq) {
        
        [remindView removeFromSuperview];
        [self.wkWebView webLoadRequest:_currentReq];
        [[HNBLoadingMask shareManager] loadingMaskWithSuperView:self.view loadingMaskType:LoadingMaskTypeExtendTabBar yoffset:0.0];
        
    }
    
}

@end
