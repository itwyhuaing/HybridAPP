# HybridAPP
记录：native 与 js间交互相关问题。

###### 问 1 ：

* JS 与 native 间的交互问题 :
> 1. JS 点击事件调用 native 方法
 2. URL 加载调用 native 方法
 3. native 调用 JS 方法
 4. native 管控 URL 的加载情况
 5. native 向 JS 中注入变量
 6. native 读取 JS 中的变量

###### 答 1 ：

* 1.native 调起 JS 方法或 注入变量比较固定，只需听过 webkit 提供的 API 传递相应的 JS 语句执行即可。

* 2.JS 调用 native ：

> 1.拦截并解析 URL 。 适用于 UIWebView 与 WKwebView ;但参数与 URL 解析比较繁琐且易出错。

> 2.JavaScriptCore - JSContext 。ios7 时推出的 框架，但 iOS8 时推出的 WKwebView 控件完全可以以更加简便方式实现 。

> 3.MessageHandler 。适用于 WKwebView 。

> 4.WebViewJavascriptBridge 。适用于 WKwebView 与 UIWebView 。


 * 3.native 调用 JS :

> 1.evaluateJavaScript 。适用于  WKwebView 。

> 2.stringByEvaluatingJavaScriptFromString 。适用于 UIWebView 。

> 3.JavaScriptCore - JSContext 。适用于 WKwebView 与 UIWebView 。

>4.WebViewJavascriptBridge 。适用于 WKwebView 与 UIWebView 。



###### URL 截断跳转问题：

解析 URL ,依据规则跳转到对应的 Native 控制器 。

规则初步拟定：
* 1.域名区分站内与站外

* 2.协议头 | 域名 | 端口  | 文件路径  | 参数

* 3.可用于区分跳转的自定义部分为 文件路径

    > 文件路径 ： 标记跳转的功能块


* 4.功能对应关系

    * 帖子详情 ----- jumpTribeThemDetail
    > https://m.hnb.com/tribe/jumpTribeThemDetail?them_id=43

    * 问答详情 ----- jumpQaDetail
    > https://m.hnb.com/qa/jumpQaDetail?qa_id=43

    * 问答搜索 ----- jumpQaSearch
    > https://m.hnb.com/qa/jumpTribeThemDetail?qa_des=english

    * 移民评估 ----- jumpImaseess
    > https://m.hnb.com/assess/jumpImaseess.html

* 5.方案

> 采用 URL 截取的方式实现跳转时，对于关键词的提取为便于迭代开发中 URL 地址的更换或修改，以及 应用发布后增强后台控制能力。链接可以采用 ：功能块关键词 + 跳转关键词 + 末尾是否跳转参数 。

###### 项目中遇到的问题：

1. 页面的前进与后退

    1.1 前进 (push 或 load)

    1.2 后退 (pop 或 goBack)

2. Web 页与 Native 页间相互跳转

  2.1 原生 --- > Web

  2.2 Web --- > 原生

  2.3 即便是 Web 页也是需要原生容器承载

3. 项目中现存的跳转设计

  * 1.URL 截取 ，只处理 “iOSjump：方法名” 方式实现跳转
  * 2.URL 截取 关键字段跳转


4. 场景描述：

> 当控制器堆栈中已存在很多页面(控制器 --- 多个Web可能存在于同一个控制器)时，点击当前 Web 页面中的某一处，可以路由到相应的功能模块。

> 综上，在跳转的路由可以采用截取 URL 提取关键词方式及必要时采用点击事件调起的方式设计。

##### WKWebView

###### WKNavigationDelegate

```
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
```
> 在发送请求之前，决定是否跳转


```
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler;
```
> 在收到响应后，决定是否跳转，该方法与 decidePolicyForNavigationAction（发送请求之前是否允许跳转） 配套使用


```
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
```
> 页面开始加载时调用


```
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
```
> 接收到服务器跳转请求之后调用


```
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation;
```
> 当内容开始返回时调用


```
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;
```
> 页面加载完成之后调用


```
/**
@abstract Invoked when an error occurs while starting to load data for the main frame.
*/
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;
```
> 当开始为主框架加载数据是发生错误时调用  --- 自己翻译


```
/**
  @abstract Invoked when an error occurs during a committed main frame navigation.
*/
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;
```
> 在渲染数据到主框架上时发生错误时调用  --- 自己翻译


```
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler;
```
> 身份验证

```
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0));
```
> WKWebView 加载操作终止时调用



###### WKUIDelegate

```
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures;
```
> 创建一个新的WebView


```
- (void)webViewDidClose:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0));
```
> W

```
/**
*  @param webView           实现该代理的webview
*  @param message           警告框中的内容
*  @param frame             主窗口
*  @param completionHandler 警告框消失调用
*/
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler;
```
> web界面中有弹出警告框时调用


```
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler;
```
> W

```
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler;
```
> W

```
- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo API_AVAILABLE(ios(10.0));
```
> W

```
- (nullable UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions API_AVAILABLE(ios(10.0));
```
> W


```
- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController API_AVAILABLE(ios(10.0));
```
> W

###### WKScriptMessageHandler

```
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;
```
> 该方法是 WKScriptMessageHandler 协议中必须实现的方法，提高App与web端交互的关键，它可以直接将接收到的JS脚本转为OC或Swift对象。



##### 参考

* [WKWeb​View - Swift 版本](http://nshipster.cn/wkwebkit/)
* [Java​Script​Core - Swift 版本](http://nshipster.cn/javascriptcore/)
* [WKWebView简单使用及关于缓存的问题](http://www.cnblogs.com/allencelee/p/6709599.html)
* [iOS9 WKWebView 缓存清除API](http://www.jianshu.com/p/186a3b236bc9)
* [iOS 下 JS 与原生 native 互相调用 --- 系列文章](http://www.jianshu.com/p/d19689e0ed83)
* [HTML meta viewport属性说明 --- H5页面适配到移动端窗口](http://www.cnblogs.com/pigtail/archive/2013/03/15/2961631.html)
* [iOS下Html页面中input获取焦点弹出键盘时挡住input解决方案—scrollIntoView()](http://www.cnblogs.com/wx1993/p/6059668.html)
* [WKWebView刷新机制小探](https://www.jianshu.com/p/1d739e2e7ed2)
> 项目中遇到的很多问题多半是因为见得太少，思考的太少。总结过程中，无意间发现早有大牛对该部分内容作了详细总结；贴上地址，方便今后查找。
