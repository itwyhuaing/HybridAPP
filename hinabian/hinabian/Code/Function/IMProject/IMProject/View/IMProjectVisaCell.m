//
//  IMProjectVisaCell.m
//  hinabian
//
//  Created by 何松泽 on 2017/8/25.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "IMProjectVisaCell.h"

@implementation IMProjectVisaCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGRect rect = self.bounds;
        rect.origin.x = GAP_S * SCREEN_SCALE;
        rect.origin.y = 0.f;
        rect.size.width = SCREEN_WIDTH - GAP_S * SCREEN_SCALE * 2;
        rect.size.height = 240.f * SCREEN_SCALE;
        _projVisaView = [[SingleProjVisaView alloc] initWithFrame:rect];
        [self addSubview:_projVisaView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProjModel:(IMHomeProjModel *)model {
    [_projVisaView setProjModel:model];
}

//- (void)setVisaModel:(IMHomeVisaModel *)model {
//    [_projVisaView setVisaModel:model];
//}

@end
