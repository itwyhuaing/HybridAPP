//
//  SpecialActivityViewController.h
//  hinabian
//
//  Created by 何松泽 on 15/11/25.
//  Copyright © 2015年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARSegmentPageController.h"
#import "IMClassroomViewController.h"
#import "IMInterviewViewController.h"
#import "IMActivityViewController.h"
#import "SeminarViewController.h"

@interface SpecialActivityViewController : ARSegmentPageController
-(instancetype)initWithIndex:(NSInteger) index;
@end
