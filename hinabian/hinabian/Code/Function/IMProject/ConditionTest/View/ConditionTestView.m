//
//  ConditionTestView.m
//  hinabian
//
//  Created by hnbwyh on 17/6/9.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "ConditionTestView.h"
#import "NationsView.h"
#import "ProjectsView.h"
#import "NationItemCell.h"


@interface ConditionTestView ()<NationsViewDelegate,ProjectViewDelegate>

@property (nonatomic,strong) NationsView *nationV;
@property (nonatomic,strong) ProjectsView *proV;
@property (nonatomic,assign) BOOL   jumpFromIMHome; //判断是否从项目首页进来的

@end

@implementation ConditionTestView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor greenColor];
        
        CGRect rect = CGRectZero;
        rect.size = frame.size;
        _nationV = [[NationsView alloc] initWithFrame:rect];
        _nationV.delegate = self;
        
        rect.origin.y = rect.size.height;
        _proV = [[ProjectsView alloc] initWithFrame:rect];
        _proV.proDelegate = self;
        [self addSubview:_nationV];
        [self addSubview:_proV];
        
        _isBackToNation = NO;
        _jumpFromIMHome = NO;
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame dataModel:(id)model {
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect rect = CGRectZero;
        rect.size = frame.size;
        _proV = [[ProjectsView alloc] initWithFrame:rect];
        [_proV setBackgroundColor:[UIColor whiteColor]];
        [_proV setViewWithNationModel:model];
        _proV.proDelegate = self;
        [self addSubview:_proV];
        
        _isBackToNation = NO;
        _jumpFromIMHome = YES;
    }
    return self;
}

#pragma mark ------ NationsViewDelegate

-(void)nationsView:(NationsView *)naView didSelectedIndex:(NSIndexPath *)inde dataModel:(id)model{
    
    CGRect pRect = _proV.frame;
    pRect.origin.y = pRect.size.height;
    [_proV setFrame:pRect];
    _proV.alpha = 0.f;
    _nationV.alpha = 1.f;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect nRect = _nationV.frame;
        nRect.origin.y = - nRect.size.height;
        [_nationV setFrame:nRect];
        CGRect pRect = _proV.frame;
        pRect.origin.y = 0;
        [_proV setFrame:pRect];
        [_proV setViewWithNationModel:model];
        _nationV.alpha = 0.f;
        _proV.alpha = 1.f;
    } completion:^(BOOL finished) {
        NationItemCell *cell = (NationItemCell *)[_nationV.collectView cellForItemAtIndexPath:inde];
        cell.isSelected = NO;
        _isBackToNation = YES;
    }];
    
}

//点击国家返回
-(void)cancelNationEvent
{
    if (!_jumpFromIMHome) {
        //如果不是从移民项目首页进入，则点击返回到选择国家页
        [self backToNation];
    }
}

-(void)backToNation
{
    CGRect pRect = _nationV.frame;
    pRect.origin.y = pRect.size.height;
    [_nationV setFrame:pRect];
    _nationV.alpha = 0.f;
    _proV.alpha = 1.f;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect nRect = _proV.frame;
        nRect.origin.y = + nRect.size.height;
        [_proV setFrame:nRect];
        CGRect pRect = _nationV.frame;
        pRect.origin.y = 0;
        [_nationV setFrame:pRect];
        _proV.alpha = 0.f;
        _nationV.alpha = 1.f;
        
    }completion:^(BOOL finished) {
        
        _isBackToNation = NO;
        for (UIView *tmpView in _proV.subviews) {
            if (tmpView.tag != kChosenNationTag) {  //把项目btn全部移除
                [tmpView removeFromSuperview];
            }
        }
    }];
}

//选择项目
-(void)clickProjectItem:(NSString *)p_id
{
    if (_testDelegate && [_testDelegate respondsToSelector:@selector(jumpToProjectTest:)]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@/assess/test.html?project_id=%@",H5URL,p_id];
        [_testDelegate jumpToProjectTest:urlStr];
    }
}


- (void)refreshMainViewWithDataSource:(NSArray *)dataSource fetchState:(BOOL)fetchState{

//    NSLog(@"  dataSource ===> %@",dataSource);
    _proV.proDataSource = dataSource;
    _nationV.nationDataSource = dataSource;
    
}

@end
