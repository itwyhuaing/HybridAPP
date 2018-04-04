//
//  ConditionTestManager.h
//  hinabian
//
//  Created by hnbwyh on 17/6/9.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ConditionTestManager;
@protocol ConditionTestManagerDelegate <NSObject>
@optional
- (void)fetchNetState:(BOOL)state data:(id)data;
- (void)fetchNetState:(BOOL)state error:(NSError *)er;

@end

@interface ConditionTestManager : NSObject

@property (nonatomic,weak) id<ConditionTestManagerDelegate>delegate;
- (void)reqConditionTestDataSource;

@end
