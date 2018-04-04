//
//  UserQAView.h
//  hinabian
//
//  Created by hnbwyh on 16/7/25.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserinfoQAManager.h"

@class UserQAView;
@protocol UserQAViewDelegate <NSObject>
@optional
/**
 * 滚动动画
 */
- (void)scrollUserQAView:(UserQAView *)UserQAView resetFrameWithYOffset:(CGFloat)yOffset;

/**
 * 开始刷新时隐藏提问按钮
 */
- (void)hiddenTheAskButtonWhenScrollUserQAView:(UserQAView *)userQAView;


/**
 * 刷新数据后显示提问按钮
 */
- (void)showTheAskButtonWhenEndRefreshScrollUserQAView:(UserQAView *)userQAView;


@end

@interface UserQAView : UIView

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UserinfoQAManager *qaManager;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,weak) id<UserQAViewDelegate> delegate;
@property (nonatomic) NSInteger countPerReq;

-(instancetype)initWithFrame:(CGRect)frame personid:(NSString *)personid superVC:(UIViewController *)superVC;

@end
