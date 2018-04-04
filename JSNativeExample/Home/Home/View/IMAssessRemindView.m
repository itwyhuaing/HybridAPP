//
//  IMAssessRemindView.m
//  hinabian
//
//  Created by hnbwyh on 16/12/14.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "IMAssessRemindView.h"

@interface IMAssessRemindView ()

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *imassesCountLabel;

@end

@implementation IMAssessRemindView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor DDR0_G0_B0ColorWithalph:0.7];
        
        _bgView = [[UIView alloc] init];
        [self addSubview:_bgView];
        UIImageView *bgImgView = [[UIImageView alloc] init];
        [_bgView addSubview:bgImgView];
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgView addSubview:closeBtn];
        _imassesCountLabel = [[UILabel alloc] init];
        [_bgView addSubview:_imassesCountLabel];
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgView addSubview:nextBtn];
        
        CGSize nextBtnSize = CGSizeMake(233.f * SCREEN_SCALE, 44.f * SCREEN_SCALE);
        CGFloat gap = 23.0 * SCREEN_SCALE;

//        CGFloat location_gap = 135.f * SCREEN_SCALE;
//        _bgView.sd_layout
//        .leftSpaceToView(self,gap)
//        .rightSpaceToView(self,gap)
//        .topSpaceToView(self,location_gap)
//        .bottomSpaceToView(self,location_gap);
        
        _bgView.sd_layout
        .centerXEqualToView(self)
        .centerYEqualToView(self)
        .widthIs(275.0 * SCREEN_SCALE)
        .heightIs(304.0 * SCREEN_SCALE);
        
        nextBtn.sd_layout
        .heightIs(nextBtnSize.height)
        .widthIs(nextBtnSize.width)
        .bottomSpaceToView(_bgView,gap)
        .centerXEqualToView(_bgView);
        bgImgView.sd_layout
        .topSpaceToView(_bgView,0.f)
        .leftSpaceToView(_bgView,0.f)
        .rightSpaceToView(_bgView,0.f)
        .bottomSpaceToView(nextBtn,gap);
        closeBtn.sd_layout
        .topSpaceToView(_bgView,0.f)
        .rightSpaceToView(_bgView,0.f)
        .heightIs(33.f * SCREEN_SCALE)
        .widthIs(33.f * SCREEN_SCALE);
        _imassesCountLabel.sd_layout
        .leftSpaceToView(_bgView,0.f)
        .rightSpaceToView(_bgView,0.f)
        .bottomSpaceToView(nextBtn,gap)
        .heightIs(58.0 * SCREEN_SCALE);
        
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0;
        _bgView.layer.masksToBounds = YES;
        bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        bgImgView.clipsToBounds = TRUE;
        _imassesCountLabel.textAlignment = NSTextAlignmentCenter;
        nextBtn.backgroundColor = [UIColor DDNavBarBlue];
        nextBtn.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0;
        [nextBtn setTitle:@"立即评估" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nextBtn.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI36PX]];
        
        [bgImgView setImage:[UIImage imageNamed:@"home_imremind_bgImg"]];
        [closeBtn setImage:[UIImage imageNamed:@"home_imremindbtn_normal"] forState:UIControlStateNormal];
        [closeBtn setImage:[UIImage imageNamed:@"home_imremindbtn_selected"] forState:UIControlStateSelected];
        
        closeBtn.tag = IMAssessRemindViewCloseButton;
        nextBtn.tag = IMAssessRemindViewNextButton;
        [closeBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [nextBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}


#pragma mark ------ setter 

-(void)setImassessCountString:(NSString *)imassessCountString{

    _imassessCountString = imassessCountString;
    NSString *str1 = @"海那边已帮 ";
    NSString *str2 = @" 人获得方案";
    NSString *tmpString = [NSString stringWithFormat:@"%@%@%@",str1,_imassessCountString,str2];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:tmpString];
    [attrString addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"Helvetica-Bold" size:FONT_UI24PX]
                       range:NSMakeRange(0, tmpString.length)];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.f]
                       range:NSMakeRange(0, tmpString.length)];
    [attrString addAttribute:NSKernAttributeName
                       value:@1.0f
                       range:NSMakeRange(0, tmpString.length)];
    
    [attrString addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"Helvetica-Bold" size:FONT_UI36PX]
                       range:NSMakeRange(str1.length, _imassessCountString.length)];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor DDR255_G209_B97ColorWithalph:1.f]
                       range:NSMakeRange(str1.length, _imassessCountString.length)];
    [attrString addAttribute:NSKernAttributeName
                       value:@0.3f
                       range:NSMakeRange(0, tmpString.length)];
    
    _imassesCountLabel.attributedText = attrString;
    
}



#pragma mark ------ click event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 点击灰色蒙版消失功能  打开如下代码
    /*
     CGFloat origin_x = CGRectGetMinX(_bgView.frame);
     CGFloat origin_y = CGRectGetMinY(_bgView.frame);
     CGFloat max_x = CGRectGetMaxX(_bgView.frame);
     CGFloat max_y = CGRectGetMaxY(_bgView.frame);
     CGRect bgRect = CGRectMake(origin_x, origin_y, max_x - origin_x, max_y - origin_y);
     UITouch *t = [touches anyObject];
     CGPoint touchPoint = [t locationInView:self.superview];
     BOOL isIn = CGRectContainsPoint(bgRect, touchPoint);
     
     if (!isIn) {
     
     [self clickButton:nil];
     
     }
     */
}

- (void)clickButton:(UIButton *)btn{
    
    self.hidden = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(imAssessRemindView:didClickButton:)]) {
        
        [_delegate imAssessRemindView:self didClickButton:btn];
        
    }
    
}

@end
