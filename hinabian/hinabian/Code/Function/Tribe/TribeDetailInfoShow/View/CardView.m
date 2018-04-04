//
//  CardView.m
//  CardSlide
//
//  Created by Rahul Pant on 03/09/15.
//  Copyright (c) 2015 Rahul Pant. All rights reserved.
//

#import "CardView.h"
#import "CommentsTitleCell.h"
#import "ReplyTableViewCell.h"
#import "BottomReqMoreDataCell.h"
#import "TribeDetailInfoCellManager.h"
#import "FloorCommentModel.h"
#import "TopShowTableViewCell.h"
#import "TribeIndexNoticeTableViewCell.h"
#import "textUiTableViewCell.h"
#import "TribeDetailRelatedThem.h"
#import "TribeDetailFunctionEntryCell.h"
#import "ThemTitleCell.h"
#import "TribeThemeModel.h"
#import "PersonalInfo.h"
#import "EditorViewCell.h"

typedef enum
{
    FIRST_PAGE_TOP_SHOW_INDEX = 0,
    FIRST_PAGE_WEB_INDEX,
    FIRST_PAGE_EDITOR,//原生楼主信息
    FIRST_PAGE_IMASSESS_INDEX,
    FIRST_PAGE_NATION_INDEX,
    FIRST_PAGE_EMPTY_ONE,
    FIRST_PAGE_RELETED_TITLE_INDEX,
    FIRST_PAGE_THEME_ONE,
    FIRST_PAGE_THEME_TWO,
    FIRST_PAGE_THEME_THREE,
    FIRST_PAGE_EMPTY_INDEX,
    FIRST_PAGE_ALL_COMMENT_LABEL_INDEX,
    FIRST_PAGE_DEFAULT,
} FirstPageIndex;

#define FLASH_CELL_HEIGHT    88

#define WEB_GAP_THEMTITLE 10.f
#define THEMTITLE_HEIGHT 31.f
#define BOTTOM_HEIGHT 44.f 

@interface CardView ()<UITableViewDelegate, UIScrollViewDelegate,textUiTableViewCellDelegate,ReplyTableViewCellDelegate>

@property (nonatomic,strong) NSMutableArray *listArr;
@property (nonatomic) NSInteger totalCellCount;

@end

@implementation CardView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _isBottomOutControl = FALSE;
    _isTopOutControl = FALSE;
    _isFirstPage = FALSE;
    _isLastPage = FALSE;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaskView)];
    [_maskView addGestureRecognizer:singleTap];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaskView)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown; //向上、下
    [_maskView addGestureRecognizer:swipeGesture];
    [self registerCellPrototype];
}

-(void)registerCellPrototype {
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_TopShowTableViewCell bundle:nil] forCellReuseIdentifier:cellNibName_TopShowTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_TribeIndexNoticeCell bundle:nil] forCellReuseIdentifier:cellNibName_TribeIndexNoticeCell];
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_textUiTableViewCellCell bundle:nil] forCellReuseIdentifier:cellNibName_textUiTableViewCellCell];
    [self.tableView registerNib:[UINib nibWithNibName:cellNib_TribeDetailRelatedThem bundle:nil] forCellReuseIdentifier:cellNib_TribeDetailRelatedThem];
    [self.tableView registerNib:[UINib nibWithNibName:cellNib_TribeDetailFunctionEntryCell bundle:nil] forCellReuseIdentifier:cellNib_TribeDetailFunctionEntryCell];
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_ThemTitleCell bundle:nil] forCellReuseIdentifier:cellNibName_ThemTitleCell];
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_EditorViewCell bundle:nil] forCellReuseIdentifier:cellNibName_EditorViewCell];
}

- (void)tableViewToTop {
    [_tableView setContentOffset:CGPointMake(0, 0) animated:FALSE];
}

- (void)tableViewToBottom {
    [_tableView setContentOffset:CGPointMake(0, _tableView.contentSize.height - _tableView.frame.size.height) animated:FALSE];
}

- (void)tapMaskView {
    if (_delegate && [_delegate respondsToSelector:@selector(tapMaskView)]) {
        [_delegate tapMaskView];
    }
}

