//
//  HNBClick.m
//  hinabian
//
//  Created by 余坚 on 16/5/12.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "HNBClick.h"
#import "DataFetcher.h"

@interface HNBClick()
{
    NSInteger UpLoadingType;
}
@property (nonatomic,strong) NSMutableArray * sendArray;
@end

@implementation HNBClick
+ (instancetype) sharedHNBCLick
{
    static HNBClick *__sharedHNBCLick = nil;
    
    static dispatch_once_t mmSharedHNBCLickOnceToken;
    dispatch_once(&mmSharedHNBCLickOnceToken, ^{
        __sharedHNBCLick = [[HNBClick alloc] init];
        __sharedHNBCLick.sendArray = [[NSMutableArray alloc] init];
    });
    
    return __sharedHNBCLick;
}

/* 设置上传类型 */
+ (void) setUpLoadingType:(NSInteger)type
{
    
}

/* 点击事件数量统计
 使用前，请先到CRM管理后台的设置添加相应的事件ID，然后在工程中传入相应的事件ID
 content 是json  这个由后台自己判断 （外部接口）*/
+ (void)event:(NSString *)eventId Content:(NSDictionary *)content
{
    [[HNBClick sharedHNBCLick] event:eventId Content:content];
}

/* 点击事件数量统计
 使用前，请先到CRM管理后台的设置添加相应的事件ID，然后在工程中传入相应的事件ID
 content 是json  这个由后台自己判断 （外部接口） act是特殊事件 */
+ (void)event:(NSString *)eventId Content:(NSDictionary *)content Act:(NSString *)act
{
    [[HNBClick sharedHNBCLick] event:eventId Content:content Act:act];
}

/* 点击事件数量统计
 使用前，请先到CRM管理后台的设置添加相应的事件ID，然后在工程中传入相应的事件ID
 content 可以是名字 或者 url  这个由后台自己判断 （内部接口） */
- (void)event:(NSString *)eventId Content:(NSDictionary *)content
{
//    NSDictionary * tmpDic = @{@"id" : eventId, @"content" : content};
//    [_sendArray addObject:tmpDic];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       eventId, @"id",
                                       content,@"content",
                                       nil];
    NSArray *tmpArray = [[NSArray alloc] initWithObjects:parameters, nil];
    [DataFetcher doSendClickInfo:tmpArray Count:[NSString stringWithFormat:@"%d",1]  withSucceedHandler:^(id JSON) {
        
    } withFailHandler:^(id error) {
        
    }];
    
}

- (void)event:(NSString *)eventId Content:(NSDictionary *)content  Act:(NSString *)act
{
    //    NSDictionary * tmpDic = @{@"id" : eventId, @"content" : content};
    //    [_sendArray addObject:tmpDic];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       eventId, @"id",
                                       act, @"act",
                                       content,@"content",
                                       nil];
    NSArray *tmpArray = [[NSArray alloc] initWithObjects:parameters, nil];
    [DataFetcher doSendClickInfo:tmpArray Count:[NSString stringWithFormat:@"%d",1]  withSucceedHandler:^(id JSON) {
        
    } withFailHandler:^(id error) {
        
    }];
    
}

@end
