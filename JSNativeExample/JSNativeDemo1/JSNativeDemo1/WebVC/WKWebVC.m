//
//  WKWebVC.m
//  JSNativeDemo1
//
//  Created by hnbwyh on 2017/9/22.
//  Copyright © 2017年 hainbwyh. All rights reserved.
//

#import "WKWebVC.h"
#import <WebKit/WebKit.h>

@interface WKWebVC ()

@property (nonatomic,strong) WKWebView *wkweb;

@end

@implementation WKWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.wkweb loadRequest:self.req];
}

-(WKWebView *)wkweb{
    if (!_wkweb) {
        _wkweb = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _wkweb.backgroundColor = [UIColor greenColor];
        [self.view addSubview:_wkweb];
    }
    return _wkweb;
}

@end
