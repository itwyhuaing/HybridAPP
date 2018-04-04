//
//  HotIMProjectModel.h
//  hinabian
//
//  Created by hnbwyh on 2017/11/6.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotIMProjectModel : NSObject

@property (nonatomic,copy) NSString *activityImage_url; // 展示图片
@property (nonatomic,copy) NSString *desInfo;           // 展示文字
@property (nonatomic,copy) NSString *dateSt;            // 活动的起始时间
@property (nonatomic,copy) NSString *dateEd;            // 活动的结束时间
@property (nonatomic,copy) NSString *actLink;           // 活动链接
@property (nonatomic,copy) NSString *actStatus;         // 活动进行的状态 0 - 未开始。 2 - 已结束。 1 - 预告
@property (nonatomic,copy) NSString *status;            // 是否展示 1-上架   0-下架

// 待转化的相应字段
@property (nonatomic,copy) NSString *dateStShow;
@property (nonatomic,copy) NSString *dateEdShow;
@property (nonatomic,copy) NSString *actStatusShow;

@end
