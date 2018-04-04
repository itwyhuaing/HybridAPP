//
//  BubbleButtonView.m
//  hinabian
//
//  Created by 何松泽 on 2018/1/3.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "BubbleButtonView.h"

@interface BubbleButtonView()

@property (nonatomic, strong) UIButton *segmentButton;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation BubbleButtonView

- (instancetype)init {
    if (self == [super init]) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupMainView];
    }
    return self;
}

- (void)setupMainView {
    self.segmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.segmentButton setFrame:CGRectMake(0, 0, self.b_width, self.b_height)];
    [self.segmentButton setTitle:@"消息" forState:UIControlStateNormal];
    [self.segmentButton addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_segmentButton];
    

    float distance = 10;
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(distance, self.b_height - 8, self.b_width - distance*2, 2)];
    self.lineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_lineView];
}

- (void)setChoosen:(BOOL)isChoosen
{
    self.lineView.hidden = !isChoosen;
    
    if (isChoosen) {
        [self.segmentButton.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI34PX]];
    }else {
        [self.segmentButton.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI30PX]];
    }
}

- (void)setBubbleTag:(NSInteger)tag
{
    [self.segmentButton setTag:tag];
}

- (void)setBubbleButtonTitle:(NSString *)title state:(UIControlState)controlState
{
    [self.segmentButton setTitle:title forState:controlState];
}

#pragma mark -- Touch事件，设置协议才会有效

- (void)clickEvent:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickBubbleButton:)]) {
        [_delegate clickBubbleButton:sender];
    }
}

@end














