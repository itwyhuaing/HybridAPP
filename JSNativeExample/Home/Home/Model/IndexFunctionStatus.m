//
//  IndexFunctionStatus.m
//  hinabian
//
//  Created by hnb on 16/4/18.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "IndexFunctionStatus.h"

@implementation IndexFunctionStatus

-(void)encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeObject:self.no forKey:@"no"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.pic forKey:@"pic"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.isLocal forKey:@"isLocal"];
    [aCoder encodeObject:self.isHide forKey:@"isHide"];
    
    [aCoder encodeObject:self.isShowTip forKey:@"isShowTip"];
    [aCoder encodeObject:self.tipText forKey:@"tipText"];
    [aCoder encodeObject:self.tipBgColor forKey:@"tipBgColor"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{

    self = [super init];
    if (self) {
        self.no = [aDecoder decodeObjectForKey:@"no"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.pic = [aDecoder decodeObjectForKey:@"pic"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.isLocal = [aDecoder decodeObjectForKey:@"isLocal"];
        self.isHide = [aDecoder decodeObjectForKey:@"isHide"];
        
        self.isShowTip = [aDecoder decodeObjectForKey:@"isShowTip"];
        self.tipText = [aDecoder decodeObjectForKey:@"tipText"];
        self.tipBgColor = [aDecoder decodeObjectForKey:@"tipBgColor"];
    }
    return self;
}
@end
