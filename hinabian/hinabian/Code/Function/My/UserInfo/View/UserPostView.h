//
//  UserPostView.h
//  hinabian
//
//  Created by 何松泽 on 16/12/19.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserinfoHisPostManager.h"

@class UserPostView;
@protocol UserPostViewDelegate <NSObject>
@optional

/**
 * 滚动动画
 */
- (void)scrollUserPostView:(UserPostView *)userPostView resetFrameWithYOffset:(CGFloat)yOffset;

/**
 * 开始刷新时隐藏提问按钮
 */
- (void)hiddenTheAskButtonWhenScrollUserPostView:(UserPostView *)userPostView;


/**
 * 刷新数据后显示提问按钮
 */
- (void)showTheAskButtonWhenEndRefreshScrollUserPostView:(UserPostView *)userPostView;


@end

@interface UserPostView : UIView

@property (nonatomic,strong) UserinfoHisPostManager *hisPostManager;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *postSource;
@property (nonatomic, weak ) id<UserPostViewDelegate> delegate;
@property (nonatomic) NSInteger countPerReq;

- (instancetype)initWithFrame:(CGRect)frame personid:(NSString *)personid superVC:(UIViewController *)superVC;

- (void)getDataSource:(NSArray *)dataSource;

@end
