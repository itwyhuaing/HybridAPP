//
//  TribeShowQAModel.h
//  hinabian
//
//  Created by hnbwyh on 17/4/19.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TribeShowQAModel : NSObject

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *questionid;
@property (nullable, nonatomic, copy) NSString *answerid;
@property (nullable, nonatomic, copy) NSString *answername;
@property (nullable, nonatomic, copy) NSString *qadescription;
@property (nullable, nonatomic, copy) NSString *userhead_url;
@property (nullable, nonatomic, copy) NSString *userid;
@property (nullable, nonatomic, copy) NSString *username;
@property (nullable, nonatomic, retain) NSObject *labels;
@property (nullable, nonatomic, copy) NSString *view_num;
@property (nullable, nonatomic, copy) NSString *certified;
@property (nullable, nonatomic, copy) NSString *certified_type;
@property (nullable, nonatomic, copy) NSString *level;
@property (nullable, nonatomic, copy) NSString *collect;
@property (nullable, nonatomic, copy) NSString *timestamp;
@property (nullable, nonatomic, copy) NSString *time;

@end
