//
//  ShufllingScrolView.h
//  hinabian
//
//  Created by 余坚 on 15/7/11.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface SGFocusImageItem : NSObject

@property (nonatomic, retain)  NSString     *title;
@property (nonatomic, retain)  NSString      *image;
@property (nonatomic, assign)  NSInteger     tag;

- (id)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag;
- (id)initWithDict:(NSDictionary *)dict tag:(NSInteger)tag;
@end
