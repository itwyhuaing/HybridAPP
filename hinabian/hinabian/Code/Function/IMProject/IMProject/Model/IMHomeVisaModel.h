//
//  IMHomeVisaModel.h
//  hinabian
//
//  Created by 何松泽 on 2017/8/22.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMHomeVisaModel : NSObject

/*签证名称*/
@property (nonatomic, copy) NSString *name;

/*国家id*/
@property (nonatomic, copy) NSString *country_id;

/*签证id*/
@property (nonatomic, copy) NSString *visa_id;

/*签证url*/
@property (nonatomic, copy) NSString *url;

/*签证图片*/
@property (nonatomic, copy) NSString *img_url;

/*办理时长---time:时间---unit:单位*/
@property (nonatomic, copy) NSDictionary *f_cycle;

@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *time_unit;

/*是否需要面试*/
@property (nonatomic, copy) NSString *interview;

/*服务费*/
@property (nonatomic, copy) NSString *service_charge;
@property (nonatomic, copy) NSString *service_original;

/*领馆费用*/
@property (nonatomic, copy) NSString *official_charge;

/*总费用 = 服务费 + 领馆费用*/
@property (nonatomic, copy) NSString *all_charge;

@end
