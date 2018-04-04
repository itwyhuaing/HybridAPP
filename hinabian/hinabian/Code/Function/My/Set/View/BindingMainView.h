//
//  BindingMainView.h
//  hinabian
//
//  Created by 何松泽 on 16/9/6.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BindingMainVCBlock)(id event);

typedef enum{
    BindingNationCodeBtnTag=15,
    BindingConfirmBtnTag=14,
    BindingCompleteBtnTag=16
} RetrievePWDMainBtn;

@interface BindingMainView : UIView

/*判断是否从找回密码进入*/
@property (nonatomic,assign) BOOL   isFindPWD;
/*验证码页面*/
@property (nonatomic,strong) UILabel *countryCode;
@property (nonatomic,strong) UIButton *nationCodeBtn;
@property (nonatomic,strong) UITextField *phoneNumInput;
@property (nonatomic,strong) UIButton *confirmBtn;
@property (nonatomic,strong) UITextField *confirmCode;
@property (nonatomic,strong) UIButton *completeBtn;

@property (nonatomic,copy) BindingMainVCBlock vcblock;

- (instancetype)initWithFrame:(CGRect)frame
                   andFindPWD:(BOOL)isFindPWD;
- (void)nextOperation:(NSString *)phoneNum;

@end
