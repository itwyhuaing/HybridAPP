//
//  TribeShowProjectView.h
//  hinabian
//
//  Created by hnbwyh on 17/4/17.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshControl.h"
#import "TribeShowProjectManager.h"

@class TribeShowProjectView;
@protocol TribeShowProjectViewDelegate <NSObject>
@optional
- (void)scrollTribeShowProjectView:(TribeShowProjectView *)proView resetFrameWithYOffset:(CGFloat)yOffset;

@end

@interface TribeShowProjectView : UIView

@property (nonatomic,weak) id<TribeShowProjectViewDelegate> delegate;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) TribeShowProjectManager *manager;
@property (nonatomic,strong) RefreshControl *refreshControl;

@property (nonatomic) NSInteger countPerReq;
@property (nonatomic) NSInteger allPost;
@property (nonatomic) NSInteger currentPost;

- (void)getData:(NSArray *)data;

-(instancetype)initWithFrame:(CGRect)frame tribeID:(NSString *)tribeID superVC:(UIViewController *)superVC;

@end
