//
//  HNBWebManager.h
//  hinabian
//
//  Created by hnbwyh on 2017/12/15.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

/**
 * 测试使用
 * 集中处理跳转问题 及 与web加载相关的处理方法
 */
typedef enum : NSUInteger {
    WebConfigIndictorDefault = 2000,
    WebConfigIndictorConsult,
    WebConfigIndictorNotConsultOnlyTel,
    WebConfigIndictorNavOnlyTitle,
    WebConfigIndictorWebFullNotConsult,
    WebConfigIndictorWebFullConsult,
    WebConfigIndictorC,
    WebConfigIndictorD,
    WebConfigIndictorBackRefresh,
    WebConfigIndictorNotConsultNotShare,
    WebConfigIndictorConsultNotShare,
} WebConfigIndictor;

//typedef enum : NSUInteger {
//    ConfigURLStringForNativeDefault = 3000,
//    ConfigURLStringForNativeDefaultConsult,             // 默认基础之上 + 咨询按钮
//    ConfigURLStringForNativeDefaultNotRefresh,          // 默认基础之上 - 返回刷新
//    ConfigURLStringForNativeWebFull,                    // web 全屏
//    ConfigURLStringForNativeWebFullConsult,             // web 全屏 + 咨询按钮
//    ConfigURLStringForNativeNavRightOnlyTel,            // 导航栏右侧只有电话
//    ConfigURLStringForNativeNavOnlyTitle,               // 导航栏只有标题
//} ConfigURLStringForNative;


#import <Foundation/Foundation.h>
@class SWKCommonWebVC;

@interface HNBWebManager : NSObject

/**
 * HNBWebManager 单例
 */
+ (instancetype)defaultInstance;

/**
 * 判断是否属于站内 url
 */
- (BOOL)isHinabianSiteWithURLString:(NSString *)URLString;

/**
 * 判断链接是否属于帖子详情
 */
- (BOOL)isHinabianThemeDetailWithURLString:(NSString *)URLString;

/**
 * 判断链接是否属于 xxx.hinabian.com 样式
 */
- (BOOL)isHinabianComWithURLString:(NSString *)URLString;

/**
 * 判断当前加载的URL是否需要 push 跳转
 */
- (BOOL)shouldPushNativeCtrlFromCurCtrlUTLString:(NSString *)urlstring url:(NSURL *)url;

/**
 * 是否在本页面内加载 web , 默认 FALSE
 * 可用于解决重定向问题修复
 */
- (BOOL)isInsideThePageWithURLString:(NSString *)URLString;

/**
 * 咨询跳转海房 / 移民 , 0-移民、1-海房
 * default - FALSE
 */
- (BOOL)isOverseasHouseConsultWithURLString:(NSString *)URLString;

/**
 * 是否准许拦截处理当前 url
 * 0 : 不准许
 * 1 : (准许) 默认值，交由移动端自己判断是否拦截处理
 */
- (BOOL)isInterceptWithURLString:(NSString *)URLString;

/**
 * 依据 url 规则处理跳转相关业务
 */
- (BOOL)decideToHandleBusinessWithURL:(NSString *)httpsurl
                                  nav:(UINavigationController *)nav;

- (void)jumpHandleWithURL:(NSString *)httpsurl nav:(UINavigationController *)nav jumpIntoAPP:(BOOL)isJump;


/**
 * native - > web
 * 配置参数需要手动添加
 */
// 默认样式
- (NSURL *)configDefaultNativeNavWithURLString:(NSString *)string;
// 自定义样式
- (NSURL *)configNativeNavWithURLString:(NSString *)string
                                   ctle:(NSString *)ctle
                             csharedBtn:(NSString *)cs
                                   ctel:(NSString *)ct
                              cfconsult:(NSString *)cf;
// web全屏 - 自定义样式
- (NSURL *)configWebNavWithURLString:(NSString *)string cfconsult:(NSString *)cf;

/**
 * 依据 url 解析配置参数
 */
- (NSDictionary *)parserConfigDataURLString:(NSString *)URLString;

/**
 * 处理 非 xxx.hinabian.com 链接
 */
- (void)directLoadWebWithURLString:(NSString *)URLString nav:(UINavigationController *)dnav;


/**
 * 测试
 */
@property (nonatomic,assign) WebConfigIndictor configIndictor;

@end
