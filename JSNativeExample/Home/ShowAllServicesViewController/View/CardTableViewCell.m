//
//  CardTableViewCell.m
//  hinabian
//
//  Created by hnbwyh on 2018/3/28.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "CardTableViewCell.h"

@interface CardTableViewCell ()

@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *themTitle;
@property (nonatomic,strong) UILabel *serviceCharge;

@end

@implementation CardTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setUpCell];
    }
    return self;
}


- (void)setUpCell{
    UIView *bg = [[UIView alloc] init];
    UIView *contentBg = [[UIView alloc] init];
    _imgV = [[UIImageView alloc] init];
    _themTitle = [[UILabel alloc] init];
    _serviceCharge = [[UILabel alloc] init];
    [self addSubview:bg];
    [bg addSubview:contentBg];
    [contentBg addSubview:_imgV];
    [contentBg addSubview:_themTitle];
    [contentBg addSubview:_serviceCharge];
    
    bg.sd_layout
    .leftSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .rightSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .bottomSpaceToView(self, 0.0);
    contentBg.sd_layout
    .leftSpaceToView(bg, 0)
    .rightSpaceToView(bg, 0)
    .topSpaceToView(bg, 0)
    .bottomSpaceToView(bg, 0);
    _imgV.sd_layout
    .topEqualToView(contentBg)
    .leftEqualToView(contentBg)
    .rightEqualToView(contentBg)
    .heightIs(192.0 * SCREEN_WIDTHRATE_6);
    _themTitle.sd_layout
    .topSpaceToView(_imgV, 15.0 * SCREEN_WIDTHRATE_6)
    .leftSpaceToView(contentBg, 21.0 * SCREEN_WIDTHRATE_6)
    .heightIs(17.0 * SCREEN_WIDTHRATE_6)
    .widthIs(SCREEN_WIDTH/2.0);
    _serviceCharge.sd_layout
    .centerYEqualToView(_themTitle)
    .heightRatioToView(_themTitle, 1.0)
    .rightSpaceToView(contentBg, 17.0 * SCREEN_WIDTHRATE_6)
    .leftSpaceToView(_themTitle, 0);
    
    
    // 卡片效果
    contentBg.backgroundColor = [UIColor whiteColor];
    contentBg.layer.masksToBounds = TRUE;
    contentBg.layer.cornerRadius = 4.f;
    bg.clipsToBounds = FALSE;
    bg.layer.cornerRadius = 5.0;
    bg.layer.shadowColor = [UIColor colorWithRed:122.0f/255.0f green:122.0f/255.0f blue:122.0f/255.0f alpha:1.0].CGColor;
    bg.layer.shadowOpacity = 0.3f;
    bg.layer.shadowRadius = 2.f;
    bg.layer.shadowOffset = CGSizeMake(0,0);
    
    _themTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_UI36PX];
    _themTitle.textColor = [UIColor DDBlack333];
    _themTitle.textAlignment = NSTextAlignmentLeft;
    _serviceCharge.font = [UIFont systemFontOfSize:FONT_UI28PX];
    _serviceCharge.textColor = [UIColor colorWithRed:237.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1.0];
    _serviceCharge.textAlignment = NSTextAlignmentRight;
    
    //_themTitle.backgroundColor = [UIColor redColor];
    //_imgV.backgroundColor = [UIColor greenColor];
    //_serviceCharge.backgroundColor = [UIColor cyanColor];
    
}


- (void)modifyCellWithModel:(CardTableDataModel *)f{
    [_imgV sd_setImageWithURL:[NSURL URLWithString:f.promotion_img]];
    [_themTitle setText:f.project_name];
    [_serviceCharge setText:[NSString stringWithFormat:@"¥ %@元起",f.total_fee]];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
