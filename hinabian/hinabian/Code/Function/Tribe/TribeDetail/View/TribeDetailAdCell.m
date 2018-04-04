//
//  TribeDetailAdCell.m
//  hinabian
//
//  Created by 何松泽 on 2018/4/4.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "TribeDetailAdCell.h"

@interface TribeDetailAdCell ()

@property (nonatomic , strong) UIImageView *adImgView;

@end

@implementation TribeDetailAdCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self initialView];
        [self makeConstraints];
    }
    return self;
}

- (void)initialView {
    _adImgView = [[UIImageView alloc]init];
    _adImgView.backgroundColor = [UIColor colorWithHexString:@"#FBFBFB"];
    _adImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_adImgView];
}

- (void)makeConstraints {
    _adImgView.sd_layout
    .leftSpaceToView(self.contentView, 22)
    .rightSpaceToView(self.contentView, 22)
    .topSpaceToView(self.contentView, 22)
    .bottomSpaceToView(self.contentView, 22);
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
