//
//  TribeShowProjectModel.h
//  hinabian
//
//  Created by hnbwyh on 17/4/18.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TribeShowProjectModel : NSObject

/*
    项目id：id
	项目类型：lable_name
	项目名：name
	优势：recommended_reason2
	签证类型：visa_type
	办理周期：cycle
	投资额度：min_amount_investment  --- >  经提包前协商：投资额度取 字段 amount_investment 的信息
	居住要求：immigrant
	服务费：service_charge(obj)
 */
@property (nonatomic,copy) NSString *proID;
@property (nonatomic,copy) NSString *label_name;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *recommended_reason2;
@property (nonatomic,copy) NSString *visa_type;
@property (nonatomic,copy) NSString *cycle;
//@property (nonatomic,copy) NSString *min_amount_investment;
@property (nonatomic,copy) NSString *amount_investment;
@property (nonatomic,copy) NSString *immigrant;
@property (nonatomic,copy) NSString *service_price;

// 高度计算
@property (nonatomic,assign) CGFloat advantageHeight;
@property (nonatomic,assign) CGFloat cellHeight;

@end
