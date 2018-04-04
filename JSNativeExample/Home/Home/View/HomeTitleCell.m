//
//  HomeTitleCell.m
//  hinabian
//
//  Created by 何松泽 on 2017/11/6.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "HomeTitleCell.h"

@implementation HomeTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}


- (void)setcellTitle:(NSString *)title detailTitle:(NSString *)detailTitle arrow:(NSString *)arrow{
    
    [self.titleLabel setText:title];
    [self.detailTitleLabel setText:detailTitle];
    if (arrow) {
        [self.arrowImageView setImage:[UIImage imageNamed:arrow]];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setHiddenCell:(BOOL)isHidden
{
    _titleLabel.hidden = isHidden;
    _detailTitleLabel.hidden = isHidden;
    _arrowImageView.hidden = isHidden;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, self.height - 5)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:FONT_UI34PX];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.0];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailTitleLabel {
    if (!_detailTitleLabel) {
        _detailTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 105, 0, 80, self.height - 5)];
        _detailTitleLabel.font = [UIFont boldSystemFontOfSize:FONT_UI26PX];
        _detailTitleLabel.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0];
        _detailTitleLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_detailTitleLabel];
    }
    return _detailTitleLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20, self.height/2 - 7.5, 10, 10)];
        _arrowImageView.contentMode = UIViewContentModeRight;
        [self addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

@end
