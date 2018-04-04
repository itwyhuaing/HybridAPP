//
//  ShufllingScrolView.m
//  hinabian
//
//  Created by 余坚 on 15/7/11.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "ShufllingScrolView.h"
#import "ShufflingInfo.h"

@implementation ShufllingScrolView
#define PAGE_COUNT 3
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //[self addShufflingScrollView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    //[self addShufflingScrollView];
}
-(void) addShufflingScrollView
{
    /* 增加图片滚动窗口 */
    
    _scrollView = [ [UIScrollView alloc ] initWithFrame:self.frame];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * PAGE_COUNT, 0);
    _scrollView.pagingEnabled = true;
    _scrollView.bounces = false;
    _scrollView.delegate = (id)self;
    _scrollView.layer.borderWidth = 0.5f;
    _scrollView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    _scrollView.showsHorizontalScrollIndicator = false;
    _scrollView.layer.cornerRadius = 2;
    [self addSubview:_scrollView];
    
    /* 增加PageCtrl */
    [self setPageCtrl];
    
    [self addImageScrollView];
    
    [self updateScrollView];
    
}

-(void) setPageCtrl
{
    
    _pgcontrol = [[UIPageControl alloc] initWithFrame:CGRectZero];
    _pgcontrol.pageIndicatorTintColor = [UIColor colorWithWhite:0.8 alpha:1];
    _pgcontrol.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.6 alpha:1];
    _pgcontrol.numberOfPages = PAGE_COUNT;
    _pgcontrol.currentPage = 0;
    [_pgcontrol sizeToFit];
    _pgcontrol.center = CGPointMake(self.center.x, _scrollView.bounds.size.height - 20);
    [self addSubview:_pgcontrol];
}

-(void)addImageScrollView
{
    for (int pageIndex = 0; pageIndex < PAGE_COUNT; pageIndex++) {
        
        UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.bounds.size.width * pageIndex, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height)];
        //tmpImageView.image = _imageArry[pageIndex];
        ShufflingInfo * f = _imageArry[pageIndex];
        [tmpImageView sd_setImageWithURL:[NSURL URLWithString:f.image_url]];
        tmpImageView.backgroundColor = [UIColor clearColor];
        [tmpImageView setUserInteractionEnabled:YES];
        [tmpImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)]];
        tmpImageView.tag = (11+pageIndex);
        UILabel * noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
        noticeLabel.text = [self.ShufflingItemsMainTitle objectForKey:[NSString stringWithFormat:@"%d",11 + pageIndex]];
        noticeLabel.center = CGPointMake(SCREEN_WIDTH / 2, 10);
        noticeLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:11];//[UIFont systemFontOfSize:11];
        [noticeLabel setTextColor:[UIColor DDTextGrey]];
        noticeLabel.textAlignment = NSTextAlignmentCenter;
        [tmpImageView addSubview:noticeLabel];
        
        [_scrollView addSubview: tmpImageView];;
    }
    
}

- (void)clickImageView:(UITapGestureRecognizer *)gestureRecognizer
{
    
}
- (void) updateScrollView
{
    [self.ShufflingTime invalidate];
    self.ShufflingTime = nil;
    NSTimeInterval timeInterval = 5.0;
    self.ShufflingTime = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self
                                                        selector:@selector(handleMaxShowTimer:)
                                                        userInfo: nil
                                                         repeats:YES];
}

- (void)handleMaxShowTimer:(NSTimer*)theTimer
{
    CGPoint pt = self.scrollView.contentOffset;
    int count = PAGE_COUNT;
    if(pt.x == SCREEN_WIDTH * (count - 1)){
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
        [self.scrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH,0,self.frame.size.width,self.frame.size.height) animated:YES];
    }else{
        pt.x += SCREEN_WIDTH;
        [self.scrollView setContentOffset:pt animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page_ = (int)round(scrollView.contentOffset.x / scrollView.frame.size.width);
    _pgcontrol.currentPage = page_;
}



@end
