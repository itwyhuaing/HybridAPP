//
//  SpecialistAndTestCell.m
//  hinabian
//
//  Created by 何松泽 on 2017/6/8.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "SpecialistAndTestCell.h"

@implementation SpecialistAndTestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [self setBackgroundColor:[UIColor blueberryColor]];
    self.line.layer.borderWidth = 0.5f;
    self.line.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
    self.specialDetailLabel.textColor = [UIColor DDR102_G102_B102ColorWithalph:1.0f];
    self.testDetailLabel.textColor = [UIColor DDR102_G102_B102ColorWithalph:1.0f];
    
    if (SCREEN_HEIGHT > SCREEN_HEIGHT_6) {
        self.specialLeadingView.constant = 19.f;
        self.testLeadingLine.constant = 19.f;
    }else {
        self.specialLeadingView.constant = 5.f;
        self.testLeadingLine.constant = 5.f;
    }
    _specialBtn.tag = SpecialTag;
    [_specialBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    _testBtn.tag = TestTag;
    [_testBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickEvent:(UIButton *)sender
{
    if (sender.tag == SpecialTag) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HOMEPAGE_FINDSPECIAL_NOTIFICATION object:nil];
    }else if (sender.tag == TestTag){
        [[NSNotificationCenter defaultCenter] postNotificationName:HOMEPAGE_CONDITION_TEST_NOTIFICATION object:nil];
    }
}

-(void)setItemShow:(BOOL)isShow
{
    self.line.hidden = !isShow;
    self.specialDetailLabel.hidden = !isShow;
    self.testDetailLabel.hidden = !isShow;
    self.specialImage.hidden = !isShow;
    self.testImage.hidden = !isShow;
    self.testTitleLabel.hidden = !isShow;
    self.specialTitleLabel.hidden = !isShow; 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
