//
//  WKWebVC.m
//  JSNativeDemo1
//
//  Created by hnbwyh on 2017/9/22.
//  Copyright © 2017年 hainbwyh. All rights reserved.
//

#import "WKWebVC.h"
#import <WebKit/WebKit.h>

@interface WKWebVC () <WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *wkweb;

@property (nonatomic,strong) UIView *nativeHolder;

@end

@implementation WKWebVC

#pragma mark ------------ life

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showUI];
    
}

- (void)showUI{
    [self.wkweb loadRequest:self.req];
    self.nativeHolder = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 CGRectGetMaxY(self.wkweb.frame),
                                                                 self.view.bounds.size.width,
                                                                 self.view.bounds.size.height/2.0)];
    [self.view addSubview:self.nativeHolder];
    
    
    CGRect rect = CGRectZero;
    rect.size = CGSizeMake(200, 30);
    rect.origin = CGPointMake((self.view.bounds.size.width - rect.size.width) / 2.0,
                              15);
    UIButton *btn1 = [self createButtonWithTitle:@"Native 调起 JS 方法" rect:rect];
    [btn1 addTarget:self action:@selector(clickBtn1:) forControlEvents:UIControlEventTouchUpInside];
    [self.nativeHolder addSubview:btn1];
    
    
    self.wkweb.backgroundColor = [UIColor redColor];
    self.nativeHolder.backgroundColor = [UIColor greenColor];
}

- (UIButton *)createButtonWithTitle:(NSString *)title rect:(CGRect)rect{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setFrame:rect];
    btn.layer.cornerRadius = rect.size.height / 2.0;
    btn.backgroundColor = [UIColor blackColor];
    return btn;
}



#pragma mark ------------ WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@" \n \n %s \n \n",__func__);
    decisionHandler(WKNavigationActionPolicyAllow);
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@" \n \n %s \n \n",__func__);
    decisionHandler(WKNavigationResponsePolicyAllow);
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@" \n \n %s \n \n",__func__);
}


- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@" \n \n %s \n \n",__func__);
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@" \n \n %s \n \n",__func__);
}


- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@" \n \n %s \n \n",__func__);
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@" \n \n %s \n \n",__func__);
}




#pragma mark ------------ WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert - 展示 JS 函数"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    
}



#pragma mark ------------
#pragma mark ------------

#pragma mark ------------ private method


- (void)clickBtn1:(UIButton *)btn{
    NSString *js = @"alerShow()";
    [self.wkweb evaluateJavaScript:js completionHandler:^(id _Nullable info, NSError * _Nullable error) {
        NSLog(@" \n \n info :%@ \n \n",info);
    }];
}


#pragma mark ------------ 懒加载


-(WKWebView *)wkweb{
    if (!_wkweb) {
        CGRect rect = self.view.bounds;
        rect.size.height /= 2.0;
        _wkweb = [[WKWebView alloc] initWithFrame:rect];
        _wkweb.backgroundColor = [UIColor greenColor];
        _wkweb.navigationDelegate = self;
        _wkweb.UIDelegate = self;
        [self.view addSubview:_wkweb];
    }
    return _wkweb;
}

@end
