//
//  RetrievePWDMainView.h
//  hinabian
//
//  Created by 何松泽 on 16/9/5.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RetrievePWDMainVCBlock)(id event);

typedef enum{
    RetrieveNationCodeBtnTag=15,
    RetrieveConfirmBtnTag=14,
    RetrieveNextBtnTag=16,
    RetrieveCompleteBtnTag=17
} RetrievePWDMainBtn;

@interface RetrievePWDMainView : UIView
/*验证码页面*/
@property (nonatomic,strong) UILabel *countryCode;
@property (nonatomic,strong) UIButton *nationCodeBtn;
@property (nonatomic,strong) UITextField *phoneNumInput;
@property (nonatomic,strong) UIButton *confirmBtn;
@property (nonatomic,strong) UITextField *confirmCode;
@property (nonatomic,strong) UIButton *nextBtn;
/*新密码页面*/
@property (nonatomic,strong) UILabel *pwdLabel;
@property (nonatomic,strong) UITextField *pwdInput;
@property (nonatomic,strong) UILabel *surePWDLabel;
@property (nonatomic,strong) UITextField *surePWDInput;
@property (nonatomic,strong) UIButton *completeBtn;

@property (nonatomic,copy) RetrievePWDMainVCBlock vcblock;

- (instancetype)initWithFrame:(CGRect)frame withPhoneNum:(NSString *)phoneNum;
- (void)nextOperation;

@end
