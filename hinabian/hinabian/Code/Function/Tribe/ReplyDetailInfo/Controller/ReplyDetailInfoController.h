//
//  ReplyDetailInfoController.h
//  hinabian
//
//  Created by hnbwyh on 16/11/14.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWKBaseViewController.h"

@class TribeDetailInfoCellManager;

@interface ReplyDetailInfoController : SWKBaseViewController

/**
 * 又帖子详情进入时，携带所有数据信息
 */
@property (nonatomic,strong) TribeDetailInfoCellManager *manager;

/**
 * 楼层评论 id
 */
@property (nonatomic,copy) NSString *floorID;

/**
 * 帖子 id
 */
@property (nonatomic,strong) NSString *themeId;

@end
