//
//  HNBWKWebView.m
//  hinabian
//
//  Created by 何松泽 on 2017/12/7.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "HNBWKWebView.h"

#import "DataFetcher.h"
#import "TFHpple.h"

@implementation HNBWKWebView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<WKNavigationDelegate,WKUIDelegate>)delegate superView:(UIView *)superV req:(NSURLRequest *)req config:(WKWebViewConfiguration *)config{
    
    if (self) {
        if (config) {
            self = [super initWithFrame:frame configuration:config];
        }else {
            self = [super initWithFrame:frame];
        }
        /* 增加进度条 */
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        progressView.tintColor = [UIColor DDNavBarBlue];
        progressView.trackTintColor = [UIColor clearColor];
        [progressView setProgress:0 animated:NO];
        
        self.progressView = progressView;
        
        
        self.navigationDelegate = delegate;
        self.UIDelegate = delegate;
        self.backgroundColor = [UIColor clearColor];
        self.scrollView.bounces = false;
        [self addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [superV addSubview:self];
        [superV addSubview:progressView];
        [self webLoadRequest:req];
//        if(req){ // 缓存已关闭
//            [self loadHTMLString:[req.URL absoluteString]];
//        }
    }
    
    return self;
    
}

-(void)addView:(UIView *)subview{
    [self addSubview:subview];
}

-(void)setWebFrame:(CGRect)webFrame{
    
    [self setFrame:webFrame];
    
}

- (void)webStopLoading{
    
    [self stopLoading];
    
}

- (BOOL)webCanGoBack {
    BOOL rlt = [self canGoBack];
    return rlt;
}

- (void)webGoBack{
    
    _isWebGoingBack = TRUE;
    [self goBack];
    if([[self.URL absoluteString] isEqualToString:@"about:blank"])
    {
        [self loadHTMLString:[_currentUrl absoluteString]];
    }
    
}

- (void)webLoadRequest:(NSURLRequest *)req{
    _currentUrl = req.URL;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[req URL] absoluteString]]];
    NSString *cookie = [HNBUtils reqCurrentCookie];
    //[request addValue:cookie forHTTPHeaderField:@"Cookie"];
    [request setValue:cookie forHTTPHeaderField:@"Cookie"];
    //NSLog(@" %s ====== > %@ , HNBSESSIONID-req :%@",__FUNCTION__,cookie,req);
    [self loadRequest:request];
    
}

- (void)webReload{
    
    [self reload];
    
}

-(void)evaluateJavaScriptFromString:(NSString *)keyString hanleComplete:(JavaScriptHandleComplete)result{
    
    //nslog(@" %s ",__FUNCTION__);
    __block NSString *resultString;
    
    [self evaluateJavaScript:keyString completionHandler:^(id _Nullable message, NSError * _Nullable error) {
        
        resultString = [NSString stringWithFormat:@"%@",message];
        if (result) {
            result(resultString);
        }
        
    }];
}

//// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self && [keyPath isEqualToString:@"estimatedProgress"]) {
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
    
    [self removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark ------ web 缓存已废弃

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
    /* 判断是否有文件 */
    NSURL *baseURL = [NSURL URLWithString:string];
    if ([HYFileManager isExistsAtPath:[NSString stringWithFormat:@"%@/%@",[HYFileManager cachesDir],[HNBUtils md5HexDigest:string]]]) {
        /* 判断Md5是否相同 */
        NSString * Md5 = [HNBUtils sandBoxGetInfo:[NSString class] forKey:[HNBUtils md5HexDigest:string]];
        NSString *filePath  = [NSString stringWithFormat:@"%@/%@", [HYFileManager cachesDir],[HNBUtils md5HexDigest:string]];
        NSString *htmlstring= [[NSString alloc] initWithContentsOfFile:filePath  encoding:NSUTF8StringEncoding error:nil];
        [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        [self loadHTMLString:[self loadCacheImageForHtml:htmlstring] baseURL:baseURL];
        
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
                [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
                [self loadHTMLString:[self loadCacheImageForHtml:tmpString] baseURL:baseURL];
                [HNBUtils writeToFile:tmpString filename:[HNBUtils md5HexDigest:string]];
                //保存md5值
                [HNBUtils sandBoxSaveInfo:tmpMd5 forKey:[HNBUtils md5HexDigest:string]];
            }
        } withFailHandler:^(id error) {
            
        }];
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

@end
