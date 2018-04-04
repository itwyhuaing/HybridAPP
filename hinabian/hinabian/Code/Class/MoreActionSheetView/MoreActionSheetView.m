//
//  MoreActionSheetView.m
//  MoreActionSheet
//
//  Created by 何松泽 on 2018/3/22.
//  Copyright © 2018年 何松泽. All rights reserved.
//

#import "MoreActionSheetView.h"

static const CGFloat MoreActionSheetViewBtnHeight = 50.f;
static const CGFloat MoreActionSheetViewBtnWidth  = 150.f;
static const CGFloat MoreActionSheetViewDistance  = 5.f;

@interface MoreActionSheetView()
{
    /*弹框View*/
    UIView *_alertView;
    
    /*底层背景*/
    UIImageView *_BgImage1;
    
    /*背景按钮*/
    UIButton *_disMissBtn;
}

@end

@implementation MoreActionSheetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIButton *disMissBtn = [[UIButton alloc] initWithFrame:frame];
        [disMissBtn setBackgroundColor:[UIColor clearColor]];
        [disMissBtn addTarget:self action:@selector(dismissFromSuper) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:disMissBtn];
        _disMissBtn = disMissBtn;
        
        CGFloat bgHeight = 170.f;
        
        CGRect rect     = CGRectZero;
        rect.origin.x   = [UIScreen mainScreen].bounds.size.width - MoreActionSheetViewBtnWidth - MoreActionSheetViewDistance;
        rect.origin.y   = MoreActionSheetViewBtnHeight + MoreActionSheetViewDistance;
        rect.size.width = MoreActionSheetViewBtnWidth;
        rect.size.height= bgHeight;
        _alertView = [[UIView alloc] initWithFrame:rect];
        [self addSubview:_alertView];
        
        rect = CGRectZero;
        rect.size = CGSizeMake(MoreActionSheetViewBtnWidth, bgHeight);
        _BgImage1 = [[UIImageView alloc] initWithFrame:rect];
        _BgImage1.image = [UIImage imageNamed:@"Tribe_Editor_Bg1"];
        [_alertView addSubview:_BgImage1];
    }
    return self;
}

- (void)setBtnArray:(NSArray *)btnArr {
    for (int index = 0; index < btnArr.count; index++) {
        NSDictionary *dic = [btnArr objectAtIndex:index];
        NSString *title = [dic valueForKey:MoreActionSheet_Title];
        NSString *image = [dic valueForKey:MoreActionSheet_Image];
        void (^function)(void) = [dic valueForKey:MoreActionSheet_Func];
        
        CGRect rect     = CGRectZero;
        rect.origin.y   = index * MoreActionSheetViewBtnHeight + MoreActionSheetViewDistance*2;
        rect.size.width = MoreActionSheetViewBtnWidth;
        rect.size.height= MoreActionSheetViewBtnHeight;
        
        MoreBtnWithImage *moreBtn = [[MoreBtnWithImage alloc] initWithFrame:rect title:title image:[UIImage imageNamed:image]];
        [_alertView addSubview:moreBtn];
        __weak typeof(self) weakSelf = self;
        [moreBtn setDidselect:^{
            [weakSelf dismissFromSuper];
            if (function) {
                function();
            }
        }];
    }
    [_alertView setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - (MoreActionSheetViewBtnWidth + MoreActionSheetViewDistance), MoreActionSheetViewBtnHeight + MoreActionSheetViewDistance, MoreActionSheetViewBtnWidth, (MoreActionSheetViewBtnHeight+MoreActionSheetViewDistance) *btnArr.count + 15)];
    [_BgImage1 setHeight:_alertView.size.height];
}

- (void)dismissFromSuper {
    [self removeFromSuperview];
}

@end


@implementation MoreBtnWithImage

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image {
    
    if (self = [super initWithFrame:frame]) {
        CGRect rect = CGRectZero;
        rect.origin.x = 35.f;
        rect.origin.y = (frame.size.height - 25.f) /2;
        rect.size.width = 25.f;
        rect.size.height = 25.f;
        _MImageView = [[UIImageView alloc] initWithFrame:rect];
        [_MImageView setImage:image];
        [self addSubview:_MImageView];
        
        rect.origin.x = CGRectGetMaxX(self.MImageView.frame) + 16;
        rect.origin.y += 2.f;
        rect.size.width = 40.f;
        _MLabel = [[UILabel alloc] initWithFrame:rect];
        [_MLabel setFont:[UIFont systemFontOfSize:16.f]];
        [_MLabel setTextColor:[UIColor blackColor]];
        [_MLabel setText:title];
        [self addSubview:_MLabel];
        
        float dis = 20.f;
        rect.origin.x = dis;
        rect.origin.y = frame.size.height - 1.f;
        rect.size.width = frame.size.width - dis*2;
        rect.size.height = 0.5f;
        _bottomLine = [[UIView alloc] initWithFrame:rect];
        _bottomLine.layer.borderColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:0.5].CGColor;
        _bottomLine.layer.borderWidth = 0.5f;
        [self addSubview:_bottomLine];
        
        rect = CGRectZero;
        rect.size = frame.size;
        _MBtn = [[UIButton alloc] initWithFrame:rect];
        [_MBtn addTarget:self action:@selector(clickMBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_MBtn];
    }
    
    return self;
}

- (void)clickMBtn {
    if (self.didselect) {
        self.didselect();
    }
}

@end



