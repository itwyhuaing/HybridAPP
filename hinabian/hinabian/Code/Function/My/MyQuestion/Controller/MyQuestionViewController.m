//
//  MyQuestionViewController.m
//  hinabian
//
//  Created by 余坚 on 15/7/9.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "MyQuestionViewController.h"
#import "RDVTabBarController.h"

@interface MyQuestionViewController ()
@property (nonatomic,readwrite) BOOL isback;
@end

#define RELOAD_BUTTON_SIZE 150

@implementation MyQuestionViewController

- (void)viewDidLoad {
    
    if (!self.URL) {
        NSString* tmpURLString = [NSString  stringWithFormat:@"%@/%@",H5URL,@"personal_qa.html"];
        self.URL = [[NSURL alloc] withOutNilString:tmpURLString];
    }
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor DDNormalBackGround];
    self.title = @"我的问答";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /* 如果从login界面跳转需要重新加载 */
//    NSString * isFromLogin = [HNBUtils sandBoxGetInfo:[NSString class] forKey:login_change_to_assess];
//    if ([isFromLogin isEqualToString:@"1"]) {
//        [self.wkWebView webReload];
//        [HNBUtils sandBoxSaveInfo:@"0" forKey:login_change_to_assess];
//    }

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //清除UIWebView的缓存
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    NSLog(@"assess disappear");
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    [self baseToolMethodWithWebDidStartLoad:webView navigation:navigation];
    
    self.isback = false;
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self baseToolMethodWithWebDidFinishLoad:webView navigation:navigation];
    [self.wkWebView evaluateJavaScriptFromString:@"document.title" hanleComplete:^(NSString *resultString) {
        self.title = resultString;
    }];
    
}


@end
