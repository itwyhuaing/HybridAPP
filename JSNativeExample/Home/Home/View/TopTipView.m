//
//  TopTipView.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/31.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "TopTipView.h"

@interface TopTipView ()

@property (nonatomic,strong) UILabel *msgLabel;

@end


@implementation TopTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView{
    UILabel *l = [[UILabel alloc] init];
    self.msgLabel = l;
    [self addSubview:self.msgLabel];
    
    l.sd_layout
    .leftEqualToView(self)
    .topEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self);
    
    self.msgLabel.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
    self.msgLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:162.0/255.0 blue:255.0/255.0 alpha:1.0];
    self.msgLabel.font = [UIFont systemFontOfSize:FONT_UI24PX];
    self.msgLabel.textAlignment = NSTextAlignmentCenter;
    
}


- (void)displayWithMsg:(NSString *)msg{
    [self modifyLabelMsg:msg];
    [self show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

- (void)modifyLabelMsg:(NSString *)msg{
    if (msg != nil || msg.length > 0) {
        self.msgLabel.text = msg;
    }
}

- (void)show{
    [UIView animateWithDuration:1.5 animations:^{
        CGRect rect = self.frame;
        rect.origin.y = 0;
        [self setFrame:rect];
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:1.5 animations:^{
        CGRect rect = self.frame;
        rect.origin.y = -rect.size.height;
        [self setFrame:rect];
    }];
}

@end
