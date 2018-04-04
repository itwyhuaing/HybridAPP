//
//  HotImmigrantCell.m
//  hinabian
//
//  Created by hnbwyh on 2017/11/6.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "HotImmigrantCell.h"
#import "HotIMProjectModel.h"

@interface HotImmigrantCell ()

@property (nonatomic,strong) UIImageView *actImageV;
@property (nonatomic,strong) UILabel *actTitle;
@property (nonatomic,strong) UILabel *actTime;
@property (nonatomic,strong) UIButton *activityStatus;

@end

@implementation HotImmigrantCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setUpCell];
        //[self test];
    }
    return self;
}

- (void)setUpCell{
    UIView *bg = [[UIView alloc] init];
    UIView *v = [[UIView alloc] init];
    _actImageV = [[UIImageView alloc] init];
    UIView *bgView = [[UIView alloc] init];
    _actTitle = [[UILabel alloc] init];
    _actTime = [[UILabel alloc] init];
    _activityStatus = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self addSubview:bg];
    [bg addSubview:v];
    [v addSubview:_actImageV];
    [v addSubview:bgView];
    [v addSubview:_activityStatus];
    [bgView addSubview:_actTitle];
    [bgView addSubview:_actTime];
    
    
    bg.sd_layout
    .leftSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .rightSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(self, 8.0 * SCREEN_WIDTHRATE_6)
    .bottomSpaceToView(self, 7.0 * SCREEN_WIDTHRATE_6);
    
    v.sd_layout
    .leftSpaceToView(bg, 0)
    .rightSpaceToView(bg, 0)
    .topSpaceToView(bg, 0)
    .bottomSpaceToView(bg, 0);
    
    _actImageV.sd_layout
    .leftSpaceToView(v, 0)
    .rightSpaceToView(v, 0)
    .topSpaceToView(v, 0)
    .heightIs(150.0 * SCREEN_WIDTHRATE_6);
    
    bgView.sd_layout
    .topSpaceToView(_actImageV, 0)
    .leftSpaceToView(v, 10.0)
    .bottomSpaceToView(v, 0)
    .widthIs((SCREEN_WIDTH - 30.0) * 0.74);
    
    _activityStatus.sd_layout
    .leftSpaceToView(bgView, 0)
    .widthIs(65.0 * SCREEN_WIDTHRATE_6)
    .heightIs(25.0 * SCREEN_WIDTHRATE_6)
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
    
    
    v.backgroundColor = [UIColor whiteColor];
    v.layer.masksToBounds = TRUE;
    v.layer.cornerRadius = 4.f;
    
    bg.clipsToBounds = FALSE;
    bg.layer.cornerRadius = 5.0;
    
    bg.layer.shadowColor = [UIColor colorWithRed:122.0f/255.0f green:122.0f/255.0f blue:122.0f/255.0f alpha:1.0].CGColor;
    bg.layer.shadowOpacity = 0.3f;
    bg.layer.shadowRadius = 2.f;
    bg.layer.shadowOffset = CGSizeMake(0,0);
    
    
    _actImageV.contentMode = UIViewContentModeScaleAspectFill;
    _actImageV.clipsToBounds = YES;
    _actTitle.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.0];
    _actTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_UI28PX];
    _actTime.textColor = [UIColor DDR102_G102_B102ColorWithalph:1.0];
    _actTime.font = [UIFont systemFontOfSize:FONT_UI24PX];
    [_activityStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_activityStatus.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI28PX]];
    [_activityStatus addTarget:self action:@selector(clickActStatusBtn:) forControlEvents:UIControlEventTouchUpInside];
    
//    v.backgroundColor = [UIColor greenColor];
//    bgView.backgroundColor = [UIColor redColor];
    
}


#pragma mark ----- 数据回调刷新

- (void)setUpItemCellWithModel:(id)model{
    if (model) {
        HotIMProjectModel *f = (HotIMProjectModel *)model;
        _actTitle.text = f.desInfo;
        _actTime.text = [NSString stringWithFormat:@"活动时间：%@ — %@",f.dateStShow,f.dateEdShow];
        [_actImageV sd_setImageWithURL:[NSURL URLWithString:f.activityImage_url]];
        
        NSString *imageName = @"";
        if ([f.actStatus isEqualToString:@"0"]) {
            imageName = @"hotimpro_pre";
        }else if ([f.actStatus isEqualToString:@"2"]){
           imageName = @"hotimpro_end";
        }else{
            imageName = @"hotimpro_ing";
        }
        [_activityStatus setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
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

- (void)test{
    
    
        _actImageV.backgroundColor = [UIColor grassColor];
        _actTitle.backgroundColor = [UIColor blueColor];
        _actTime.backgroundColor = [UIColor yellowColor];
        _activityStatus.backgroundColor = [UIColor grayColor];
    
//    _actTitle.text = @"租房攻略，5000元优惠券免费领！";
//    _actTime.text = @"活动时间：2017-10-28--2017-10-29";
//    [_actImageV sd_setImageWithURL:[NSURL URLWithString:@"https://cache.hinabian.com/images/release/3/6/3f7f426b1c60c87fcce618a21c50c216.jpeg"]];
//    [_activityStatus setTitle:@"进行中" forState:UIControlStateNormal];
//
//    NSLog(@" _actImageV :%@ ",_actImageV);
    
}
@end
