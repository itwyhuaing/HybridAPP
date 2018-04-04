//
//  QALabelSelectView.h
//  hinabian
//
//  Created by 余坚 on 16/7/27.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QALabelSelectView : UIView
@property (strong, nonatomic) NSArray * labelsArray;
@property (strong, nonatomic) NSString * labelsString;
- (void) updateTagWrite:(NSArray *)array;
@end
