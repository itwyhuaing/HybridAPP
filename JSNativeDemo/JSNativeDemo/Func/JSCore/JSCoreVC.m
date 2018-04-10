//
//  JSCoreVC.m
//  JSNativeDemo
//
//  Created by hnbwyh on 2018/4/10.
//  Copyright © 2018年 ZhiXing. All rights reserved.
//

#import "JSCoreVC.h"

@interface JSCoreVC ()

@end

@implementation JSCoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)eventSourceTouchBtn:(UIButton *)btn{
    NSLog(@" JSCoreVC - %s ",__FUNCTION__);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
