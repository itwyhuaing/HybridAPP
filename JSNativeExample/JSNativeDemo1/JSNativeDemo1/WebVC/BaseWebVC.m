//
//  BaseWebVC.m
//  JSNativeDemo1
//
//  Created by hnbwyh on 2017/9/22.
//  Copyright © 2017年 hainbwyh. All rights reserved.
//

#import "BaseWebVC.h"

@interface BaseWebVC ()

@end

@implementation BaseWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *htmlPath = [bundle pathForResource:@"jsoc" ofType:@"html"];
    _req = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
