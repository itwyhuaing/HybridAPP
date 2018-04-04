//
//  PullRefreshViewController.h
//  hinabian
//
//  Created by 何松泽 on 15/10/20.
//  Copyright © 2015年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullRefreshViewController : UIViewController
{
    UIView *refreshHeaderView;
    
    UIImageView *refreshArrow;

    BOOL isDragging;
    BOOL isLoading;
}

@property (nonatomic, strong) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, strong) NSString *textPullRight;
@property (nonatomic, strong) NSString *textPullLeft;
@property (nonatomic, strong) NSString *textRelease;
@property (nonatomic, strong) NSString *textLoading;

@property (nonatomic, strong) UILabel *refreshLabelRight;
@property (nonatomic, strong) UILabel *refreshLabelLeft;
@property (nonatomic, assign) BOOL      refreshLeft;
@property (nonatomic, assign) BOOL      refreshRight;


@property (nonatomic, strong) UICollectionView *myRefreshview;

- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopRefreshing;
- (void)refresh;
@end
