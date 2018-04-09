//
//  UIBaseFuncVC.h
//  JSNativeDemo
//
//  Created by wangyinghua on 2018/4/9.
//  Copyright © 2018年 ZhiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    EventClickUIWebType = 20000,
    EventClickWKWebType,
} EventClickType;

@interface UIBaseFuncVC : UIViewController

- (void)eventSourceTouchBtn:(UIButton *)btn;

@end
