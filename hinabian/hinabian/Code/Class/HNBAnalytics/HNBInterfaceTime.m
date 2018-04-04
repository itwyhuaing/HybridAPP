//
//  HNBInterfaceTime.m
//  hinabian
//
//  Created by 余坚 on 16/5/17.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "HNBInterfaceTime.h"
#import "DataFetcher.h"

@interface HNBInterfaceTime()
{
    NSInteger _UpLoadingType;
}
@property (nonatomic,strong) NSMutableArray * sendArray;
@end

@implementation HNBInterfaceTime
+ (instancetype)sharedHNBInterfaceTime
{
    static HNBInterfaceTime *__sharedHNBInterfaceTime = nil;
    
    static dispatch_once_t mmSharedHNBCLickOnceToken;
    dispatch_once(&mmSharedHNBCLickOnceToken, ^{
        __sharedHNBInterfaceTime = [[HNBInterfaceTime alloc] init];
        __sharedHNBInterfaceTime.sendArray = [[NSMutableArray alloc] init];
        __sharedHNBInterfaceTime->_UpLoadingType = 1;   //默认统计达5次上报
    });
    
    return __sharedHNBInterfaceTime;
}

+ (void)recordInterfaceTime:(NSString *)Interface IsSuccessed:(BOOL)charge Time:(NSTimeInterval) time
{
    [[HNBInterfaceTime sharedHNBInterfaceTime] recordInterfaceTime:Interface IsSuccessed:charge Time:time];
}

- (void)recordInterfaceTime:(NSString *)Interface IsSuccessed:(BOOL)charge Time:(NSTimeInterval) time
{
    if ([Interface rangeOfString:@"data.hinabian.com"].location != NSNotFound) {
        return ;
    }
    NSDictionary *sendDic = @{@"interface" : Interface, @"time" : [NSString stringWithFormat:@"%f",time]};
    //NSLog(@"%@",sendDic);
    [_sendArray addObject:sendDic];
    [HNBUtils sandBoxSaveInfo:_sendArray forKey:hnb_interface_time];
    //根据不同上报规则上报数据
    switch (_UpLoadingType) {
        case 1:
            [self sendInterfactTimeEveryXTime];
            break;
            
        default:
            break;
    }


}

/* 下一次启动上传数据 */



/* 每累计n次上传一次数据 */
- (void)sendInterfactTimeEveryXTime
{
    NSArray *currentSave = [HNBUtils sandBoxGetInfo:[NSArray class] forKey:hnb_interface_time];
    if (currentSave.count > 5) {
//        for (NSDictionary * a in currentSave) {
//            //NSLog(@"%@",a);
//        }
        [DataFetcher doSendInterfaceTimeInfo:currentSave Count:[NSString stringWithFormat:@"%lu",(unsigned long)currentSave.count] withSucceedHandler:^(id JSON) {
        } withFailHandler:^(id error) {
            
        }];
        [_sendArray removeAllObjects];
        [HNBUtils sandBoxClearAllInfo:hnb_interface_time];
    }
}


/* 每X分钟上传一次数据 */



/**
  上报增加 网络状态
 */

+ (void)reportInterfaceTime:(NSString *)Interface IsSuccessed:(BOOL)charge Time:(NSTimeInterval) time netStatus:(NSString *)netStatus{
    [[HNBInterfaceTime sharedHNBInterfaceTime] reportInterfaceTime:Interface IsSuccessed:charge Time:time netStatus:netStatus];
}

- (void)reportInterfaceTime:(NSString *)Interface IsSuccessed:(BOOL)charge Time:(NSTimeInterval)time netStatus:(NSString *)netStatus{
    
    if ([Interface rangeOfString:@"data.hinabian.com"].location != NSNotFound) {
        return ;
    }
    
    NSDictionary *content = @{@"netStatus":netStatus};
    NSDictionary *sendDic = @{@"interface" : Interface, @"time" : [NSString stringWithFormat:@"%f",time],@"content" : content};
    //NSLog(@"%@",sendDic);
    [_sendArray addObject:sendDic];
    [HNBUtils sandBoxSaveInfo:_sendArray forKey:hnb_interface_time];
    //根据不同上报规则上报数据
    switch (_UpLoadingType) {
        case 1:
            [self sendInterfactTimeEveryXTime];
            break;
            
        default:
            break;
    }
    
}

@end
