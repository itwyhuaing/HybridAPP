//
//  AppointmentButton.m
//  hinabian
//
//  Created by 何松泽 on 15/11/20.
//  Copyright © 2015年 &#20313;&#22362;. All rights reserved.
//

enum appointment_button{
    CONSULT_ONLINE = 2,
    CONSULT_PHONE,
    CONSULT_LABEL,
    CONSULT_QUICKVIEW,
};

typedef enum{
    Left_Location,
    Right_Location,
}Location;

#define DISMISS_BUTTON_TAG  100
#define CIRCLE_DISTANCE     7*SCREEN_WIDTH/SCREEN_WIDTH_6

#import "AppointmentButton.h"
#import "IQKeyBoardManager.h"
#import "UIView+KeyboardObserver.h"
#import "DataFetcher.h"
#import "HNBToast.h"

@interface AppointmentButton()
{
    Location location;
    CGPoint startPoint;
    CGPoint newcenter;
    BOOL    isMove;
}

@end

@implementation AppointmentButton

#pragma mark -懒加载
- (UIView *)appointmentView
{
    if (!_appointmentView) {
        NSArray *lib = [[NSBundle mainBundle]loadNibNamed:@"YuYueButtonView" owner:self options:nil];
        _appointmentView = [[UIView alloc]init];
        _appointmentView = [lib objectAtIndex:0];
        _appointmentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        _appointmentView.hidden = TRUE;
        
        [[[UIApplication sharedApplication] delegate].window addSubview:_appointmentView];
    }
    return _appointmentView;
}
/*数字键盘*/
- (MMNumberKeyboard *)numKeyboard
{
    if (!_numKeyboard) {
        _numKeyboard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
        _numKeyboard.allowsDecimalPoint = YES;
        _numKeyboard.delegate = self;
    }
    return _numKeyboard;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        isMove = NO;
        
        /*button上的头像*/
        UIImage *image = [[UIImage imageNamed:@"appointment_icon"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        iconImageView = [[UIImageView alloc]initWithImage:image];
        iconImageView.center = CGPointMake(frame.size.width/2, frame.size.height/2 - 5*SCREEN_WIDTH/SCREEN_WIDTH_6);
        
        /*button上的白色圈圈*/
        whiteCircle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width - CIRCLE_DISTANCE, frame.size.width - CIRCLE_DISTANCE)];
        whiteCircle.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [whiteCircle setBackgroundColor:[UIColor clearColor]];
        [whiteCircle layer].cornerRadius = (frame.size.width - CIRCLE_DISTANCE)/2;
        [whiteCircle layer].borderWidth = 1.0f;
        [whiteCircle layer].borderColor = [UIColor whiteColor].CGColor;
        [whiteCircle layer].masksToBounds = YES;
        
        /*button上的标题*/
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,14*SCREEN_WIDTH/SCREEN_WIDTH_6, frame.size.width, frame.size.height)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:FONT_UI20PX*SCREEN_SCALE];
        titleLabel.text = @"咨询";
        [titleLabel.layer setCornerRadius:titleLabel.frame.size.width/2];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:iconImageView];
        [self addSubview:whiteCircle];
        [self addSubview:titleLabel];
        
        if (![[HNBUtils sandBoxGetInfo:[NSString class] forKey:APPOINTMENT_BUTTON_COLOR] isEqualToString:@""] && [HNBUtils sandBoxGetInfo:[NSString class] forKey:APPOINTMENT_BUTTON_COLOR]) {
            UIColor *color = [UIColor colorWithHexString:[HNBUtils sandBoxGetInfo:[NSString class] forKey:APPOINTMENT_BUTTON_COLOR]];
            [self setBackgroundColor:color];
        }else{
            [self setBackgroundColor:[UIColor DDNavBarBlue]];
        }
        [self.layer setCornerRadius:self.frame.size.width/2];
        self.layer.masksToBounds = YES;
        self.alpha = 0.8f;
        
        [self startAnimation];
    }
    return self;
}

//自身动画
-(void)startAnimation
{
    [UIView animateWithDuration:0.6 animations:^{
        whiteCircle.transform = CGAffineTransformMakeScale(1.2,1.2);
        iconImageView.transform = CGAffineTransformMakeScale(0.83*SCREEN_WIDTH/SCREEN_WIDTH_6, 0.83*SCREEN_WIDTH/SCREEN_WIDTH_6);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^{
            whiteCircle.transform = CGAffineTransformMakeScale(1.0,1.0);
            iconImageView.transform = CGAffineTransformMakeScale(1.0*SCREEN_WIDTH/SCREEN_WIDTH_6, 1.0*SCREEN_WIDTH/SCREEN_WIDTH_6);
        }completion:^(BOOL finished) {
            
        }];
    }];
}

