//
//  PublicViewController.h
//  hinabian
//
//  Created by 余坚 on 15/8/14.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentButton.h"
#import "SWKBaseViewController.h"
@interface PublicViewController : SWKBaseViewController
@property (nonatomic,strong) AppointmentButton *appointmentBtn;

- (void) setshowAppointmentBtn:(BOOL)isTure;
- (void) setshoudApperaReload:(BOOL)isTure;

@end
