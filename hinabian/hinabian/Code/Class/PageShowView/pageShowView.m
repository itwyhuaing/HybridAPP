//
//  pageShowView.m
//  hinabian
//
//  Created by 余坚 on 16/10/25.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "pageShowView.h"
@interface pageShowView ()
@property (strong,nonatomic) UIButton *pageButton;
@property (strong,nonatomic) UIButton *leftButton;
@property (strong,nonatomic) UIButton *rightButton;
@end

@implementation pageShowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViwe];
    }
    return self;
}

-(void) setUpViwe
{
    //CGRect rectNav = self.navigationController.navigationBar.frame;
    //CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    //_pageShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PAGE_VIEW_WIDTH, PAGE_VIEW_HEIGHT)];
    self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2];
   //self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 44 - rectNav.size.height - rectStatus.size.height - PAGE_VIEW_HEIGHT/2);
    self.layer.cornerRadius = RRADIUS_LAYERCORNE;
   // self.hidden = TRUE;
    
    //UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(PAGE_BUTTON_EDGE, (_pageShowView.frame.size.height - PAGE_VIEW_HEIGHT)/2, PAGE_VIEW_HEIGHT, PAGE_VIEW_HEIGHT)];
    //[leftButton setTitle:@"<" forState:UIControlStateNormal];
    _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - PAGE_VIEW_HEIGHT)/2, PAGE_VIEW_HEIGHT, PAGE_VIEW_HEIGHT)];
    [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(leftPageButtonButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(PAGE_VIEW_WIDTH - PAGE_BUTTON_EDGE - PAGE_VIEW_HEIGHT, (_pageShowView.frame.size.height - PAGE_VIEW_HEIGHT)/2, PAGE_VIEW_HEIGHT, PAGE_VIEW_HEIGHT)];
    //[rightButton setTitle:@">" forState:UIControlStateNormal];
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(PAGE_VIEW_WIDTH - PAGE_VIEW_HEIGHT, (self.frame.size.height - PAGE_VIEW_HEIGHT)/2, PAGE_VIEW_HEIGHT, PAGE_VIEW_HEIGHT)];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightPageButtonButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    CGRect rect = CGRectZero;
    rect.size.width = 14.0;
    rect.size.height = rect.size.width;
    rect.origin.x = 13.0;
    rect.origin.y = _leftButton.frame.size.height/2.0 - rect.size.height/2.0;
    UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:rect];
    [leftImgView setImage:[UIImage imageNamed:@"forePage"]];
    [_leftButton addSubview:leftImgView];
    rect.origin.x = _rightButton.frame.size.width - 13.0 - rect.size.width;
    UIImageView *rightImgView = [[UIImageView alloc] initWithFrame:rect];
    [rightImgView setImage:[UIImage imageNamed:@"backPage"]];
    [_rightButton addSubview:rightImgView];
    //    rightImgView.backgroundColor = [UIColor orangeColor];
    //    leftImgView.backgroundColor = [UIColor orangeColor];
    //    leftButton.backgroundColor = [UIColor redColor];[rightButton setBackgroundColor:[UIColor greenColor]];
    _pageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, PAGE_VIEW_HEIGHT)];
    //[_pageButton setTitle:@"200/300" forState:UIControlStateNormal];
    [_pageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _pageButton.titleLabel.font = [UIFont systemFontOfSize:FONT_UI24PX];
    [_pageButton addTarget:self action:@selector(centerPageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _pageButton.center = CGPointMake((self.frame.size.width)/2, self.frame.size.height/2);
    
    [self addSubview:_leftButton];
    [self addSubview:_rightButton];
    [self addSubview:_pageButton];
}

- (void) setPageNum:(NSString *)text
{
    [_pageButton setTitle:text forState:UIControlStateNormal];
    NSArray * tmpArray = Nil;
    tmpArray = [text componentsSeparatedByString: @"/"];
    if (tmpArray) {
        NSInteger index = [tmpArray[0] intValue];
        if (index == 1) {
            self.hidden = TRUE;
        }
        else
        {
            self.hidden = FALSE;
        }
    }
    
}

/* left 防双击 */
- (void)leftPageButtonButtonClicked:(id)sender
{
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(leftPageButtonPressed:) object:_leftButton];
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(rightPageButtonPressed:) object:_rightButton];
    [self performSelector:@selector(leftPageButtonPressed:) withObject:sender afterDelay:0.4f];
}

-(void) leftPageButtonPressed:(id)sender
{
    NSLog(@"leftPageButtonPressed");
    if ([_delegate respondsToSelector:@selector(HNBPageShowViewLeftButtonPressed)])
    {
        [_delegate HNBPageShowViewLeftButtonPressed];
    }
}

/* right 防双击 */
- (void)rightPageButtonButtonClicked:(id)sender
{
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(leftPageButtonPressed:) object:_leftButton];
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(rightPageButtonPressed:) object:_rightButton];
    [self performSelector:@selector(rightPageButtonPressed:) withObject:sender afterDelay:0.4f];
}
-(void) rightPageButtonPressed:(id)sender
{
    NSLog(@"rightPageButtonPressed");
    if ([_delegate respondsToSelector:@selector(HNBPageShowViewRightButtonPressed)])
    {
        [_delegate HNBPageShowViewRightButtonPressed];
    }
}

-(void) centerPageButtonPressed
{
    if ([_delegate respondsToSelector:@selector(HNBPageShowViewCenterButtonPressed)])
    {
        [_delegate HNBPageShowViewCenterButtonPressed];
    }
}

@end