#pragma mark -Click Event

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *moveTouch = [touches anyObject];
    startPoint = [moveTouch locationInView:[moveTouch view]];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    //计算位移=当前位置-起始位置
    CGPoint point = [[touches anyObject] locationInView:self];
    float dx = point.x - startPoint.x;
    float dy = point.y - startPoint.y;
    
    //小幅度移动判断用户想点击
    if ((fabsf(dx) + fabsf(dy)) > 10.0f) {
        isMove = YES;
    }
    //计算移动后的view中心点
    newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    
    
    /* 限制用户不可将视图托出屏幕 */
    float halfx = CGRectGetMidX(self.bounds);
    //x坐标左边界
    newcenter.x = MAX(halfx, newcenter.x);
    //x坐标右边界
    newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
    
    //y坐标同理
    float halfy = CGRectGetMidY(self.bounds);
    newcenter.y = MAX(halfy + 64, newcenter.y);
    newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
    
    //移动view
    self.center = newcenter;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!isMove) {
        /*数据上报*/
        if ([HNBUtils sandBoxGetInfo:[NSString class] forKey:APPOINTMENT_BUTTON_COLOR]) {
            NSString *btnColor = [HNBUtils sandBoxGetInfo:[NSString class] forKey:APPOINTMENT_BUTTON_COLOR];
            NSDictionary *dic = @{@"colour" : btnColor};
            [HNBClick event:@"160013" Content:dic];
        }else{
            //无配置
            NSDictionary *dic = @{@"colour" : @""};
            [HNBClick event:@"160013" Content:dic];
        }
        
        [self appointmentViewShow];
        return;
    }else{
        isMove = NO;
    }
    if (newcenter.x > SCREEN_WIDTH/2) {
        location = Right_Location;
        
    }else{
        location = Left_Location;
    }
    
    [self setNewFrame:location];
}

-(void)setNewFrame:(Location)newLocation
{
    
    if(newLocation == Left_Location){
        newcenter = CGPointMake(self.bounds.size.width/2, self.center.y);
        [UIView animateWithDuration:0.2f animations:^{
            self.center = newcenter;
        }];
    }else{
        newcenter = CGPointMake(SCREEN_WIDTH - self.bounds.size.width/2, self.center.y);
        [UIView animateWithDuration:0.2f animations:^{
            self.center = newcenter;
        }];
    }
}

-(void)appointmentViewShow
{
    [self addAppointmentView];
    
    [UIView animateWithDuration:0.3f animations:^{
        _appointmentView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    } completion:^(BOOL finished) {
        [_dismissBtn setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.3f]];
    }];
    
    /*数据上报*/
    if ([HNBUtils sandBoxGetInfo:[NSString class] forKey:APPOINTMENT_BUTTON_COLOR]) {
        NSString *btnColor = [HNBUtils sandBoxGetInfo:[NSString class] forKey:APPOINTMENT_BUTTON_COLOR];
        NSDictionary *dic = @{@"colour" : btnColor};
        [HNBClick event:@"160013" Content:dic];
    }else{
        //无配置
        NSDictionary *dic = @{@"colour" : @""};
        [HNBClick event:@"160013" Content:dic];
    }
}

