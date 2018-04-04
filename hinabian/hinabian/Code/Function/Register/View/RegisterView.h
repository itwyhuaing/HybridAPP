//
//  RegisterView.h
//  hinabian
//
//  Created by 何松泽 on 16/1/14.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneRegisterInputView.h"

@interface RegisterView : UIView<UITextFieldDelegate>
{
    int coolDown;
    NSString * idImageNormal;
    NSString * idImagePressed;
    
    NSString * vCodeImageNormal;
    NSString * vCodeImagePressed;
    
    NSString * PWDImageNormal;
    NSString * PWDImagePressed;
    
    NSString * idPlacehold;
}

@property (strong, nonatomic) UITextField *IDTextField;
@property (strong, nonatomic) UITextField *PWDTextField;
@property (strong, nonatomic) UITextField *VCodeTextField;
@property (strong, nonatomic) UIButton *vCodeButton;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIImageView * IDImageView;
@property (strong, nonatomic) UIImageView * VCodeImageView;
@property (strong, nonatomic) UIImageView * PWDImageView;

@property (nonatomic,strong) PhoneRegisterInputView *phInputView;

-(id)initWithIDImageNormalName:(NSString *)IDNormal
            IDImagePressedName:(NSString *)IDPressed
               VCodeNormalName:(NSString *)CODENormal
              VCodePressedName:(NSString *)CODEPressed
                 PWDNormalName:(NSString *)PWDNormal
                PWDPressedName:(NSString *)PWDPressed
             IDPlaceholdString:(NSString *)IDPlacehold;

@end
