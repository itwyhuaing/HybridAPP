//
//  QAMainView.m
//  hinabian
//
//  Created by 余坚 on 16/7/25.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "QAMainView.h"
#import "hnbSegmentedView.h"

#define SEGMENT_HEIGHT 44
#define SEARCH_BAR_HEIGHT 44
#define ASK_AND_SEARCH_HEIGHT 28
#define ASK_BUTTON_WIDTH 47
#define EACH_DISTANCE 10
#define SEARCH_ICON_WIDTH 11.5
#define SEARCH_ICON_HEIGHT 13

@interface QAMainView ()<UIScrollViewDelegate,hnbSegmentedViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) hnbSegmentedView *segmentedview;
@property (strong, nonatomic) UILabel *placeHoldLabel;
@end

@implementation QAMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
        [self initView];
        
    }
    return self;
}


/**
 *  初始化view
 */
-(void) initView
{
    [self setBackgroundColor:[UIColor beigeColor]];
    /* 搜索提问 view */
    [self addSearchAndAskBar];
    /* 标签页 */
    _segmentedview =[[hnbSegmentedView alloc] initWithFrame:CGRectMake(0, SEARCH_BAR_HEIGHT, SCREEN_WIDTH, SEGMENT_HEIGHT) titles:@[[NSString stringWithFormat:@"精选"],[NSString stringWithFormat:@"筛选 ▾"]] clickBlick:^void(NSInteger index) {
        [self setPageIndex:index];
        
    }];
    _segmentedview.x_0ffset = 30 * SCREEN_SCALE;
    _segmentedview.titleNomalColor=[UIColor colorWithRed:78.0/255.0f green:78.0/255.0f blue:78.0/255.0f alpha:1.0f];
    _segmentedview.titleSelectColor=[UIColor DDNavBarBlue];
    _segmentedview.normalLineHeight = 0.3;
    _segmentedview.delegate = (id)self;
    [self addSubview:_segmentedview];
    
    _scrollView = [[UIScrollView alloc]  initWithFrame:CGRectMake(0, SEGMENT_HEIGHT + SEARCH_BAR_HEIGHT, self.frame.size.width, self.frame.size.height - SEGMENT_HEIGHT - SEARCH_BAR_HEIGHT)];
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * 2, self.frame.size.height - SEGMENT_HEIGHT - SEARCH_BAR_HEIGHT);
    _scrollView.pagingEnabled = TRUE;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    
    _firstView = [[QARecommendView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height - 64)];
    [_scrollView addSubview:_firstView];
    
    _secondView = [[QAFilterView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height - 64)];
    [_scrollView addSubview:_secondView];
    
    [self addSubview:_scrollView];
    
    
}

/* 搜索提问 view */
-(void) addSearchAndAskBar
{
    UIButton *askButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - EACH_DISTANCE - ASK_BUTTON_WIDTH, (SEARCH_BAR_HEIGHT - ASK_AND_SEARCH_HEIGHT) / 2, ASK_BUTTON_WIDTH, ASK_AND_SEARCH_HEIGHT)];
    [askButton setTitle:@"提问" forState:UIControlStateNormal];
    [askButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [askButton.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI24PX]];
    [askButton setBackgroundColor:[UIColor DDNavBarBlue]];
    [askButton addTarget:self action:@selector(gotoAskQuestion) forControlEvents:UIControlEventTouchUpInside];
    askButton.layer.cornerRadius = RRADIUS_LAYERCORNE;
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(EACH_DISTANCE, (SEARCH_BAR_HEIGHT - ASK_AND_SEARCH_HEIGHT) / 2, SCREEN_WIDTH - EACH_DISTANCE*3 - ASK_BUTTON_WIDTH, ASK_AND_SEARCH_HEIGHT)];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.cornerRadius = RRADIUS_LAYERCORNE;
    
    UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, (ASK_AND_SEARCH_HEIGHT - SEARCH_ICON_HEIGHT)/2, SEARCH_ICON_WIDTH, SEARCH_ICON_HEIGHT)];
    [searchImage setImage:[UIImage imageNamed:@"search_search_icon"]];
    _placeHoldLabel = [[UILabel alloc] initWithFrame:CGRectMake(5*2 + SEARCH_ICON_WIDTH,  (ASK_AND_SEARCH_HEIGHT - SEARCH_ICON_HEIGHT)/2, searchView.frame.size.width - 5*2 + SEARCH_ICON_WIDTH, SEARCH_ICON_HEIGHT)];
    //_placeHoldLabel.text = @"已有8888个人在这里找到答案";
    _placeHoldLabel.textAlignment = NSTextAlignmentLeft;
    _placeHoldLabel.textColor = [UIColor DDPlaceHoldGray];
    _placeHoldLabel.font = [UIFont systemFontOfSize:FONT_UI24PX];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:searchView.frame];
    [searchButton setBackgroundColor:[UIColor clearColor]];
    [searchButton addTarget:self action:@selector(gotoSearchQuestion) forControlEvents:UIControlEventTouchUpInside];
    
    
    [searchView addSubview:searchImage];
    [searchView addSubview:_placeHoldLabel];
    
    
    
    [self addSubview:askButton];
    [self addSubview:searchView];
    [self addSubview:searchButton];
}

- (void) setSearchPlaceHold:(NSString *)placeHold
{
    _placeHoldLabel.text = placeHold;
}

-(void) setPageIndex:(NSInteger) index
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * (index - 1), 0) animated:TRUE];
}

- (void) setFirstViewRefreshBottom:(BOOL)hide
{
    _firstView.refreshControl.bottomEnabled = hide;
}
/* 重新加载推荐页 */
- (void) reloadQAIndexData
{
    [_firstView reloadQAIndexData];
    [_firstView.tableView reloadData];

}

/* 重新加载推荐页 */
- (void) reloadQAIndexFilterData
{
    [_secondView reloadQAFilterData];
}

/* 设置筛选页bottom刷新 */
- (void) setFilterViewBottomFresh:(BOOL) isTrue
{
    _secondView.refreshControl.bottomEnabled = isTrue;
}

/* 设置精选页bottom刷新 */
- (void) setIndexViewBottomFresh:(BOOL) isTrue
{
    _firstView.refreshControl.bottomEnabled = isTrue;
}

/* 停止精选页bottom刷新 */
- (void) stopIndexViewBottomFresh
{
    [_firstView.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
}

- (void) stopIndexViewTopFresh
{
    [_firstView.refreshControl finishRefreshingDirection:RefreshDirectionTop];
}

/* 去提问 */
- (void) gotoAskQuestion
{
    [[NSNotificationCenter defaultCenter] postNotificationName:QA_INDEX_GOTO_ASK_QUESTION object:nil];
}

/* 去搜索 */
- (void) gotoSearchQuestion
{
    [[NSNotificationCenter defaultCenter] postNotificationName:QA_INDEX_GOTO_SEARCH object:nil];
}

- (void) hideFilterView
{
    [_secondView hideFilterView];
}
- (void) choseSegmentView:(NSInteger) index
{
    [_segmentedview setIndex:(int)index];
    [self setPageIndex:(index+1)];
}

- (BOOL) isLabelSelectEmpty
{
    return [_secondView isSelectLabelEmpty];
}
#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    int page = (int)round(scrollView.contentOffset.x / scrollView.frame.size.width);
    [_segmentedview setIndex:page];
}

#pragma hnbSegmentedViewDelegate
-(void) titleButtonPressed:(NSInteger) tag
{
    if (2 == tag) {
        [_secondView ShowFilterView];
    }
}

@end
