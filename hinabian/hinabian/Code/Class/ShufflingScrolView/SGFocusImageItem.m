//
//  ShufllingScrolView.m
//  hinabian
//
//  Created by 余坚 on 15/7/11.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "SGFocusImageItem.h"

@implementation SGFocusImageItem
@synthesize title = _title;
@synthesize image = _image;
@synthesize tag = _tag;


- (id)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.tag = tag;
    }
    
    return self;
}

- (id)initWithDict:(NSDictionary *)dict tag:(NSInteger)tag
{
    self = [super init];
    if (self)
    {
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            self.title = [dict objectForKey:@"title"];
            //...
        }
    }
    return self;
}
@end
