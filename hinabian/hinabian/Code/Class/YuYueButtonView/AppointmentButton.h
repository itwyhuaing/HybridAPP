//
//  AppointmentButton.h
//  hinabian
//
//  Created by 何松泽 on 15/11/20.
//  Copyright © 2015年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMNumberKeyboard.h"

@class AppointmentButton;

@protocol AppointmentButtonDelegate <NSObject>

-(void)consultOnlineEvent:(AppointmentButton *)appointmentButton;
-(void)consultPhoneEvent:(AppointmentButton *)appointmentButton;

@optional
-(void)touchConsultEvent:(AppointmentButton *)appointmentButton;    //点击咨询按钮，用于统计上报

@end

@interface AppointmentButton : UIButton<UITextFieldDelegate,MMNumberKeyboardDelegate>
{
    /*图标*/
    UIView *whiteCircle;        
    UIImageView *iconImageView;
    /*提示蒙版*/
    UIView *maskView;
    UIView *alertView;
    UILabel *alertTitle;
    UILabel *alertStatus;
    UIImageView *errorImageView;
    /*数字键盘*/
//    MMNumberKeyboard *keyboard;
}

@property (weak, nonatomic)id <AppointmentButtonDelegate>delegate;

@property (strong, nonatomic)UIView *appointmentView;
@property (strong, nonatomic)UIView *buttonView;
@property (strong, nonatomic)UIButton *quickBtn;
@property (strong, nonatomic)UIButton *dismissBtn;
@property (strong, nonatomic)UITextField *phoneTextView;
@property (strong, nonatomic)MMNumberKeyboard *numKeyboard;

-(id)initWithFrame:(CGRect)frame;
-(void)addAppointmentView;
-(void)startAnimation;

@end
