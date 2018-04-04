//
//  PullRefreshViewController.m
//  hinabian
//
//  Created by 何松泽 on 15/10/20.
//  Copyright © 2015年 &#20313;&#22362;. All rights reserved.
//

#define REFRESH_HEADER_WIDTH        50.0f
#define CELL_EDGEINSETS             10.0f

#import "PullRefreshViewController.h"

@interface PullRefreshViewController ()

@end

@implementation PullRefreshViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    [self setupStrings];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self addPullToRefreshHeader];
    [self setupStrings];
    [self.myRefreshview setAlwaysBounceVertical:NO];
    [self.myRefreshview setAlwaysBounceHorizontal:YES];
}

-(void)setupStrings{
    self.textRelease = [NSString stringWithFormat:@"松开刷新"];
    self.textLoading = [NSString stringWithFormat:@"加载中"];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}


- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0 - REFRESH_HEADER_WIDTH, 0, REFRESH_HEADER_WIDTH, SCREEN_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    _refreshLabelRight = [[UILabel alloc] initWithFrame:CGRectMake(floorf((REFRESH_HEADER_WIDTH-50) / 2), floorf((SCREEN_HEIGHT-100) / 2), REFRESH_HEADER_WIDTH, 15)];
    _refreshLabelRight.font = [UIFont boldSystemFontOfSize:FONT_UI24PX];
    _refreshLabelRight.textColor = [UIColor DDLableBlue];
    _refreshLabelRight.textAlignment = NSTextAlignmentCenter;
    _refreshLabelRight.lineBreakMode = NSLineBreakByWordWrapping;
    
    _refreshLabelLeft = [[UILabel alloc] initWithFrame:CGRectMake(floorf((self.myRefreshview.contentSize.width+REFRESH_HEADER_WIDTH) / 2), floorf((SCREEN_HEIGHT-100) / 2), REFRESH_HEADER_WIDTH, 15)];
    _refreshLabelLeft.font = [UIFont boldSystemFontOfSize:FONT_UI24PX];
    _refreshLabelLeft.textColor = [UIColor DDLableBlue];
    _refreshLabelLeft.textAlignment = NSTextAlignmentCenter;
    _refreshLabelLeft.lineBreakMode = NSLineBreakByWordWrapping;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"afterzan.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_WIDTH-10) / 2),
                                    (floorf(SCREEN_HEIGHT-10) / 2),
                                    10, 10);
    
    _refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_WIDTH - 20) / 2), floorf((SCREEN_HEIGHT - 60) / 2), 30, 30);
    _refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:_refreshLabelRight];
    [refreshHeaderView addSubview:_refreshLabelLeft];
    [refreshHeaderView addSubview:_refreshSpinner];
    [self.myRefreshview addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _refreshLabelLeft.hidden = FALSE;
    _refreshLabelRight.hidden = FALSE;
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.x > 0){
        }else if (scrollView.contentOffset.x >= -REFRESH_HEADER_WIDTH){
            self.myRefreshview.contentInset = UIEdgeInsetsMake(0, REFRESH_HEADER_WIDTH, 0, 0);
        }
    } else if (isDragging && scrollView.contentOffset.x < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.x < -REFRESH_HEADER_WIDTH+10) {
                // User is scrolling above the header
                _refreshLabelRight.text = self.textRelease;
                
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            }
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.x >scrollView.contentSize.width - scrollView.bounds.size.width+REFRESH_HEADER_WIDTH) {
                _refreshLabelLeft.text = self.textRelease;
                
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            }
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.x <= -REFRESH_HEADER_WIDTH) {
        _refreshRight = TRUE;
        [self startLoading];
    }else if (scrollView.contentOffset.x >= scrollView.contentSize.width-scrollView.bounds.size.width+REFRESH_HEADER_WIDTH){
        _refreshLeft = TRUE;
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
    if (_refreshRight && !_refreshLeft) {
        _refreshLabelRight.hidden = NO;
        _refreshLabelRight.text = self.textLoading;
        refreshArrow.hidden = YES;
        [_refreshSpinner startAnimating];
        [UIView animateWithDuration:0.3 animations:^{
            self.myRefreshview.contentInset = UIEdgeInsetsMake(0, REFRESH_HEADER_WIDTH, 0, 0);
        }];
    }else if (_refreshLeft && !_refreshRight){
        _refreshLabelLeft.hidden = FALSE;
        _refreshLabelLeft.text = self.textLoading;
        refreshArrow.hidden = TRUE;
        [_refreshSpinner startAnimating];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.myRefreshview.contentInset = UIEdgeInsetsMake(0, -REFRESH_HEADER_WIDTH-self.myRefreshview.contentSize.width+self.myRefreshview.bounds.size.width, 0, 0);
        }];
    }
    
    // Refresh action!
    [self refresh];
}

- (void)stopRefreshing {
    isLoading = FALSE;
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        self.myRefreshview.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }completion:^(BOOL finished) {
        [self performSelector:@selector(stopLoadingComplete)];
    }];
    _refreshLeft = FALSE;
    _refreshRight = FALSE;
    _refreshLabelRight.hidden = TRUE;
    _refreshLabelLeft.hidden = TRUE;
}


- (void)stopLoadingComplete {
    // Reset the header
    _refreshLabelRight.text = self.textPullRight;
    _refreshLabelLeft.text = self.textPullLeft;
    refreshArrow.hidden = FALSE;
    [_refreshSpinner stopAnimating];
    
}

- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopRefreshing) withObject:nil afterDelay:1.0];
}


@end
