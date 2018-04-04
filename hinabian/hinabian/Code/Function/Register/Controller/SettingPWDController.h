//
//  SettingPWDController.h
//  hinabian
//
//  Created by hnbwyh on 16/9/5.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingPWDController : UIBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *setPWDLabel;

@property (weak, nonatomic) IBOutlet UILabel *confirmPWDLabel;

@property (weak, nonatomic) IBOutlet UITextField *PWDInput;

@property (weak, nonatomic) IBOutlet UITextField *confirmPWDInput;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end
