//
//  FloorCommentUserInfoModel.h
//  hinabian
//
//  Created by hnbwyh on 16/10/20.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

/*
 该模型对应于 帖子详情 - 楼层评论用户信息
 */

#import <Foundation/Foundation.h>

@interface FloorCommentUserInfoModel : NSObject

@property (nonatomic,copy) NSString *id;// id
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *head_url;
@property (nonatomic,copy) NSString *im_nation_cn;
@property (nonatomic,copy) NSString *im_state_cn;
@property (nonatomic,copy) NSString *certified_type;
@property (nonatomic,copy) NSString *certified;
@property (nonatomic,copy) NSDictionary *levelInfo;
@property (nonatomic,copy) NSArray  *moderator;

@end
