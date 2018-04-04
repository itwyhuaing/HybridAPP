//
//  FloorCommentModel.m
//  hinabian
//
//  Created by hnbwyh on 16/10/20.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "FloorCommentModel.h"
#import "FloorCommentUserInfoModel.h"

@implementation FloorCommentModel

-(FloorCommentUserInfoModel *)u_info{
    
    if (_u_info == nil) {
        _u_info = [[FloorCommentUserInfoModel alloc] init];
    }
    
    return _u_info;
}


-(NSMutableArray *)reply_infoArr{

    if (_reply_infoArr == nil) {
        _reply_infoArr = [[NSMutableArray alloc] init];
    }
    return _reply_infoArr;
}

@end
