//
//  HNBCustomActionSheet.m
//  hinabian
//
//  Created by 余坚 on 15/6/18.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "HNBCustomActionSheet.h"

#define WINDOW_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]
#define ANIMATE_DURATION                        0.25f

@implementation HNBCustomActionSheet

-(id)initWithView:(UIView *)view AndHeight:(float)height{
    self = [super init];
    if (self) {
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = WINDOW_COLOR;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        //生成HNBCustomActionSheet
        self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 200), SCREEN_WIDTH, height)];
        self.backGroundView.backgroundColor = [UIColor whiteColor];
        
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        toolBar.barStyle = UIBarStyleDefault;
        
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style: UIBarButtonItemStyleDone target: self action: @selector(done)];
        UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStylePlain target: self action: @selector(docancel)];
        UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
        NSArray *array = [[NSArray alloc] initWithObjects: leftButton,fixedButton,rightButton, nil];
        [toolBar setItems: array];
        
        
        //给HNBCustomActionSheet添加响应事件(如果不加响应事件则传过来的view不显示)
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackGroundView)];
        [self.backGroundView addGestureRecognizer:tapGesture1];
        
        
        [self addSubview:self.backGroundView];
        [self.backGroundView addSubview:toolBar];
        [self.backGroundView addSubview:view];
        
        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
            [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-height, [UIScreen mainScreen].bounds.size.width, height)];
            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
    
    return self;
}

- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

-(void)showInView:(UIView *)view{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    
}

- (void)tappedBackGroundView
{
    //
}

-(void)done{
    
    
    [self.doneDelegate done];
    [self tappedCancel];
}

-(void)docancel
{
    [self tappedCancel];
}

@end
