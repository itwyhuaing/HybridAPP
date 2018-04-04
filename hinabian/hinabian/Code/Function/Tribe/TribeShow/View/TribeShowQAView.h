//
//  TribeShowQAView.h
//  hinabian
//
//  Created by hnbwyh on 17/4/17.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshControl.h"
#import "TribeShowQAManager.h"

@class TribeShowQAView;
@protocol TribeShowQAViewDelegate <NSObject>
@optional
- (void)scrollTribeShowQAView:(TribeShowQAView *)qaView resetFrameWithYOffset:(CGFloat)yOffset;

@end


@interface TribeShowQAView : UIView

@property (nonatomic,weak) id<TribeShowQAViewDelegate> delegate;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) TribeShowQAManager *manager;
@property (nonatomic,strong) RefreshControl *refreshControl;

@property (nonatomic) NSInteger countPerReq;
@property (nonatomic) NSInteger allPost;
@property (nonatomic) NSInteger currentPost;

- (void)getData:(NSArray *)data;

-(instancetype)initWithFrame:(CGRect)frame tribeID:(NSString *)tribeID superVC:(UIViewController *)superVC;

@end