#pragma mark ------ UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isFirstPage && _listArr.count == 0) {
        //第一页无评论
        return _listArr.count + FIRST_PAGE_DEFAULT + 1;
    } else if(_isFirstPage && _isLastPage) {
        return _listArr.count + FIRST_PAGE_DEFAULT + 1;
    } else if (_isFirstPage) {
        return _listArr.count + FIRST_PAGE_DEFAULT;
    } else if (_isLastPage) {
        return _listArr.count + 1;
    } else {
        return _listArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isFirstPage) {
        if (indexPath.row == FIRST_PAGE_TOP_SHOW_INDEX ) {
            return 60.0;
        } else if (indexPath.row == FIRST_PAGE_WEB_INDEX) {
            return _heightForWeb;
        } else if (indexPath.row == FIRST_PAGE_IMASSESS_INDEX) {
            return 44.f;
        } else if (indexPath.row == FIRST_PAGE_NATION_INDEX) {
            if (_funcDic != nil) {
                return 44.f;
            }
            return 0.f;
        } else if (indexPath.row == FIRST_PAGE_EDITOR){//原生楼主信息
            NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
            PersonalInfo *userInfo = nil;
            if (tmpPersonalInfoArry.count != 0) {
                userInfo = tmpPersonalInfoArry[0];
                if ([userInfo.id isEqualToString:_lzInfo.personID] || !_lzInfo.personID || [_lzInfo.personID isEqualToString:@""] || [_lzInfo.personID isKindOfClass:[NSNull class]]){//本人的帖子不显示关注
                    return 0.f;
                }else{
                    return 150.f;
                }
            }
            return 150.f;
        } else if (indexPath.row == FIRST_PAGE_EMPTY_ONE) {
            if (self.relContents.count > 0) {
                return 9.f;
            }
            return 0.f;
        } else if (indexPath.row == FIRST_PAGE_RELETED_TITLE_INDEX){
            if (self.relContents.count > 0) {
                return 32.f;
            }
            return 0.f;
        } else if (indexPath.row == FIRST_PAGE_THEME_ONE){
            if (self.relContents.count > 0) {
                return 44.f;
            }
            return 0.f;
        } else if (indexPath.row == FIRST_PAGE_THEME_TWO){
            if (self.relContents.count > 1) {
                return 44.f;
            }
            return 0.f;
        } else if (indexPath.row == FIRST_PAGE_THEME_THREE){
            if (self.relContents.count > 2) {
                return 44.f;
            }
            return 0.f;
        } else if (indexPath.row == FIRST_PAGE_EMPTY_INDEX)
        {
            return 9.f; //22;
        } else if (indexPath.row == FIRST_PAGE_ALL_COMMENT_LABEL_INDEX) {
            return 32.f;//44;
        } else if (_listArr.count == 0) {
            return FLASH_CELL_HEIGHT;
        } else if (_isLastPage && indexPath.row == FIRST_PAGE_DEFAULT + _listArr.count) {
            return FLASH_CELL_HEIGHT;
        } else {
            if (indexPath.row - FIRST_PAGE_DEFAULT < _listArr.count) {
                TribeDetailInfoCellManager *manager = _listArr[indexPath.row-FIRST_PAGE_DEFAULT];
                return manager.cellHeight;
            } else{
                NSLog(@"indexPath=%ld    _listArr=%lu",(long)indexPath.row,(unsigned long)_listArr.count);
            }
        }
    } else {
        if(_isLastPage && indexPath.row == _listArr.count)
        {
            return FLASH_CELL_HEIGHT;
        } else {
            if(indexPath.row < _listArr.count)
            {
                TribeDetailInfoCellManager *manager = _listArr[indexPath.row];
                return manager.cellHeight;
            }
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *returnCell = nil;
    if (_isFirstPage) {
        if(indexPath.row == FIRST_PAGE_TOP_SHOW_INDEX) {
            textUiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_textUiTableViewCellCell];
            if (_tribInfo != nil) {
                [cell setDataForTribeInfo:_tribInfo];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = (id)self;
            returnCell = cell;
        } else if(indexPath.row == FIRST_PAGE_WEB_INDEX) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
                [cell addSubview:_wkWebForTribe];
            }
            [_wkWebForTribe setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _heightForWeb)];
            returnCell = cell;
        } else if (indexPath.row == FIRST_PAGE_IMASSESS_INDEX) {
            TribeDetailFunctionEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNib_TribeDetailFunctionEntryCell];
            cell.layer.borderWidth = 1.0f;
            cell.layer.borderColor = [UIColor DDR238_G238_B238ColorWithalph:1.0].CGColor;
            [cell configContentsForCellWithString:@"移民评估"];
            returnCell = cell;
        } else if (indexPath.row == FIRST_PAGE_NATION_INDEX) {
            TribeDetailFunctionEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNib_TribeDetailFunctionEntryCell];
            cell.layer.borderColor = [UIColor DDR238_G238_B238ColorWithalph:1.0].CGColor;
            NSString *tmpString = @"";
            if (_funcDic != nil) {
                tmpString = [_funcDic objectForKey:@"title"];
            }
            [cell configContentsForCellWithString:tmpString];
            returnCell = cell;
        } else if (indexPath.row == FIRST_PAGE_EDITOR){
            //楼主信息
            EditorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_EditorViewCell];
            NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
            PersonalInfo *userInfo = nil;
            if (tmpPersonalInfoArry.count != 0) {
                userInfo = tmpPersonalInfoArry[0];
                if ([userInfo.id isEqualToString:_lzInfo.personID] || !_lzInfo.personID || [_lzInfo.personID isEqualToString:@""] || [_lzInfo.personID isKindOfClass:[NSNull class]]) {
                    //本人的帖子不显示关注
                    [cell setCellHidden:TRUE];
                } else {
                    [cell setCellHidden:FALSE];
                    [cell setViewWithPersonInfo:_lzInfo];
                    cell.layer.borderWidth = 0.f;
                    cell.layer.borderColor = [UIColor clearColor].CGColor;
                }
            } else {
                [cell setCellHidden:FALSE];
                [cell setViewWithPersonInfo:_lzInfo];
                cell.layer.borderWidth = 0.f;
                cell.layer.borderColor = [UIColor clearColor].CGColor;
            }
            returnCell = cell;
        } else if (indexPath.row == FIRST_PAGE_EMPTY_ONE){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GapCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GapCell"];
                cell.backgroundColor = [UIColor DDR245_G245_B245ColorWithalph:1.0];
            }
            returnCell = cell;
        } else if (indexPath.row == FIRST_PAGE_RELETED_TITLE_INDEX) {
            ThemTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_ThemTitleCell];
            cell.layer.borderWidth = 0.5f;
            cell.layer.borderColor = [UIColor DDR238_G238_B238ColorWithalph:1.0].CGColor;
            [cell setcellIcon:nil title:nil detailTitle:nil arrow:nil];
            if (_relContents.count > 0) {
                [cell setcellIcon:@"tribe_detail_relativedthem" title:@"相关内容" detailTitle:@"" arrow:@""];
            }
            returnCell = cell;
        } else if (indexPath.row == FIRST_PAGE_THEME_ONE) {
            TribeDetailRelatedThem *cell = [tableView dequeueReusableCellWithIdentifier:cellNib_TribeDetailRelatedThem];
            cell.layer.borderWidth = 0.5f;
            cell.layer.borderColor = [UIColor DDR238_G238_B238ColorWithalph:1.0].CGColor;
            [cell configContentsForCellWithDic:nil];
            if (_relContents.count > 0) {
             [cell configContentsForCellWithDic:_relContents[0]];
            }
            returnCell = cell;
        } else if (indexPath.row == FIRST_PAGE_THEME_TWO) {
            TribeDetailRelatedThem *cell = [tableView dequeueReusableCellWithIdentifier:cellNib_TribeDetailRelatedThem];
            cell.layer.borderWidth = 0.5f;
            cell.layer.borderColor = [UIColor DDR238_G238_B238ColorWithalph:1.0].CGColor;
            [cell configContentsForCellWithDic:nil];
            if (_relContents.count > 1) {
                [cell configContentsForCellWithDic:_relContents[1]];
            }
            returnCell = cell;
        } else if (indexPath.row == FIRST_PAGE_THEME_THREE) {
            TribeDetailRelatedThem *cell = [tableView dequeueReusableCellWithIdentifier:cellNib_TribeDetailRelatedThem];
            cell.layer.borderWidth = 0.5f;
            cell.layer.borderColor = [UIColor DDR238_G238_B238ColorWithalph:1.0].CGColor;
            [cell configContentsForCellWithDic:nil];
            if (_relContents.count > 2) {
                [cell configContentsForCellWithDic:_relContents[2]];
            }
            returnCell = cell;
        } else if (indexPath.row == FIRST_PAGE_EMPTY_INDEX) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GapCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GapCell"];
                cell.backgroundColor = [UIColor DDR245_G245_B245ColorWithalph:1.0];
            }
            returnCell = cell;
        } else if (indexPath.row == FIRST_PAGE_ALL_COMMENT_LABEL_INDEX) {
            ThemTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_ThemTitleCell];
            cell.layer.borderWidth = 0.5f;
            cell.layer.borderColor = [UIColor DDR238_G238_B238ColorWithalph:1.0].CGColor;
            [cell setcellIcon:@"tribe_detail_comment" title:@"评论" detailTitle:@"" arrow:@""];
            returnCell = cell;
        } else if (_listArr.count == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = @"暂没有更多了 点击刷新";
            [cell.textLabel setFont:[UIFont systemFontOfSize:FONT_UI28PX]];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.layer.borderWidth = 0.5f;
            cell.layer.borderColor = [UIColor DDR238_G238_B238ColorWithalph:1.0].CGColor;
            returnCell = cell;
        } else if (_isLastPage && indexPath.row == FIRST_PAGE_DEFAULT + _listArr.count) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = @"暂没有更多了 点击刷新";
            [cell.textLabel setFont:[UIFont systemFontOfSize:FONT_UI28PX]];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.layer.borderWidth = 0.5f;
            cell.layer.borderColor = [UIColor DDR238_G238_B238ColorWithalph:1.0].CGColor;
            returnCell = cell;
        } else {
            ReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNib_ReplyTableViewCell];
            if (cell == nil) {
                cell = [[ReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNib_ReplyTableViewCell];
                cell.cellStyle = ReplyTableViewCellTribeDetail;
                cell.layer.borderWidth = 0.5f;
                cell.layer.borderColor = [UIColor DDR238_G238_B238ColorWithalph:1.0].CGColor;
            }
            NSInteger index = indexPath.row;
            index -=FIRST_PAGE_DEFAULT;
            if (index < _listArr.count) {
                TribeDetailInfoCellManager *manager = (TribeDetailInfoCellManager *)_listArr[index];
                manager.currentIndexPath = indexPath;
                cell.manager = manager;
                cell.delegate = self;
            }
            returnCell = cell;
        }
    } else {
        if(_isLastPage && indexPath.row == _listArr.count) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = @"暂没有更多了 点击刷新";
            [cell.textLabel setFont:[UIFont systemFontOfSize:FONT_UI28PX]];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.layer.borderWidth = 0.5f;
            cell.layer.borderColor = [UIColor DDR238_G238_B238ColorWithalph:1.0].CGColor;
            returnCell = cell;
        } else {
            ReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNib_ReplyTableViewCell];
            if (cell == nil) {
                cell = [[ReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNib_ReplyTableViewCell];
                cell.cellStyle = ReplyTableViewCellTribeDetail;
                cell.layer.borderWidth = 0.5f;
                cell.layer.borderColor = [UIColor DDR238_G238_B238ColorWithalph:1.0].CGColor;
            }
            NSInteger index = indexPath.row;
            if (index < _listArr.count) {
                TribeDetailInfoCellManager *manager = (TribeDetailInfoCellManager *)_listArr[index];
                manager.currentIndexPath = indexPath;
                cell.manager = manager;
                cell.delegate = self;
            }
            returnCell = cell;
        }
    }
    returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return returnCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isLastPage) {
        if (_isFirstPage) {
            if(indexPath.row == FIRST_PAGE_DEFAULT + _listArr.count)
            {
                [self cellButtonClicked];
                return;
            }
        }
        else if(indexPath.row ==  _listArr.count)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(refreshLastPage)]) {
                [_delegate refreshLastPage];
            }
            return;
        }
    }
    
    TribeDetailInfoCellManager * manager = nil;
    if (_isFirstPage) {
        if (indexPath.row >= FIRST_PAGE_DEFAULT) {
            if (indexPath.row - FIRST_PAGE_DEFAULT < _listArr.count) {
                // 第一页 楼层
                manager = (TribeDetailInfoCellManager *)_listArr[indexPath.row - FIRST_PAGE_DEFAULT];
            }
        }
        else if (indexPath.row == FIRST_PAGE_IMASSESS_INDEX){
            
            if (_delegate && [_delegate respondsToSelector:@selector(replyTableView:didClickEvent:info:)]) {
                
                // 统计代码
                [HNBClick event:@"107051" Content:nil];
                
                [_delegate replyTableView:self didClickEvent:@"FuncAssessEntry" info:nil];
            }
            return;
        }
        else if (indexPath.row == FIRST_PAGE_NATION_INDEX) {
            if (_delegate && [_delegate respondsToSelector:@selector(replyTableView:didClickEvent:info:)]) {
                
                // 统计代码
                [HNBClick event:@"107052" Content:nil];
                
                [_delegate replyTableView:self didClickEvent:@"FuncNationEntry" info:[_funcDic objectForKey:@"url"]];
            }
            return;
        }
        else if (indexPath.row == FIRST_PAGE_THEME_ONE){
            TribeThemeModel *f = _relContents[0];
            if (_delegate && [_delegate respondsToSelector:@selector(replyTableView:didClickEvent:info:)]) {
                [_delegate replyTableView:self didClickEvent:@"FuncThemeEntry" info:f.id];
                
                // 统计代码
                NSString *URLString = [NSString stringWithFormat:@"https://m.hinabian.com/theme/detail/%@",f.id];
                NSDictionary *dict = @{@"url":URLString};
                [HNBClick event:@"107053" Content:dict];
            }
            return;
        }
        else if (indexPath.row == FIRST_PAGE_THEME_TWO){
            TribeThemeModel *f = _relContents[1];
            if (_delegate && [_delegate respondsToSelector:@selector(replyTableView:didClickEvent:info:)]) {
                [_delegate replyTableView:self didClickEvent:@"FuncThemeEntry" info:f.id];
                
                // 统计代码
                NSString *URLString = [NSString stringWithFormat:@"https://m.hinabian.com/theme/detail/%@",f.id];
                NSDictionary *dict = @{@"url":URLString};
                [HNBClick event:@"107054" Content:dict];
            }
            return;
        }
        else if (indexPath.row == FIRST_PAGE_THEME_THREE){
            TribeThemeModel *f = _relContents[2];
            if (_delegate && [_delegate respondsToSelector:@selector(replyTableView:didClickEvent:info:)]) {
                [_delegate replyTableView:self didClickEvent:@"FuncThemeEntry" info:f.id];
                
                // 统计代码
                NSString *URLString = [NSString stringWithFormat:@"https://m.hinabian.com/theme/detail/%@",f.id];
                NSDictionary *dict = @{@"url":URLString};
                [HNBClick event:@"107055" Content:dict];
                
            }
            return;
        }
        else
        {
            return;
        }
    } else {
        if (indexPath.row < _listArr.count) {
            manager = (TribeDetailInfoCellManager *)_listArr[indexPath.row];
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(replyTableView:didClickEvent:info:)]) {
        [_delegate replyTableView:self didClickEvent:tableView info:manager];
    }
}

