//
//  TribeDetailNewsCell.m
//  hinabian
//
//  Created by 何松泽 on 2018/4/4.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "TribeDetailNewsCell.h"

@interface TribeDetailNewsCell ()

@property (nonatomic , strong) UILabel *titleLab;

@property (nonatomic , strong) UILabel *desLab;

@end

@implementation TribeDetailNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialView];
        [self makeConstraints];
    }
    return self;
}

- (void)initialView {
    _titleLab = [[UILabel alloc]init];
    _titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.font = [UIFont systemFontOfSize:14];
    _titleLab.text = @"中国政府或拟承认双重国籍！！政协委员提委员提...";
    [self.contentView addSubview:_titleLab];
    
    _desLab = [[UILabel alloc]init];
    _desLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _desLab.textAlignment = NSTextAlignmentLeft;
    _desLab.font = [UIFont systemFontOfSize:12];
    _desLab.text = @"2018-03-12  16:12   阅读  1023";
    [self.contentView addSubview:_desLab];
}

- (void)makeConstraints {
    _titleLab.sd_layout
    .topSpaceToView(self.contentView, 14)
    .leftSpaceToView(self.contentView, 23)
    .rightSpaceToView(self.contentView, 23)
    .heightIs(14);
    
    _desLab.sd_layout
    .bottomSpaceToView(self.contentView, 14)
    .leftSpaceToView(self.contentView, 23)
    .rightSpaceToView(self.contentView, 23)
    .heightIs(12);
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
