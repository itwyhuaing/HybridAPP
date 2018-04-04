//
//  WebViewAdapter.m
//  hinabian
//
//  Created by hnbwyh on 16/8/16.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "WebViewAdapter.h"

#import "DataFetcher.h"
#import "TFHpple.h"

@interface WebViewAdapter ()

@property (nonatomic,strong) UIWebView *uiweb;
@property (nonatomic,strong) WKWebView *wkweb;

@end

@implementation WebViewAdapter

#pragma mark ------ private Method

-(CGFloat)judgeIOSSystemVersionForCurrentDevice{

    NSString *tmpString = [UIDevice currentDevice].systemVersion;
    return [tmpString floatValue];
    
}

#pragma mark ------ publick Method

- (void)webGoBack{

    _isWebGoingBack = TRUE;
    
    if ([self judgeIOSSystemVersionForCurrentDevice] < 8.0) {
        
        [self.uiweb goBack];
        
    } else {

        [self.wkweb goBack];
        if([[self.wkweb.URL absoluteString] isEqualToString:@"about:blank"])
        {
            [self loadHTMLString:[_currentUrl absoluteString]];
        }
        
    }
    
}

- (BOOL)webCanGoBack{

    if ([self judgeIOSSystemVersionForCurrentDevice] < 8.0) {
        
        if ([self.uiweb canGoBack]) {
            
            return YES;
            
        } else {
            
            return NO;
            
        }
        
    } else {
        
        if ([self.wkweb canGoBack]) {
            
            return YES;
            
        } else {
//            if(![[self.wkweb.URL absoluteString] isEqualToString:[_currentUrl absoluteString]] && ![[self.wkweb.URL absoluteString] isEqualToString:@"https://m.hinabian.com/"])
//            {
//                return YES;
//            }
            return NO;
            
        }
        
    }
    
}

-(void)evaluateJavaScriptFromString:(NSString *)keyString hanleComplete:(JavaScriptHandleComplete)result{

    //nslog(@" %s ",__FUNCTION__);
    __block NSString *resultString;
    
    if ([self judgeIOSSystemVersionForCurrentDevice] < 8.0) {
        
        resultString = [self.uiweb stringByEvaluatingJavaScriptFromString:keyString];
        if (result) {
            result(resultString);
        }
        
        
    } else {
        
        [self.wkweb evaluateJavaScript:keyString completionHandler:^(id _Nullable message, NSError * _Nullable error) {
            
           resultString = [NSString stringWithFormat:@"%@",message];
            if (result) {
                result(resultString);
            }
            
        }];
        
    }
}

- (void)webReload{

    if ([self judgeIOSSystemVersionForCurrentDevice] < 8.0) {
        if([_uiweb.request.URL absoluteString] && ![[_uiweb.request.URL absoluteString] isEqualToString:@""])
        {
            if(![self isThisUrlCache:[_currentUrl absoluteString]])
            {
                [self.uiweb reload];
            }
            else
            {
                [self loadHTMLString:[_currentUrl absoluteString]];
            }
            
        }

        //[self.uiweb reload];
        
    } else {
        if(![self isThisUrlCache:[_currentUrl absoluteString]])
        {
            [self.wkweb reload];
        }
        else
        {
            if([_wkweb.URL absoluteString] && ![[_wkweb.URL absoluteString] isEqualToString:@""])
            {
                [self loadHTMLString:[_currentUrl absoluteString]];
            }
        }

        //[self.wkweb reload];
        
    }
    
}


- (void)webLoadRequest:(NSURLRequest *)req{

    //  web 请求全部使用 https 
//    NSString *urlstring = req.URL.absoluteString;
//    if ([urlstring hasPrefix:@"http:"] && ![urlstring hasPrefix:@"https:"]) {
//       urlstring = [urlstring stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
//       req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstring]];
//    }
    
    if ([self judgeIOSSystemVersionForCurrentDevice] < 8.0) {
        
        [self.uiweb loadRequest:req];
        
    } else {
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[req URL] absoluteString]]];
        NSString *cookie = [self readCurrentCookie];
        [request addValue:cookie forHTTPHeaderField:@"Cookie"];
        [self.wkweb loadRequest:request];
        
    }
    
}

