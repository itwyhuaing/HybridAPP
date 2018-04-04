//
//  SWKTransactViewController.m
//  hinabian
//
//  Created by 何松泽 on 2017/8/31.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "SWKTransactViewController.h"
#import "RDVTabBarController.h"
#import "LoginViewController.h"


#define RELOAD_BUTTON_SIZE 150

@interface SWKTransactViewController ()

@property (nonatomic,strong) NSURL *localURL;
@property (nonatomic,readwrite) BOOL isback;

@end

@implementation SWKTransactViewController

#pragma mark ------ init - dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.title = @"签约办理";
    }
    return self;
}

- (void)viewDidLoad {
    if (!self.URL) {
        NSString* tmpURLString = [NSString  stringWithFormat:@"%@/%@",H5URL,@"project/type.html"];
        self.URL = [[NSURL alloc] withOutNilString:tmpURLString];
    }
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor DDNormalBackGround];
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
        //[self.webView reload];
        [self.wkWebView webReload];
        [HNBUtils sandBoxSaveInfo:@"0" forKey:login_change_to_assess];
    }
    /* 有拨号功能 */
    [self modifyNativeTelBtnAndSharedBtn];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //清除UIWebView的缓存
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    
}


#pragma mark ------ private Method

-(void) reloadRightNow
{
    //[self.webView reload];
    [self.wkWebView webReload];
}

- (void) webViewReload
{
    NSLog(@"inside");
    NSURLRequest *req = nil;
    if (self.URL) {
        req = [NSURLRequest requestWithURL:self.URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    }
    else
    {
        req = [NSURLRequest requestWithURL:self.localURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    }
    
    //清除UIWebView的缓存
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    
    [self.wkWebView webLoadRequest:req];
}

#pragma mark ------ CONSULT_BUTTON_DELEGATE

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    if (![self.wkWebView webCanGoBack] && nil == self.URL)
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
    else
    {
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
        temporaryBarButtonItem.target = self;
        temporaryBarButtonItem.action = @selector(back);
        self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    }
    if (!self.isback) {
        
    }
    self.isback = false;
    
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self baseToolMethodWithWebDidFinishLoad:webView navigation:navigation];
    
    [self.wkWebView evaluateJavaScriptFromString:@"document.title" hanleComplete:^(NSString *resultString) {
        self.title = resultString;
    }];
    
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    [self.wkWebView setWebFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - rectNav.size.height - rectStatus.size.height)];
}

@end
