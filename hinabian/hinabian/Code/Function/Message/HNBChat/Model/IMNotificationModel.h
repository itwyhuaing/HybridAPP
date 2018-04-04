//
//  IMNotificationModel.h
//  hinabian
//
//  Created by 何松泽 on 2018/1/29.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMNotificationModel : NSObject

/**
 * 通知类型(1 - 回复；2 - 点赞)
 */
@property (nonatomic, strong) NSString *f_type;

/**
 * 帖子标题
 */
@property (nonatomic, strong) NSString *f_title;

/**
 * 回复的内容(点赞为空)
 */
@property (nonatomic, strong) NSString *f_content;

/**
 * 回复的时间
 */
@property (nonatomic, strong) NSString *f_create_time;

/**
 * 是否未读(1 - 已读；2 - 未读)
 */
@property (nonatomic, strong) NSString *f_is_read;

/**
* 跳转的url
*/
@property (nonatomic, strong) NSString *f_jump_url;

/**
 * 回复、点赞的用户
 */
@property (nonatomic, strong) NSArray *users;

/**
 * 点赞总数
 */
@property (nonatomic, strong) NSString *total;

@end
