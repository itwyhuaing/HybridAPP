//
//  QAFilterView.h
//  hinabian
//
//  Created by 余坚 on 16/7/25.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshControl.h"

@interface QAFilterView : UIView
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) RefreshControl *refreshControl;
- (void) reloadQAFilterData;
- (void) ShowFilterView;
- (void) hideFilterView;

- (BOOL) isSelectLabelEmpty;
@end
