//
//  ProjectStateModel.h
//  hinabian
//
//  Created by hnbwyh on 16/6/14.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectStateModel : NSObject

@property (nonatomic,copy) NSString *user_project_id; // 关闭项目参数 
@property (nonatomic,strong) NSArray *userSteps;
@property (nonatomic,copy) NSString *projectName;
@property (nonatomic,copy) NSString *specialName;
@property (nonatomic,copy) NSString *lookLink;

@property (nonatomic,copy) NSString *isShow;

@end
