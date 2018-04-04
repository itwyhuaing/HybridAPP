//
//  UserAccountController.h
//  hinabian
//
//  Created by hnbwyh on 16/9/5.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAccountController : UIBaseViewController



@property (weak, nonatomic) IBOutlet UILabel *userAccountLabel;

@property (weak, nonatomic) IBOutlet UILabel *PWDLabel;

@property (weak, nonatomic) IBOutlet UITextField *userAccountInput;

@property (weak, nonatomic) IBOutlet UITextField *PWDLabelInput;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UIButton *PWDButton;

@end
    
