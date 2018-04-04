//
//  UserInfoMainView.h
//  hinabian
//
//  Created by hnbwyh on 16/7/22.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoMainManager.h"
@class PersonInfoModel;

typedef void(^ModifyShareBtnBlock)(BOOL isShow , PersonInfoModel *personModel);
@interface UserInfoMainView : UIView

@property (nonatomic,strong) UserInfoMainManager *mainMnager;

@property (nonatomic,copy) ModifyShareBtnBlock modifyShareBtn;

-(instancetype)initWithFrame:(CGRect)frame personid:(NSString *)personid superVC:(UIViewController *)superVC;

@end
