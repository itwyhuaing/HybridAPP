//
//  ReplyDetaiInfoDataManager.h
//  hinabian
//
//  Created by hnbwyh on 16/11/15.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ReturnDataForReplyDetailViewBlock)(id data);

@interface ReplyDetaiInfoDataManager : NSObject

/**
 * 举报接口
 */
- (void)reportWithType:(NSString *)reportType reportId:(NSString *)reportId desc:(NSString *)desc;

/**
 * 获取全部回复接口
 */

- (void)reqAllCommentsForTheFloorWithCommentId:(NSString *)commentId successBlock:(ReturnDataForReplyDetailViewBlock)dataBlock;

@end
