//
//  TribeInfoByThemeIdModel.h
//  hinabian
//
//  Created by 余坚 on 16/11/2.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TribeInfoByThemeIdModel : NSObject

@property (nonatomic,copy) NSString *tribeName;  //圈子名
@property (nonatomic,copy) NSString *triebId;    //圈子Id
@property (nonatomic,copy) NSString *themeNum;   //帖子数
@property (nonatomic,copy) NSString *userNum;    //关注数
@property (nonatomic,copy) NSString *country;   //国家圈子
@property (nonatomic)      BOOL      statue;    //是否关注

@end
