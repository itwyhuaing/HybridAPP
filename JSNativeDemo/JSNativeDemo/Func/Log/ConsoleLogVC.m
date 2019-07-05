//
//  ConsoleLogVC.m
//  JSNativeDemo
//
//  Created by hnbwyh on 2019/7/5.
//  Copyright © 2019 ZhiXing. All rights reserved.
//

#import "ConsoleLogVC.h"
#import <WebKit/WebKit.h>
#import "JXWKWeb.h"

@interface ConsoleLogVC ()

@property (strong,nonatomic) JXWKWeb     *wkweb;


@end

@implementation ConsoleLogVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSStringFromClass(self.class);
    self.view.backgroundColor = [UIColor purpleColor];
    CGRect bounds = [UIScreen mainScreen].bounds;
    WKWebViewConfiguration *cfg = [[WKWebViewConfiguration alloc] init];
    self.wkweb = [[JXWKWeb alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds)/2.0) configuration:cfg];
    [self.view addSubview:self.wkweb];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"WKHandlerWeb" ofType:@"html"];
    [self.wkweb loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    self.view.backgroundColor = [UIColor purpleColor];
    self.wkweb.backgroundColor = [UIColor cyanColor];
}


#pragma mark - WKScriptMessageHandler

@end
