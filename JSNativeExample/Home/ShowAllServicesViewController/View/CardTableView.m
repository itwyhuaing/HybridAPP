//
//  CardTableView.m
//  hinabian
//
//  Created by hnbwyh on 2018/3/28.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "CardTableView.h"
#import "CardTableViewCell.h"
#import "RefreshControl.h"

@interface CardTableView () <UITableViewDelegate,UITableViewDataSource,RefreshControlDelegate>

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *listData;
@property (nonatomic,strong) RefreshControl *refreshControl;

@end

@implementation CardTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = CGRectZero;
        rect.size = frame.size;
        _table = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        _listData = [[NSMutableArray alloc] init];
//        _refreshControl=[[RefreshControl alloc] initWithScrollView:self.table delegate:self];
//        _refreshControl.topEnabled=YES;
//        _refreshControl.bottomEnabled=YES;
        _table.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_table];
        
    }
    return self;
}

-(UITableView *)getCurrentTableView{
    return self.table;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat xh = section <= 0 ? kTABLEHEADERHEIGHT : 0.0;
    return xh;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCARDTABLEVIEWCELLHEIGHT;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_CardTableViewCell];
    if (!cell) {
        cell = [[CardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_CardTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell modifyCellWithModel:(CardTableDataModel *)_listData[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(cardTableView:didSelectedIndexPath:)]) {
        //NSLog(@" === ");
        [_delegate cardTableView:self didSelectedIndexPath:indexPath];
    }
}

#pragma mark - scrollViewDidScroll

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollCardTableViewWithOffsetY:)]) {
        //NSLog(@" --- ");
        [_delegate scrollCardTableViewWithOffsetY:scrollView.contentOffset.y];
    }
}

#pragma mark - 数据回调

-(void)modifyTableHeaderWithType:(CardTableContentType)type{
    NSString *text = @"";
    NSString *bgImageName = @"";
    NSString *iconImageName = @"";
    
    switch (type) {
        case CardTableContentTypeOverseaCompany:
            text = @"海外公司注册";
            bgImageName = @"oversea_company_sevice";
            iconImageName = @"oversea_company_sevice_icon";
            break;
        case CardTableContentTypeOverseaBank:
            text = @"海外银行开户";
            bgImageName = @"oversea_bank_sevice";
            iconImageName = @"oversea_bank_sevice_icon";
            break;
        default:
            break;
    }
    
    UILabel *titleLabel = [self.headerView viewWithTag:HeaderSubViewThemTitle];
    UIImageView *iconImageV = [self.headerView viewWithTag:HeaderSubViewIconImageV];
    UIImageView *bgImageV = [self.headerView viewWithTag:HeaderSubViewBgImageV];
    bgImageV.image = [UIImage imageNamed:bgImageName];
    titleLabel.text = [NSString stringWithFormat:@"· %@ ·",text];
    iconImageV.image = [UIImage imageNamed:iconImageName];
}

-(void)refreshTableWithDataSource:(NSArray *)dataSource{
    [_listData addObjectsFromArray:dataSource];
    [self.table reloadData];
}

#pragma mark - 刷新

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{
    
    if (direction == RefreshDirectionTop) { // 顶部下拉刷新
        
        NSLog(@" (direction == RefreshDirectionTop) ");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
        });
        
        return;
        
    } else if (direction == RefreshDirectionBottom){ // 底部上拉加载
        
        NSLog(@" (direction == RefreshDirectionBottom) ");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
        });
        
    }
    
}

- (void)clickEventBtn:(UIButton *)btn{
    
    if (_delegate && [_delegate respondsToSelector:@selector(didClickCardTableHeaderBackBtn:)]) {
        [_delegate didClickCardTableHeaderBackBtn:btn];
    }
}


#pragma mark - 懒加载

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTABLEHEADERHEIGHT)];
        UILabel *titleLabel = [[UILabel alloc] init];
        UIImageView *icon = [[UIImageView alloc] init];
        UIImageView *bgImageV = [[UIImageView alloc] init];
        UIButton *backBtn = [[UIButton alloc] init];
        [_headerView addSubview:bgImageV];
        [_headerView addSubview:backBtn];
        [_headerView addSubview:titleLabel];
        [_headerView addSubview:icon];
        
        bgImageV.sd_layout
        .topEqualToView(_headerView)
        .bottomEqualToView(_headerView)
        .leftEqualToView(_headerView)
        .rightEqualToView(_headerView);
        backBtn.sd_layout
        .widthIs(40.0)
        .heightEqualToWidth()
        .leftSpaceToView(_headerView, 10.0)
        .topSpaceToView(_headerView, 20.0);
        titleLabel.sd_layout
        .leftEqualToView(_headerView)
        .rightEqualToView(_headerView)
        .bottomSpaceToView(_headerView, 22.0 * SCREEN_WIDTHRATE_6)
        .heightIs(17.0 * SCREEN_WIDTHRATE_6);
        icon.sd_layout
        .centerXEqualToView(_headerView)
        .bottomSpaceToView(titleLabel, 12.0 * SCREEN_WIDTHRATE_6)
        .widthIs(90.0 * SCREEN_WIDTHRATE_6)
        .heightEqualToWidth();
        
        bgImageV.tag = HeaderSubViewBgImageV;
        titleLabel.tag = HeaderSubViewThemTitle;
        icon.tag = HeaderSubViewIconImageV;
        bgImageV.clipsToBounds = TRUE;
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_UI36PX];
        titleLabel.textColor = [UIColor DDBlack333];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        icon.layer.masksToBounds = TRUE;
        icon.layer.cornerRadius = (90.0 * SCREEN_WIDTHRATE_6)/2.0;
        [backBtn setImage:[UIImage imageNamed:@"btn_fanhui_black"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(clickEventBtn:) forControlEvents:UIControlEventTouchUpInside];
        
//        backBtn.backgroundColor = [UIColor yellowColor];
//        bgImageV.backgroundColor = [UIColor cyanColor];
        
    }
    return _headerView;
}

@end
