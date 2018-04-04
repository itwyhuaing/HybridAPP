//
//  GreatTalkModel.h
//  hinabian
//
//  Created by hnbwyh on 2017/10/23.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GreatTalkModel : NSObject

@property (nonatomic,copy) NSString *greatImage_url;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *talk_link;

@property (nonatomic,copy) NSString  *greatMasterIcon;
@property (nonatomic,copy) NSString  *greatMasterName;
@property (nonatomic,copy) NSString  *greatMasterDes;
@property (nonatomic,copy) NSString  *talkNum;
@property (nonatomic,copy) NSString  *talkTime;
@property (nonatomic,copy) NSString  *dateShow;  // 由 talkTime 计算出需要展示的日期

@end
