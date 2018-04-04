//
//  HNBButton.m
//  hinabian
//
//  Created by hnbwyh on 16/12/5.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "HNBButton.h"

@implementation HNBButton

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(_imgRect, CGRectZero)) {
        [self.imageView setFrame:_imgRect];
    }
    
    if (!CGRectEqualToRect(_titleRect, CGRectZero)) {
        [self.titleLabel setFrame:_titleRect];
    }
    
}


@end
