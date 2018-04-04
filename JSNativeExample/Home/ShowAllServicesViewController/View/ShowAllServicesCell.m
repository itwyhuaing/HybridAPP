//
//  ShowAllServicesCell.m
//  ShowAllServicesViewController
//
//  Created by 何松泽 on 2018/3/26.
//  Copyright © 2018年 HSZ. All rights reserved.
//

#import "ShowAllServicesCell.h"
#import "ShowAllServicesModel.h"

@interface ShowAllServicesCell()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *actionBtn;

@property (nonatomic, strong) ShowAllServicesModel *currentModel;

@end

@implementation ShowAllServicesCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    CGRect rect = CGRectZero;
    rect.size.width = self.frame.size.width/3;
    rect.size.height = rect.size.width;
    rect.origin.x = self.frame.size.width/3;
    rect.origin.y = (self.frame.size.height - rect.size.height - 20)/2;//20代表间距加label高度
    
    self.icon = [[UIImageView alloc] initWithFrame:rect];
    [self addSubview:self.icon];
    
    rect.size.width = self.frame.size.width;
    rect.size.height = 15.f;
    rect.origin.x = 0.f;
    rect.origin.y = CGRectGetMaxY(self.icon.frame) + 5;
    self.titleLabel = [[UILabel alloc] initWithFrame:rect];
    self.titleLabel.font = [UIFont systemFontOfSize:13.f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = self.frame.size.width;
    rect.size.height = self.frame.size.height;
    self.actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.actionBtn setFrame:rect];
    [self.actionBtn addTarget:self action:@selector(btnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.actionBtn];
}

- (void) setCellWithModel:(ShowAllServicesModel *)model {
    
    _currentModel = model;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.img]];
    [self.titleLabel setText:model.name];
}

- (void)btnClickEvent:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(ShowAllSercicesCellClickModel:)]) {
        [_delegate ShowAllSercicesCellClickModel:_currentModel];
    }
}



@end











