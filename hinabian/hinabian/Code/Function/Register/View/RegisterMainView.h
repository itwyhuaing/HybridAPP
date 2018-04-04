//
//  RegisterMainView.h
//  hinabian
//
//  Created by 何松泽 on 16/9/7.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RegisterMainVCBlock)(id event);

typedef enum{
    RegisterNationCodeBtnTag=15,
    RegisterConfirmBtnTag=14,
    RegisterBtnTag=16,
    RegisterVisableBtnTag=17,
    RegisterAgreeBtnTag = 18,
    RegisterNikeBtnTag = 19
} RegisterMainBtn;

@interface RegisterMainView : UIView

/*验证码页面*/
@property (nonatomic,strong) UILabel *countryCode;
@property (nonatomic,strong) UIButton *nationCodeBtn;
@property (nonatomic,strong) UITextField *phoneNumInput;
@property (nonatomic,strong) UIButton *confirmBtn;
@property (nonatomic,strong) UITextField *confirmCode;
@property (nonatomic,strong) UIButton *visableBtn;
@property (nonatomic,strong) UIImageView *visibleImage;
@property (nonatomic,strong) UITextField *pwdInput;
@property (nonatomic,strong) UILabel *pwdLabel;
@property (nonatomic,strong) UIButton *completeBtn;
@property (nonatomic,strong) UIButton *nikeBtn;

@property (nonatomic,copy) RegisterMainVCBlock vcblock;

@end
