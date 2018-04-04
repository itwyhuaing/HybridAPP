//
//  LoginMainView.h
//  hinabian
//
//  Created by hnbwyh on 16/9/1.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ITEM_HEIGHT 44
#define ITEM_LEADING_GAP 12
#define LOGIN_BTN_HEIGHT 38
#define LOGIN_BTN_TOP_GAP 28
#define THIRD_PART_ITEM_HEIGT 120

typedef void(^LoginMainVCBlock)(id event);

typedef enum : NSUInteger {
    LoginNationCodeBtnTag=15,
    LoginConfirmBtnTag=14,
    LoginBtnTag = 16,
    LoginUserBtnTag = 17,
    LoginQQbTtnTag = 10,
    LoginWeChatBtnTag = 20,
} LoginMainBtnTag;

@interface LoginMainView : UIView

@property (nonatomic,copy) LoginMainVCBlock vcblock;

@property (nonatomic,copy) NSString *nationCode;
@property (nonatomic,strong) UIButton *confirmBtn;
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UITextField *phoneNumInput;
@property (nonatomic,strong) UITextField *confirmCode;
@property (nonatomic,strong) UIButton *qqLoginBtn;
@property (nonatomic,strong) UIButton *wechatLoginBtn;

@end
