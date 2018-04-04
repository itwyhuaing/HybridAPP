//
//  HotestView.h
//  hinabian
//
//  Created by hnbwyh on 16/6/22.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshControl.h"
#import "HotestManager.h"


@class HotestView;
@protocol HotestViewDelegate <NSObject>
@optional
- (void)scrollHotestView:(HotestView *)hotestView resetFrameWithYOffset:(CGFloat)yOffset;

@end


@interface HotestView : UIView

@property (nonatomic,weak) id<HotestViewDelegate> delegate;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) HotestManager *manager;
@property (nonatomic,strong) RefreshControl *refreshControl;

@property (nonatomic) NSInteger countPerReq;
@property (nonatomic) NSInteger allPost;
@property (nonatomic) NSInteger currentPost;

- (void)getData:(NSArray *)data;

-(instancetype)initWithFrame:(CGRect)frame tribeID:(NSString *)tribeID superVC:(UIViewController *)superVC;

@end
