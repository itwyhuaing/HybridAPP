//
//  PoorNetWorkView.m
//  hinabian
//
//  Created by 余坚 on 16/6/2.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "PoorNetWorkView.h"

@implementation PoorNetWorkView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addPoorNetItem];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}
-(instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void) addPoorNetItem
{
    UIButton * poorNetButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    poorNetButton.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 3);
    [poorNetButton setBackgroundImage:[UIImage imageNamed:@"loading_net"] forState:UIControlStateNormal];
    [poorNetButton addTarget:self action:@selector(poornetButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:poorNetButton];
    
    UILabel * poorNetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
    poorNetLabel.center = CGPointMake(self.frame.size.width / 2, poorNetButton.center.y + 70);
    poorNetLabel.textAlignment = NSTextAlignmentCenter;
    poorNetLabel.text = @"无网络,点击刷新";
    poorNetLabel.textColor = [UIColor colorWithRed:202/255.0f green:202/255.0f blue:202/255.0f alpha:1.0f];
    [self addSubview:poorNetLabel];
}
- (void)poornetButtonPressed
{
    if ([_delegate respondsToSelector:@selector(poorNetWorkThenReload)])
    {
        [_delegate poorNetWorkThenReload];
    }
}

@end
