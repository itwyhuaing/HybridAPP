# HybridAPP
记录：native 与 js间交互相关问题。

###### 问 1 ：

* JS 与 OC 间的交互问题 :
> 1. JS 点击事件调用 OC 方法
 2. URL 加载调用 OC 方法
 3. OC 调用 JS 方法
 4. OC 管控 URL 的加载情况
 5. OC 向 JS 中注入变量
 6. OC 读取 JS 中的变量

###### 答 1 ：

 * 1.交互方式比较单调。
 * 2.JS 调用 OC ：
  > 方式一：拦截并解析 URL 。 适用于 UIWebView 与 WKwebView ;但参数与 URL 解析比较繁琐且易出错。
  方式二：JavaScriptCore - JSContext 。ios7 时推出的 框架，但 iOS8 时推出的 WKwebView 控件完全可以以更加简便方式实现 。
方式三： MessageHandler 。适用于 WKwebView 。
方式四：WebViewJavascriptBridge 。适用于 WKwebView 与 UIWebView 。


 * 3.OC 调用 JS :
 > 方式一： evaluateJavaScript 。适用于  WKwebView 。

 > 方式二：stringByEvaluatingJavaScriptFromString 。适用于 UIWebView 。

 > 方式三：JavaScriptCore - JSContext 。适用于 WKwebView 与 UIWebView 。

 > 方式四：WebViewJavascriptBridge 。适用于 WKwebView 与 UIWebView 。



###### 现在的问题是：

1. 页面的前进与后退

    1.1 前进

    1.2 后退

2. Web 页与 Native 页间相互跳转

  2.1 原生 --- > Web

  2.2 Web --- > 原生

###### URL 截断跳转问题：

解析 URL ,依据 规则跳转到对应的 Native 控制器 。
规则初步拟定：
1. 域名区分站内与站外
2. 协议头 域名 端口 文件路径 参数

   https://域名:端口/文件路径?参数
   https://域名:端口/文件路径/?参数

   https://域名:端口/文件路径.html
   https://域名:端口/文件路径
   https://域名:端口/文件路径/


   https://m.hinabian.com/visa/index.html
   https      m.hinabian.com       /visa/index.html

   https://m.hinabian.com/visa/countryList.html?country_id=43
   https     m.hinabian.com        /visa/countryList.html      country_id=43

   https://m.hinabian.com/native/visa/detail/?project_id=15002067
   https    m.hinabian.com         /native/visa/detail         project_id=15002067


3. 可自定义部分为 文件路径

    文件路径 ： 标记跳转的功能块


4. 功能对应关系

    帖子详情 ----- jumpTribeThemDetail
    问答详情 ----- jumpQaDetail
    问答搜索 ----- jumpQaSearch
    问答提问 ----- jumpQaPickUpQuestion
    移民评估 ----- jumpImaseess
