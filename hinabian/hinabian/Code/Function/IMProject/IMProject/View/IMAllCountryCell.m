//
//  IMAllCountryCell.m
//  hinabian
//
//  Created by 何松泽 on 2017/8/25.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "IMAllCountryCell.h"

@interface IMAllCountryCell()

@property (nonatomic, strong)UIImageView *imageView;

@property (nonatomic, strong)UILabel *label;

@end

@implementation IMAllCountryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
                                                               
- (void)setModel:(IMHomeNationTabModel *)model {
    IMHomeNationTabModel *f = model;
    
    if (!_imageView) {
        float imageViewWidth = 50.f;
        float imageViewX = (SCREEN_WIDTH/3 - imageViewWidth)/2;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, 0, imageViewWidth, imageViewWidth)];
        [self addSubview:_imageView];
    }
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame) + 10, SCREEN_WIDTH/3, 20)];
        _label.textColor = [UIColor DDR102_G102_B102ColorWithalph:1.0f];
        [_label setFont:[UIFont systemFontOfSize:FONT_UI26PX]];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    
    if (f) {
        if ([f.f_id isEqualToString:@"0"]) {
            //热门项目使用本地图片
            [_imageView setImage:[UIImage imageNamed:@"project_hot_icon"]];
        }else{
            [_imageView sd_setImageWithURL:[NSURL URLWithString:f.f_icon]];
        }
        [_label setText:f.f_name_short_cn];
    }
    
}
                                                               

@end
