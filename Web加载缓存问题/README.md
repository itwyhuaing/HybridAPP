####### Web加载缓存问题

1. html 、js、css 三种文件加载的机制

原理 ：
现象：

1. HTTP 1.1 响应头 中参数 cache-control no-cache / max-age=3600


结论：
cache-control 设置为 no-cache 属性，第一次请求返回码 200 ，之后多次请求 304 ，页面修改之后的再次请求 200

cache-control 设置为 max-age=xx 属性，第一次请求返回码 200 ，之后多次请求 - 若请求发生在时间内则不会发出请求，若请求发生在时间之外则会重新发出请求

cache-control 无论设置怎样， 清楚缓存 ( WKWebsiteDataStore ) 之后，请求返回 200 








##### 参考

* [HTTP缓存控制小结](http://imweb.io/topic/5795dcb6fb312541492eda8c)
