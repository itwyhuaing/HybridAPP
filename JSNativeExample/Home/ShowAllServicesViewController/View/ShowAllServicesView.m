//
//  ShowAllServicesView.m
//  ShowAllServicesViewController
//
//  Created by 何松泽 on 2018/3/26.
//  Copyright © 2018年 HSZ. All rights reserved.
//

#import "ShowAllServicesView.h"
#import "ShowAllServicesCell.h"

static const CGFloat kLabelDistance = 10.f;
static const NSInteger kCountInRow  = 3;

@interface ShowAllServicesView()<ShowAllSercicesCellDelegate>

@property (nonatomic, strong)NSArray *dataArrs;

@property (nonatomic, strong)UILabel *titleLabel;

@end

@implementation ShowAllServicesView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArrs = [[NSArray alloc] init];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelDistance, 0, self.frame.size.width - kLabelDistance, kShowAllServicesViewLabelHeight)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
        self.titleLabel.textColor = [UIColor colorWithRed:102/255 green:102/255 blue:102/255 alpha:0.6];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setDataArr:(NSArray *)datas title:(NSString *)title {
    
    _dataArrs = [datas copy];
    
    CGFloat buttonWidth = self.frame.size.width/kCountInRow;
    for (int i = 0; i < _dataArrs.count; i++) {
        NSInteger nextLineNum = i%kCountInRow;
        NSInteger lines = i/kCountInRow;
        
        ShowAllServicesCell *cell = [[ShowAllServicesCell alloc] initWithFrame:CGRectMake(buttonWidth*nextLineNum, lines*buttonWidth + kShowAllServicesViewLabelHeight, buttonWidth, buttonWidth)];
        cell.delegate = (id)self;
        [cell setCellWithModel:_dataArrs[i]];
        [self addSubview:cell];
    }
    
    //画分割线
    if (_dataArrs.count > 0) {
        //横线
        NSInteger lineNum = _dataArrs.count/kCountInRow + 2;
        for (int i = 0; i < lineNum; i++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, i*buttonWidth + kShowAllServicesViewLabelHeight, self.frame.size.width, 0.6f)];
            line.backgroundColor = [UIColor colorWithRed:224/255 green:224/255 blue:224/255 alpha:0.2f];
            [self addSubview:line];
        }
        //竖线
        NSInteger rowNum = _dataArrs.count%kCountInRow == 0 ? _dataArrs.count/kCountInRow : _dataArrs.count/kCountInRow + 1;
        for (int i = 0; i < kCountInRow - 1; i ++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake((i+1)*buttonWidth, kShowAllServicesViewLabelHeight, 0.6f, rowNum * buttonWidth)];
            line.backgroundColor = [UIColor colorWithRed:224/255 green:224/255 blue:224/255 alpha:0.2f];
            [self addSubview:line];
        }
    }
    
    
    self.titleLabel.text = title;
}

- (void)ShowAllSercicesCellClickModel:(ShowAllServicesModel *)model {
    if (_delegate && [_delegate respondsToSelector:@selector(ShowAllServicesViewClickEvent:)]) {
        [_delegate ShowAllServicesViewClickEvent:model];
    }
}

@end
