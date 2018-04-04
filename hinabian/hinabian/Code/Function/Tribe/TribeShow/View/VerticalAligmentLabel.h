//
//  VerticalAligmentLabel.h
//  hinabian
//
//  Created by hnbwyh on 16/6/8.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
         VerticalAlignmentTop = 0, // default
         VerticalAlignmentMiddle,
         VerticalAlignmentBottom,
    } VerticalAlignment;

@interface VerticalAligmentLabel : UILabel
{
@private
VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;
@end