-(NSString *)readCurrentCookie{
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: cookiesData];
    NSMutableString *cookieString = [[NSMutableString alloc] init];
    for (NSHTTPCookie*cookie in cookies) {
        [cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
    }
    return cookieString;
}

- (void)webStopLoading{

    if ([self judgeIOSSystemVersionForCurrentDevice] < 8.0) {
        
        [self.uiweb stopLoading];
        
    } else {
        
        [self.wkweb stopLoading];
        
    }
    
}

-(void)addGesture:(UIGestureRecognizer *)gesture{

    if ([self judgeIOSSystemVersionForCurrentDevice] < 8.0) {
        
        [self.uiweb addGestureRecognizer:gesture];
        
    } else {
        
        [self.wkweb addGestureRecognizer:gesture];
        
    }
    
}

-(void)addView:(UIView *)subview{

    if ([self judgeIOSSystemVersionForCurrentDevice] < 8.0) {
        
        [self.uiweb addSubview:subview];
        
    } else {
        
        [self.wkweb addSubview:subview];
        
    }
    
}

- (UIScrollView *)webScrollView{

    if ([self judgeIOSSystemVersionForCurrentDevice] < 8.0) {
        
        return self.uiweb.scrollView;
        
    } else {
        
        return self.wkweb.scrollView;
        
    }
    
}

#pragma mark ------ setter

-(void)setWebUserInteractionEnabled:(BOOL)webUserInteractionEnabled{

    if ([self judgeIOSSystemVersionForCurrentDevice] < 8.0) {
        
        self.uiweb.userInteractionEnabled = webUserInteractionEnabled;
        
    } else {
        
        self.wkweb.userInteractionEnabled = webUserInteractionEnabled;
        
    }
    
}

-(void)setWebFrame:(CGRect)webFrame{

    if ([self judgeIOSSystemVersionForCurrentDevice] < 8.0) {
        
        [self.uiweb setFrame:webFrame];
        
    } else {
        
        [self.wkweb setFrame:webFrame];
        
    }
    
}

#pragma mark ------ load

-(void)loadWebWithFrame:(CGRect)frame delegate:(id)delegate superView:(UIView *)superV req:(NSURLRequest *)req{

    if ([self judgeIOSSystemVersionForCurrentDevice] < 8.0) {
        
        [self loadUIWebWithFrame:frame delegate:delegate superView:superV req:req];
        
    } else {
        
        [self loadWKWebWithFrame:frame delegate:delegate superView:superV req:req];
        
    }
    
}

- (WKWebView *)loadWKWebWithFrame:(CGRect)frame delegate:(id<WKNavigationDelegate,WKUIDelegate>)delegate superView:(UIView *)superV req:(NSURLRequest *)req config:(WKWebViewConfiguration *)config{
    
    /* 增加进度条 */
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    progressView.tintColor = [UIColor DDNavBarBlue];
    progressView.trackTintColor = [UIColor clearColor];
    [progressView setProgress:0 animated:NO];
    
    self.progressView = progressView;
    
    _wkweb = nil;
    _wkweb = [[WKWebView alloc] initWithFrame:frame configuration:config];
    _wkweb.navigationDelegate = delegate;
    _wkweb.UIDelegate = delegate;
    _wkweb.backgroundColor = [UIColor clearColor];
    _wkweb.scrollView.bounces = false;
    [_wkweb addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [superV addSubview:_wkweb];
    [superV addSubview:progressView];
    [self webLoadRequest:req];
    _currentUrl = req.URL;
    if(req)
    {
        [self loadHTMLString:[req.URL absoluteString]];
    }
    return _wkweb;
    
}


-(void)loadUIWebWithFrame:(CGRect)frame delegate:(id<UIWebViewDelegate>)delegate superView:(UIView *)superV req:(NSURLRequest *)req{
    
    _uiweb = nil;
    _uiweb = [[UIWebView alloc] initWithFrame:frame];
    _uiWebprogressProxy = [[NJKWebViewProgress alloc] init];
    _uiweb.delegate = _uiWebprogressProxy;
    _uiWebprogressProxy.webViewProxyDelegate = (id)delegate;
    _uiWebprogressProxy.progressDelegate = (id)delegate;
    _uiweb.backgroundColor = [UIColor clearColor];
    
    CGFloat progressBarHeight = 2.f;
    CGRect barFrame = CGRectMake(0, 0, SCREEN_WIDTH, progressBarHeight);
    _uiWebprogressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _uiWebprogressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_uiweb addSubview:_uiWebprogressView];
    
    [superV addSubview:_uiweb];
    [self webLoadRequest:req];
    
}

