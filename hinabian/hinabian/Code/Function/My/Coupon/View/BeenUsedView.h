//
//  BeenUsedView.h
//  hinabian
//
//  Created by hnb on 16/4/13.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeenUsedView : UIView
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * dataArray;
- (void) setNothing;          //无数据情况设置
@end
