//
//  JudgeAppView.m
//  hinabian
//
//  Created by 何松泽 on 2017/9/22.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "JudgeAppView.h"

@interface JudgeAppView()

@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIView *line3;
@property (nonatomic, strong) UIButton *storeBtn;
@property (nonatomic, strong) UIButton *ideabackBtn;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation JudgeAppView

- (instancetype) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        float alertWidth = 260.f;
        float alertHeight = 290.f;
        
        self.backgroundColor = [UIColor DDR51_G51_B51ColorWithalph:0.3];
        
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 6.f;
        _alertView.layer.masksToBounds = YES;
        [self addSubview:_alertView];
        
        
        _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ideaback_Alert_image"]];
        [_alertView addSubview:_headImageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"喜欢海那边吗?";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:FONT_UI36PX];
        [_alertView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 2;
        _contentLabel.text = @"如果你喜欢，花1分钟给海那边\n评个分，好吗？";
        _contentLabel.textColor = [UIColor DDR153_G153_B153ColorWithalph:0.5f];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont boldSystemFontOfSize:FONT_UI30PX];
        [_alertView addSubview:_contentLabel];
        
        _line1 = [[UIView alloc] init];
        _line1.layer.borderColor = [UIColor DDR153_G153_B153ColorWithalph:0.5f].CGColor;
        _line1.layer.borderWidth = 0.5f;
        [_alertView addSubview:_line1];
        
        _storeBtn = [[UIButton alloc] init];
        _storeBtn.tag = JudgeAppViewGoStoreButton;
        [_storeBtn.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI32PX]];
        [_storeBtn setTitle:@"好，去评个分~" forState:UIControlStateNormal];
        [_storeBtn setTitleColor:[UIColor DDNavBarBlue] forState:UIControlStateNormal];
        [_storeBtn addTarget:self action:@selector(clickBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:_storeBtn];
        
        _line2 = [[UIView alloc] init];
        _line2.layer.borderColor = [UIColor DDR153_G153_B153ColorWithalph:0.5f].CGColor;
        _line2.layer.borderWidth = 0.5f;
        [_alertView addSubview:_line2];
        
        _ideabackBtn = [[UIButton alloc] init];
        _ideabackBtn.tag = JudgeAppViewGoIdeaBackButton;
        [_ideabackBtn.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI32PX]];
        [_ideabackBtn setTitle:@"用得不爽！我要吐槽！" forState:UIControlStateNormal];
        [_ideabackBtn setTitleColor:[UIColor DDNavBarBlue] forState:UIControlStateNormal];
        [_ideabackBtn addTarget:self action:@selector(clickBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:_ideabackBtn];
        
        _line3 = [[UIView alloc] init];
        _line3.layer.borderColor = [UIColor DDR153_G153_B153ColorWithalph:0.5f].CGColor;
        _line3.layer.borderWidth = 0.5f;
        [_alertView addSubview:_line3];
        
        _closeBtn = [[UIButton alloc] init];
        _closeBtn.tag = JudgeAppViewCloseButton;
        [_closeBtn.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI32PX]];
        [_closeBtn setTitle:@"残忍拒绝" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor DDNavBarBlue] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clickBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:_closeBtn];
        
//        (SCREEN_WIDTH - 260)/2, SCREEN_HEIGHT/3, 260, 255)
        _alertView.sd_layout
        .widthIs(alertWidth)
        .heightIs(alertHeight)
        .topSpaceToView(self, SCREEN_HEIGHT/4)
        .centerXEqualToView(self);
        
        
        _headImageView.sd_layout
        .topSpaceToView(_alertView,20)
        .heightIs(52)
        .widthIs(80)
        .centerXEqualToView(_alertView);
        
        _titleLabel.sd_layout
        .heightIs(20)
        .widthIs(alertWidth)
        .topSpaceToView(_headImageView, 20)
        .centerXEqualToView(_alertView);
        
        _contentLabel.sd_layout
        .topSpaceToView(_titleLabel,5.f)
        .centerXEqualToView(_alertView)
        .heightIs(40.f)
        .widthIs(alertWidth);
        
        _line1.sd_layout
        .topSpaceToView(_contentLabel,12.f)
        .centerXEqualToView(_alertView)
        .heightIs(1.f)
        .widthIs(alertWidth - 20);
        
        _storeBtn.sd_layout
        .topSpaceToView(_line1,0.f)
        .centerXEqualToView(_alertView)
        .heightIs(40.f)
        .widthIs(alertWidth - 20);
        
        _line2.sd_layout
        .topSpaceToView(_storeBtn,0.f)
        .centerXEqualToView(_alertView)
        .heightIs(1.f)
        .widthIs(alertWidth - 20);
        
        _ideabackBtn.sd_layout
        .topSpaceToView(_line2,0.f)
        .centerXEqualToView(_alertView)
        .heightIs(40.f)
        .widthIs(alertWidth - 20);
        
        _line3.sd_layout
        .topSpaceToView(_ideabackBtn,0.f)
        .centerXEqualToView(_alertView)
        .heightIs(1.f)
        .widthIs(alertWidth - 20);
        
        _closeBtn.sd_layout
        .topSpaceToView(_line3,0.f)
        .centerXEqualToView(_alertView)
        .heightIs(40.f)
        .widthIs(alertWidth - 20);
    }
    return self;
}

-(void)clickBtnEvent:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(JudgeAppView:didClickButton:)]) {
        [_delegate JudgeAppView:self didClickButton:sender];
    }
    self.hidden = YES;
}

@end
