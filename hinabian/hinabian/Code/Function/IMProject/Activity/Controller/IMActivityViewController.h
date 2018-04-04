//
//  IMActivityViewController.h
//  hinabianBBS
//
//  Created by 何松泽 on 16/11/29.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARSegmentControllerDelegate.h"

@interface IMActivityViewController : UIBaseViewController<ARSegmentControllerDelegate>
@property (strong, nonatomic)  UITableView *tableView;
@end
