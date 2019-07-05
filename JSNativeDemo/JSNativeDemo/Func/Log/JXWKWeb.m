//
//  JXWKWeb.m
//  JSNativeDemo
//
//  Created by hnbwyh on 2019/7/5.
//  Copyright © 2019 ZhiXing. All rights reserved.
//

#import "JXWKWeb.h"

@interface JXWKWeb ()<WKScriptMessageHandler>

@end


@implementation JXWKWeb

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    self = [super initWithFrame:frame configuration:configuration];
    if (self) {
//        NSString *js = @"console.log = (function(originFunc){\
//                                            return function(info) {\
//                                                window.webkit.messageHandlers.log.postMessage(info);\
//                                                originFunc.call(console,info);\
//                                            }\
//                                        })(console.log)";
        
        [configuration.userContentController addScriptMessageHandler:self name:@"log"];
        
//        NSString *js = @"console.log = (function(oriLogFunc){\
//        return function(str)\
//        {\
//        window.webkit.messageHandlers.log.postMessage(str);\
//        oriLogFunc.call(console,str);\
//        }\
//        })(console.log);";
//        [self.configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:js
//                                                                                  injectionTime:WKUserScriptInjectionTimeAtDocumentStart
//                                                                               forMainFrameOnly:TRUE]];
        
        [self showConsole];
        
    }
    return self;
}

- (void)showConsole {
    
    //rewrite the method of console.log
    NSString *jsCode = @"console.log = (function(oriLogFunc){\
    return function(str)\
    {\
    window.webkit.messageHandlers.log.postMessage(str);\
    oriLogFunc.call(console,str);\
    }\
    })(console.log);";
    
    //injected the method when H5 starts to create the DOM tree
    [self.configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:jsCode injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"log"]) {
        NSLog(@" 打印：%@",message.body);
    }
}

@end
