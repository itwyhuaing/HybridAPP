//
//  SWKBaseViewController.h
//  hinabian
//
//  Created by hnbwyh on 16/8/16.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

/**
 * 设置一级父类 - 便于后期拓展新功能
 */

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "HNBWKWebView.h"
#import "AppointmentButton.h"
#import "HNBWebManager.h"

@interface SWKBaseViewController : UIViewController <WKNavigationDelegate,WKUIDelegate,AppointmentButtonDelegate,UIGestureRecognizerDelegate,WKScriptMessageHandler>

/**
 * 可配置参数问题
 */

/**
 * 是否原生导航栏 - default : TRUE
 */
@property (nonatomic,assign) BOOL isNativeNavBar;

/**
 * 原生导航栏是否显示返回按钮  - default : TRUE  - 预留参数
 */
@property (nonatomic,assign) BOOL isNativeNavShowBackBtn;

/**
 * 原生导航栏是否显示标题 - default : TRUE
 */
@property (nonatomic,assign) BOOL isNativeNavShowTitle;

/**
 * 原生导航栏是否显示分享按钮 - default : TRUE
 */
@property (nonatomic,assign) BOOL isNativeNavRightOnlyShowSharedBtn;

/**
 * 原生导航栏是否显示电话按钮 - default : FALSE
 */
@property (nonatomic,assign) BOOL isNativeNavRightOnlyShowTelBtn; 

/**
 * 原生导航栏是否显示电话按钮 - default : FALSE
 */
@property (nonatomic,assign) BOOL isNativeNavRightShowTelBtnAndSharedBtn;

/**
 * 是否显示咨询按钮 - default : FALSE
 */
@property (nonatomic,assign) BOOL isNativeNavShowConsultBtn;

/**
 * 返回后页面重新展示是否需要 reload - default : TRUE - 预留参数
 */
@property (nonatomic,assign) BOOL canRefreshWhenBack;

/**
 * 是否跳原生 - default : TRUE - 预留参数
 */
@property (nonatomic,assign) BOOL shouldJumpNative;

/**
 * 关于 url 的记录
 */
@property (nonatomic, strong) NSURL *URL;

/**
 * 分享相关参数
 */
@property (nonatomic, copy) NSString * shareURL;
@property (nonatomic, copy) NSString * shareTitle;
@property (nonatomic, copy) NSString * shareFriendTitle;
@property (nonatomic, copy) NSString * shareDesc;
@property (nonatomic, copy) NSString * shareImageUrl;
@property (nonatomic,assign) BOOL sharedDataIsOK; // 分享相关的参数是否全部准备完毕


/**
 * 手动设置返回时展示页面是否需要手动刷新
 * default - FALSE
 */
@property (nonatomic,assign) BOOL manualRefreshWhenBack;

/**
 * 手动设置:URL加载时是否进行跳转 - 咨询 web 等情况处理 
 * default - TRUE
 */
@property (nonatomic,assign) BOOL manualPushWhenLoading;

/**
 * 是否第一次加载 URL : 即 alloc vc 之后的第一次加载
 * default - TRUE
 */
@property (nonatomic,assign) BOOL isFirstLoadURL;

/**
 * 是否不必拦截,直接允许加载 web
 * default - FALSE
 */
@property (nonatomic,assign) BOOL isDirectAllow;

/**
 * 咨询跳转海房 / 移民 , 0-移民、1-海房
 * default - FALSE
 */
@property (nonatomic,assign) BOOL isOverseasHouseConsult;

/**
 * title 参数 - 当前页面的标题
 */
@property (nonatomic, copy) NSString *webTitle;

@property (nonatomic,strong) AppointmentButton *appointButton;

/**
 * 电话参数 - 电话号码
 */
@property (nonatomic, copy) NSString *telNumb;

/**
 * 设置电话按钮 - 分享按钮
 * 分享按钮在电话按钮右侧
 */
- (void)modifyNativeTelBtnAndSharedBtn;

/**
 * 返回 goPreV_C
 */
- (void)goPreV_C;

/**
 * 分享 shareContent
 */
-(void) shareContent;



/**
 * 无需适配UIWebView
 */
@property (nonatomic, strong) HNBWKWebView *wkWebView;

@property (nonatomic, strong) HNBWebManager *webManger;


/**
 *  WKNavigationDelegate - decidePolicyForNavigationAction
 */
-(WKNavigationActionPolicy)baseToolMethodWithWKWeb:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;

/**
 * start
 */
- (void)baseToolMethodWithWebDidStartLoad:(id)webView navigation:(WKNavigation *)navigation;

/**
 * finish
 */
- (void)baseToolMethodWithWebDidFinishLoad:(id)webView navigation:(WKNavigation *)navigation;

/**
 * fail
 */
- (void)baseToolMethodWithWKWeb:(id)webView didFailWithError:(NSError *)error;


@end
