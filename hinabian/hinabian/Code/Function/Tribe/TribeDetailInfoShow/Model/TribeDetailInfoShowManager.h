//
//  TribeDetailInfoShowManager.h
//  hinabian
//
//  Created by hnbwyh on 16/10/20.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ReturnDataForCardViewBlock)(NSArray *data);

@class TribeDetailInfoShowManager;
@protocol TribeDetailInfoShowManagerDelegate <NSObject>
@optional
- (void)TribeDetailInfoShowManager:(TribeDetailInfoShowManager *)manager dataSource:(NSArray *)data;

@end

@class PersonInfoModel;
@interface TribeDetailInfoShowManager : NSObject

@property (nonatomic,weak) id<TribeDetailInfoShowManagerDelegate> delegate;

- (instancetype)initWithThemId:(NSString *)themId superVC:(UIViewController *)superVC;

- (void)reqNetDataPage:(NSInteger)page withSucceedHandler:(ReturnDataForCardViewBlock)suceedHandler;

- (void)reqLZNetDataPage:(NSInteger)page withSucceedHandler:(ReturnDataForCardViewBlock)suceedHandler;

- (void)reportWithType:(NSString *)reportType reportId:(NSString *)reportId desc:(NSString *)desc;

@end
