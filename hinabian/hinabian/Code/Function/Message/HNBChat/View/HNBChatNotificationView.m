//
//  HNBChatNotificationView.m
//  hinabian
//
//  Created by 何松泽 on 2018/1/22.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "HNBChatNotificationView.h"
#import "HNBNotificationCell.h"
#import "IMNotificationModel.h"

typedef enum : NSUInteger {
    NotificationTableIndexSetion0 = 0,
    NotificationTableIndexSetion1,
    NotificationIndexSetionCount,
} NotificationIndexSetion;

@interface HNBChatNotificationView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) NSArray *notifications;
@property (nonatomic, strong) NSArray *heightArr;
@property (nonatomic, assign) NSUInteger newsCount;

@end

@implementation HNBChatNotificationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        _notifications = [[NSArray alloc] init];
        _heightArr = [[NSArray alloc] init];
        _newsCount = 0;
        
        _backgroundView = [[UIView alloc] initWithFrame:frame];
        
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor DDR245_G245_B245ColorWithalph:1.0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 174;
        
        [self addSubview:_backgroundView];
        [self addSubview:_tableView];
        
        [self setUsallyBackground];
    }
    return self;
}

- (void)getData:(NSArray *)datas andNewsNum:(NSString *)countStr
{
    self.notifications = datas;
    self.heightArr = [self getHeightArray];
    self.newsCount = [countStr integerValue] > datas.count ? datas.count:[countStr integerValue];
    if (_notifications.count <= 0) {
        self.tableView.hidden = YES;
        self.newsCount = 0;
    }else {
        self.tableView.hidden = NO;
    }
    [self.tableView reloadData];
}

- (void)loadData:(NSArray *)datas
{
    NSMutableArray *summaryArr = [[self.notifications arrayByAddingObjectsFromArray:datas] mutableCopy];
    self.notifications = [summaryArr copy];
    self.heightArr = [self getHeightArray];
    [self.tableView reloadData];
}

#pragma mark -- 设置无消息默认背景图
- (void)setUsallyBackground
{
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMEase_NoNotification_Imag"]];
    [backgroundView setFrame:CGRectMake(SCREEN_WIDTH/2 - 35, 80, 70, 70)];
    [self.backgroundView addSubview:backgroundView];
    
    UILabel *backgroundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    backgroundLabel.text = @"暂无消息";
    backgroundLabel.textColor = [UIColor DDR153_G153_B153ColorWithalph:1];
    backgroundLabel.font = [UIFont boldSystemFontOfSize:FONT_UI26PX*SCREEN_WIDTHRATE_6];
    backgroundLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundView addSubview:backgroundLabel];
    
    
    backgroundView.sd_layout
    .topSpaceToView(self.backgroundView, 80)
    .centerXEqualToView(self.backgroundView)
    .widthIs(100*SCREEN_WIDTHRATE_6)
    .heightIs(100*SCREEN_WIDTHRATE_6);
    
    backgroundLabel.sd_layout
    .topSpaceToView(backgroundView, 20)
    .centerXEqualToView(self.backgroundView)
    .widthIs(SCREEN_WIDTH)
    .heightIs(20*SCREEN_WIDTHRATE_6);
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == NotificationTableIndexSetion0) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"lastestcell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] init];
                cell.backgroundColor = [UIColor DDR245_G245_B245ColorWithalph:1.0];
                UILabel *lastestLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 20)];
                lastestLabel.text = @"最新";
                lastestLabel.textColor = [UIColor DDR51_G51_B51ColorWithalph:0.6f];
                lastestLabel.font = [UIFont systemFontOfSize:FONT_UI24PX];
                lastestLabel.textAlignment = NSTextAlignmentLeft;
                [cell addSubview:lastestLabel];
            }
        }else {
            HNBNotificationCell *quickCell = [tableView dequeueReusableCellWithIdentifier:cellNib_HNBNotificationCell];
            if (!quickCell) {
                quickCell = [[HNBNotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNib_HNBNotificationCell];
                quickCell.layer.borderWidth = 1.0;
                quickCell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
            }
            [quickCell setCellModel: _notifications[indexPath.row - 1]];
            cell = quickCell;
        }
    }else if (indexPath.section == NotificationTableIndexSetion1) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"historycell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] init];
                cell.backgroundColor = [UIColor DDR245_G245_B245ColorWithalph:1.0];
                UILabel *lastestLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 20)];
                lastestLabel.text = @"历史";
                lastestLabel.textColor = [UIColor DDR51_G51_B51ColorWithalph:0.6f];
                lastestLabel.font = [UIFont systemFontOfSize:FONT_UI24PX];
                lastestLabel.textAlignment = NSTextAlignmentLeft;
                [cell addSubview:lastestLabel];
            }
        }else {
            HNBNotificationCell *quickCell = [tableView dequeueReusableCellWithIdentifier:cellNib_HNBNotificationCell];
            if (!quickCell) {
                quickCell = [[HNBNotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNib_HNBNotificationCell];
                quickCell.layer.borderWidth = 1.0;
                quickCell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
            }
            [quickCell setCellModel: _notifications[indexPath.row - 1 + _newsCount]];
            cell = quickCell;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == NotificationTableIndexSetion0) {
        if (indexPath.row > 0) {
            if (_delegate && [_delegate respondsToSelector:@selector(lookTribe:)]) {
                IMNotificationModel *model = _notifications[indexPath.row - 1];
                [_delegate lookTribe:model.f_jump_url];
            }
        }
    }else if (indexPath.section == NotificationTableIndexSetion1) {
        if (indexPath.row > 0) {
            if (_delegate && [_delegate respondsToSelector:@selector(lookTribe:)]) {
                IMNotificationModel *model = _notifications[indexPath.row - 1 + _newsCount];
                [_delegate lookTribe:model.f_jump_url];
            }
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == NotificationTableIndexSetion0) {
        if (indexPath.row == 0) {
            return 20;
        }else {
            CGFloat height = [_heightArr[indexPath.row - 1] floatValue];
            return height+60;
        }
    }else if (indexPath.section == NotificationTableIndexSetion1) {
        if (indexPath.row == 0) {
            return 20;
        }else{
            CGFloat height = [_heightArr[indexPath.row - 1 + _newsCount] floatValue];
            return height+60;
        }
    }
    
    return 82;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == NotificationTableIndexSetion0) {
        if (_newsCount == 0) {
            //如果没有最新消息
            return 0;
        }else {
            return _newsCount + 1;
        }
    }else if (section == NotificationTableIndexSetion1) {
        if (_newsCount == _notifications.count) {
            //如果没有历史消息
            return 0;
        }else {
            return _notifications.count - _newsCount + 1;
        }
    }
    return 0;
}

#pragma mark - 根据数据获取高度数组
-(NSArray *)getHeightArray
{
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (int index = 0;index < _notifications.count;index++) {
        IMNotificationModel *model = _notifications[index];
        if ([model.f_type isEqualToString:@"2"]) {
            //点赞的取默认高
            [tempArr addObject:[NSNumber numberWithFloat:DefaultLabelHeight]];
        }else {
            NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:FONT_UI26PX]};
            CGRect labelSize = [model.f_content boundingRectWithSize:CGSizeMake(LabelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
            [tempArr addObject:[NSNumber numberWithFloat:labelSize.size.height]];
        }
    }
    return [tempArr copy];
}

@end
