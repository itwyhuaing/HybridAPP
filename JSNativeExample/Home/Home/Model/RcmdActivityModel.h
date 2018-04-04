//
//  RcmdActivityModel.h
//  hinabian
//
//  Created by hnbwyh on 2017/10/23.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RcmdActivityModel : NSObject

@property (nonatomic,copy) NSString *activityImage_url;
@property (nonatomic,copy) NSString *actLink;
@property (nonatomic,copy) NSString *desInfo;

@property (nonatomic,copy) NSString *dateSt;
@property (nonatomic,copy) NSString *dateEd;

@property (nonatomic,copy) NSString *dateStShow;
@property (nonatomic,copy) NSString *dateEdShow;

@property (nonatomic,copy) NSString *actStatus;
@property (nonatomic,copy) NSString *actStatusShow;

// 是否展示 1-展示   0-不展示
@property (nonatomic,copy) NSString *status;

@end
