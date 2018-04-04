//
//  HNBWKWebView.h
//  hinabian
//
//  Created by 何松泽 on 2017/12/7.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

/**
 个性化定制项目所需 WKWebview 
 */


#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"


typedef void(^JavaScriptHandleComplete)(NSString *resultString);

@interface HNBWKWebView : WKWebView

/**
 * default is YES. if set to NO, user events (touch, keys) are ignored and removed from the event queue.
 */
@property (nonatomic) BOOL webUserInteractionEnabled;

/**
 * wk 进度条
 */
@property (nonatomic,strong) UIProgressView *progressView;


@property (nonatomic,strong) NJKWebViewProgress * uiWebprogressProxy;
@property (nonatomic,strong) NJKWebViewProgressView * uiWebprogressView;


/**
 * 记录当前 URL
 */
@property (nonatomic,strong) NSURL *currentUrl;

/**
 *  标记 webGoBack 状态，不准许跳转 : web 在 goBack 状态下不准许 alloc
 */
@property (nonatomic) BOOL isWebGoingBack;

/**
 * 创建 wkweb
 * rect
 * delegate
 * superV
 */
-(instancetype)initWithFrame:(CGRect)frame delegate:(id<WKNavigationDelegate>)delegate superView:(UIView *)superV req:(NSURLRequest *)req config:(WKWebViewConfiguration *)config;

/**
 * web addView
 */
- (void)addView:(UIView *)subview;

/**
 * setWebFrame
 */
-(void)setWebFrame:(CGRect)webFrame;

/**
 * web stopLoading
 */
- (void)webStopLoading;

/**
 * web canGoBack
 */
- (BOOL)webCanGoBack;
/**
 * web goBack
 */
- (void)webGoBack;

/**
 * web loadRequest
 */
- (void)webLoadRequest:(NSURLRequest *)req;

/**
 * evaluatingJavaScriptFromString
 */
- (void)evaluateJavaScriptFromString:(NSString *)keyString hanleComplete:(JavaScriptHandleComplete)result;

- (void)webReload;

- (void)loadHTMLString:(NSString *)string;

@end

