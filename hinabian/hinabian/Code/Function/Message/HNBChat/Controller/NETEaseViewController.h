//
//  NETEaseViewController.h
//  hinabian
//
//  Created by 何松泽 on 2017/10/17.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <NIMKit/NIMKit.h>

enum IdentifierType {
    NormalIDType = 1,
    SpecialistIDType,
};

@interface NETEaseViewController : NIMSessionViewController

@property (nonatomic, assign) BOOL isAllow_Chat;    //是否超出限制数，超出不允许聊天

@end
