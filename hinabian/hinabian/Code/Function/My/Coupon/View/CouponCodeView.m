//
//  CouponCodeView.m
//  hinabian
//
//  Created by 余坚 on 16/12/28.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "CouponCodeView.h"

@implementation CouponCodeView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.submitButton.layer.cornerRadius = 5.0f;
    self.layer.cornerRadius = 5.0f;
    self.inputLabel.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    self.inputLabel.layer.borderWidth = 1.0f;
    self.inputLabel.layer.cornerRadius = 5.0f;
    [self.delButton addTarget:self action:@selector(delALL) forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.inPutTextField becomeFirstResponder];
    
}

-(void) delALL
{
    if (_delegate && [_delegate respondsToSelector:@selector(CouponCodeDelButtonPressed)]) {
        [_delegate CouponCodeDelButtonPressed];
    }
}

-(void) submit
{
    if (_delegate && [_delegate respondsToSelector:@selector(CouponCodeSubMitButtonPressed:)]) {
        [_delegate CouponCodeSubMitButtonPressed:self.inPutTextField.text];
    }
}
@end
