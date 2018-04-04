//
//  ScrollBannerView.m
//  YHScrollBannerView
//
//  Created by wangyinghua on 2017/5/12.
//  Copyright © 2017年 wangyinghua. All rights reserved.
//

#import "ScrollBannerView.h"

/**< 理论上 imgVArr 与 imgsData 数组有相同元素，但为了更好地无线循环的体验效果，imgVArr往往多2个元素 >*/
#define IMGVIEW_EXTRA_COUNT 2
#define IMGVIEW_TAG 100

@interface ScrollBannerView () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UILabel *indexLabel;

@property (nonatomic,assign) CGRect selRect;
@property (nonatomic,strong) NSMutableArray *imgVArr;
@property (nonatomic,strong) NSMutableArray *imgsData;


@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSTimeInterval timeInterval;
@property (nonatomic,assign) BOOL isManual;

@property (nonatomic,assign) NSInteger currentLocation;

@end

@implementation ScrollBannerView

- (instancetype)initWithFrame:(CGRect)frame autoPlayTimeInterval:(NSTimeInterval)ti
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_scrollView];
        [self addSubview:_pageControl];
        [self addSubview:_indexLabel];
        
        CGRect rect = frame;
        rect.origin.x = 0;
        rect.origin.y = 0;
        [_scrollView setFrame:rect];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.4f];
        _pageControl.hidden = NO;
        _indexLabel.hidden = YES;
        _indexLabel.font = [UIFont systemFontOfSize:15.f];
        
        _selRect = frame;
        _timeInterval = ti;
        _isManual = NO;
        
        if (_timeInterval > 0) {
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(autoScrollToTarget:) userInfo:nil repeats:YES];
            [_timer setFireDate:[NSDate distantFuture]];
        }
        
        //[self test];
    }
    return self;
}

#pragma mark ----- 新数据处理 - UI刷新

-(void)reFreshBannerViewWithDataSource:(NSArray *)dataSource{

    if (dataSource == nil || dataSource.count <= 0) {
        return;
    }
    [self.imgsData removeAllObjects];
    [self.imgsData addObjectsFromArray:dataSource];
    [self.imgsData insertObject:[dataSource lastObject] atIndex:0];
    [self.imgsData addObject:[dataSource firstObject]];
    
    [self reLayoutUIBasedImageCount:self.imgsData.count];
    [self refreshImageViewWithDataSource:self.imgsData];
    
    if (dataSource.count == 1) {//只有一张图片
        
        _pageControl.hidesForSinglePage = YES;
        _scrollView.scrollEnabled = NO;
        if (_timer.valid) {
            [_timer invalidate];
        }
        
    }else{
        
        _scrollView.scrollEnabled = YES;
        if (_timeInterval > 0) {
            [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_timeInterval]];
        }
    }
    
    //NSLog(@" reFreshBannerViewWithDataSource ");
    
}

- (void)reLayoutUIBasedImageCount:(NSInteger)imgCount{
    
    // 1. scroll 布局方向
    [_scrollView setContentSize:CGSizeMake(_selRect.size.width * imgCount,
                                               0)];
    
 
    // 2. 布局 imageView
    NSInteger currentImageVCount = self.imgVArr.count;
    if (imgCount > currentImageVCount) {
        CGRect rect = _selRect;
        for (NSInteger cou = currentImageVCount; cou < imgCount; cou ++) {
            
            rect.origin.y = 0;
            rect.origin.x = cou * _selRect.size.width;
           
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:rect];
            imgV.tag = IMGVIEW_TAG + cou;
            //[imgV setContentMode:UIViewContentModeScaleAspectFit];
            [imgV setContentMode:UIViewContentModeScaleAspectFill];
            imgV.clipsToBounds = YES;
            //imgV.backgroundColor = [UIColor redColor];
            [_scrollView addSubview:imgV];
            [self.imgVArr addObject:imgV];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedImageView:)];
            imgV.userInteractionEnabled = YES;
            [imgV addGestureRecognizer:tap];
            
        }
    }else{
    
        for (NSInteger cou = imgCount; cou < self.imgVArr.count; cou ++) {
            UIImageView *imgV = self.imgVArr[cou];
            [imgV removeFromSuperview];
        }
        
    }
    
    //  设置 setContentOffset 显示数据源中的第一张图片
    [_scrollView setContentOffset:CGPointMake(_selRect.size.width,
                                              0) animated:NO];
    
    
    // 4. 指示器数据 更新
    _pageControl.numberOfPages = imgCount - IMGVIEW_EXTRA_COUNT;
    _pageControl.currentPage = 0;
    _indexLabel.text = [NSString stringWithFormat:@"1 / %ld",imgCount - IMGVIEW_EXTRA_COUNT];
    
    // 5. 指示器 尺寸适配
    CGSize tmpSize = [_pageControl sizeForNumberOfPages:imgCount - IMGVIEW_EXTRA_COUNT];
    tmpSize.height = tmpSize.height > 15 ? 15 : tmpSize.height;
    CGRect tmpRect = CGRectMake(_selRect.size.width - tmpSize.width - 10,
                                _selRect.size.height - tmpSize.height - 5,
                                tmpSize.width,
                                tmpSize.height);
    [_pageControl setFrame:tmpRect];
    [_indexLabel sizeToFit];
    tmpRect.size = _indexLabel.frame.size;
    tmpSize.width = tmpSize.width < 30 ? 30 : tmpSize.width;
    tmpRect = CGRectMake(_selRect.size.width - tmpSize.width - 10,
                         _selRect.size.height - tmpSize.height - 5,
                         tmpSize.width,
                         tmpSize.height);
    [_indexLabel setFrame:tmpRect];
    
}

