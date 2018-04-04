//
//  CouponMainView.m
//  hinabian
//
//  Created by hnb on 16/4/13.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "CouponMainView.h"
#import "hnbSegmentedView.h"
#import "UnusedView.h"
#import "OutOfDateView.h"
#import "BeenUsedView.h"


@interface CouponMainView ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) hnbSegmentedView *segmentedview;
@property (strong, nonatomic) UnusedView *firstView;
@property (strong, nonatomic) OutOfDateView *secondView;
@property (strong, nonatomic) BeenUsedView *thirdView;
@end

#define SEGMENT_HEIGHT 44

@implementation CouponMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self initView];

    }
    return self;
}


/**
 *  初始化view
 */
-(void) initView:(NSInteger) unuse OutOfDate:(NSInteger) outofdate BeenUsed:(NSInteger) beenused
{
    _segmentedview =[[hnbSegmentedView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SEGMENT_HEIGHT) titles:@[[NSString stringWithFormat:@"未使用(%ld)",(long)unuse],[NSString stringWithFormat:@"已过期(%ld)",(long)outofdate],[NSString stringWithFormat:@"已使用(%ld)",(long)beenused]] clickBlick:^void(NSInteger index) {
        [self setPageIndex:index];
        
    }];
    _segmentedview.titleNomalColor=[UIColor colorWithRed:78.0/255.0f green:78.0/255.0f blue:78.0/255.0f alpha:1.0f];
    _segmentedview.titleSelectColor=[UIColor DDNavBarBlue];
    [self addSubview:_segmentedview];

    _scrollView = [[UIScrollView alloc]  initWithFrame:CGRectMake(0, SEGMENT_HEIGHT, self.frame.size.width, self.frame.size.height - SEGMENT_HEIGHT)];
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height - SEGMENT_HEIGHT);
    _scrollView.pagingEnabled = TRUE;
    _scrollView.delegate = self;
    
    _firstView = [[UnusedView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height - 66)];
    [_scrollView addSubview:_firstView];
    
    _secondView = [[OutOfDateView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height - 66)];
    [_scrollView addSubview:_secondView];
    
    _thirdView = [[BeenUsedView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width * 2, 0, _scrollView.frame.size.width, _scrollView.frame.size.height - 66)];
    [_scrollView addSubview:_thirdView];
    
    [self addSubview:_scrollView];
    

}

-(void) setPageIndex:(NSInteger) index
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * (index - 1), 0) animated:TRUE];
    
    [HNBClick event:[NSString stringWithFormat:@"10601%ld",index] Content:nil];
}

- (void) setCouponMainData:(NSMutableArray *) inUseArray UnUsed:(NSMutableArray *) usedArray OutOfDate:(NSMutableArray *) outOfDateArray
{

    [self initView:inUseArray.count OutOfDate:outOfDateArray.count BeenUsed:usedArray.count];
    _firstView.dataArray = inUseArray;
    _secondView.dataArray = outOfDateArray;
    _thirdView.dataArray = usedArray;
    if (inUseArray.count == 0) {
        [_firstView setNothing];
    }
    if (outOfDateArray.count == 0) {
        [_secondView setNothing];
    }
    if (usedArray.count == 0) {
        [_thirdView setNothing];
    }
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    int page = (int)round(scrollView.contentOffset.x / scrollView.frame.size.width);
    [_segmentedview setIndex:page];
}

@end
