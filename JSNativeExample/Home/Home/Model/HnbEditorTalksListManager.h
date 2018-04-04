//
//  HnbEditorTalksListManager.h
//  hinabian
//
//  Created by hnbwyh on 2017/10/27.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HnbEditorTalksListManager;
@protocol HnbEditorTalksListManagerDelegate <NSObject>
@optional
- (void)hnbEditorTalksListReqNetSucWithDataSource:(id)dataSource reqStatus:(BOOL)rs;
- (void)hnbEditorTalksListReqNetFailWithError:(NSError *)error reqStatus:(BOOL)rs;

@end

@interface HnbEditorTalksListManager : NSObject

@property (nonatomic,weak) id <HnbEditorTalksListManagerDelegate> delegate;

- (void)reqHnbEditorTalksListData;

@end
