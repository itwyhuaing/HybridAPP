//
//  TribeDetailInfoCellManager.h
//  hinabian
//
//  Created by hnbwyh on 16/10/24.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FloorCommentModel;

@interface TribeDetailInfoCellManager : NSObject

/**
 * cell 整体高度 <楼层下的回复只去5个>
 */
@property (nonatomic) CGFloat cellHeight;

/**
 * 楼层评论部分的固定高度 ： 100
 */
@property (nonatomic) CGFloat floorStaticHeight;

/**
 * 楼层评论的动态 size
 */
@property (nonatomic) CGSize floorCommentSize;

/**
 * 楼层下每一个回复的固定高度 ： 50
 */
@property (nonatomic) CGFloat replyFloorStaticHeight;

/**
 * replyFloorCommentHeights - 回复楼层的评论高度（含固定高度）
 */
@property (nonatomic,strong) NSMutableArray *replyFloorCommentHeights;

/**
 * 查看更多按钮 高度
 */
@property (nonatomic) CGFloat seeMoreHeight;

/**
 * 记录当前 cell - IndexPath
 */
@property (nonatomic,strong) NSIndexPath *currentIndexPath;

/**
 * 数据模型
 */
@property (nonatomic,strong) FloorCommentModel *model;

@end
