//
//  ReplyTableViewCell.h
//  TextImageDemo
//
//  Created by hnbwyh on 16/10/8.
//  Copyright © 2016年 hnbwyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TribeDetailInfoCellManager;
@class FloorCommentView;
@class YYLabel;

@class ReplyTableViewCell;
@protocol ReplyTableViewCellDelegate <NSObject>
@optional
- (void)replyTableViewCell:(ReplyTableViewCell *)cell eventSource:(id)eventSource info:(id)info;

@end


// 按钮 Tag 标记 
#define BUTTON_TAG_BASENUM 100

typedef enum : NSUInteger {
    ReplyTableViewCellIconTag = BUTTON_TAG_BASENUM,
    ReplyTableViewCellOperationTag,
    ReplyTableViewCellCommentTag,
    ReplyTableViewCellSupportTag,
    ReplyTableViewCellReportTag,
    ReplyTableViewCellSeeMoreTag,
} ReplyTableViewCellClickEventTag;

typedef enum : NSUInteger {
    ReplyTableViewCellTribeDetail = 150,
    ReplyTableViewCellReplyDetail,
} ReplyTableViewCellStyle;


static NSString *cellNib_ReplyTableViewCell = @"ReplyTableViewCell";
@interface ReplyTableViewCell : UITableViewCell

/**
 * 用于区分 帖子详情与回复详情两处不同地方的cell
 */
@property (nonatomic) ReplyTableViewCellStyle cellStyle;

/**
 * 传递 点击事件 delegate
 */
@property (nonatomic,weak) id<ReplyTableViewCellDelegate> delegate;

/**
 * 携带 cell 布局及赋值所需信息
 */
@property (nonatomic,strong) TribeDetailInfoCellManager *manager;


@end
