//
//  HotTopicListVC.m
//  hinabian
//
//  Created by hnbwyh on 2017/11/1.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "HotTopicListVC.h"
#import "RDVTabBarController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>


@interface HotTopicListVC ()

@property (nonatomic,readwrite) BOOL isback;
@end

#define RELOAD_BUTTON_SIZE 150

@implementation HotTopicListVC

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.isback = false;
    if (self.isRefreshWhenPop) {
        [self.wkWebView webReload];
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

@end
