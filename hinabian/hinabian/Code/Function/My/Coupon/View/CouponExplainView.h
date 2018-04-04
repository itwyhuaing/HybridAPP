//
//  CouponExplainView.h
//  hinabian
//
//  Created by 余坚 on 16/12/28.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CouponExplainViewDelegate <NSObject>
@optional
-(void) CouponExplainDelButtonPressed;
-(void) CouponExplainOKButtonPressed;

@end

@interface CouponExplainView : UIView
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIButton *delButton;
@property (nonatomic,weak) id<CouponExplainViewDelegate> delegate;
@end
