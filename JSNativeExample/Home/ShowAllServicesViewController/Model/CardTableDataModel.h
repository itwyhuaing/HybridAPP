//
//  CardTableDataModel.h
//  hinabian
//
//  Created by hnbwyh on 2018/3/29.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardTableDataModel : NSObject

@property (nonatomic,copy) NSString *prj_id;
@property (nonatomic,copy) NSString *project_desc;
@property (nonatomic,copy) NSString *project_name;
@property (nonatomic,copy) NSString *project_type;
@property (nonatomic,copy) NSString *promotion_img;
@property (nonatomic,copy) NSString *total_fee;
@property (nonatomic,copy) NSString *total_fee_currency_gb;

@end
