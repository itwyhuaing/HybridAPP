//
//  HotIMProjectManager.h
//  hinabian
//
//  Created by hnbwyh on 2017/11/6.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HotIMProjectManager;
@protocol HotIMProjectManagerDelegate <NSObject>
@optional
- (void)hotIMProjectManagerReqNetSucWithDataSource:(id)dataSource reqStatus:(BOOL)rs;
- (void)hotIMProjectManagerReqNetFailWithError:(NSError *)error reqStatus:(BOOL)rs;

@end

@interface HotIMProjectManager : NSObject

@property (nonatomic,weak) id <HotIMProjectManagerDelegate> delegate;

- (void)reqHotIMProjectData;

@end
