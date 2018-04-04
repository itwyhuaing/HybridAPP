//
//  QuickViewCell.m
//  hinabian
//
//  Created by 何松泽 on 2017/10/18.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "QuickViewCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface QuickViewCell()<SDCycleScrollViewDelegate>

@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UIView *line;

@end


@implementation QuickViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat imageHeight = 20.f;
        self.headImageView.sd_layout
        .topSpaceToView(self.contentView,(37.f - imageHeight)/2)
        .leftSpaceToView(self.contentView,imageHeight)
        .heightIs(imageHeight)
        .widthIs(45);
        
        self.line.sd_layout
        .topSpaceToView(self.contentView,(37.f - imageHeight)/2)
        .leftSpaceToView(self.headImageView, 10)
        .heightIs(imageHeight)
        .widthIs(1.f);
        
        self.quickNewsView.sd_layout
        .topSpaceToView(self.contentView,0)
        .leftSpaceToView(self.line,10)
        .heightIs(37.f)
        .widthIs(SCREEN_WIDTH - CGRectGetMaxX(self.line.frame) - 80);
        
        //[self test];
        
    }
    return self;
}

-(UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.image = [UIImage imageNamed:@"homepage_quickNews"];
        [self.contentView addSubview:_headImageView];
    }
    return _headImageView;
}

-(UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
        _line.layer.borderWidth = 0.5f;
        _line.layer.borderColor = [UIColor DDR102_G102_B102ColorWithalph:0.3f].CGColor;
        [self.contentView addSubview:_line];
    }
    return _line;
}

-(SDCycleScrollView *)quickNewsView {
    if (!_quickNewsView) {
        _quickNewsView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        _quickNewsView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _quickNewsView.titleLabelTextColor = [UIColor DDR102_G102_B102ColorWithalph:1.0f];
        _quickNewsView.titleLabelTextFont = [UIFont systemFontOfSize:15.f];
        _quickNewsView.titleLabelBackgroundColor = [UIColor whiteColor];
        _quickNewsView.onlyDisplayText = YES;
        _quickNewsView.autoScroll = TRUE;
        [_quickNewsView disableScrollGesture];
        
        [self.contentView addSubview:_quickNewsView];
    }
    return _quickNewsView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)test{
    self.headImageView.backgroundColor = [UIColor greenColor];
    self.quickNewsView.backgroundColor = [UIColor redColor];
}

@end
