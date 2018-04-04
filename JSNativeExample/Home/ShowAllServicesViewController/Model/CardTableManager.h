//
//  CardTableManager.h
//  hinabian
//
//  Created by hnbwyh on 2018/3/28.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CardTableManager;
@protocol CardTableManagerDelegate <NSObject>
@optional
- (void)cardTableData:(id)data;

@end


@interface CardTableManager : NSObject

@property (nonatomic,weak) id <CardTableManagerDelegate> delegate;

- (void)reqOverSeaServiceListWithType:(NSString *)type start:(NSInteger)start num:(NSInteger)num;

@end
