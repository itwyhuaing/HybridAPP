//
//  UIButton+Analytics.m
//  hinabian
//
//  Created by 余坚 on 16/5/16.
//  Copyright © 2016年 余坚;. All rights reserved.
//

#import "UIButton+Analytics.h"
#import <objc/message.h>

@implementation UIButton (Analytics)
//+ (void) load
//{
//    NSLog(@"class %@",[self class]);
//    [self changeAddTarget];
//}
//
//+ (void) changeAddTarget
//{
//    Class class = [self class];
//    //NSLog(@"class = %@",class);
//
//    SEL originalSelector = @selector(sendAction:to:forEvent:);
//    SEL swizzledSelector = @selector(cimc_sendAction:to:forEvent:);
//        
//    Method originalMethod = class_getInstanceMethod(class, originalSelector);
//    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//        
//    method_exchangeImplementations(originalMethod, swizzledMethod);
//}
//
//- (void) cimc_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
//{
//    NSString *str = NSStringFromSelector(action);
//    NSLog(@"tick   %ld   %@   %@",(long)self.tag,str, [self class]);
//    [self cimc_sendAction:action to:target forEvent:event];
//    
//}
//------------------------------------------------------------------------
//- (void) cimc_addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
//{
//    [self cimc_addTarget:target action:action forControlEvents:controlEvents];
//    
//    Class class = [target class];
//    NSString *oldSelString = NSStringFromSelector(action);
//    
//    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"cimc_%@",oldSelString]);
//    SEL actionSel = action;
//    if (class_addMethod(class, selector, (IMP)cimc_buttonAction, "v@:@")) {
//        Method dis_originalMethod = class_getInstanceMethod(class, actionSel);
//        Method dis_swizzlendMethod = class_getInstanceMethod(class, selector);
//        
//        method_exchangeImplementations(dis_originalMethod, dis_swizzlendMethod);
//    }
//}
//
//void cimc_buttonAction(id self, SEL _cmd, id sender)
//{
//    UIButton * tmpbutton = sender;
//    NSLog(@"tick %ld",(long)tmpbutton.tag);
//    
//    NSString *oldSelstring = NSStringFromSelector(_cmd);
//    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"cimc_%@",oldSelstring]);
//    ((void(*)(id,SEL,id))objc_msgSend)(self,selector,sender);
//}

@end
