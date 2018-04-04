//
//  RcmdSpecialModel.h
//  hinabian
//
//  Created by hnbwyh on 2017/10/23.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RcmdSpecialModel : NSObject

@property (nonatomic,copy) NSString *specialImage_url;

//@property (nonatomic,copy) NSString *specailID;
@property (nonatomic,copy) NSString *specialID;

@property (nonatomic,copy) NSString *netease_im_id; // 网易账号 ID
@property (nonatomic,copy) NSString *years;
@property (nonatomic,strong) NSArray *specializednations;

//@property (nonatomic,copy) NSString *specilcon;
@property (nonatomic,copy) NSString *specilIcon;
@property (nonatomic,copy) NSString *specialName;
@property (nonatomic,copy) NSString *specialEngName;
@property (nonatomic,copy) NSString *specialPosition;

@property (nonatomic,copy) NSString *nationstring;

// 是否展示 1-展示   0-不展示
@property (nonatomic,copy) NSString *status;


@end
