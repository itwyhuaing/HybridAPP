//
//  NationButtonView.m
//  hinabian
//
//  Created by 何松泽 on 17/4/13.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "NationButtonView.h"
#import "NationalButton.h"
#import "NationCode.h"
#import "DataFetcher.h"

#define DistanceToBorder    15
#define COUNT_IN_ONE_ROW    3
#define BUTTON_WIDTH        (SCREEN_WIDTH - DistanceToBorder*(COUNT_IN_ONE_ROW+1))/COUNT_IN_ONE_ROW

static const float kCornerRadius     = 6.f;
static const int   kNationShowNum    = 8;
static const int   kSelectedTag      = 100;
static const int   kOriginalTag      = 0;

@implementation NationButtonView

/*有选择国家使用这个方法*/
- (id)initAllShowWithFrame:(CGRect)frame
         andSelectedNation:(NSArray *)IdArray{
    if (self = [super initWithFrame:frame]) {
        
        _selectedNationsCode    = [[NSMutableArray alloc] init];
        _selectedNationString   = [[NSMutableArray alloc] init];
        _nationButtonArray      = [[NSMutableArray alloc] init];
        _nationArray            = [[NSMutableArray alloc] init];
        
        NSArray *dataArray = [NationCode MR_findAllSortedBy:@"timestamp" ascending:YES];

        if (dataArray.count <= 0) {
            NSBundle *bundle = [NSBundle mainBundle];
            NSString *plistPath = [bundle pathForResource:@"NewNationData" ofType:@"plist"];
            _nationArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        }else{
            /*没有请求到数据显示本地*/
            for (NationCode *f in dataArray) {
                NSMutableDictionary *dic= [[NSMutableDictionary alloc] init];
                if (f.id) {
                    [dic setObject:f.id forKey:@"id"];
                }
                if (f.title) {
                    [dic setObject:f.title forKey:@"title"];
                }
                if (f.desc) {
                    [dic setObject:f.desc forKey:@"desc"];
                }
                [_nationArray addObject:dic];
            }
        }
        /* 设置新高度 */
        NSInteger line = _nationArray.count/COUNT_IN_ONE_ROW;
        if(_nationArray.count%COUNT_IN_ONE_ROW == 0){
            _newHeight = (line - 1) * 10 + line * 45 + 20;
        }else{
            _newHeight = line * 10 + (line + 1) * 45 + 20;
        }
        
        [self addNationButtonFrom:0 To:_nationArray.count];
        /* 获取已选国家的ID */
        [self getInputNationData:IdArray];
    }
    
    return self;
}

/*无选择国家使用这个方法*/
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _selectedNationsCode    = [[NSMutableArray alloc] init];
        _selectedNationString   = [[NSMutableArray alloc] init];
        _nationButtonArray      = [[NSMutableArray alloc] init];
        _nationArray            = [[NSMutableArray alloc] init];
        
        NSArray *dataArray = [NationCode MR_findAllSortedBy:@"timestamp" ascending:YES];
        
        
        if (dataArray.count <= 0) {
            NSBundle *bundle = [NSBundle mainBundle];
            NSString *plistPath = [bundle pathForResource:@"NewNationData" ofType:@"plist"];
            _nationArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        }else{
            /*没有请求到数据显示本地*/
            for (NationCode *f in dataArray) {
                NSMutableDictionary *dic= [[NSMutableDictionary alloc] init];
                if (f.id) {
                    [dic setObject:f.id forKey:@"id"];
                }
                if (f.title) {
                    [dic setObject:f.title forKey:@"title"];
                }
                if (f.desc) {
                    [dic setObject:f.desc forKey:@"desc"];
                }
                [_nationArray addObject:dic];
            }
        }
    
        [self setNationButton];
    }
    
    return self;
}

- (void)getInputNationData:(NSArray *)IdArray
{
    /*根据传入的国家ID选定国家*/
    if (IdArray != nil) {
        for (int index = 0; index < IdArray.count; index++) {
            for (NSDictionary *tmpDic in _nationArray) {
                if ([[tmpDic valueForKey:@"id"] isEqualToString:IdArray[index]]) {
                    [_selectedNationsCode addObject:[tmpDic valueForKey:@"id"]];
                    [_selectedNationString addObject:[tmpDic valueForKey:@"title"]];
                }
            }
            
        }
        [self checkButtonIsSelected:_selectedNationString];
    }
}

- (void)checkButtonIsSelected:(NSArray *)strArray
{
    if (strArray  && strArray.count != 0 && _nationButtonArray != nil) {
        
        for (NationalButton *tempButton in _nationButtonArray) {
            if ([strArray containsObject:tempButton.nationLabel.text]) {
                [self setSelectedBtn:tempButton];
            }
        }
    }
}

