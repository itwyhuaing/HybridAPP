//
//  NationCodesView.m
//  hinabian
//
//  Created by hnbwyh on 16/9/2.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "NationCodesView.h"
#import "TelCountryCode.h"

@interface NationCodesView () <UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic,strong) UIView *superView;
@property (nonatomic,strong) UIView *hudView;
@property (nonatomic,strong) NSMutableArray *listTitles;
@property (nonatomic,strong) UITableView *listTable;

@end



@implementation NationCodesView



- (instancetype)initWithDelegate:(id<NationCodesViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        
        _delegate = delegate;
        _listTitles = [[NSMutableArray alloc] init];
        NSArray *infos = [TelCountryCode MR_findAllSortedBy:@"timestamp" ascending:YES];
        for (TelCountryCode *f in infos) {
            [_listTitles addObject:f];
        }
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        _hudView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NATIONCODE_LIST_TABLE_HEIGHT)];
        [btn addTarget:self action:@selector(dismissHUDWithListTableViw) forControlEvents:UIControlEventTouchUpInside];
        //btn.backgroundColor = [UIColor redColor];
        [_hudView addSubview:btn];
        
        _hudView.backgroundColor = [UIColor DDR0_G0_B0ColorWithalph:0.7];
        _hudView.hidden = YES;
        [keyWindow addSubview:_hudView];
        _listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, NATIONCODE_LIST_TABLE_HEIGHT) style:UITableViewStylePlain];
        _listTable.delegate =self;
        _listTable.dataSource = self;
        _listTable.bounces = NO;
        _listTable.showsVerticalScrollIndicator = NO;
        [_hudView addSubview:_listTable];
        
    }
    return self;
}

- (void)showNationCodesTableView{

    CGRect rect = _listTable.frame;
    if (rect.origin.y == SCREEN_HEIGHT) {
        _hudView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _listTable.transform = CGAffineTransformTranslate(_listTable.transform, 0, -NATIONCODE_LIST_TABLE_HEIGHT);
        }];
    }
    
    
}

- (void)dismissHUDWithListTableViw{

    CGRect rect = _listTable.frame;
    if (rect.origin.y == SCREEN_HEIGHT - NATIONCODE_LIST_TABLE_HEIGHT) {
        [UIView animateWithDuration:0.3 animations:^{
            _listTable.transform = CGAffineTransformTranslate(_listTable.transform, 0, NATIONCODE_LIST_TABLE_HEIGHT);
        } completion:^(BOOL finished) {
            _hudView.hidden = YES;
        }];
    }
    
}

#pragma mark ------ UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NATIONCODE_LIST_TABLE_CELLHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"listTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:FONT_UI26PX];
        cell.selectedBackgroundView.backgroundColor = [UIColor DDR245_G245_B245ColorWithalph:1.0];
    }
    cell.backgroundColor = [UIColor whiteColor];
    TelCountryCode *telCountryCode = _listTitles[indexPath.row];
    cell.textLabel.text = telCountryCode.showstring;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 蒙板与列表隐藏
    [self dismissHUDWithListTableViw];

    // 数据更新
    TelCountryCode *f = _listTitles[indexPath.row];
    _currentNationCode = f.telcountrycodeid;
    // 代理回调
    if (_delegate && [_delegate respondsToSelector:@selector(nationCodesView:didSelectedNationCode:)] && ![_lastNationCode isEqualToString:_currentNationCode]) {
        [_delegate nationCodesView:self didSelectedNationCode:_currentNationCode];
    }
    _lastNationCode = _currentNationCode;
    
}


@end
