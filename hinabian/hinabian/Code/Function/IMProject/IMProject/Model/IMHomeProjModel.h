//
//  IMHomeProjModel.h
//  hinabian
//
//  Created by 何松泽 on 2017/8/22.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMHomeProjModel : NSObject

/*项目名称*/
@property (nonatomic, copy) NSString *name;

/*项目id*/
@property (nonatomic, copy) NSString *proj_id;

/*项目url*/
@property (nonatomic, copy) NSString *url;

/*项目图片*/
@property (nonatomic, copy) NSString *img_url;

/*国家id*/
@property (nonatomic, copy) NSString *country_id;

/*身份类型*/
@property (nonatomic, copy) NSString *visa_type_cn;

/*移民类型*/
@property (nonatomic, copy) NSString *type_cn;

/*办理周期---time:时间---unit:单位*/
@property (nonatomic, copy) NSDictionary *f_cycle;

@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *time_unit;

/*投资额度---sum:额度---unit:单位*/
@property (nonatomic, copy) NSDictionary *min_amount_investment;

@property (nonatomic, copy) NSString *sum;
@property (nonatomic, copy) NSString *sum_unit;

/*服务费---current:费用---unit:单位---original:原价（为0时不显示原价）*/
@property (nonatomic, copy) NSDictionary *service_fee;

@property (nonatomic, copy) NSString *service_charge;
@property (nonatomic, copy) NSString *service_original;
@property (nonatomic, copy) NSString *service_unit;

@property (nonatomic, assign)BOOL isShowOriginal;

@end
