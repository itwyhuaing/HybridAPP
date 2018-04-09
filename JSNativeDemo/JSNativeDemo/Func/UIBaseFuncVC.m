//
//  UIBaseFuncVC.m
//  JSNativeDemo
//
//  Created by wangyinghua on 2018/4/9.
//  Copyright © 2018年 ZhiXing. All rights reserved.
//

#import "UIBaseFuncVC.h"

@interface UIBaseFuncVC ()

@end

@implementation UIBaseFuncVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseUI];
}

- (void)setBaseUI{
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect rect = CGRectZero;
    rect.size = CGSizeMake(120, 30);
    rect.origin.y = 90.0;
    rect.origin.x = [UIScreen mainScreen].bounds.size.width/2.0 - rect.size.width/2.0;
    [self addFuncBtnWithRect:rect title:@"UIWeb示例" clickTag:EventClickUIWebType];
    rect.origin.y = CGRectGetMaxY(rect) + 30.0;
    [self addFuncBtnWithRect:rect title:@"WKWeb示例" clickTag:EventClickWKWebType];
}

- (void)addFuncBtnWithRect:(CGRect)rect title:(NSString *)title clickTag:(EventClickType)tag{
    UIButton *webBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [webBtn setTitle:title forState:UIControlStateNormal];
    [webBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    webBtn.tag = tag;
    [webBtn addTarget:self action:@selector(eventClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [webBtn setFrame:rect];
    [self.view addSubview:webBtn];
}

- (void)eventClickBtn:(UIButton *)btn{
    [self eventSourceTouchBtn:btn];
}

-(void)eventSourceTouchBtn:(UIButton *)btn{
    NSLog(@" Base - %s ",__FUNCTION__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
