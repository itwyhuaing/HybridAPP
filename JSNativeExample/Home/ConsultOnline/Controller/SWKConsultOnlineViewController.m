//
//  SWKConsultOnlineViewController.m
//  hinabian
//
//  Created by hnbwyh on 16/8/16.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "SWKConsultOnlineViewController.h"
#import "LoginViewController.h"

@implementation SWKConsultOnlineViewController

#pragma mark ------ init - dealloc

- (void)viewDidLoad {
    //浏览器窗口
    if (!self.URL) {
        self.URL = [[NSURL alloc] withOutNilString:H5APIURL];
    }
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor DDNormalBackGround];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"在线咨询";
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //清除UIWebView的缓存
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    //显示tabbar
    [[self rdv_tabBarController] setTabBarHidden:FALSE animated:YES];
}


#pragma mark ------ private Method


- (void)login
{
    [self.wkWebView webStopLoading];
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) goPreV_C
{
    if (self.isIMAcess) {
        [[self rdv_tabBarController] setTabBarHidden:FALSE animated:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------ Base Publick

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    // 支持 打电话
    if ([navigationAction.request.URL.scheme isEqualToString:@"tel"]) {

        if ([[UIApplication sharedApplication] canOpenURL:navigationAction.request.URL]) {

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",navigationAction.request.URL.resourceSpecifier]]];

        }
        
    }

    // 说明协议头是ios
    if ([@"ios" isEqualToString:navigationAction.request.URL.scheme]) {
        NSString *url = navigationAction.request.URL.absoluteString;
        NSRange range = [url rangeOfString:@":"];
        NSString *method = [navigationAction.request.URL.absoluteString substringFromIndex:range.location + 1];
        //method = [method stringByAppendingString:@":"];
        NSLog(@"%@",method);
        range = [method rangeOfString:@":"];

        if (range.length > 0) {
            NSString * methodTemp = [method substringToIndex:range.location];
            methodTemp = [methodTemp stringByAppendingString:@":"];
            NSLog(@"%@",methodTemp);

            NSString * argument = [method substringFromIndex:range.location + 1];
            NSArray * tmpArgunment = [HNBUtils getAllParameterForJS:argument];
            NSLog(@"%@",tmpArgunment);

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

        decisionHandler(WKNavigationActionPolicyCancel);
    }

    decisionHandler(WKNavigationActionPolicyAllow);

}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self baseToolMethodWithWebDidFinishLoad:webView navigation:navigation];
}


@end
