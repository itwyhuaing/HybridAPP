//
//  TribeDetailHeaderCell.m
//  hinabian
//
//  Created by 何松泽 on 2018/4/3.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "TribeDetailHeaderCell.h"

@interface TribeDetailHeaderCell ()

@property (nonatomic , strong) UILabel *tipLab;

@property (nonatomic , strong) UILabel *titleLab;

@property (nonatomic , strong) UIImageView *aryImg;

@end

@implementation TribeDetailHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F7F8"];
        [self initialView];
        [self makeConstraints];
    }
    return self;
}

- (void)initialView {
    _tipLab = [[UILabel alloc]init];
    _tipLab.text = @"来自";
    _tipLab.textColor = [UIColor colorWithHexString:@"#BCBBBB"];
    _tipLab.textAlignment = NSTextAlignmentLeft;
    _tipLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_tipLab];
    
    _titleLab = [[UILabel alloc]init];
    _titleLab.text = @"美国移民圈";
    _titleLab.textColor = [UIColor colorWithHexString:@"#777777"];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_titleLab];
    
    _aryImg = [[UIImageView alloc]init];
    _aryImg.image = [UIImage imageNamed:@"tribe_ary"];
    _aryImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_aryImg];
}

- (void)makeConstraints {
    _tipLab.sd_layout
    .topEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 21)
    .bottomEqualToView(self.contentView);
    [_tipLab setSingleLineAutoResizeWithMaxWidth:100];
    
    _titleLab.sd_layout
    .topEqualToView(self.contentView)
    .leftSpaceToView(_tipLab, 10)
    .bottomEqualToView(self.contentView);
    [_titleLab setSingleLineAutoResizeWithMaxWidth:100];
    
    _aryImg.sd_layout
    .topEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, 12)
    .bottomEqualToView(self.contentView)
    .widthIs(17);
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
