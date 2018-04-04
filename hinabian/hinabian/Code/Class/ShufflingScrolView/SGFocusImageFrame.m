//
//  ShufllingScrolView.m
//  hinabian
//
//  Created by 余坚 on 15/7/11.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import <objc/runtime.h>


@interface SGFocusImageFrame () {
    UIScrollView *_scrollView;
    //    GPSimplePageView *_pageControl;
    UIPageControl *_pageControl;
}
@property (nonatomic, strong)  NSTimer *timer;
@property(nonatomic) NSInteger autoCurrentPage;
- (void)setupViews;
- (void)switchFocusImageItems;
@end

static NSString *SG_FOCUS_ITEM_ASS_KEY = @"loopScrollview";

static CGFloat SWITCH_FOCUS_PICTURE_INTERVAL = 5.0; //switch interval time

@implementation SGFocusImageFrame
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate focusImageItems:(SGFocusImageItem *)firstItem, ...
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *imageItems = [NSMutableArray array];
        SGFocusImageItem *eachItem;
        va_list argumentList;
        if (firstItem)
        {
            [imageItems addObject: firstItem];
            va_start(argumentList, firstItem);
            while((eachItem = va_arg(argumentList, SGFocusImageItem *)))
            {
                [imageItems addObject: eachItem];
            }
            va_end(argumentList);
        }
        
        objc_setAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        _isAutoPlay = YES;
        [self setupViews];
        
        [self setDelegate:delegate];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate imageItems:(NSArray *)items isAuto:(BOOL)isAuto
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSMutableArray *imageItems = [NSMutableArray arrayWithArray:items];
        objc_setAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        _isAutoPlay = isAuto;
        [self setupViews];
        
        [self setDelegate:delegate];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate imageItems:(NSArray *)items
{
    return [self initWithFrame:frame delegate:delegate imageItems:items isAuto:YES];
}

/*- (void)dealloc
{
    objc_setAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    _scrollView.delegate = nil;
    [_scrollView release];
    [_pageControl release];
    [super dealloc];
}*/


#pragma mark - private methods
- (void)setupViews
{
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.scrollsToTop = NO;
    float space = 0;
    CGSize size = CGSizeMake(SCREEN_WIDTH, 0);
    //    _pageControl = [[GPSimplePageView alloc] initWithFrame:CGRectMake(self.bounds.size.width *.5 - size.width *.5, self.bounds.size.height - size.height, size.width, size.height)];
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, self.frame.size.height -11, 80, 5)];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.4f];
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
    
    /*
     _scrollView.layer.cornerRadius = 10;
     _scrollView.layer.borderWidth = 1 ;
     _scrollView.layer.borderColor = [[UIColor lightGrayColor ] CGColor];
     */
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    
    _pageControl.numberOfPages = imageItems.count>1?imageItems.count -2:imageItems.count;
    _pageControl.currentPage = 0;
    CGSize pointSize = [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages];
    CGFloat page_x = -(_pageControl.bounds.size.width - pointSize.width) / 2 ;
    [_pageControl setBounds:CGRectMake(page_x, _pageControl.bounds.origin.y, _pageControl.bounds.size.width, _pageControl.bounds.size.height)];

    _scrollView.delegate = self;
    
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tapGestureRecognize];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * imageItems.count, _scrollView.frame.size.height);
    
    for (int i = 0; i < imageItems.count; i++) {
//        SGFocusImageItem *item = [imageItems objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * _scrollView.frame.size.width+space, space, _scrollView.frame.size.width-space*2, _scrollView.frame.size.height-2*space-size.height)];
        //加载图片
        SGFocusImageItem * f = imageItems[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:f.image]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        imageView.clipsToBounds = YES;
        [_scrollView addSubview:imageView];
        //[imageView release];
    }
    //[tapGestureRecognize release];
    if ([imageItems count]>1)
    {
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO] ;
        if (_isAutoPlay)
        {
            //[self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
            _timer = [NSTimer scheduledTimerWithTimeInterval:SWITCH_FOCUS_PICTURE_INTERVAL target:self selector:@selector(switchFocusImageItems) userInfo:nil repeats:NO];

        }
        
    }
    _autoCurrentPage = _pageControl.currentPage;
    
    //objc_setAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)switchFocusImageItems
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    targetX = (int)(targetX/SCREEN_WIDTH) * SCREEN_WIDTH;
    [self moveToTargetPosition:targetX];
    
    if ([imageItems count] >1 && _isAutoPlay)
    {
        //[self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
        _timer = [NSTimer scheduledTimerWithTimeInterval:SWITCH_FOCUS_PICTURE_INTERVAL target:self selector:@selector(switchFocusImageItems) userInfo:nil repeats:NO];
    }
    
}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%s", __FUNCTION__);
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    int page = (int)(_scrollView.contentOffset.x / _scrollView.frame.size.width);
    if (page > -1 && page < imageItems.count) {
        SGFocusImageItem *item = [imageItems objectAtIndex:page];
        if ([self.delegate respondsToSelector:@selector(foucusImageFrame:didSelectItem:)]) {
            [self.delegate foucusImageFrame:self didSelectItem:item];
        }
    }
}

- (void)moveToTargetPosition:(CGFloat)targetX
{
    BOOL animated = YES;
    //    NSLog(@"moveToTargetPosition : %f" , targetX);
    _autoCurrentPage = _pageControl.currentPage;
    [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:animated];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float targetX = scrollView.contentOffset.x;
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    if ([imageItems count]>=3)
    {
        if (targetX >= SCREEN_WIDTH * ([imageItems count] -1)) {
            targetX = SCREEN_WIDTH;
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
        else if(targetX <= 0)
        {
            targetX = SCREEN_WIDTH *([imageItems count]-2);
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
    }
    int page = (_scrollView.contentOffset.x+SCREEN_WIDTH/2.0) / SCREEN_WIDTH;
    //    NSLog(@"%f %d",_scrollView.contentOffset.x,page);
    if ([imageItems count] > 1)
    {
        page --;
        if (page >= _pageControl.numberOfPages)
        {
            page = 0;
        }else if(page <0)
        {
            page = (int)(_pageControl.numberOfPages -1);
        }
    }
    if (page!= _pageControl.currentPage)
    {
        /*if ([self.delegate respondsToSelector:@selector(foucusImageFrame:currentItem:)])
        {
            [self.delegate foucusImageFrame:self currentItem:page];
        }*/
    }
    if (_autoCurrentPage != _pageControl.currentPage) {
        
        if (_timer != nil) {
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:SWITCH_FOCUS_PICTURE_INTERVAL target:self selector:@selector(switchFocusImageItems) userInfo:nil repeats:NO];
        
    }
    _pageControl.currentPage = page;

}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
        targetX = (int)(targetX/SCREEN_WIDTH) * SCREEN_WIDTH;
        [self moveToTargetPosition:targetX];
    }
}


- (void)scrollToIndex:(int)aIndex
{
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    if ([imageItems count]>1)
    {
        if (aIndex >= ([imageItems count]-2))
        {
            aIndex = (int)([imageItems count]-3);
        }
        [self moveToTargetPosition:SCREEN_WIDTH*(aIndex+1)];
    }else
    {
        [self moveToTargetPosition:0];
    }
    [self scrollViewDidScroll:_scrollView];
    
}

- (void)dealloc
{
//    if ([_timer isValid]) {
//        [_timer invalidate];
//        _timer = nil;
//    }
    
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    
}
@end
