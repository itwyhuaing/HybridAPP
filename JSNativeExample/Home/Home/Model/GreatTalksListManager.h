//
//  GreatTalksListManager.h
//  hinabian
//
//  Created by hnbwyh on 2017/10/30.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GreatTalksListManager;
@protocol GreatTalksListManagerDelegate <NSObject>
@optional
- (void)greatTalksListManagerReqNetSucWithDataSource:(id)dataSource reqStatus:(BOOL)rs;
- (void)greatTalksListManagerReqNetFailWithError:(NSError *)error reqStatus:(BOOL)rs;

@end

@interface GreatTalksListManager : NSObject

@property (nonatomic,weak) id <GreatTalksListManagerDelegate> delegate;

- (void)reqGreatTalksListData;

@end