-(void)addAppointmentView
{
    if ([_delegate respondsToSelector:@selector(touchConsultEvent:)]) {
        [_delegate touchConsultEvent:self];
    }
    
    self.alpha = 0.f;
    self.appointmentView.hidden = FALSE;
    
    /*点击背景消失按钮*/
    _dismissBtn = (UIButton *)[self.appointmentView  viewWithTag:DISMISS_BUTTON_TAG];
    [_dismissBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    
    /*咨询按钮的View*/
    _buttonView = [[UIView alloc]init];
    _buttonView = (UIView*)[self.appointmentView viewWithTag:1];
    
    /*另外两种咨询view内的控件*/
    UIButton *btn;
    for (int i = 2; i<=4; i++) {
        btn = (UIButton *)[_buttonView viewWithTag:i];
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton *phoneBtn = (UIButton *)[_buttonView viewWithTag:CONSULT_PHONE];
    phoneBtn.layer.cornerRadius = 8.0f;
    phoneBtn.layer.masksToBounds = TRUE;
    phoneBtn.layer.borderWidth = 1.0f;
    phoneBtn.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    
    UIButton *onlineBtn = (UIButton *)[_buttonView viewWithTag:CONSULT_ONLINE];
    onlineBtn.layer.cornerRadius = 8.0f;
    onlineBtn.layer.masksToBounds = TRUE;
    onlineBtn.layer.borderWidth = 1.0f;
    onlineBtn.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    
    UIView *quickView = [_buttonView viewWithTag:CONSULT_QUICKVIEW];
    quickView.layer.cornerRadius = 8.0f;
    quickView.layer.masksToBounds = TRUE;
    quickView.layer.borderWidth = 1.0f;
    quickView.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    
    /*快速咨询view内的控件*/
    _phoneTextView = (UITextField *)[quickView viewWithTag:1];
    _phoneTextView.delegate = (id)self;
    _phoneTextView.inputView = self.numKeyboard;
    
    /*
     2.9.5去除给我回电
     如要恢复，将此设置为NO；前往YuYueButtonView.xib，将View高度改回200；
     */
    quickView.hidden = YES;
    
    UIButton *deletBtn = (UIButton *)[quickView viewWithTag:2];
    [deletBtn addTarget:self action:@selector(deleteTextContent) forControlEvents:UIControlEventTouchUpInside];
    
    _quickBtn = (UIButton *)[quickView viewWithTag:3];
    [_quickBtn addTarget:self action:@selector(submitPhoneNum) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)buttonClicked:(id)sender
{
    [self dismissView];
    
    if (sender == (UIButton *)[_buttonView viewWithTag:CONSULT_ONLINE]) {
        if ([_delegate respondsToSelector:@selector(consultOnlineEvent:)]) {
            [_delegate consultOnlineEvent:self];
            [HNBClick event:@"131001" Content:nil];
        }else{
            NSLog(@"请设置在线咨询点击事件");
        }
    }else if (sender == (UIButton *)[_buttonView viewWithTag:CONSULT_PHONE]){
        if ([_delegate respondsToSelector:@selector(consultPhoneEvent:)]) {
            [_delegate consultPhoneEvent:self];
            [HNBClick event:@"131002" Content:nil];
        }else{
            NSLog(@"请设置电话咨询点击事件");
        }
    }
}

-(void)dismissView
{
    self.alpha = 0.8f;
    [_dismissBtn setBackgroundColor:[UIColor clearColor]];
    [UIView animateWithDuration:0.5f animations:^{
        _appointmentView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 + SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
    [_phoneTextView resignFirstResponder];
    //移除键盘监听事件
    //    [[[UIApplication sharedApplication] delegate].window removeKeyboardObserver];
}

-(void)deleteTextContent
{
    if (_phoneTextView.text.length != 0) {
        _phoneTextView.text = @"";
    }
}

-(void)submitPhoneNum
{
    [_phoneTextView resignFirstResponder];
    
    if (_phoneTextView.text.length >= 5) {
        [DataFetcher doSendAppointmentPhoneNum:_phoneTextView.text withSucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            NSLog(@"errCode = %d",errCode);
            if (errCode == 0) {
                [HNBClick event:@"131003" Content:nil];
                [[HNBToast shareManager] toastWithOnView:nil msg:@"亲，您已成功预约咨询P&稍后海那边移民规划师将会与您联系，请保持通讯畅通哦" afterDelay:2.0 style:HNBToastHudOnlyTitleAndDetailText];
            }else{
                [[HNBToast shareManager] toastWithOnView:nil msg:@"亲，手机号码似乎不对哦~" afterDelay:1.0 style:HNBToastHudFailure];
            }
        } withFailHandler:^(id error) {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"亲，网络似乎不好哦~" afterDelay:1.0 style:HNBToastHudFailure];
            NSLog(@"errCode = %@",error);
        }];
    }else{
        [[HNBToast shareManager] toastWithOnView:nil msg:@"亲，手机号码似乎不对哦~" afterDelay:1.0 style:HNBToastHudFailure];
    }
    
}

#pragma mark - TextFieldDelegate.

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3f animations:^{
        _appointmentView.center = CGPointMake(SCREEN_WIDTH/2,_appointmentView.center.y - self.numKeyboard.frame.size.height);
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3f animations:^{
        _appointmentView.center = CGPointMake(SCREEN_WIDTH/2,_appointmentView.center.y + self.numKeyboard.frame.size.height);
    }];
}

#pragma mark - MMNumberKeyboardDelegate.

- (BOOL)numberKeyboardShouldReturn:(MMNumberKeyboard *)numberKeyboard
{
    // Do something with the done key if neeed. Return YES to dismiss the keyboard.
    return YES;
}

- (BOOL)numberKeyboard:(MMNumberKeyboard *)numberKeyboard shouldInsertText:(NSString *)text
{
    if ([_phoneTextView.text length] >= 11) {
        return NO;
    }
    return YES;
}


@end
