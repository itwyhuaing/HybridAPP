//
//  LatestView.h
//  hinabian
//
//  Created by hnbwyh on 16/6/22.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshControl.h"
#import "LatestManager.h"

@class LatestView;
@protocol LatestViewDelegate <NSObject>
@optional
- (void)scrollLatestViewView:(LatestView *)latestView resetFrameWithYOffset:(CGFloat)yOffset;

@end

@interface LatestView : UIView

@property (nonatomic,weak) id<LatestViewDelegate> delegate;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) LatestManager *manager;
@property (nonatomic,strong) RefreshControl *refreshControl;

@property (nonatomic) NSInteger countPerReq;
@property (nonatomic) NSInteger allPost;
@property (nonatomic) NSInteger currentPost;

- (void)getData:(NSArray *)data;

-(instancetype)initWithFrame:(CGRect)frame tribeID:(NSString *)tribeID superVC:(UIViewController *)superVC;

@end
