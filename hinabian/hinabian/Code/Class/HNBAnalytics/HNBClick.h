//
//  HNBClick.h
//  hinabian
//
//  Created by 余坚 on 16/5/12.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum {
    EM_REAL_TIME = 0,          //实时发送
    EM_TEN_COUNT = 1,          //累计10次发送
    EM_TEN_SECOND = 2,         //累计10秒发送
    EM_START_TIME = 3,         //启动时发送上一次启动的统计
} HNBReportPolicy;

@interface HNBClick : NSObject
/**
 海那边点击统计单例
 */
+ (instancetype)sharedHNBCLick;
/**
 设置上传类型
 */
+ (void) setUpLoadingType:(NSInteger)type;

/** 点击事件数量统计
 使用前，请先到CRM管理后台的设置添加相应的事件ID，然后在工程中传入相应的事件ID
 content 可以是名字 或者 url  这个由后台自己判断
 */
+ (void)event:(NSString *)eventId Content:(NSDictionary *)content;

+ (void)event:(NSString *)eventId Content:(NSDictionary *)content Act:(NSString *)act;
@end