- (void)cellButtonClicked {
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(cellRefresh) object:nil];
    [self performSelector:@selector(cellRefresh) withObject:nil afterDelay:0.3f];
}

- (void)cellRefresh
{
    if (_delegate && [_delegate respondsToSelector:@selector(refreshLastPage)]) {
        [_delegate refreshLastPage];
    }
}

#pragma mark ------ Mutual Event

#pragma mark clickEventOnReplyTableView

- (void)clickEventOnReplyTableView:(UIButton *)btn{
    
    [self endEditing:YES];
    
}


#pragma mark ------ reqSourceDataWithData

- (void)reqSourceDataWithData:(NSArray *)data {
    _listArr = [NSMutableArray arrayWithArray:data];
    [_tableView reloadData];
}

#pragma mark ------ toolMethod

- (void)refreshViewWithData {
    [_tableView reloadData];
}

#pragma mark ------ scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //scrollView.panGestureRecognizer;
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    if (_isBottomOutControl && scrollView) {
        if (contentYoffset != 0) {
            [_tableView setContentOffset:CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height) animated:FALSE];
        }
        if ([_delegate respondsToSelector:@selector(handlePanGestureBottom:)] && scrollView.panGestureRecognizer)
        {
            [_delegate handlePanGestureBottom:scrollView.panGestureRecognizer];
        }
        return;
    }
    if (_isTopOutControl && scrollView) {
        [scrollView setContentOffset:CGPointMake(0, 0)];
        if ([_delegate respondsToSelector:@selector(handlePanGestureTop:)] && scrollView.panGestureRecognizer)
        {
            [_delegate handlePanGestureTop:scrollView.panGestureRecognizer];
        }
        return;
    }
    /* 划到底部处理 */
    if (distanceFromBottom  <= height && !_isTopOutControl && !_isLastPage) {
        if (scrollView.panGestureRecognizer.state != 0) {
            _isBottomOutControl = TRUE;
            if (contentYoffset != 0) {
                [_tableView setContentOffset:CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height) animated:FALSE];
            }
            if ([_delegate respondsToSelector:@selector(handlePanGestureBottom:)] && scrollView.panGestureRecognizer)
            {
                [_delegate handlePanGestureBottom:scrollView.panGestureRecognizer];
            }
        }
    }
    
    /* 滑到顶部处理 */
    if(contentYoffset <= 0 && !_isBottomOutControl) {
        if (scrollView.panGestureRecognizer.state != 0) {
            _isTopOutControl = TRUE;
            [_tableView setContentOffset:CGPointMake(0, 0) animated:FALSE];
            if ([_delegate respondsToSelector:@selector(handlePanGestureTop:)] && scrollView.panGestureRecognizer) {
                [_delegate handlePanGestureTop:scrollView.panGestureRecognizer];
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_delegate && [_delegate respondsToSelector:@selector(textViewResign)] &&[_delegate respondsToSelector:@selector(isKeyboardShow)]) {
        if ([_delegate isKeyboardShow]) {
            [_delegate textViewResign];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat contentYoffset = scrollView.contentOffset.y;
    if (_isBottomOutControl) {
        if (contentYoffset != 0 && scrollView) {
            [_tableView setContentOffset:CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height) animated:FALSE];
        }
        if ([_delegate respondsToSelector:@selector(handlePanGestureBottom:)] && scrollView.panGestureRecognizer) {
            [_delegate handlePanGestureBottom:scrollView.panGestureRecognizer];
        }
    }
    if (_isTopOutControl && scrollView) {
        [_tableView setContentOffset:CGPointMake(0, 0) animated:FALSE];
        if ([_delegate respondsToSelector:@selector(handlePanGestureTop:)]  && scrollView.panGestureRecognizer) {
            [_delegate handlePanGestureTop:scrollView.panGestureRecognizer];
        }
    }
    _isBottomOutControl = FALSE;
    _isTopOutControl = FALSE;
}

#pragma mark ------ ReplyTableViewCellDelegate

- (void)replyTableViewCell:(ReplyTableViewCell *)cell eventSource:(id)eventSource info:(id)info {
    if (_delegate && [_delegate respondsToSelector:@selector(replyTableView:didClickEvent:info:)]) {
        [_delegate replyTableView:self didClickEvent:eventSource info:info];
    }
}

#pragma mark ------ textUiTableViewCellDelegate
- (void)attentionButtonPressed {
    if ([_delegate respondsToSelector:@selector(attentionButtonPress)]) {
        [_delegate attentionButtonPress];
    }
}
- (void)tribeButtonPressed {
    if ([_delegate respondsToSelector:@selector(tribeButtonPress)]) {
        [_delegate tribeButtonPress];
    }
}

#pragma mark ------ 懒加载

- (NSMutableArray *)relContents {
    if (_relContents == nil) {
        _relContents = [[NSMutableArray alloc] init];
    }
    return _relContents;
}

@end
