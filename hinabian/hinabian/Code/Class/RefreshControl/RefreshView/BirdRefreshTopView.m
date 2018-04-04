//
//  BirdRefreshTopView.m
//  hinabian
//
//  Created by 余坚 on 16/8/4.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "BirdRefreshTopView.h"

@implementation BirdRefreshTopView

#define IMAGE_SIZE  40

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        
        [self initViews:frame];
    }
    
    return self;
}

- (void)resetLayoutSubViews
{
    
    
}

- (void)initViews:(CGRect)frame
{
    self.backgroundColor=[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:237.0/255.0];
    
    
//    _imageView = [[GIFImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - IMAGE_SIZE_WIDTH / 2, self.frame.size.height - IMAGE_SIZE_HEIGHT, IMAGE_SIZE_WIDTH, IMAGE_SIZE_HEIGHT)];
//    [self addSubview:_imageView];
//    _imageView.image = [GIFImage imageNamed:@"flash.gif"];
//    [self addSubview:_imageView];
    
    //    _imageView=[[UIImageView alloc] initWithFrame:CGRectZero];
    //    _imageView.image=[UIImage imageNamed:@"pull_refresh.png"];
    //    _imageView.translatesAutoresizingMaskIntoConstraints=NO;
    //    [self addSubview:_imageView];
    
    _imageView = [[GIFImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - IMAGE_SIZE / 2, frame.size.height/2 + 5, IMAGE_SIZE, IMAGE_SIZE)];
     [self addSubview:_imageView];
     _imageView.image = [GIFImage imageNamed:@"loading.gif"];
    
    
    [self resetViews];
    
}

- (void)resetViews
{
    if([_imageView isAnimating])
    {
        [_imageView stopAnimating];
    }
    _promptLabel.text=@"下拉刷新";
    
}

- (void)canEngageRefresh
{
    _promptLabel.text=@"松开刷新";
    
}

- (void)didDisengageRefresh
{
    [self resetViews];
}

- (void)startRefreshing
{
    [_imageView startAnimating];
}

- (void)finishRefreshing
{
    [self resetViews];
    
}



@end
