//
//  IMStrategyCell.m
//  hinabian
//
//  Created by hnbwyh on 16/5/24.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "IMStrategyCell.h"
#import "CountDownTimeView.h"
#import "NewActivityInfo.h"

@interface IMStrategyCell ()

@property (nonatomic) CGFloat startCountDownTimeInterval;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic) NSInteger maxSeconds;
@property (nonatomic) BOOL allowRun;

@end

@implementation IMStrategyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //[self setColor];
    
    [self modifyCellEVent:self.firstButton imgView:self.firstImageView firstLabel:self.firsttitle1Label secondLabel:self.firsttitle2Label];
    [self modifyCellEVent:self.secondButton imgView:self.secondImageView firstLabel:self.secondtitle1Label secondLabel:self.secondtitle2Label];
    [self modifyCellEVent:self.thirdButton imgView:self.thirdImageView firstLabel:self.thirdtitle1Label secondLabel:self.thirdtitle2Label];
    [self modifyCellEVent:self.fourthButton imgView:self.fourthImageView firstLabel:self.fourthtitle1Label secondLabel:self.fourthtitle2Label];
    
    self.firstButton.tag = IMStrategy_FirstBtn_Tag;
    self.secondButton.tag = IMStrategy_SecondBtn_Tag;
    self.thirdButton.tag = IMStrategy_ThirdBtn_Tag;
    self.fourthButton.tag = IMStrategy_FourthBtn_Tag;
    
    self.tipView1.hidden = YES;
    self.tipView2.hidden = YES;
    self.tipView3.hidden = YES;
    self.tipView4.hidden = YES;
    _allowRun = YES;
    _maxSeconds = 0;
    _startCountDownTimeInterval = 8 * 3600.0; // 活动开始前八小时开始计时
}


- (void)modifyCellEVent:(UIButton *)btn imgView:(UIImageView *)imgView firstLabel:(UILabel *)fLabel secondLabel:(UILabel *)sLabel{

    imgView.clipsToBounds = YES;
    imgView.layer.cornerRadius = RRADIUS_LAYERCORNE;
    
    fLabel.font = [UIFont systemFontOfSize:FONT_UI26PX];
    sLabel.font = [UIFont systemFontOfSize:FONT_UI18PX];
    fLabel.textColor = [UIColor DDR0_G0_B0ColorWithalph:1.0];
    sLabel.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0];
    
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)setCellItem:(NSArray *)infos{

    NSArray *imgViews = @[self.firstImageView,self.secondImageView,self.thirdImageView,self.fourthImageView];
    NSArray *firstLabels = @[self.firsttitle1Label,self.secondtitle1Label,self.thirdtitle1Label,self.fourthtitle1Label];
    NSArray *secondLabels = @[self.firsttitle2Label,self.secondtitle2Label,self.thirdtitle2Label,self.fourthtitle2Label];
    NSArray *activityStateTipViews = @[self.tipView1,self.tipView2,self.tipView3,self.tipView4];
    
    for (NSInteger cou = 0; cou < infos.count;cou ++ ) {
        NewActivityInfo *f = infos[cou];
        
        UIImageView *imgV = imgViews[cou];
        [imgV sd_setImageWithURL:[NSURL URLWithString:f.index_img] placeholderImage:[UIImage imageNamed:@"homePage_imstrategy"]];
        UILabel *fLabel = firstLabels[cou];
        [fLabel setText:f.index_title];
        
        UILabel *sLabel = secondLabels[cou];
        [sLabel setText:[NSString stringWithFormat:@"%@人正在关注",f.follow_num]];
        
        CountDownTimeView *countDownTipView = activityStateTipViews[cou];
        // 计算时间差 － 判断活动状态
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        //f.activity_time = @"2016-06-2 19:42:00";
        //f.end_time = @"2016-06-2 19:43:00";
        NSDate *startDate = [formatter dateFromString:f.activity_time];
        NSDate *endDate = [formatter dateFromString:f.end_time];
        //NSDate *dat = [formatter dateFromString:@"2016-05-30 20:20:05"];
        NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval currentTimeInterval = [dat timeIntervalSince1970];
        NSTimeInterval startTimeInterval = [startDate timeIntervalSince1970];
        NSTimeInterval endTimeInterval = [endDate timeIntervalSince1970];
        
        countDownTipView.totalSeconds = startTimeInterval - currentTimeInterval;
        countDownTipView.totalEndSeconds = endTimeInterval - currentTimeInterval;
        
        if (countDownTipView.totalSeconds >= 0 && countDownTipView.totalSeconds <= self.startCountDownTimeInterval) { // 启动倒计时
            countDownTipView.hidden = NO;
            countDownTipView.viewType = CountDownTimer;
            _maxSeconds = [self compulateMaxSecond:countDownTipView.totalEndSeconds];
            
            for (UILabel *l in countDownTipView.subviews) {
                [l removeFromSuperview];
            }
            [countDownTipView setViewType:countDownTipView.viewType disPlay:nil];
            
        }else if(countDownTipView.totalEndSeconds >= 0 && countDownTipView.totalSeconds < 0){ // 活动进行中
            countDownTipView.hidden = NO;
            countDownTipView.viewType = ActivityStateOn;
            countDownTipView.totalSeconds = -100;
            _maxSeconds = [self compulateMaxSecond:countDownTipView.totalEndSeconds];
            
            for (UILabel *l in countDownTipView.subviews) {
                [l removeFromSuperview];
            }
            [countDownTipView setViewType:countDownTipView.viewType disPlay:nil];
        }else{
            for (UILabel *l in countDownTipView.subviews) {
                [l removeFromSuperview];
            }
            
            countDownTipView.hidden = YES;
        }
        
        
    }
    
    if (_allowRun && infos.count > 0 && _maxSeconds > 0) {  //  _allowRun && 有数据 && 有倒计时类型
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        _allowRun = NO;
        
    }

}