- (void)refreshImageViewWithDataSource:(NSArray *)data{

    for (NSInteger cou = 0; cou < data.count; cou ++) {
        UIImageView *imgV = self.imgVArr[cou];
        //imgV.backgroundColor = [UIColor redColor];
        //NSLog(@" Banner_Image ====== > %@",imgV);
        [imgV sd_setImageWithURL:[NSURL URLWithString:data[cou]]];
    }
    
}

#pragma mark ----- UIScrollViewDelegate


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    //NSLog(@" 开始拖动 ");
    _isManual = YES;
    
    [_timer setFireDate:[NSDate distantFuture]];
    
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (_scrollView.contentOffset.x >= (self.imgsData.count - 1) * _selRect.size.width) {
        //NSLog(@" 强制切回第一张 ");
        [_scrollView setContentOffset:CGPointMake(_selRect.size.width,
                                                  0) animated:NO];
    }else if (_scrollView.contentOffset.x <= 0){
        //NSLog(@" 强制切回第最后张 ");
        [_scrollView setContentOffset:CGPointMake((self.imgsData.count - IMGVIEW_EXTRA_COUNT) * _selRect.size.width,
                                                  0) animated:NO];
    }
    
    _currentLocation = floor(_scrollView.contentOffset.x/_selRect.size.width);
    _pageControl.currentPage = _currentLocation - 1;
    _indexLabel.text = [NSString stringWithFormat:@"%lu / %lu",(long)_currentLocation,self.imgsData.count - IMGVIEW_EXTRA_COUNT];
    //NSLog(@" 滚动 ： %f - %ld",_scrollView.contentOffset.x,(long)_currentLocation);
    
    if (_isManual) {
        _isManual = NO;
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_timeInterval]];
    }
    
}



#pragma mark ------ autoScrollToTarget

- (void)autoScrollToTarget:(NSTimer *)t{

    //NSLog(@" --- scrollToTarget --- ");
    [_scrollView setContentOffset:CGPointMake((_currentLocation + 1) * _selRect.size.width,
                                                  0) animated:YES];
   
    
}

#pragma mark ------ tappedImageView

- (void)tappedImageView:(UITapGestureRecognizer *)tap{

    UIImageView *imgV = (UIImageView *)tap.view;
    NSInteger location = imgV.tag - IMGVIEW_TAG;
    if (location == 0) {
        location = self.imgVArr.count - IMGVIEW_EXTRA_COUNT;
    }else if (location == self.imgVArr.count - 1){
        location = 1;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(scrollBannerView:didSelectedImageViewAtIndex:)]) {
        [_delegate scrollBannerView:self didSelectedImageViewAtIndex:location];
    }
    
}

#pragma mark ------ 懒加载

-(NSMutableArray *)imgVArr{
    if (_imgVArr == nil) {
        _imgVArr = [[NSMutableArray alloc] init];
    }
    return _imgVArr;
}

-(NSMutableArray *)imgsData{
    if (_imgsData == nil) {
        _imgsData = [[NSMutableArray alloc] init];
    }
    return _imgsData;
}


-(void)dealloc{

    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    
}

#pragma mark ------ test

- (void)test{

    self.backgroundColor = [UIColor greenColor];
    _scrollView.backgroundColor = [UIColor purpleColor];
    _pageControl.backgroundColor = [UIColor blueColor];
    _indexLabel.backgroundColor = [UIColor yellowColor];
    
}
@end
