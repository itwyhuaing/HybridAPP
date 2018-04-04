//
//  TipMaskView.m
//  TieZi
//
//  Created by 何松泽 on 15/9/21.
//  Copyright © 2015年 HSZ. All rights reserved.
//

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

#import "TipMaskView.h"


@implementation TipMaskView

-(id)initWithFrame:(CGRect)frame message:(NSString *)message andButtonRect:(CGRect)rect textColor:(UIColor *)textColor bubbleColor:(UIColor *)bubbleColor isCustom:(BOOL)isCustom image:(UIImage *)image{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        
        _message = message;
        _rect = rect;
        _textColor = textColor;
        _bubbleColor = bubbleColor;
        _highLightImage = image;
        if (isCustom) {
            [self addButtonCustom];
        }else{
            [self addButtondefault];
        }
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame message:(NSString *)message andButtonRect:(CGRect)rect textColor:(UIColor *)textColor bubbleColor:(UIColor *)bubbleColor isCustom:(BOOL)isCustom title:(NSString *)title{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        
        _message = message;
        _rect = rect;
        _textColor = textColor;
        _bubbleColor = bubbleColor;
        [self addButtonCustomWithTitle:title];
    }
    return self;
}

-(void)addButtondefault
{
    _popTipView = [[CMPopTipView alloc] initWithMessage:_message];
    _popTipView.delegate = self;
    if (!_bubbleColor) {
        _popTipView.backgroundColor = [UIColor DDNavBarBlue];
    }else{
        _popTipView.backgroundColor = _bubbleColor;
    }
    
    if (!_textColor) {
        _popTipView.textColor = [UIColor whiteColor];
    }else{
        _popTipView.textColor = _textColor;
    }
    
    _popTipView.has3DStyle = NO;
    _popTipView.borderColor = [UIColor whiteColor];
    //    _popTipView.dismissTapAnywhere = YES;
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, _rect.origin.y, _rect.origin.x, _rect.size.height)];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(_rect.origin.x+_rect.size.width, _rect.origin.y, SCREEN_WIDTH - _rect.origin.x-_rect.size.width, _rect.size.height)];
    
    UIButton *topButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _rect.origin.y)];
    
    UIButton *bottomButton = [[UIButton alloc]initWithFrame:CGRectMake(0, _rect.origin.y+_rect.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-_rect.origin.y-_rect.size.height)];
    
    UIColor *backgroundColor = [self maskColor];
    
    leftButton.backgroundColor  = backgroundColor;
    rightButton.backgroundColor = backgroundColor;
    topButton.backgroundColor   = backgroundColor;
    bottomButton.backgroundColor  = backgroundColor;
    
    
    _highLightButton = [[UIButton alloc]initWithFrame:_rect];
    _highLightButton.backgroundColor = [UIColor clearColor];
    [_highLightButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchDown];
    
    [leftButton addTarget:self action:@selector(backgroundAction:) forControlEvents:UIControlEventTouchDown];
    [rightButton addTarget:self action:@selector(backgroundAction:) forControlEvents:UIControlEventTouchDown];
    [topButton addTarget:self action:@selector(backgroundAction:) forControlEvents:UIControlEventTouchDown];
    [bottomButton addTarget:self action:@selector(backgroundAction:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:_highLightButton];
    
    [self addSubview:leftButton];
    [self addSubview:rightButton];
    [self addSubview:topButton];
    [self addSubview:bottomButton];
    
    [_popTipView presentPointingAtView:_highLightButton inView:self animated:YES];

}

-(void)addButtonCustom
{
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [backBtn addTarget:self action:@selector(backgroundAction:) forControlEvents:UIControlEventTouchDown];
    
    UIColor *backgroundColor = [self maskColor];
    customMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [customMaskView setBackgroundColor:backgroundColor];
    [self addSubview:customMaskView];
    
    _popTipView = [[CMPopTipView alloc] initWithMessage:_message];
    _popTipView.delegate = self;
    if (!_bubbleColor) {
        _popTipView.backgroundColor = [UIColor DDNavBarBlue];
    }else{
        _popTipView.backgroundColor = _bubbleColor;
    }
    
    if (!_textColor) {
        _popTipView.textColor = [UIColor whiteColor];
    }else{
        _popTipView.textColor = _textColor;
    }
    
    
    _popTipView.has3DStyle = NO;
    _popTipView.borderColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:_rect];
    [imageView setImage:_highLightImage];
    [customMaskView addSubview:imageView];
    
    [_popTipView presentPointingAtView:imageView inView:self animated:YES];
    [customMaskView addSubview:backBtn];
}

-(void)addButtonCustomWithTitle:(NSString *)title
{
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [backBtn addTarget:self action:@selector(backgroundAction:) forControlEvents:UIControlEventTouchDown];
    
    UIColor *backgroundColor = [self maskColor];
    customMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [customMaskView setBackgroundColor:backgroundColor];
    [self addSubview:customMaskView];
    
    _popTipView = [[CMPopTipView alloc] initWithMessage:_message];
    _popTipView.delegate = self;
    if (!_bubbleColor) {
        _popTipView.backgroundColor = [UIColor DDNavBarBlue];
    }else{
        _popTipView.backgroundColor = _bubbleColor;
    }
    
    if (!_textColor) {
        _popTipView.textColor = [UIColor whiteColor];
    }else{
        _popTipView.textColor = _textColor;
    }
    
    
    _popTipView.has3DStyle = NO;
    _popTipView.borderColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btn setFrame:_rect];
    btn.layer.cornerRadius = CGRectGetHeight(btn.frame)/2.0;
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1].CGColor;
    btn.backgroundColor = [UIColor DDNavBarBlue];
    if ([title isEqualToString:@"关注"]) {
        btn.backgroundColor = [UIColor colorWithRed:15.0/255.0 green:188.0/255.0 blue:30.0/255.0 alpha:1];
    }
    [btn addTarget:self action:@selector(clcikEventForhHeadCell) forControlEvents:UIControlEventTouchUpInside];
    [customMaskView addSubview:btn];
    [_popTipView presentPointingAtView:btn inView:self animated:YES];
    [customMaskView addSubview:backBtn];
        
}

-(UIColor*)maskColor
{
    return [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5f];
}

//点击高亮事件
-(void)btnAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(tipMaskViewPressedButton:)]) {
        [_delegate tipMaskViewPressedButton:self];
    }else{
        [self removeFromSuperview];
    }
}

//点击背景事件
-(void)backgroundAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(tipMaskViewPressedBackground:)]) {
        [_delegate tipMaskViewPressedBackground:self];
    }else{
        [self removeFromSuperview];
    }
}

- (void)clcikEventForhHeadCell{
    NSLog(@"=================");
}

#pragma mark - CMPopTipViewDelegate

-(void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView{
    [self backgroundAction:nil];
}

@end







