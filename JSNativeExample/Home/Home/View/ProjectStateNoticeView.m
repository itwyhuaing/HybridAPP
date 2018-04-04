//
//  ProjectStateNoticeView.m
//  hinabian
//
//  Created by hnbwyh on 2018/1/22.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "ProjectStateNoticeView.h"
#import "ProjectStateView.h"
#import "DataFetcher.h"
#import "ProjectStateModel.h"

@interface ProjectStateNoticeView () <ProjectStateViewDelegate>

@property (nonatomic,strong) ProjectStateView *proStateView;
@property (nonatomic,copy) NSString *usrProjectID;

@end

@implementation ProjectStateNoticeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    CGRect rect = CGRectZero;
    rect.size.width = 274.0;
    rect.size.height = 298.0;
    CGPoint windowCenter = [UIApplication sharedApplication].keyWindow.center;
    NSArray *nibTEL = [[NSBundle mainBundle]loadNibNamed:viewNib_ProjectStateView owner:self options:nil];
    _proStateView = (ProjectStateView *)[nibTEL objectAtIndex:0];
    _proStateView.delegate = self;
    [_proStateView setFrame:rect];
    [_proStateView setCenter:windowCenter];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setFrame:CGRectMake(0, 0, 25, 25)];
    CGPoint center = CGPointMake(CGRectGetMaxX(_proStateView.frame), CGRectGetMinY(_proStateView.frame));
    [closeBtn setCenter:center];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"project_state_close"] forState:UIControlStateNormal];
    closeBtn.tag = CloseViewBtnTag;
    [closeBtn addTarget:self action:@selector(clickEventBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_proStateView];
    [self addSubview:closeBtn];
}

-(void)modifyViewWithData:(ProjectStateModel *)model{
    [_proStateView setViewWithModel:model];
    _usrProjectID = model.user_project_id;
}

#pragma mark ------ ProjectStateViewDelegate

-(void)touchEvent:(UIButton *)btn info:(NSDictionary *)info{
    NSLog(@" %s ",__FUNCTION__);
    [self removeProSubView];
    if (_delegate && [_delegate respondsToSelector:@selector(touchProjectStateNoticeEvent:info:)]) {
        [_delegate touchProjectStateNoticeEvent:btn info:info];
    }
    
}

#pragma mark ------ clickEventBtn

- (void)clickEventBtn:(UIButton *)btn{
    //NSLog(@" %s ",__FUNCTION__);
    [self removeProSubView];
    if (_delegate && [_delegate respondsToSelector:@selector(touchProjectStateNoticeEvent:info:)]) {
        [_delegate touchProjectStateNoticeEvent:btn info:nil];
    }
}

- (void)removeProSubView{
    [self removeFromSuperview];
    
    if (_usrProjectID != nil || _usrProjectID.length > 0) {
        
        [DataFetcher doCloseViewForProjectShowONHomeWithUserProjectID:_usrProjectID succeedHandler:^(id JSON) {
        } withFailHandler:^(id error) {
        }];
        
    }
}


@end