- (BOOL) isThisUrlCache:(NSString *)url
{
    /* 全部关闭缓存
     if ([url rangeOfString:@"hinabian.com"].location == NSNotFound) {
     return FALSE;
     }
     else
     {
     if ([url rangeOfString:@"about/advantage"].location != NSNotFound ||
     [url rangeOfString:@"national.html"].location != NSNotFound ||
     [url rangeOfString:@"national/detail"].location != NSNotFound ||
     [url rangeOfString:@"project/type"].location != NSNotFound ||
     [url rangeOfString:@"estate.html"].location != NSNotFound ||
     [url rangeOfString:@"visa/index"].location != NSNotFound
     ) {
     return TRUE;
     }
     }
     return FALSE;
     */
    
    return FALSE;
}

- (void)loadHTMLString:(NSString *)string
{
    // qa_question/specialSubject      qa_question/detail
    if(![self isThisUrlCache:string])
    {
        [self webLoadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
        return;
    }
    if ([self judgeIOSSystemVersionForCurrentDevice] < 8.0) {
        /* 判断是否有文件 */
        NSURL *baseURL = [NSURL URLWithString:string];
        if ([HYFileManager isExistsAtPath:[NSString stringWithFormat:@"%@/%@",[HYFileManager cachesDir],[HNBUtils md5HexDigest:string]]]) {
            /* 判断Md5是否相同 */
            NSString * Md5 = [HNBUtils sandBoxGetInfo:[NSString class] forKey:[HNBUtils md5HexDigest:string]];
            [DataFetcher doGetPageHTML:string MD5:Md5 withSucceedHandler:^(id JSON) {
                NSData *tmpData = JSON;
                NSString * tmpString = [[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding];
                if ([tmpString isEqualToString:@""]) {
                    NSString *filePath  = [NSString stringWithFormat:@"%@/%@", [HYFileManager cachesDir],[HNBUtils md5HexDigest:string]];
                    NSString *htmlstring= [[NSString alloc] initWithContentsOfFile:filePath  encoding:NSUTF8StringEncoding error:nil];
                    
                    [_wkweb loadHTMLString:[self loadCacheImageForHtml:htmlstring] baseURL:baseURL];
                }
                else
                {
                    NSString *tmpMd5 = [HNBUtils md5HexDigest:tmpString];
                    [_uiweb loadHTMLString:tmpString baseURL:baseURL];
                    [HNBUtils removeFile:Md5];
                    [HNBUtils writeToFile:tmpString filename:[HNBUtils md5HexDigest:string]];
                    //保存md5值
                    [HNBUtils sandBoxSaveInfo:tmpMd5 forKey:[HNBUtils md5HexDigest:string]];
                }
            } withFailHandler:^(id error) {
                
            }];
            
        }
        else
        {
            [DataFetcher doGetPageHTML:string MD5:@"" withSucceedHandler:^(id JSON) {
                NSData *tmpData = JSON;
                NSString * tmpString = [[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding];
                if (JSON != NULL && ![tmpString isEqualToString:@""]) {
                    NSString *tmpMd5 = [HNBUtils md5HexDigest:tmpString];
                    NSURL *baseURL = [NSURL URLWithString:string];
                    [_uiweb loadHTMLString:[self loadCacheImageForHtml:tmpString] baseURL:baseURL];
                    [HNBUtils writeToFile:tmpString filename:[HNBUtils md5HexDigest:string]];
                    //保存md5值
                    [HNBUtils sandBoxSaveInfo:tmpMd5 forKey:[HNBUtils md5HexDigest:string]];
                }
            } withFailHandler:^(id error) {
                
            }];
        }

        
    } else {
        /* 判断是否有文件 */
        NSURL *baseURL = [NSURL URLWithString:string];
        if ([HYFileManager isExistsAtPath:[NSString stringWithFormat:@"%@/%@",[HYFileManager cachesDir],[HNBUtils md5HexDigest:string]]]) {
            /* 判断Md5是否相同 */
            NSString * Md5 = [HNBUtils sandBoxGetInfo:[NSString class] forKey:[HNBUtils md5HexDigest:string]];
            NSString *filePath  = [NSString stringWithFormat:@"%@/%@", [HYFileManager cachesDir],[HNBUtils md5HexDigest:string]];
            NSString *htmlstring= [[NSString alloc] initWithContentsOfFile:filePath  encoding:NSUTF8StringEncoding error:nil];
            [_wkweb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
            [_wkweb loadHTMLString:[self loadCacheImageForHtml:htmlstring] baseURL:baseURL];
            
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval inTime=[dat timeIntervalSince1970]*1000;
            [DataFetcher doGetPageHTML:string MD5:Md5 withSucceedHandler:^(id JSON) {
                NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval outTime=[dat timeIntervalSince1970]*1000;
                NSString * consumingString = [NSString stringWithFormat:@"%f",outTime - inTime];

                NSData *tmpData = JSON;
                NSString * tmpString = [[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding];
                if ([tmpString isEqualToString:@""]) {

                }
                else
                {
                    NSString *tmpMd5 = [HNBUtils md5HexDigest:tmpString];
                    if([consumingString integerValue] < 200)  //网速好的情况下(请求时间200ms以下)获取下新html后再次reload
                    {
                        //[_wkweb loadHTMLString:tmpString baseURL:baseURL];
                    }
                    //[HNBUtils removeFile:Md5];
                    [HNBUtils writeToFile:tmpString filename:[HNBUtils md5HexDigest:string]];
                    //保存md5值
                    [HNBUtils sandBoxSaveInfo:tmpMd5 forKey:[HNBUtils md5HexDigest:string]];
                }
            } withFailHandler:^(id error) {
                
            }];

        }
        else
        {
            [DataFetcher doGetPageHTML:string MD5:@"" withSucceedHandler:^(id JSON) {
                NSData *tmpData = JSON;
                NSString * tmpString = [[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding];
                if (JSON != NULL && ![tmpString isEqualToString:@""] &&tmpString) {/*保证md5写入文件不是空*/
                    NSString *tmpMd5 = [HNBUtils md5HexDigest:tmpString];
                    NSURL *baseURL = [NSURL URLWithString:string];
                    [_wkweb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
                    [_wkweb loadHTMLString:[self loadCacheImageForHtml:tmpString] baseURL:baseURL];
                    [HNBUtils writeToFile:tmpString filename:[HNBUtils md5HexDigest:string]];
                    //保存md5值
                    [HNBUtils sandBoxSaveInfo:tmpMd5 forKey:[HNBUtils md5HexDigest:string]];
                }
            } withFailHandler:^(id error) {
                
            }];
        }
        
        
        
        
    }
    
}

- (NSString *) loadCacheImageForHtml:(NSString *)html
{
    NSString * returnHtml = [NSString stringWithFormat:@"%@",html];
    NSData *data = [returnHtml dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *htmlParser = [[TFHpple alloc] initWithHTMLData:data];
    // img
    NSArray *IMGElementsArr = [htmlParser searchWithXPathQuery:@"//img"];
    for (TFHppleElement *tempAElement in IMGElementsArr) {
        NSString *imgStr = [tempAElement objectForKey:@"src"];
        NSString *normalStr = [tempAElement objectForKey:@"src"];
        imgStr = [imgStr stringByReplacingOccurrencesOfString:@"https:" withString:@""];
        imgStr = [imgStr stringByReplacingOccurrencesOfString:@"http:" withString:@""];
        imgStr = [NSString stringWithFormat:@"https:%@",imgStr];
        [[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:imgStr] completion:^(BOOL isInCache) {
            if (isInCache) {
                NSString *cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:imgStr]];
                if (cacheImageKey.length) {
                    NSString *cacheImagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:cacheImageKey];
                    if (cacheImagePath.length)
                    {
                        [returnHtml stringByReplacingOccurrencesOfString:normalStr withString:cacheImagePath];
                    }
                }
            }
            else
            {
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imgStr]
                                                                      options:0
                                                                     progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                                                         
                                                                     }completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                                                         
                                                                     }];
                
            }
        }];
        
        
    }
    NSArray *IMG2ElementsArr = [htmlParser searchWithXPathQuery:@"//*[contains(@style,'background-image:')]"];
    for (TFHppleElement *tempAElement in IMG2ElementsArr) {
        NSString *imgStr = [tempAElement objectForKey:@"style"];
        imgStr = [imgStr stringByReplacingOccurrencesOfString:@"background-image: url(" withString:@""];
        imgStr = [imgStr stringByReplacingOccurrencesOfString:@");" withString:@""];
        NSString *normalStr = [NSString stringWithFormat:@"%@",imgStr];
        
        imgStr = [imgStr stringByReplacingOccurrencesOfString:@"https:" withString:@""];
        imgStr = [imgStr stringByReplacingOccurrencesOfString:@"http:" withString:@""];
        imgStr = [NSString stringWithFormat:@"https:%@",imgStr];
        [[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:imgStr] completion:^(BOOL isInCache) {
            if (isInCache) {
                NSString *cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:imgStr]];
                if (cacheImageKey.length) {
                    NSString *cacheImagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:cacheImageKey];
                    if (cacheImagePath.length)
                    {
                        [returnHtml stringByReplacingOccurrencesOfString:normalStr withString:cacheImagePath];
                    }
                }
            }
            else
            {
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imgStr]
                                                                      options:0
                                                                     progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                                                         
                                                                     }completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                                                         
                                                                     }];
                
            }
        }];
    }
    return returnHtml;

}

-(void)loadWKWebWithFrame:(CGRect)frame delegate:(id<WKNavigationDelegate,WKUIDelegate>)delegate superView:(UIView *)superV req:(NSURLRequest *)req{
    /* 增加进度条 */
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    progressView.tintColor = [UIColor DDNavBarBlue];
    progressView.trackTintColor = [UIColor clearColor];
    [progressView setProgress:0 animated:NO];
    
    self.progressView = progressView;
    
    _wkweb = nil;
    _wkweb = [[WKWebView alloc] initWithFrame:frame];
    _wkweb.navigationDelegate = delegate;
    _wkweb.UIDelegate = delegate;
    _wkweb.backgroundColor = [UIColor clearColor];
    _wkweb.scrollView.bounces = false;
    [_wkweb addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [superV addSubview:_wkweb];
    [superV addSubview:progressView];
    [self webLoadRequest:req];
    _currentUrl = req.URL;
    if(req)
    {
            [self loadHTMLString:[req.URL absoluteString]];
    }

    
    
}

//// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == _wkweb && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}


- (void)dealloc {
    
        [_wkweb removeObserver:self forKeyPath:@"estimatedProgress"];
}


@end
