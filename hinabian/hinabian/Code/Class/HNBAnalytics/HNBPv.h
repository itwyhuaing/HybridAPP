//
//  HNBPv.h
//  hinabian
//
//  Created by 余坚 on 16/5/12.
//  Copyright © 2016年 余坚;. All rights reserved.
//
//
//  功能：记录每个页面pv，并且统计每个页面的使用时长
//  并根据规则上报
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface HNBPv : NSObject
/**
 海那边点击统计单例
 */
+ (instancetype)sharedHNBPv;

/* 设置上传类型 */
+ (void) setUpLoadingType:(NSInteger)type;

/** 自动页面时长统计, 开始记录某个页面展示时长.
 使用方法：必须配对调用beginLogPageView:和endLogPageView:两个函数来完成自动统计，若只调用某一个函数不会生成有效数据。
 在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView:
 @param pageName 统计的页面名称.
 @return void.
 */
+ (void)beginLogPageView:(NSString *)pageName Time:(NSTimeInterval)time IsH5:(BOOL)isH5;

/** 自动页面时长统计, 结束记录某个页面展示时长.
 使用方法：必须配对调用beginLogPageView:和endLogPageView:两个函数来完成自动统计，若只调用某一个函数不会生成有效数据。
 在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView:
 @param pageName 统计的页面名称.
 @return void.
 */
+ (void)endLogPageView:(NSString *)pageName Time:(NSTimeInterval)time IsH5:(BOOL)isH5;
@end
