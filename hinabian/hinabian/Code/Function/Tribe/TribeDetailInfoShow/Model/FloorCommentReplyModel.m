//
//  FloorCommentReplyModel.m
//  hinabian
//
//  Created by hnbwyh on 16/10/20.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "FloorCommentReplyModel.h"
#import "FloorCommentUserInfoModel.h"

@implementation FloorCommentReplyModel


-(FloorCommentUserInfoModel *)u_info{

    if (_u_info == nil) {
        _u_info = [[FloorCommentUserInfoModel alloc] init];
    }
    
    return _u_info;
}

-(NSMutableArray *)replyContentArr{

    if (_replyContentArr == nil) {
        _replyContentArr = [[NSMutableArray alloc] init];
    }
    return _replyContentArr;
}

@end
