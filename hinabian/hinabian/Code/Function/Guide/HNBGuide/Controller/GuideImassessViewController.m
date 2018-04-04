//
//  GuideImassessViewController.m
//  hinabian
//
//  Created by 何松泽 on 2017/10/24.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "GuideImassessViewController.h"
#import "GuideHomeViewController.h"
#import "RDVTabBarController.h"
#import "HNBLoadingProgressView.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "RcmSpecialListVC.h"
#import "IMAssessVC.h"

@interface GuideImassessViewController () 

@property (nonatomic,readwrite) BOOL isback;


@end

@implementation GuideImassessViewController

-(instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor DDNormalBackGround];
    self.title = @"";
    // Do any additional setup after loading the view.
    //浏览器窗口
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:self.URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    self.wkWebView = [[HNBWKWebView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - rectNav.size.height - rectStatus.size.height) delegate:self superView:self.view req:req config:config];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.isback = false;
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

/* 打电话 */
-(void)goPreV_C {
    if ([self.wkWebView webCanGoBack]) {
        self.isback = true;
        [self.wkWebView webGoBack];
        //返回时重新获取当前的title
        [self.wkWebView evaluateJavaScriptFromString:@"document.title" hanleComplete:^(NSString *resultString) {
            if (resultString != nil || [self.title isEqualToString:@""]) {
                self.title = resultString;
            }
        }];
    }
    else
    {
        NSArray *tmpVCS = [self.navigationController viewControllers];
        NSMutableArray *vcs = [[NSMutableArray alloc] initWithArray:tmpVCS];
        //NSLog(@" 当前数组个数： ------ > %@",vcs);
        if (tmpVCS.count >= 2) {
            id vc = vcs[tmpVCS.count - 2]; // 倒数第二个
            if ([vc isKindOfClass:[GuideHomeViewController class]]) {
                
                [vcs removeObject:vc];
                self.navigationController.viewControllers = vcs;
                
            }else if ([vc isKindOfClass:[IMAssessVC class]]) {
                
                [vcs removeObject:vc];
                self.navigationController.viewControllers = vcs;
                
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self baseToolMethodWithWebDidFinishLoad:webView navigation:navigation];
    [self.wkWebView evaluateJavaScriptFromString:@"document.title" hanleComplete:^(NSString *resultString) {
        if (resultString != nil || [self.title isEqualToString:@""]) {
            self.title = resultString;
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 清除UIWebView的缓存
    [[NSURLCache  sharedURLCache ] removeAllCachedResponses];
}

- (void)getUrl
{
    
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

@end


