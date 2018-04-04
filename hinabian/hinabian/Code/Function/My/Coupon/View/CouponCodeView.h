//
//  CouponCodeView.h
//  hinabian
//
//  Created by 余坚 on 16/12/28.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CouponCodeViewDelegate <NSObject>
@optional
-(void) CouponCodeDelButtonPressed;
-(void) CouponCodeSubMitButtonPressed:(NSString *)text;

@end

@interface CouponCodeView : UIView
@property (weak, nonatomic) IBOutlet UILabel *inputLabel;
@property (weak, nonatomic) IBOutlet UIButton *delButton;
@property (weak, nonatomic) IBOutlet UITextField *inPutTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic,weak) id<CouponCodeViewDelegate> delegate;
@end

