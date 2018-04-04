//
//  ReplyDetaiInfoDataManager.m
//  hinabian
//
//  Created by hnbwyh on 16/11/15.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "ReplyDetaiInfoDataManager.h"
#import "DataFetcher.h"


@implementation ReplyDetaiInfoDataManager

- (void)reportWithType:(NSString *)reportType reportId:(NSString *)reportId desc:(NSString *)desc{
    
    
    [DataFetcher doReportWithType:reportType reportId:reportId desc:desc withSucceedHandler:^(id JSON) {
        
        
        
    } withFailHandler:^(id error) {
        
        
        
    }];
    
}

-(void)reqAllCommentsForTheFloorWithCommentId:(NSString *)commentId successBlock:(ReturnDataForReplyDetailViewBlock)dataBlock{

    [DataFetcher doGetCommentDetailWithCommentId:commentId withSucceedHandler:^(id JSON) {
        
        if (dataBlock) {
            dataBlock(JSON);
        }
        
    } withFailHandler:^(id error) {
        
        
        
        
    }];
    
}

@end
