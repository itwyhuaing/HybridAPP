//
//  HomeHotTopicCell.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/20.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "HomeHotTopicCell.h"
#import "HotTopicModel.h"

@interface HomeHotTopicCell ()

@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *gotoLook;


@end

@implementation HomeHotTopicCell

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
    
    _imageV = [[UIImageView alloc] init];
    _title = [[UILabel alloc] init];
    _gotoLook = [[UILabel alloc] init];
    [self addSubview:_imageV];
    [self addSubview:_title];
    [self addSubview:_gotoLook];
    
    _imageV.sd_layout
    .leftSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .rightSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(self, 0)
    .heightIs(150.0 * SCREEN_WIDTHRATE_6);
    
    _title.sd_layout
    .topSpaceToView(self, 50.0 * SCREEN_WIDTHRATE_6)
    .leftEqualToView(_imageV)
    .rightEqualToView(_imageV)
    .heightIs(18.0 * SCREEN_WIDTHRATE_6);
    
    _gotoLook.sd_layout
    .topSpaceToView(_title, 15.0 * SCREEN_WIDTHRATE_6)
    .centerXEqualToView(_imageV)
    .heightIs(30.0 * SCREEN_WIDTHRATE_6)
    .widthIs(94.0 * SCREEN_WIDTHRATE_6);
    
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _imageV.clipsToBounds = YES;
    _imageV.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0 * SCREEN_WIDTHRATE_6;
    
    _title.font = [UIFont systemFontOfSize:FONT_UI34PX];
    _title.textColor = [UIColor whiteColor];
    _title.textAlignment = NSTextAlignmentCenter;
    _gotoLook.textAlignment = NSTextAlignmentCenter;
    _gotoLook.textColor = [UIColor whiteColor];
    _gotoLook.font = [UIFont systemFontOfSize:FONT_UI28PX];
    _gotoLook.layer.cornerRadius = 15.0 * SCREEN_WIDTHRATE_6;
    _gotoLook.layer.borderColor = [UIColor whiteColor].CGColor;
    _gotoLook.layer.borderWidth = 1.0;
    [self.gotoLook setText:@"去看看"];
    
    //[self test];
    
//    _title.backgroundColor = [UIColor greenColor];
//    _gotoLook.backgroundColor = [UIColor greenColor];
    
}


#pragma mark ----- 数据回调刷新

- (void)setUpItemCellWithModel:(id)model{
    if (model) {
        HotTopicModel *f = (HotTopicModel *)model;
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:f.img]];
        [self.title setText:f.title];
        
    }
}

#pragma mark ----- 点击交互


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)test{
    
    _imageV.backgroundColor = [UIColor purpleColor];
    [_imageV sd_setImageWithURL:[NSURL URLWithString:@"https://cache.hinabian.com/images/release/3/6/3f7f426b1c60c87fcce618a21c50c216.jpeg"]];
    
    
    
    NSLog(@" _imageV :%@ ",_imageV);
    
}

@end
