//
//  HTMLContentModel.h
//  hinabian
//
//  Created by hnbwyh on 16/11/9.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HTMLContentModelTagPText,
    HTMLContentModelTagHref,
    HTMLContentModelTagImg,
    HTMLContentModelTagBr,
} HTMLContentModelTagType;

@interface HTMLContentModel : NSObject

@property (nonatomic) HTMLContentModelTagType tagType;

// Text
@property (nonatomic,copy) NSString *textString;

// Hyper
@property (nonatomic,copy) NSString *hyperTitle;
@property (nonatomic,copy) NSString *hyperLink;

// Image
@property (nonatomic,copy) NSString *imgURLString;
@property (nonatomic) CGFloat imgWidth;
@property (nonatomic) CGFloat imgHeight;

@end
