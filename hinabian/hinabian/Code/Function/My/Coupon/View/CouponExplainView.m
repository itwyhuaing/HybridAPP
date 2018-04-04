//
//  CouponExplainView.m
//  hinabian
//
//  Created by 余坚 on 16/12/28.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "CouponExplainView.h"

@implementation CouponExplainView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 5.0f;
    
    [self.delButton addTarget:self action:@selector(delALL) forControlEvents:UIControlEventTouchUpInside];
    [self.okButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}

-(void) delALL
{
    if (_delegate && [_delegate respondsToSelector:@selector(CouponExplainDelButtonPressed)]) {
        [_delegate CouponExplainDelButtonPressed];
    }
}

-(void) okButtonPressed
{
    if (_delegate && [_delegate respondsToSelector:@selector(CouponExplainOKButtonPressed)]) {
        [_delegate CouponExplainOKButtonPressed];
    }
}


@end
