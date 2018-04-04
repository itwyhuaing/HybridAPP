//
//  main.m
//  hinabian
//
//  Created by 余坚 on 15/6/1.
//  Copyright (c) 2015年 余坚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

CFAbsoluteTime appOpenStartTime;
int main(int argc, char * argv[]) {
    appOpenStartTime = CFAbsoluteTimeGetCurrent();
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
