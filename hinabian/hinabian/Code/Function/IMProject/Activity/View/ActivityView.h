//
//  SeminarView.h
//  hinabian
//
//  Created by 何松泽 on 17/1/10.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityManager.h"

@interface ActivityView : UIView

@property (nonatomic, strong)ActivityManager *activityManager;

@property (nonatomic) NSInteger countPerReq;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *seminarSource;
@property (nonatomic, strong)NSString *type;

-(instancetype)initWithFrame:(CGRect)frame
                        type:(NSString *)type
                     superVC:(UIViewController *)superVC;
-(void)reloadTableViewWIthData:(NSArray *)data;

@end
