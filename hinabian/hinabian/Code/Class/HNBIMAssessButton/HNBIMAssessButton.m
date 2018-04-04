//
//  HNBIMAssessButton.m
//  hinabian
//
//  Created by 何松泽 on 2017/10/24.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "HNBIMAssessButton.h"

@interface HNBIMAssessButton()

@property (nonatomic, strong)UILabel *textLabel;
@property (nonatomic, strong)UILabel *describeLabel;

@end

@implementation HNBIMAssessButton

-(id)initWithDescribeFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initialization];
        
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = frame.size.height/2 - 3;
        
        self.textLabel.sd_layout
        .topSpaceToView(self, 12)
        .centerXEqualToView(self)
        .widthIs(frame.size.width)
        .heightIs(20);
        
        self.describeLabel.sd_layout
        .topSpaceToView(self.textLabel, 10)
        .centerXEqualToView(self)
        .widthIs(frame.size.width)
        .heightIs(12);
        
        self.textLabel.font = _titleFont;
        self.describeLabel.font = _describeFont;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initialization];
        
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = frame.size.height/2 - 3;
        
        self.textLabel.sd_layout
        .centerYEqualToView(self)
        .centerXEqualToView(self)
        .widthIs(frame.size.width)
        .heightIs(20);
        
        self.describeLabel.sd_layout
        .topSpaceToView(self.textLabel, 10)
        .centerXEqualToView(self)
        .widthIs(frame.size.width)
        .heightIs(12);
        self.describeLabel.hidden = YES;
        self.textLabel.font = _titleFont;
        self.describeLabel.font = _describeFont;
    }
    return self;
}

-(void)initialization {
    _titleFont = [UIFont systemFontOfSize:FONT_UI32PX];
    _describeFont = [UIFont systemFontOfSize:FONT_UI24PX];
    _titleColor = [UIColor DDNavBarBlue];
    _describeColor = [UIColor DDR102_G102_B102ColorWithalph:1.f];
}

-(void)setOriginalBtn {
    self.selected = NO;
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    [self.textLabel setTextColor:[UIColor DDNavBarBlue]];
    [self.describeLabel setTextColor:[UIColor DDR102_G102_B102ColorWithalph:1.f]];
}

-(void)setSelectedBtn {
    self.selected = YES;
    self.backgroundColor = [UIColor DDNavBarBlue];
    self.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    [self.textLabel setTextColor:[UIColor whiteColor]];
    [self.describeLabel setTextColor:[UIColor whiteColor]];
}

-(UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

-(UILabel *)describeLabel {
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _describeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_describeLabel];
    }
    return _describeLabel;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.textLabel.text = _title;
}

- (void)setDescribe:(NSString *)describe {
    _describe = describe;
    self.describeLabel.text = _describe;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.textLabel.font = titleFont;
}

- (void)setDescribeFont:(UIFont *)describeFont {
    _describeFont = describeFont;
    self.describeLabel.font = describeFont;
}


@end
