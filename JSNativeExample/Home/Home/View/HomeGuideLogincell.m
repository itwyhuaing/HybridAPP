//
//  HomeGuideLogincell.m
//  hinabian
//
//  Created by hnbwyh on 17/5/18.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "HomeGuideLogincell.h"


@implementation HomeGuideLogincell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.loginBtn.backgroundColor = [UIColor DDNavBarBlue];
    self.loginBtn.layer.cornerRadius = 5.f;
    self.loginBtn.titleLabel.textColor = [UIColor whiteColor];
    [self.loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.loginLabel.textColor = [UIColor colorFromHexString:@"#A6A6A6"];
    
    self.topGapLabel.backgroundColor = [UIColor DDR245_G245_B245ColorWithalph:1.0];
    self.bottomGapLabel.backgroundColor = [UIColor DDR245_G245_B245ColorWithalph:1.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configSubviewsDisplayStatus:(BOOL)isShow{

    self.loginBtn.hidden = !isShow;
    self.loginLabel.hidden = !isShow;
    self.topGapLabel.hidden = !isShow;
    self.bottomGapLabel.hidden = !isShow;
    
}


- (void)loginClick:(UIButton *)btn{

    if (_delegate && [_delegate respondsToSelector:@selector(homeGuideLogincell:didClickLoginBtn:)]) {
        [_delegate homeGuideLogincell:self didClickLoginBtn:btn];
    }
    
}

@end
