//
//  PhoneRegisterInputView.h
//  hinabian
//
//  Created by wangyinghua on 16/3/31.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#define LIST_TABLEVIEW_HEIGHT 300
#define LIST_TABLEVIEW_CELLHEIGHT 60

#import <UIKit/UIKit.h>
@class PhoneRegisterInputView;
@protocol PhoneRegisterInputViewDelegate <NSObject>

- (void)phoneRegisterInputView:(PhoneRegisterInputView *)PhoneRegisterInputView didSelectedCountryCode:(NSString *)selectedCountryCode;

@end

@interface PhoneRegisterInputView : UIView
@property (nonatomic,strong) UIView *spView;
@property (nonatomic,weak) id <PhoneRegisterInputViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *IDImageView;
@property (weak, nonatomic) IBOutlet UIButton *choosedBtn;
@property (weak, nonatomic) IBOutlet UITextField *IDTextField;

// 关联按钮点击事件
- (IBAction)choosePhoneCodeOfCountry:(id)sender;

// 实例化蒙板及表格
- (void)initCountryChoicesTableViewShowInSuperView:(UIView *)spView;

@end
