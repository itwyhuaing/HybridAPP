//
//  UserReplyView.h
//  hinabian
//
//  Created by 何松泽 on 16/12/19.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserinfoHisReplyManager.h"

@class UserReplyView;
@protocol UserReplyViewDelegate <NSObject>
@optional

/**
 * 滚动动画
 */
- (void)scrollUserReplyView:(UserReplyView *)userReplyView resetFrameWithYOffset:(CGFloat)yOffset;

/**
 * 开始刷新时隐藏提问按钮
 */
- (void)hiddenTheAskButtonWhenScrollUserReplyView:(UserReplyView *)userReplyView;


/**
 * 刷新数据后显示提问按钮
 */
- (void)showTheAskButtonWhenEndRefreshScrollUserReplyView:(UserReplyView *)userReplyView;


@end

@interface UserReplyView : UIView

@property (nonatomic,strong) UserinfoHisReplyManager *hisReplyManager;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *replySource;
@property (nonatomic, weak ) id<UserReplyViewDelegate> delegate;
@property (nonatomic) NSInteger countPerReq;


- (instancetype)initWithFrame:(CGRect)frame personid:(NSString *)personid superVC:(UIViewController *)superVC;

- (void)getDataSource:(NSArray *)dataSource;

@end
