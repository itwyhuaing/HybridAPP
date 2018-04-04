//
//  ThirdPartCompleteUserInfoViewController.h
//  hinabian
//
//  Created by 余坚 on 15/7/13.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdPartCompleteUserInfoViewController : UIBaseViewController

@property (nonatomic,assign) BOOL isFindPWD;
@property (nonatomic,strong) NSString *login_type;

-(void) isRegister:(BOOL) isregister;
@end
