//
//  TableVC.h
//  JSNativeDemo
//
//  Created by wangyinghua on 2018/4/9.
//  Copyright © 2018年 ZhiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FunctionInterceptVCType = 20000,
    FunctionJSCoreVCType,
    FunctionJSBridgeVCType,
    FunctionMsgHandlerVCType,
    FunctionWKDemoShowType,
} FunctionVCType;

@interface TableVC : UITableViewController

@end
