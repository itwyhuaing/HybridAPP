//
//  IMInterviewViewController.h
//  hinabian
//
//  Created by 何松泽 on 15/11/25.
//  Copyright © 2015年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARSegmentControllerDelegate.h"

@interface IMInterviewViewController : UIBaseViewController<ARSegmentControllerDelegate>
@property (strong, nonatomic)  UITableView *tableView;

@end
