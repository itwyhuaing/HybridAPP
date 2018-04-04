//
//  IMNationCityModel.h
//  hinabian
//
//  Created by 何松泽 on 2017/10/27.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMNationCityModel : NSObject

@property (nonatomic, strong) NSString *fID;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *shortName;
@property (nonatomic, strong) NSString *wholeName;
@property (nonatomic, copy)   NSArray *city;

/*问题里的参数*/
@property (nonatomic, assign) NSInteger value;

@end
