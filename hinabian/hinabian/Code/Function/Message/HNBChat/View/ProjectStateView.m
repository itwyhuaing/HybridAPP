//
//  ProjectStateView.m
//  hinabian
//
//  Created by hnbwyh on 16/6/14.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "ProjectStateView.h"
#import "VerticalAligmentLabel.h"
#import "ProjectStateModel.h"

@interface ProjectStateView ()

@property (nonatomic,strong) ProjectStateModel *currentModel;

@end

@implementation ProjectStateView

-(void)awakeFromNib{

    [super awakeFromNib];
    self.layer.cornerRadius = RRADIUS_LAYERCORNE;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    self.stateTip.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:246.0/255.0 blue:255.0/255.0 alpha:1.0];
    [self.stateTip setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]];
    self.stateTip.font = [UIFont systemFontOfSize:16.0];
    self.stateTip.textAlignment = NSTextAlignmentCenter;
    
    [self.project setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
    self.project.font = [UIFont systemFontOfSize:12.0];
    self.project.textAlignment = NSTextAlignmentLeft;
    [self.project setText:@"在办项目:"];
    
    [self.projectName setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]];
    self.projectName.font = [UIFont systemFontOfSize:14.0];
    self.projectName.textAlignment = NSTextAlignmentLeft;
    
    [self.state setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
    self.state.font = [UIFont systemFontOfSize:12.0];
    self.state.textAlignment = NSTextAlignmentLeft;
    [self.state setText:@"当前进度:"];
    
    // 蓝 - 灰白 线条
    self.blueline.backgroundColor = [UIColor DDNavBarBlue];
    self.grayWhiteline.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:211.0/255.0 blue:211.0/255.0 alpha:1.0];
    // 已完成 - 进行中 - 待进行
    [self modifyProcessStateImgView:_finishedState];
    [self modifyProcessStateImgView:_goonState];
    [self modifyProcessStateImgView:_unStartState];
    _unStartState.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:211.0/255.0 blue:211.0/255.0 alpha:1.0];
    [_goonState setFont:[UIFont systemFontOfSize:11.0]];
    // 内容
    [self modifyStateLabel:self.leftState];
    [self modifyStateLabel:self.middleState];
    [self modifyStateLabel:self.rightState];
    [self.middleState setTextColor:[UIColor DDNavBarBlue]];
    
    [self.specialLink setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
    self.specialLink.font = [UIFont systemFontOfSize:9.0];
    self.specialLink.textAlignment = NSTextAlignmentCenter;
    
    self.lookLink.layer.cornerRadius = RRADIUS_LAYERCORNE;
    self.lookLink.backgroundColor = [UIColor DDNavBarBlue];
    [self.lookLink setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.lookLink.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    self.lookLink.tag = LookLinkBtnTag;
    [self.lookLink addTarget:self action:@selector(clickEventFromBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.successLabel setTextColor:[UIColor colorWithRed:16.0/255.0 green:175.0/255.0 blue:94.0/255.0 alpha:1.0]];
    [self.successLabel setFont:[UIFont systemFontOfSize:12.0]];
    
    [self setProcessDisplay:YES];
    [self setSuccessDisplay:NO];
    
}

- (void)modifyProcessStateImgView:(UILabel *)label{
    
    label.layer.cornerRadius = CGRectGetHeight(label.frame)/2.0;
    label.clipsToBounds = YES;
    label.backgroundColor = [UIColor DDNavBarBlue];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:8.0]];
    
}

- (void)modifyStateLabel:(VerticalAligmentLabel *)label{

    [label setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
    label.font = [UIFont systemFontOfSize:10.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    
}


- (void)setViewWithModel:(ProjectStateModel *)model{

    _currentModel = model;
    
    [self.projectName setText:_currentModel.projectName];
    if (_currentModel.userSteps.count == 3 ) { // 3

        [self setProcessDisplay:YES];
        [self setSuccessDisplay:NO];

        for (NSInteger cou = 0; cou < 3; cou ++) {
            
            NSDictionary *stepDict = _currentModel.userSteps[cou];
            NSInteger status = [[stepDict valueForKey:@"status"] integerValue];
            switch (status) {
                case 3: // 已完成
                {
                    [_finishedState setText:@"已完成"];
                    [_leftState setText:[stepDict valueForKey:@"name"]];
                }
                    break;
                case 2: // 进行中
                {
                    [_goonState setText:@"进行中"];
                    [_middleState setText:[stepDict valueForKey:@"name"]];
                }
                    break;
                case 1: // 待进行
                {
                    [_unStartState setText:@"待进行"];
                    [_rightState setText:[stepDict valueForKey:@"name"]];
                }
                    break;
                case 4: // 成功
                {
                    [_unStartState setText:@"成功"];
                    [_rightState setText:@"办理成功"];
                }
                    break;
                default:
                    break;
            }

        }
        
        NSString *tmp = [NSString stringWithFormat:@"文案专家%@随时在线为您服务",_currentModel.specialName];
        NSMutableAttributedString *t = [[NSMutableAttributedString alloc] initWithString:tmp];
        [t addAttribute:NSForegroundColorAttributeName
                  value:[UIColor DDNavBarBlue]
                  range:NSMakeRange(4, _currentModel.specialName.length)];
        [self.specialLink setAttributedText:t];
        
        
    }else{ // 1
    
        [self setProcessDisplay:NO];
        [self setSuccessDisplay:YES];
        
    }

}

- (void)setProcessDisplay:(BOOL)isShow{

    self.blueline.hidden = !isShow;
    self.grayWhiteline.hidden = !isShow;
    self.finishedState.hidden = !isShow;
    self.goonState.hidden = !isShow;
    self.unStartState.hidden = !isShow;
    self.leftState.hidden = !isShow;
    self.middleState.hidden = !isShow;
    self.rightState.hidden = !isShow;
    
}

- (void)setSuccessDisplay:(BOOL)isShow{

    self.successLabel.hidden = !isShow;
    self.successImgView.hidden = !isShow;
    
}




#pragma mark ------ lookLink
- (void)clickEventFromBtn:(UIButton *)btn{

    if (_delegate && [_delegate respondsToSelector:@selector(touchEvent:info:)]) {

        NSDictionary *infoDic;
        if (_currentModel && _currentModel.lookLink != nil && _currentModel.user_project_id != nil) {
            infoDic = @{
                          @"lookLink":_currentModel.lookLink,
                          @"projectId":_currentModel.user_project_id
                       };
        }
        [_delegate touchEvent:btn info:infoDic];
        
    }
    
}





@end
