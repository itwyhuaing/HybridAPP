//
//  HNBPv.m
//  hinabian
//
//  Created by 余坚 on 16/5/12.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "HNBPv.h"
#import "DataFetcher.h"
#import "PersonalInfo.h"

@interface HNBPv()
{
    NSTimeInterval _inTime;
    NSInteger _UpLoadingType;
}
@property (nonatomic,strong) NSMutableArray * sendArray;
@end

@implementation HNBPv

+ (instancetype)sharedHNBPv
{
    static HNBPv *__sharedHNBPv = nil;
    
    static dispatch_once_t mmSharedHNBCLickOnceToken;
    dispatch_once(&mmSharedHNBCLickOnceToken, ^{
        __sharedHNBPv = [[HNBPv alloc] init];
        __sharedHNBPv.sendArray = [[NSMutableArray alloc] init];
        __sharedHNBPv->_UpLoadingType = 2;   //默认统计立刻上报
    });
    
    return __sharedHNBPv;
}

+ (void) setUpLoadingType:(NSInteger)type
{
    [[HNBPv sharedHNBPv] setUpLoadingType:type];
}

+ (void)beginLogPageView:(NSString *)pageName Time:(NSTimeInterval)time IsH5:(BOOL)isH5
{
    [[HNBPv sharedHNBPv] beginLogPageView:pageName Time:time IsH5:isH5];
}

+ (void)endLogPageView:(NSString *)pageName Time:(NSTimeInterval)time IsH5:(BOOL)isH5
{
    [[HNBPv sharedHNBPv] endLogPageView:pageName Time:time IsH5:isH5];
}

- (void) setUpLoadingType:(NSInteger)type
{
    _UpLoadingType = type;
}

- (void)beginLogPageView:(NSString *)pageName Time:(NSTimeInterval)time IsH5:(BOOL)isH5
{
    if(!isH5)
    {
        [self sendPVRightNow:pageName Time:time];
    }
    _inTime = time;
}

- (void)endLogPageView:(NSString *)pageName Time:(NSTimeInterval)time IsH5:(BOOL)isH5
{
    NSTimeInterval spentTime = time - _inTime;
    NSString *timeString = [NSString stringWithFormat:@"%f", spentTime];
    //通过className找到对应页面的中文名
    
    //to do 页面时间统计 进入队列，根据规则上报
    NSDictionary *sendDic = nil;
    if (pageName != nil && ![pageName isEqualToString:@""]) {
        sendDic = @{@"id" : pageName, @"time" : timeString};
    }
    else
    {
        return;
    }
    [_sendArray addObject:sendDic];
    //根据不同上报规则上报数据
    switch (_UpLoadingType) {
        case 1:
            [self sendPvEveryXTime];
            break;
        case 2:
            [self sendPVTimeRightNow:time];
            break;
        default:
            break;
    }
}

/* 立刻上报pv */
- (void)sendPVRightNow:(NSString *)pageName Time:(NSTimeInterval)time
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       pageName, @"id",
                                       nil];
    NSArray *tmpArray = [[NSArray alloc] initWithObjects:parameters, nil];
    [DataFetcher doSendPVInfo:tmpArray Count:[NSString stringWithFormat:@"%d",1] Time:[NSString stringWithFormat:@"%0.f",time] withSucceedHandler:^(id JSON) {
        
    } withFailHandler:^(id error) {
        
    }];
    
}

/* 立刻上报页面停留时间 */
- (void)sendPVTimeRightNow:(NSTimeInterval)time
{
    if (_sendArray.count >= 1) {
        for (NSDictionary * a in _sendArray) {
            NSArray *ar = [[NSArray alloc] initWithObjects:a, nil];
            [DataFetcher doSendPVTimeInfo:ar Count:[NSString stringWithFormat:@"%d",1] Time:[NSString stringWithFormat:@"%0.f",time] withSucceedHandler:^(id JSON) {
                
            } withFailHandler:^(id error) {
                
            }];
            if (![HNBUtils isLogin]) {
                [DataFetcher doVerifyUserInfo:^(id JSON) {
                    /*输入手机验证码后，刷新个人资料并且修改登录态*/
                    int state = [[JSON valueForKey:@"state"] intValue];
                    if (state == 0)
                    {
                        [HNBUtils sandBoxSaveInfo:@"1" forKey:IMGuide_hasBeen_Logined];
                        [HNBUtils sandBoxSaveInfo:@"1" forKey:personal_is_login];
                    }
                } withFailHandler:^(id error) {
                    
                }];
            }
        }
        [_sendArray removeAllObjects];
    }
}
/* 下一次启动上传数据 */

/* 每统计达到十次上报一次数据 */
- (void)sendPvEveryXTime
{
    if (_sendArray.count >= 1) {
//        for (NSDictionary * a in _sendArray) {
//            NSArray *ar = [a allValues];
//            //NSLog(@"%@",ar);
//        }
        [_sendArray removeAllObjects];
    }
}

/* 每X分钟上传一次数据 */

@end
