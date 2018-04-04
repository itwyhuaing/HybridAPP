//
//  HomeRecommandActivityCell.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/20.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "HomeRecommandActivityCell.h"
#import "RcmdActivityModel.h"

@interface HomeRecommandActivityCell ()

@property (nonatomic,strong) UIImageView *actImageV;
@property (nonatomic,strong) UILabel *actTitle;
@property (nonatomic,strong) UILabel *actTime;
@property (nonatomic,strong) UIButton *activityStatus;

@end

@implementation HomeRecommandActivityCell

#pragma mark ----- init

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell{
    
    _actImageV = [[UIImageView alloc] init];
    UIView *bgView = [[UIView alloc] init];
    _actTitle = [[UILabel alloc] init];
    _actTime = [[UILabel alloc] init];
    _activityStatus = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_actImageV];
    [self addSubview:bgView];
    [bgView addSubview:_actTitle];
    [bgView addSubview:_actTime];
    [self addSubview:_activityStatus];
    
    _actImageV.sd_layout
    .leftSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .rightSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(self, 0)
    .heightIs(150.0 * SCREEN_WIDTHRATE_6);

    bgView.sd_layout
    .topSpaceToView(_actImageV, 0)
    .leftEqualToView(_actImageV)
    .bottomSpaceToView(self, 0)
    .widthIs(SCREEN_WIDTH * 0.75);
    
    _activityStatus.sd_layout
    .leftSpaceToView(bgView, 0)
    .widthIs(70.0 * SCREEN_WIDTHRATE_6)
    .heightIs(26.0 * SCREEN_WIDTHRATE_6)
    .centerYEqualToView(bgView);
    
    _actTitle.sd_layout
    .leftSpaceToView(bgView, 0)
    .topSpaceToView(bgView, 12.0 * SCREEN_WIDTHRATE_6) // 28 -- > 24
    .heightIs(13.0 * SCREEN_WIDTHRATE_6)   // 30 --- > 26
    .rightSpaceToView(bgView, 0);
    
    _actTime.sd_layout
    .leftSpaceToView(bgView, 0)
    .rightEqualToView(_actTitle)
    .bottomSpaceToView(bgView, 12.0 * SCREEN_WIDTHRATE_6) // 30 -- > 24
    .heightIs(9.0 * SCREEN_WIDTHRATE_6); // 22 --- > 18
    
    _actImageV.contentMode = UIViewContentModeScaleAspectFill;
    _actImageV.clipsToBounds = YES;
    _actImageV.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0 * SCREEN_WIDTHRATE_6;
    _actTitle.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.0];
    _actTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_UI28PX];
    _actTime.textColor = [UIColor DDR102_G102_B102ColorWithalph:1.0];
    _actTime.font = [UIFont systemFontOfSize:FONT_UI24PX];
    _activityStatus.layer.cornerRadius = CGRectGetHeight(_activityStatus.frame) / 2.0;
    _activityStatus.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
    _activityStatus.layer.borderWidth = 0.6f;
    [_activityStatus setTitleColor:[UIColor DDR102_G102_B102ColorWithalph:1.0] forState:UIControlStateNormal];
    [_activityStatus.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI28PX]];
    
    [_activityStatus addTarget:self action:@selector(clickActStatusBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //[self test];
    //bgView.backgroundColor = [UIColor greenColor];
}


#pragma mark ----- 数据回调刷新

- (void)setUpItemCellWithModel:(id)model{
    if (model) {
        RcmdActivityModel *f = (RcmdActivityModel *)model;
        _actTitle.text = f.desInfo;
        _actTime.text = [NSString stringWithFormat:@"活动时间：%@ — %@",f.dateStShow,f.dateEdShow];
        [_actImageV sd_setImageWithURL:[NSURL URLWithString:f.activityImage_url]];
        
        [_activityStatus setTitle:f.actStatusShow forState:UIControlStateNormal];
    }
}

#pragma mark ----- 点击交互

- (void)clickActStatusBtn:(UIButton *)btn{
    if (self.clickCellBtnBlock) {
        self.clickCellBtnBlock(btn);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHiddenCell:(BOOL)isHidden
{
    _actImageV.hidden = isHidden;
    _actTitle.hidden = isHidden;
    _actTime.hidden = isHidden;
    _activityStatus.hidden = isHidden;
}

- (void)test{
    
    
//    _actImageV.backgroundColor = [UIColor greenColor];
//    _actTitle.backgroundColor = [UIColor purpleColor];
//    _actTime.backgroundColor = [UIColor yellowColor];
//    _activityStatus.backgroundColor = [UIColor purpleColor];
    
    _actTitle.text = @"租房攻略，5000元优惠券免费领！";
    _actTime.text = @"活动时间：2017-10-28--2017-10-29";
    [_actImageV sd_setImageWithURL:[NSURL URLWithString:@"https://cache.hinabian.com/images/release/3/6/3f7f426b1c60c87fcce618a21c50c216.jpeg"]];
    [_activityStatus setTitle:@"进行中" forState:UIControlStateNormal];
    
    NSLog(@" _actImageV :%@ ",_actImageV);
    
}

@end
