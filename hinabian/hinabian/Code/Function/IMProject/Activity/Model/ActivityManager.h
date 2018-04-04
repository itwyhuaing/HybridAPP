//
//  ActivityManager.h
//  hinabian
//
//  Created by 何松泽 on 17/1/11.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ActivityManager;
@protocol ActivityManagerDelegate <NSObject>
@optional
- (void)completeThenRefreshSeminarWithData:(NSArray *)data;

- (void)failedThenFinishRefreshSeminarView;

@end

@interface ActivityManager : NSObject

@property (nonatomic, strong) id<ActivityManagerDelegate> delegate;

-(void)setSuperControl:(UIViewController *)supercontroller type:(NSString *)type;
-(void)requestSeminarDataFrom:(NSInteger)start getCount:(NSInteger)num;
//-(void)requestDataInFirstTimeByType:(NSString *)type;
-(void)reqiestSeminarFirstDataFrom:(NSInteger)start getCount:(NSInteger)num;

@end
