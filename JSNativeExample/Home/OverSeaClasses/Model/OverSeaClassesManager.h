//
//  OverSeaClassesManager.h
//  hinabian
//
//  Created by hnbwyh on 2018/4/3.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OverSeaClassModel.h"

@class OverSeaClassesManager;
@protocol OverSeaClassesManagerDelegate <NSObject>
@optional
- (void)OverSeaClassesWithType:(NSString *)type curPage:(NSString *)page data:(id)data isCache:(BOOL)isCache;

@end

@interface OverSeaClassesManager : NSObject

@property (nonatomic,weak) id <OverSeaClassesManagerDelegate> delegate;

- (void)reqNetDataWithType:(NSString *)type page:(NSString *)page num:(NSString *)num;

- (NSArray *)filterDataSource:(NSArray<OverSeaClassModel *> *)ds extraData:(NSArray<OverSeaClassModel *> *)ed;

@end
