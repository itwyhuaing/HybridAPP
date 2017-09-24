//
//  UIWebVC.m
//  JSNativeDemo1
//
//  Created by hnbwyh on 2017/9/22.
//  Copyright © 2017年 hainbwyh. All rights reserved.
//

#import "UIWebVC.h"

@interface UIWebVC ()

@property (nonatomic,strong) UIWebView *uiweb;

@end

@implementation UIWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(UIWebView *)uiweb{
    if (_uiweb) {
        _uiweb = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _uiweb.backgroundColor = [UIColor redColor];
        [self.view addSubview:_uiweb];
    }
    return _uiweb;
}

@end
