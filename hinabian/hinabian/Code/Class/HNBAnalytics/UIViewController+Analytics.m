//
//  UIViewController+Analytics.m
//  hinabian
//
//  Created by 余坚 on 16/5/16.
//  Copyright © 2016年 余坚;. All rights reserved.
//

#import "UIViewController+Analytics.h"
#import "SWKBaseViewController.h"
#import "RDVTabBarController.h"
#import "HNBPv.h"
#import <objc/message.h>
#import "NationIMProjectViewController.h"
#import "HotIMProjectVC.h"
#import "TYPagerController.h"

@implementation UIViewController (Analytics)
+ (void)load
{
    [self changeViewDidAppear];
    [self changeViewWillDisappear];
}

+ (void) changeViewDidAppear
{
    Class class = [self class];
    SEL originalSelector = @selector(viewWillAppear:);
    SEL swizzledSeletcor = @selector(analyticsViewDidAppear:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSeletcor);
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

+ (void) changeViewWillDisappear
{
    Class class = [self class];
    SEL originalSelector = @selector(viewWillDisappear:);
    SEL swizzledSeletcor = @selector(analyticsviewWillDisappear:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSeletcor);
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)analyticsviewWillDisappear:(BOOL)animated
{
    [self analyticsviewWillDisappear:animated];
    [HNBUtils canclAllRequestInAFNQueue];
    if ([self class] == [UINavigationController class] || [self class] == [RDVTabBarController class]) {
        return;
    }
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[dat timeIntervalSince1970];
    BOOL isH5 = false;
    
    if ([self superclass] == [SWKBaseViewController class]) {
        isH5 = true;
    }
    //退出打点记录
    if ([self class] == [NationIMProjectViewController class] || [self class] == [HotIMProjectVC class]) {
        /*NationIMProjectViewController、HotIMProjectVC这两个类中自行退出打点记录*/
    }else if ([self class] == [TYPagerController class]){
        /**引入第三方库之后有些控制器需要剔出*/
    }else {
        [HNBPv endLogPageView:[NSString stringWithFormat:@"%@",[self class]] Time:time IsH5:isH5];
    }
}
-(void) analyticsViewDidAppear:(BOOL)animated
{
    [self analyticsViewDidAppear:animated];
    if ([self class] == [UINavigationController class] || [self class] == [RDVTabBarController class]) {
        return;
    }
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[dat timeIntervalSince1970];
    BOOL isH5 = false;
    
    if ([self superclass] == [SWKBaseViewController class]) {
        isH5 = true;
    }
    
    if ([self class] == [NationIMProjectViewController class] || [self class] == [HotIMProjectVC class]) {
        /*NationIMProjectViewController、HotIMProjectVC这两个类中自行打点记录*/
    }else if ([self class] == [TYPagerController class]){
        /**引入第三方库之后有些控制器需要剔出*/
    }else {
        [HNBPv beginLogPageView:[NSString stringWithFormat:@"%@",[self class]] Time:time IsH5:isH5];
    }
    
}
@end
