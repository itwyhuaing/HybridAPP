//
//  QANotificationView.m
//  hinabian
//
//  Created by hnbwyh on 16/6/6.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "QANotificationView.h"
#import "QANotificationCell.h"

@interface QANotificationView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *listData;
@property (nonatomic,strong) NSArray *times;
@property (nonatomic,strong) NSArray *descs;

@end


@implementation QANotificationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _times = @[@"2分钟前",@"17:59",@"12-08"];
        _descs = @[@"如何办理美国移民",@"现在可以申请美国签证吗？（美国签证的价值）",@"有案底就不能移民吗"];
        _listData = [[NSMutableArray alloc] init];
        [self setUpViewAfterData:frame];
    }
    return self;
}



- (void)setUpViewAfterData:(CGRect)frame{

    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];

    [_tableView registerNib:[UINib nibWithNibName:cellNibName_QANotificationCell bundle:nil] forCellReuseIdentifier:cellNibName_QANotificationCell];
    [self addSubview:_tableView];
    
}


#pragma mark ------ UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
    return _listData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QANotificationCell *returnCell = [tableView dequeueReusableCellWithIdentifier:cellNibName_QANotificationCell];
    
    [returnCell setCellItem:_times[indexPath.row] desc:_descs[indexPath.row]];
    return returnCell;
}













/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
