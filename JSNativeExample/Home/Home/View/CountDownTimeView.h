//
//  CountDownTimeView.h
//  hinabian
//
//  Created by hnbwyh on 16/5/26.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

typedef enum : NSUInteger {
    CountDownTimer = 1,
    ActivityStateStart,
    ActivityStateOn,
    ActivityStateEnd,
} TipViewType;

#import <UIKit/UIKit.h>

@interface CountDownTimeView : UIView

@property (nonatomic) TipViewType viewType;
@property (nonatomic) NSInteger totalSeconds;
@property (nonatomic) NSInteger totalEndSeconds;

@property (nonatomic,strong) UILabel *timeTitle;
@property (nonatomic,strong) UILabel *hour;
@property (nonatomic,strong) UILabel *hm_gapFlag;
@property (nonatomic,strong) UILabel *min;
@property (nonatomic,strong) UILabel *ms_gapFlag;
@property (nonatomic,strong) UILabel *second;

- (void)setViewType:(TipViewType)type disPlay:(NSDictionary *)info;

- (void)uPDateDisplayView:(CountDownTimeView *)tipView seconds:(NSInteger)sec;

- (void)uPDateDisplayActivityState:(TipViewType)type;

@end
