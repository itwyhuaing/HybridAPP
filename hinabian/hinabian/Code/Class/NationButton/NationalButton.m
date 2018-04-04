//
//  NationalButton.m
//  hinabian
//
//  Created by 何松泽 on 2017/6/9.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "NationalButton.h"

static const float kCornerRadius     = 6.f;
static const int   kSelectedTag      = 100;
static const int   kOriginalTag      = 0;

@implementation NationalButton

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGRect rect = CGRectZero;
        rect.origin.y   = 8;
        rect.size.height= FONT_UI32PX;
        rect.size.width = frame.size.width;
        _nationLabel = [[UILabel alloc] initWithFrame:rect];
        _nationLabel.textAlignment = NSTextAlignmentCenter;
        _nationLabel.numberOfLines = 1;
        _nationLabel.font = [UIFont systemFontOfSize:FONT_UI32PX];
        
        rect.origin.y   = frame.size.height - 8 - FONT_UI22PX;
        rect.size.height= FONT_UI22PX;
        _describeLabel = [[UILabel alloc] initWithFrame:rect];
        _describeLabel.textAlignment = NSTextAlignmentCenter;
        _describeLabel.numberOfLines = 1;
        _describeLabel.font = [UIFont systemFontOfSize:FONT_UI22PX];
        _describeLabel.textColor = [UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1.0];
        
        [self addSubview:_nationLabel];
        [self addSubview:_describeLabel];
    }
    
    return self;
}

- (instancetype)initWithProjectFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setOriginalBtn];
        self.layer.cornerRadius = 10.f;
        [self.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI28PX]];
        [self setTitleColor:[UIColor DDNavBarBlue] forState:UIControlStateNormal];
//        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        self.contentEdgeInsets = UIEdgeInsetsMake(0,50, 0, 0);//title偏移
//        [self setBackgroundImage:[UIColor createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setOriginalBtn
{
    self.tag = kOriginalTag;
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = kCornerRadius;
    [self.nationLabel setTextColor:[UIColor DDNavBarBlue]];
    [self.describeLabel setTextColor:[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1.0]];
}

- (void)setSelectedBtn
{
    self.tag = kSelectedTag;
    self.backgroundColor = [UIColor DDNavBarBlue];
    self.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = kCornerRadius;
    [self.nationLabel setTextColor:[UIColor whiteColor]];
    [self.describeLabel setTextColor:[UIColor whiteColor]];
}

@end
