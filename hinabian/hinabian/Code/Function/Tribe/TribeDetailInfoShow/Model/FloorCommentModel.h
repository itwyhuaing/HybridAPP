//
//  FloorCommentModel.h
//  hinabian
//
//  Created by hnbwyh on 16/10/20.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

/*
 该模型对应于 帖子详情 - 楼层评论
 */

#import <Foundation/Foundation.h>
@class FloorCommentUserInfoModel;

@interface FloorCommentModel : NSObject

@property (nonatomic,copy) NSString *floor;
@property (nonatomic,copy) NSString *floorId; // id - 楼层 id
@property (nonatomic,copy) NSString *show_time;
@property (nonatomic,copy) NSString *praise;
@property (nonatomic) BOOL praised;
@property (nonatomic,copy) NSString *content_for_app;

@property (nonatomic,strong) FloorCommentUserInfoModel *u_info;

@property (nonatomic,strong) NSArray *floorContentArr;  // 楼层评论内容 ： HTMLModel

@property (nonatomic,strong) NSMutableArray *reply_infoArr; // 楼层下的回复模型数组 ：FloorCommentReplyModel

/*
 某一楼层下的回复的 总条数。策略问题:针对楼层的回复过多时显示“点击查看更多”按钮，跳转到具体界面查看 ！第一次取的数据条数 < total 时跳转
 */
@property (nonatomic,copy) NSString *replyTotal_UnderFloor;

@end
