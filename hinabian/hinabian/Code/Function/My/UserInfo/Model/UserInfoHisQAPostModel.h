//
//  UserInfoHisQAPostModel.h
//  hinabian
//
//  Created by hnbwyh on 16/8/22.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoHisQAPostModel : NSObject

@property ( nonatomic,  copy) NSString *type;
@property ( nonatomic,  copy) NSString *comment_brief;
@property ( nonatomic,  copy) NSString *content;
@property ( nonatomic,  copy) NSString *title;
@property ( nonatomic,  copy) NSString *formated_time;
@property ( nonatomic,  copy) NSString *question_id;
@property ( nonatomic,  copy) NSString *answer_id;
@property ( nonatomic,  copy) NSString *answer_num;
@property ( nonatomic,  copy) NSString *view_num;
@property ( nonatomic,  copy) NSString *label;
@property ( nonatomic,  copy) NSString *timestamp;

@end
