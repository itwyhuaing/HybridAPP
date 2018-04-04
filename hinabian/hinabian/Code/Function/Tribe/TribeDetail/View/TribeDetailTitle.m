//
//  TribeDetailTitle.m
//  hinabian
//
//  Created by 何松泽 on 2018/4/4.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "TribeDetailTitle.h"

@interface TribeDetailTitle ()

@property (nonatomic , strong) UILabel *titleLab;

@end

@implementation TribeDetailTitle

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initialView];
        [self makeConstraints];
    }
    return self;
}

- (void)initialView {
    _titleLab = [[UILabel alloc]init];
    _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_titleLab];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLab.text = _title;
}

- (void)makeConstraints {
    _titleLab.sd_layout
    .topEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 22)
    .rightSpaceToView(self.contentView, 22)
    .bottomEqualToView(self.contentView);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
