//
//  IndependenceLoadingMask.m
//  hinabian
//
//  Created by 余坚 on 16/11/7.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "IndependenceLoadingMask.h"
#import "GIFImageView.h"
#import "GIFImage.h"

@interface IndependenceLoadingMask ()
@property (nonatomic, strong) GIFImageView *subInstance;

@end

@implementation IndependenceLoadingMask
-(instancetype)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        _subInstance = [[GIFImageView alloc] init];
        [_subInstance setImage:[GIFImage imageNamed:@"loading.gif"]];
        [self addSubview:_subInstance];
    }
    return self;
}

-(void)loadingMaskWithSuperView:(UIView *)superV frame:(CGRect)frame{
    
    //NSLog(@" Loading 添加 ");

    //CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_STATUSHEIGHT - SCREEN_NAVHEIGHT - SCREEN_TABHEIGHT);
    [self setFrame:frame];
    [superV addSubview:self];
    self.backgroundColor = [UIColor whiteColor];
    
    CGRect rect = CGRectZero;
    rect.size.width = 50.0;
    rect.size.height = rect.size.width;
    rect.origin.x = frame.size.width / 2.0 - rect.size.width / 2.0;
    rect.origin.y = frame.size.height / 2.0 - rect.size.height;
    [_subInstance setFrame:rect];
}

-(void)dismiss{
    
    [self removeFromSuperview];
    //NSLog(@" Loading 移除操作 ");
}

@end
