//
//  IMAssessQuesnaireContentModel.h
//  hinabian
//
//  Created by wangyinghua on 16/4/11.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMAssessQuesnaireContentModel : NSObject

@property (nonatomic,copy) NSString *redFlag;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *note;
@property (nonatomic,copy) NSArray *subTitles;
@property (nonatomic,copy) NSArray *choices;

@end
