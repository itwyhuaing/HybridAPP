//
//  ProjectContientModel.m
//  hinabian
//
//  Created by 何松泽 on 2017/6/8.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "ProjectContientModel.h"

@implementation ProjectContientModel

-(NSMutableArray *)nations_Arr{
    
    if (_nations_Arr == nil) {
        _nations_Arr = [[NSMutableArray alloc] init];
    }
    return _nations_Arr;
}

@end
