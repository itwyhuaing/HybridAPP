//
//  ProjectNationsModel.h
//  hinabian
//
//  Created by 何松泽 on 2017/6/8.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectNationsModel : NSObject

@property (nonatomic,copy) NSString *nation_name;
@property (nonatomic,copy) NSString *cn_short_name;
@property (nonatomic,copy) NSString *nation_id; // id
@property (nonatomic,copy) NSString *desc;      // 国家描述
@property (nonatomic,strong) NSMutableArray *project_Arr;

@end
