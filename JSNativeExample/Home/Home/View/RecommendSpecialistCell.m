//
//  RecommendSpecialistCell.m
//  hinabian
//
//  Created by 何松泽 on 2017/10/19.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "RecommendSpecialistCell.h"
#import "RcmdSpecialModel.h"

@interface RecommendSpecialistCell()

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UIImageView *showAllImage;
@property (nonatomic, strong) UILabel *countryTitle_Label;
@property (nonatomic, strong) UILabel *countryContent_Label;
@property (nonatomic, strong) UILabel *yearTitle_Label;
@property (nonatomic, strong) UILabel *yearContent_Label;
@property (nonatomic, strong) UILabel *showAllLabel;

@end

static const CGFloat RTitleWidth = 50.f;
static const CGFloat RMargin = 10.f;

@implementation RecommendSpecialistCell

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setShadows];
    }
    return self;
}

- (void)setModel:(id)model {
    RcmdSpecialModel *f = (RcmdSpecialModel *)model;
    if (model) {
        
        self.headImage.hidden = FALSE;
        self.countryTitle_Label.hidden = FALSE;
        self.countryContent_Label.hidden = FALSE;
        self.yearTitle_Label.hidden = FALSE;
        self.yearContent_Label.hidden = FALSE;
        self.consultBtn.hidden = FALSE;
        self.showAllImage.hidden = TRUE;
        self.showAllLabel.hidden = TRUE;
        
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:f.specialImage_url]];
        self.countryTitle_Label.text = @"擅长国家:";
        self.countryContent_Label.text = f.nationstring;
        self.yearTitle_Label.text = @"从业年限:";
        self.yearContent_Label.text = [NSString stringWithFormat:@"%@年",f.years];
        
    }
    
}

- (void)setShowAllCell {
    self.headImage.hidden = TRUE;
    self.countryTitle_Label.hidden = TRUE;
    self.countryContent_Label.hidden = TRUE;
    self.yearTitle_Label.hidden = TRUE;
    self.yearContent_Label.hidden = TRUE;
    self.consultBtn.hidden = TRUE;
    self.showAllImage.hidden = FALSE;
    self.showAllLabel.hidden = FALSE;
    
    self.showAllImage.image = [UIImage imageNamed:@"homepage_showAllSpecialists"];
    self.showAllLabel.text  = @"查看全部";
}

- (void)setShadows {
    self.contentView.layer.cornerRadius = 6.f;
    self.contentView.clipsToBounds = NO;
    self.contentView.layer.masksToBounds = YES;
    //增加阴影
    CALayer *layer=[[CALayer alloc]init];
    float shadowsWidth = 1.f;
    [layer setFrame:CGRectMake(0,0 , self.bounds.size.width, self.bounds.size.height)];
    layer.cornerRadius=self.layer.cornerRadius;
    layer.backgroundColor=[UIColor whiteColor].CGColor;//这里必须设置layer层的背景颜色，默认应该是透明的，导致设置的阴影颜色无法显示出来
    layer.shadowColor=[UIColor DDR102_G102_B102ColorWithalph:0.3f].CGColor;//设置阴影的颜色
    layer.shadowRadius=shadowsWidth;//设置阴影的宽度
    layer.shadowOffset=CGSizeMake(shadowsWidth * 1, shadowsWidth * 1.5);//设置偏移
    layer.shadowOpacity=0.6;
    layer.cornerRadius = 6.f;
    [self.layer addSublayer:layer];
    [self bringSubviewToFront:self.contentView];
    
    self.contentView.layer.borderWidth = 0.2f;
    self.contentView.layer.borderColor = [UIColor DDR102_G102_B102ColorWithalph:0.3f].CGColor;
}

- (UIImageView *)headImage {
    
    if (!_headImage) {
        _headImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_headImage];
        _headImage.sd_layout
        .topSpaceToView(self.contentView, 0)
        .leftSpaceToView(self.contentView, 0)
        .widthIs(self.width)
        .heightIs(145.f);
    }
    return _headImage;
}

- (UIImageView *)showAllImage {
    
    if (!_showAllImage) {
        _showAllImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_showAllImage];
        _showAllImage.sd_layout
        .topSpaceToView(self.contentView, 49)
        .centerXEqualToView(self.contentView)
        .widthIs(44)
        .heightIs(44);
    }
    return _showAllImage;
}

