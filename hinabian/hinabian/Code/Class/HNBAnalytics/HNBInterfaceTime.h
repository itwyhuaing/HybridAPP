//
//  HNBInterfaceTime.h
//  hinabian
//
//  Created by 余坚 on 16/5/17.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNBInterfaceTime : NSObject
/**
 海那边接口时间单例
 */
+ (instancetype)sharedHNBInterfaceTime;

/** 接口时间统计
 */
+ (void)recordInterfaceTime:(NSString *)Interface IsSuccessed:(BOOL)charge Time:(NSTimeInterval) time;

/** 接口时间统计
  接口 - 状态 - 时间 - 网络环境
 */
+ (void)reportInterfaceTime:(NSString *)Interface IsSuccessed:(BOOL)charge Time:(NSTimeInterval) time netStatus:(NSString *)netStatus;

@end
