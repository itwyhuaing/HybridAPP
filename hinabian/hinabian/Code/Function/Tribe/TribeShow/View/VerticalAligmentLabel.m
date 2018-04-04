//
//  VerticalAligmentLabel.m
//  hinabian
//
//  Created by hnbwyh on 16/6/8.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "VerticalAligmentLabel.h"

@implementation VerticalAligmentLabel
@synthesize verticalAlignment = verticalAlignment_;

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.verticalAlignment = VerticalAlignmentMiddle;
        
    }
    
return self;
    
}

- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {
    
    verticalAlignment_ = verticalAlignment;
    [self setNeedsDisplay];
    
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {

    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
        switch (self.verticalAlignment) {
            case VerticalAlignmentTop:
                textRect.origin.y = bounds.origin.y;
            break;
            case VerticalAlignmentBottom:
                textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
            case VerticalAlignmentMiddle:
                // Fall through.
            default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
        }
    return textRect;
    
}

-(void)drawTextInRect:(CGRect)requestedRect {

    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
    
}
@end
