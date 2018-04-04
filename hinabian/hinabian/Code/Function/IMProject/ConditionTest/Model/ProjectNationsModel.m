//
//  ProjectNationsModel.m
//  hinabian
//
//  Created by 何松泽 on 2017/6/8.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "ProjectNationsModel.h"

@implementation ProjectNationsModel

-(NSMutableArray *)project_Arr{
    
    if (_project_Arr == nil) {
        _project_Arr = [[NSMutableArray alloc] init];
    }
    return _project_Arr;
}

@end