- (void)countDown{
    
    [self uPDateDisplay:self.tipView1];
    [self uPDateDisplay:self.tipView2];
    [self uPDateDisplay:self.tipView3];
    [self uPDateDisplay:self.tipView4];
    
    if (_maxSeconds <= 0) {
        [_timer invalidate];
    }
    _maxSeconds --;
}



- (void)uPDateDisplay:(CountDownTimeView *)tipView{
    
    tipView.totalSeconds --;
    tipView.totalEndSeconds --;
    if (tipView.totalSeconds > 0) {
        
        [tipView uPDateDisplayView:tipView seconds:tipView.totalSeconds];
        
    }else if(tipView.totalSeconds == 0){
        
        // 倒计时结束 － 清空子视图，重新设置 label
        for (UILabel *l in tipView.subviews) {
            [l removeFromSuperview];
        }
        tipView.viewType = ActivityStateOn;
        [tipView setViewType:tipView.viewType disPlay:nil];
    }
    
    if (tipView.totalEndSeconds < 0) {
        
        for (UILabel *l in tipView.subviews) {
            [l removeFromSuperview];
        }
        
        tipView.hidden = YES;
    }
    
}

// 最大时间
- (NSInteger)compulateMaxSecond:(NSInteger)sec{
    
    NSInteger tmp = sec > _maxSeconds ? sec : _maxSeconds;
    return tmp;
}

- (void)clickBtn:(UIButton *)btn{

     //NSLog(@" 移民攻略 %ld",btn.tag);
    [[NSNotificationCenter defaultCenter] postNotificationName:HOMEPAGE_RAIDERS_NOTIFICATION object:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
}


- (void)setColor{
    
    self.firstImageView.backgroundColor = [UIColor redColor];
    self.secondImageView.backgroundColor = [UIColor greenColor];
    
    //    self.tipView1.backgroundColor = [UIColor greenColor];
    //    self.tipView2.backgroundColor = [UIColor greenColor];
    //    self.tipView3.backgroundColor = [UIColor greenColor];
    //    self.tipView4.backgroundColor = [UIColor greenColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
