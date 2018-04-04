//
//  CouponMainManager.h
//  hinabian
//
//  Created by hnb on 16/4/22.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol CouponMainManagerDelegate;

@interface CouponMainManager : NSObject
@property (weak, nonatomic) UIViewController * superController;
@property (nonatomic, strong) NSMutableArray * couponInUseArry;
@property (nonatomic, strong) NSMutableArray * couponUsedArry;
@property (nonatomic, strong) NSMutableArray * couponOutOfDateArry;
@property (nonatomic, weak) id<CouponMainManagerDelegate> delegate;

/**
 * 获取网络数据
 * 
 **/
- (void)getDataSource;

//- (void) getCouponInfo:(int) start GetNum:(int) num Flag:(int) flag;               //从服务器获取数据


@end

@protocol CouponMainManagerDelegate <NSObject>
@optional
-(void) getAllDateComplete;

- (void) reqNetFail;

@end