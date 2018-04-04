//
//  MyUILabel.h
//  hinabian
//
//  Created by 余坚 on 15/8/5.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface MyUILabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;
@end
