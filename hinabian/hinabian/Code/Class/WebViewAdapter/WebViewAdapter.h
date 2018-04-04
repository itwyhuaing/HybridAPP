//
//  WebViewAdapter.h
//  hinabian
//
//  Created by hnbwyh on 16/8/16.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import <WebKit/WebKit.h>

typedef void(^JavaScriptHandleComplete)(NSString *resultString);

@interface WebViewAdapter : NSObject

@property (nonatomic) BOOL webUserInteractionEnabled;

@property (nonatomic) CGRect webFrame;

@property (nonatomic,strong) UIProgressView *progressView;

@property (nonatomic,strong) NJKWebViewProgress * uiWebprogressProxy;

@property (nonatomic,strong) NJKWebViewProgressView * uiWebprogressView;

@property (nonatomic,strong) NSURL *currentUrl;

// 标记 webGoBack 状态，不准许跳转 : web 在 goBack 状态下不准许 alloc 
@property (nonatomic) BOOL isWebGoingBack;

/**
 * 判断 iOS version
 */

//- (CGFloat)judgeIOSSystemVersionForCurrentDevice;

/**
 * 创建 web
 * rect
 * delegate
 * superV
 */
- (void)loadWebWithFrame:(CGRect)frame delegate:(id)delegate superView:(UIView *)superV req:(NSURLRequest *)req;


/** 针对项目详情等页面创建
 * 创建 wkweb
 * rect
 * delegate
 * superV
 */
-(WKWebView *)loadWKWebWithFrame:(CGRect)frame delegate:(id<WKNavigationDelegate>)delegate superView:(UIView *)superV req:(NSURLRequest *)req config:(WKWebViewConfiguration *)config;


- (void)loadHTMLString:(NSString *)string;
/**
 * web canGoBack
 */
- (BOOL)webCanGoBack;

/**
 * web goBack
 */
- (void)webGoBack;

/**
 * evaluatingJavaScriptFromString
 */

-(void)evaluateJavaScriptFromString:(NSString *)keyString hanleComplete:(JavaScriptHandleComplete)result;

/**
 * web reload
 */
- (void)webReload;
/**
 * web loadRequest
 */

- (void)webLoadRequest:(NSURLRequest *)req;

/**
 * web stopLoading
 */
- (void)webStopLoading;

/**
 * web addGesture
 */

- (void)addGesture:(UIGestureRecognizer *)gesture;

/**
 * web addView
 */

- (void)addView:(UIView *)subview;

/**
 * web scrollView
 */

- (UIScrollView *)webScrollView;


@end
