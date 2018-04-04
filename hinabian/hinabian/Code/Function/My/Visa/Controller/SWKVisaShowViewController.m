//
//  SWKVisaShowViewController.m
//  hinabian
//
//  Created by 何松泽 on 2017/8/31.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "SWKVisaShowViewController.h"
#import "RDVTabBarController.h"
#import "LoginViewController.h"
#import "DataFetcher.h"


#define RELOAD_BUTTON_SIZE 150

@interface SWKVisaShowViewController ()
{
    NSString * shareURL;
    NSString * shareTitle;
    NSString * shareFriendTitle;
    NSString * shareDesc;
    NSString * shareImageUrl;
    NSString * telNumb;
}
@property (nonatomic,strong) NSURL *localURL;
@property (nonatomic,readwrite) BOOL isback;
@end

@implementation SWKVisaShowViewController

#pragma mark ------ init - dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.title = @"签证立即办理";
    }
    return self;
}

- (void)viewDidLoad {
    NSURLRequest *req = nil;
    if (!self.URL) {
        NSString* tmpURLString = [NSString  stringWithFormat:@"%@/%@",H5URL,@"project/type.html"];
        self.localURL = [[NSURL alloc] withOutNilString:tmpURLString];
        req = [NSURLRequest requestWithURL:self.localURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    }else
    {
        req = [NSURLRequest requestWithURL:self.URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor DDNormalBackGround];
    self.title = @"";
    
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
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //清除UIWebView的缓存
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    
    [MobClick endLogPageView:@"IMProject"];
}


#pragma mark ------ private Method

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    [self baseToolMethodWithWebDidStartLoad:webView navigation:navigation];
    self.isback = false;
    
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

    [self baseToolMethodWithWebDidFinishLoad:webView navigation:navigation];
    
    [self.wkWebView evaluateJavaScriptFromString:@"document.title" hanleComplete:^(NSString *resultString) {
        self.title = resultString;
    }];
    
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    [self.wkWebView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - rectNav.size.height - rectStatus.size.height)];
    
    [self modifyNativeTelBtnAndSharedBtn];

}

@end
