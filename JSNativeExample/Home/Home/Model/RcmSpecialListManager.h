//
//  RcmSpecialListManager.h
//  hinabian
//
//  Created by hnbwyh on 2017/10/30.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RcmSpecialListManager;
@protocol RcmSpecialListManagerDelegate <NSObject>
@optional
- (void)rcmSpecialListManagerReqNetSucWithDataSource:(id)dataSource reqStatus:(BOOL)rs;
- (void)rcmSpecialListManagerReqNetFailWithError:(NSError *)error reqStatus:(BOOL)rs;

@end

@interface RcmSpecialListManager : NSObject

@property (nonatomic,weak) id <RcmSpecialListManagerDelegate> delegate;

- (void)reqRcmSpecialListData;

@end
