//
//  FloorCommentReplyModel.h
//  hinabian
//
//  Created by hnbwyh on 16/10/20.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

/*
  该模型对应于 帖子详情 - 针对楼层评论的回复部分
 */

#import <Foundation/Foundation.h>
@class FloorCommentUserInfoModel;

@interface FloorCommentReplyModel : NSObject

@property (nonatomic,copy) NSString *comment_id; // 楼层的id
@property (nonatomic,copy) NSString *content_for_app;
@property (nonatomic,copy) NSString *replyModel_id; // id - 该条回复的 id
@property (nonatomic,copy) NSString *show_time;
@property (nonatomic,strong) FloorCommentUserInfoModel *u_info;

/*
  楼层下的回复数据数组 - HTMLModel
 */
@property (nonatomic,strong) NSMutableArray *replyContentArr;

@end
