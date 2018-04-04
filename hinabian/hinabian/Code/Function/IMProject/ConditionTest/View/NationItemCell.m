//
//  NationItemCell.m
//  hinabian
//
//  Created by hnbwyh on 17/6/9.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "NationItemCell.h"
#import "ProjectNationsModel.h"

@interface NationItemCell ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *desLabel;

@end


@implementation NationItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect rect = CGRectZero;
        rect.size.width = frame.size.width;
        rect.size.height = CGRectGetHeight(frame) * 0.6;
        _titleLabel = [[UILabel alloc] initWithFrame:rect];
        rect.origin.y = CGRectGetMaxY(_titleLabel.frame) - 3.f;
        rect.size.height = CGRectGetHeight(frame) * 0.4;
        _desLabel = [[UILabel alloc] initWithFrame:rect];
        [self addSubview:_titleLabel];
        [self addSubview:_desLabel];
        
        [self modifyLabel:_titleLabel font:FONT_UI32PX textColor:[UIColor DDNavBarBlue]];
        [self modifyLabel:_desLabel font:FONT_UI22PX textColor:[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1.0]];
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 8.0  * (SCREEN_WIDTH / 375.0);
        
//        _titleLabel.backgroundColor = [UIColor greenColor];
//        _desLabel.backgroundColor = [UIColor purpleColor];
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)modifyLabel:(UILabel *) label font:(CGFloat)font textColor:(UIColor *)clr{

    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 1;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = clr;
}

- (void)modifyUnSelectedItem{
    self.backgroundColor = [UIColor whiteColor];
    _titleLabel.textColor = [UIColor DDNavBarBlue];
    _desLabel.textColor = [UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1.0];
}


- (void)modifySelectedItem{
    self.backgroundColor = [UIColor DDNavBarBlue];
    _titleLabel.textColor = [UIColor whiteColor];
    _desLabel.textColor = [UIColor whiteColor];
}

- (void)configNationItemCellContentsWithDataModel:(id)f{
    ProjectNationsModel *tmpF = (ProjectNationsModel *)f;
    _titleLabel.text = tmpF.cn_short_name;
    _desLabel.text = tmpF.desc;
}

-(void)setIsSelected:(BOOL)isSelected{
    if (isSelected) {
        [self modifySelectedItem];
    } else {
        [self modifyUnSelectedItem];
    }
}

@end
