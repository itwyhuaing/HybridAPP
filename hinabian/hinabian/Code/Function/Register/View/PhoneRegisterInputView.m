//
//  PhoneRegisterInputView.m
//  hinabian
//
//  Created by wangyinghua on 16/3/31.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "PhoneRegisterInputView.h"
#import "TelCountryCode.h"

@interface PhoneRegisterInputView () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *listTableView;
@property (nonatomic,strong) UIView *HUDView;
@property (nonatomic,strong) NSMutableArray *listTitles;
@property (nonatomic,strong) NSMutableArray *listImages;
@property (nonatomic,strong) NSIndexPath *oldIndexPath;
@property (nonatomic,copy) NSString *sendCountryCode;
@end

@implementation PhoneRegisterInputView

- (void)awakeFromNib{
    NSLog(@" ====== awakeFromNib");
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor DDInputLightGray] CGColor];
    self.choosedBtn.titleLabel.font = [UIFont systemFontOfSize:12];
}

- (void)initCountryChoicesTableViewShowInSuperView:(UIView *)spView{
    _spView = spView;
    _listImages = [[NSMutableArray alloc] init];
    _listTitles = [[NSMutableArray alloc] init];
    NSArray *infos = [TelCountryCode MR_findAllSortedBy:@"timestamp" ascending:YES];
    for (TelCountryCode *f in infos) {
        [_listTitles addObject:f];
        if ([f.telcountrycodeid isEqualToString:@"86"]) {
            self.choosedBtn.titleLabel.text = f.showstring;
            self.sendCountryCode = f.telcountrycodeid;
        }
    }
    [_listImages addObject:@"register_choose_countrycode_selected"];
    _oldIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    for (NSInteger cou = 1; cou < _listTitles.count; cou ++) {
        [_listImages addObject:@"register_choose_countrycode_nomal"];
    }
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    _HUDView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissHUDWithListTableViw)];
    _HUDView.userInteractionEnabled = YES;
    [_HUDView addGestureRecognizer:tap];
    _HUDView.backgroundColor = [UIColor grayColor];
    _HUDView.alpha = 0.4;
    _HUDView.hidden = YES;
    [keyWindow addSubview:_HUDView];
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, LIST_TABLEVIEW_HEIGHT) style:UITableViewStylePlain];
    _listTableView.delegate =self;
    _listTableView.dataSource = self;
    _listTableView.bounces = NO;
    _listTableView.showsVerticalScrollIndicator = NO;
    [keyWindow addSubview:_listTableView];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listTitles.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LIST_TABLEVIEW_CELLHEIGHT;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"listTableViewCell";
    UITableViewCell *cell = [_listTableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    TelCountryCode *telCountryCode = _listTitles[indexPath.row];
    cell.textLabel.text = telCountryCode.showstring;
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_listImages[indexPath.row]]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 蒙板与列表隐藏
    [self dismissHUDWithListTableViw];
    // 数据更新
    if (_oldIndexPath.row != indexPath.row) {
        TelCountryCode *telF = _listTitles[indexPath.row];
        [self.choosedBtn setTitle:telF.showstring forState:UIControlStateNormal];
        _sendCountryCode = telF.telcountrycodeid;
        [_listImages removeObjectAtIndex:_oldIndexPath.row];
        [_listImages insertObject:@"register_choose_countrycode_nomal" atIndex:_oldIndexPath.row];
        [_listImages removeObjectAtIndex:indexPath.row];
        [_listImages insertObject:@"register_choose_countrycode_selected" atIndex:indexPath.row];
        [_listTableView reloadData];
        _oldIndexPath = indexPath;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(phoneRegisterInputView:didSelectedCountryCode:)]) {
        [_delegate phoneRegisterInputView:self didSelectedCountryCode:_sendCountryCode];
    }
}

- (IBAction)choosePhoneCodeOfCountry:(id)sender {
    [_spView endEditing:YES];
    [self showHUDWithListTableViw];
}

// 展示蒙板与列表
- (void)showHUDWithListTableViw{
    CGRect rect = _listTableView.frame;
    if (rect.origin.y == SCREEN_HEIGHT) {
        _HUDView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _listTableView.transform = CGAffineTransformTranslate(_listTableView.transform, 0, -LIST_TABLEVIEW_HEIGHT);
        }];
    }
}

// 隐藏蒙板与列表
- (void)dismissHUDWithListTableViw{
    CGRect rect = _listTableView.frame;
    if (rect.origin.y == SCREEN_HEIGHT-LIST_TABLEVIEW_HEIGHT) {
        [UIView animateWithDuration:0.3 animations:^{
            _listTableView.transform = CGAffineTransformTranslate(_listTableView.transform, 0, LIST_TABLEVIEW_HEIGHT);
        } completion:^(BOOL finished) {
            _HUDView.hidden = YES;
        }];
    }
}
@end