- (void)setNationButton
{
    if (_nationArray.count <= kNationShowNum - 1) {
        /*国家数量小于等于8个*/
        [self addNationButtonFrom:0 To:_nationArray.count];
    }else{
        /*国家数量大于8个*/
        [self addNationButtonFrom:0 To:kNationShowNum];
        /*更多*/
        _moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(
                                                             ((kNationShowNum % COUNT_IN_ONE_ROW) + 1)*DistanceToBorder + (kNationShowNum % COUNT_IN_ONE_ROW)* BUTTON_WIDTH,
                                                             (kNationShowNum / COUNT_IN_ONE_ROW)*10 + 10 + (kNationShowNum / COUNT_IN_ONE_ROW)* 45,
                                                             BUTTON_WIDTH,
                                                             45
                                                             )];
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreNations) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.backgroundColor = [UIColor clearColor];
        _moreBtn.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
        _moreBtn.layer.borderWidth = 0.5;
        _moreBtn.layer.cornerRadius = kCornerRadius;
        [_moreBtn setTitleColor:[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1.0] forState:UIControlStateNormal];
        [self addSubview:_moreBtn];
    }
}

- (void)addNationButtonFrom:(NSInteger)StartNum To:(NSInteger)endNum
{
    for (NSInteger index = StartNum; index < endNum; index++) {
        
        NSDictionary *nationDic = _nationArray[index];
        NSString *nationID      = [nationDic valueForKey:@"id"];
        NSString *nationTitle   = [nationDic valueForKey:@"title"];
        NSString *nationDesc    = [nationDic valueForKey:@"desc"];
        
        //        NationCode *f = _nationArray[index];
        
        NationalButton * tmpButton = [[NationalButton alloc] initWithFrame:CGRectMake(
                                                                                      ((index % COUNT_IN_ONE_ROW) + 1)*DistanceToBorder + (index % COUNT_IN_ONE_ROW)* BUTTON_WIDTH,
                                                                                      (index / COUNT_IN_ONE_ROW)*10 + 10 + (index / COUNT_IN_ONE_ROW)* 45,
                                                                                      BUTTON_WIDTH,
                                                                                      45
                                                                                      )];
        tmpButton.idTag = nationID;
        [tmpButton.nationLabel setText:nationTitle];
        [tmpButton.describeLabel setText:nationDesc]; /*国家描述*/
        [tmpButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_nationButtonArray addObject:tmpButton];
        [self setOriginalBtn:tmpButton];
        [self addSubview:tmpButton];
    }
}

- (void)setOriginalBtn:(NationalButton *)sender
{
    sender.tag = kOriginalTag;
    sender.backgroundColor = [UIColor clearColor];
    sender.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    sender.layer.borderWidth = 0.5;
    sender.layer.cornerRadius = kCornerRadius;
    [sender.nationLabel setTextColor:[UIColor DDNavBarBlue]];
    [sender.describeLabel setTextColor:[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1.0]];
}

- (void)setSelectedBtn:(NationalButton *)sender
{
    sender.tag = kSelectedTag;
    sender.backgroundColor = [UIColor DDNavBarBlue];
    sender.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    sender.layer.borderWidth = 0.5;
    sender.layer.cornerRadius = kCornerRadius;
    [sender.nationLabel setTextColor:[UIColor whiteColor]];
    [sender.describeLabel setTextColor:[UIColor whiteColor]];
}

- (void)clickButton:(NationalButton *)sender
{
    if (_selectedNationsCode.count == kOriginalTag) {
        [_selectedNationsCode addObject:sender.idTag];
        [_selectedNationString addObject:sender.nationLabel.text];
        [self setSelectedBtn:sender];
    }else {
        if (sender.tag == kSelectedTag) {
            /*取消已经选过的国家*/
            [_selectedNationsCode removeObject:sender.idTag];
            [_selectedNationString removeObject:sender.nationLabel.text];
            [self setOriginalBtn:sender];
        }else if (sender.tag == 0){
            if (_selectedNationsCode.count < 3) {
                /*少于三个能继续选*/
                [_selectedNationsCode addObject:sender.idTag];
                [_selectedNationString addObject:sender.nationLabel.text];
                [self setSelectedBtn:sender];
            }else {
                [[HNBToast shareManager] toastWithOnView:nil msg:@"最多选择3个哦" afterDelay:1.0 style:HNBToastHudFailure];
            }
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(clickNationButton)]) {
        [_delegate clickNationButton];
    }
    
}

- (void)moreNations
{
    _moreBtn.hidden = YES;
    
    NSInteger line = _nationArray.count/COUNT_IN_ONE_ROW;
    if(_nationArray.count%COUNT_IN_ONE_ROW == 0){
        _newHeight = line * 10 + line * 45 + 20;
    }else{
        _newHeight = (line + 1) * 10 + (line + 1) * 45 + 20;
    }
    
    [self addNationButtonFrom:kNationShowNum To:_nationArray.count];
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickMoreButton)]) {
        [_delegate clickMoreButton];
    }
    
}

@end
