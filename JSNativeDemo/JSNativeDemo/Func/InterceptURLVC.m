//
//  InterceptURLVC.m
//  JSNativeDemo
//
//  Created by wangyinghua on 2018/4/9.
//  Copyright © 2018年 ZhiXing. All rights reserved.
//

#import "InterceptURLVC.h"

@interface InterceptURLVC ()

@end

@implementation InterceptURLVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)eventSourceTouchBtn:(UIButton *)btn{
    NSLog(@" InterceptURLVC - %s ",__FUNCTION__);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