- (UILabel *)countryTitle_Label {
    
    if (!_countryTitle_Label) {
        _countryTitle_Label = [[UILabel alloc] initWithFrame:CGRectZero];
        _countryTitle_Label.font = [UIFont boldSystemFontOfSize:FONT_UI22PX];
        _countryTitle_Label.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.0f];
        [self.contentView addSubview:_countryTitle_Label];
        _countryTitle_Label.sd_layout
        .topSpaceToView(self.headImage, RMargin)
        .leftSpaceToView(self.contentView, RMargin)
        .widthIs(RTitleWidth)
        .heightIs(10.f);
    }
    return _countryTitle_Label;
}

- (UILabel *)countryContent_Label {
    
    if (!_countryContent_Label) {
        _countryContent_Label = [[UILabel alloc] initWithFrame:CGRectZero];
        _countryContent_Label.font = [UIFont systemFontOfSize:FONT_UI22PX];
        _countryContent_Label.textColor = [UIColor DDR102_G102_B102ColorWithalph:1.0f];
        [self.contentView addSubview:_countryContent_Label];
        _countryContent_Label.sd_layout
        .topSpaceToView(self.headImage, RMargin)
        .leftSpaceToView(self.countryTitle_Label, RMargin/2)
        .widthIs(self.frame.size.width - CGRectGetMaxX(self.countryTitle_Label.frame))
        .heightIs(10.f);
    }
    return _countryContent_Label;
}

- (UILabel *)yearTitle_Label {
    
    if (!_yearTitle_Label) {
        _yearTitle_Label = [[UILabel alloc] initWithFrame:CGRectZero];
        _yearTitle_Label.font = [UIFont boldSystemFontOfSize:FONT_UI22PX];
        _yearTitle_Label.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.0f];
        [self.contentView addSubview:_yearTitle_Label];
        _yearTitle_Label.sd_layout
        .topSpaceToView(self.countryTitle_Label, RMargin)
        .leftSpaceToView(self.contentView, RMargin)
        .widthIs(RTitleWidth)
        .heightIs(10.f);
    }
    return _yearTitle_Label;
}

- (UILabel *)yearContent_Label {
    
    if (!_yearContent_Label) {
        _yearContent_Label = [[UILabel alloc] initWithFrame:CGRectZero];
        _yearContent_Label.font = [UIFont systemFontOfSize:FONT_UI22PX];
        _yearContent_Label.textColor = [UIColor DDR102_G102_B102ColorWithalph:1.0f];
        [self.contentView addSubview:_yearContent_Label];
        _yearContent_Label.sd_layout
        .topSpaceToView(self.countryTitle_Label, RMargin)
        .leftSpaceToView(self.yearTitle_Label, RMargin/2)
        .widthIs(self.frame.size.width - CGRectGetMaxX(self.yearTitle_Label.frame))
        .heightIs(10.f);
    }
    return _yearContent_Label;
}

- (UILabel *)showAllLabel {
    
    if (!_showAllLabel) {
        _showAllLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _showAllLabel.font = [UIFont systemFontOfSize:FONT_UI32PX];
        _showAllLabel.textColor = [UIColor DDR102_G102_B102ColorWithalph:1.0f];
        _showAllLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_showAllLabel];
        _showAllLabel.sd_layout
        .topSpaceToView(self.showAllImage, 8.f)
        .centerXEqualToView(self.contentView)
        .widthIs(self.frame.size.width)
        .heightIs(16.f);
    }
    return _showAllLabel;
}


- (UIButton *)consultBtn {
    
    if (!_consultBtn) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        //view.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:view];
        view.sd_layout
        .topSpaceToView(self.contentView, 70)
        .leftSpaceToView(self.contentView, 140)
        .widthIs(100)
        .heightIs(30);
        
        _consultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_consultBtn setImage:[UIImage imageNamed:@"homepage_consultBtn"] forState:UIControlStateNormal];
        [view addSubview:_consultBtn];
        _consultBtn.sd_layout
        .topSpaceToView(view, 0)
        .leftSpaceToView(view, 0)
        .widthIs(100)
        .heightIs(30);
    }
    return _consultBtn;
}

@end













