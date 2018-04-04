//  IMAssessViewController.m
//  hinabian
//
//  Created by 余坚 on 15/6/24.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "IMAssessViewController.h"
#import "RDVTabBarController.h"
#import "HNBLoadingMask.h"
#import "LoginViewController.h"
#import "PublicViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "TalkingDataAppCpa.h"
#import "DataFetcher.h"

@interface IMAssessViewController ()<UIAlertViewDelegate>

@property (nonatomic,readwrite) BOOL isback;

@end

#define RELOAD_BUTTON_SIZE 150

@implementation IMAssessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [TalkingDataAppCpa onCustEvent1];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor DDNormalBackGround];
    self.isLoginStateChange = @"0";
    // Do any additional setup after loading the view.
    //浏览器窗口
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    if (!self.URL) {
        NSString* tmpURLString = [NSString  stringWithFormat:@"%@/%@",H5URL,@"assess/index.html"];
        self.URL = [[NSURL alloc] withOutNilString:tmpURLString];
    }
    NSURLRequest *req = [NSURLRequest requestWithURL:self.URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    self.wkWebView = [[HNBWKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - rectNav.size.height - rectStatus.size.height)
                                                delegate:self
                                               superView:self.view
                                                     req:req
                                                  config:nil];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [MobClick beginLogPageView:@"IMAssess"];
    
}

- (void)toIdeaBack
{
    [HNBClick event:@"110002" Content:nil];
    
    PublicViewController *vc = [[PublicViewController alloc]init];
    vc.URL = [NSURL URLWithString:[NSString  stringWithFormat:@"%@/%@",H5URL,@"assess/feedback.html"]];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) reloadRightNow
{
    [self.wkWebView webReload];
}

-(void) goPreV_C
{
    if ([self.wkWebView webCanGoBack])
    {
        [self.wkWebView evaluateJavaScriptFromString:@"IS_BACK_NEED_TIP" hanleComplete:^(NSString *resultString) {
            
            if (resultString && ![resultString isEqualToString:@""] && ![resultString isEqualToString:@"(null)"]) {
                UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:resultString  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                alterview.delegate = (id)self;
                [alterview show];
                return;
            }
            
            if ([self.wkWebView webCanGoBack]) {
                self.isback = true;
                [self.wkWebView webGoBack];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

/* js调用函数 */
- (void) back
{
    if ([self.wkWebView webCanGoBack]) {
        self.isback = true;
        [self.wkWebView webGoBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if ([self.wkWebView webCanGoBack]) {
            self.isback = true;
            [self.wkWebView webGoBack];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }

    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    //清除UIWebView的缓存
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    
    [[HNBLoadingMask shareManager] dismiss];
    [MobClick endLogPageView:@"IMAssess"];

}

- (void) webViewReload
{
    NSLog(@"inside");
    NSURLRequest *req = [NSURLRequest requestWithURL:self.URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    //清除UIWebView的缓存
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    
    [self.wkWebView webLoadRequest:req];
}


#pragma mark ------ Base Publick webview每次加载之前都会调用这个方法

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self baseToolMethodWithWebDidStartLoad:webView navigation:navigation];
    
    self.isback = false;
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self baseToolMethodWithWebDidStartLoad:webView navigation:navigation];
    
    [self.wkWebView evaluateJavaScriptFromString:@"document.title" hanleComplete:^(NSString *resultString) {
        self.title = resultString;
    }];
}

@end
