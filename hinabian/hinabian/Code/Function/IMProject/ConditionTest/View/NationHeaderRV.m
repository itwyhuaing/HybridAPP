//
//  NationHeaderRV.m
//  hinabian
//
//  Created by hnbwyh on 17/6/9.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "NationHeaderRV.h"

@interface NationHeaderRV ()

@property (nonatomic,strong) UILabel *msgLabel;
@property (nonatomic,strong) UIImageView *imgV;
//@property (nonatomic,strong) UILabel *areaLabel;

@end

@implementation NationHeaderRV

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat widthRadio = [UIScreen mainScreen].bounds.size.width/350.0;
        CGRect rect = CGRectZero;
        rect.size = CGSizeMake(110.0 * widthRadio, 45.0 * widthRadio);
        rect.origin = CGPointMake((frame.size.width - rect.size.width)/2.0, (frame.size.height - rect.size.height)/2.0);
        _imgV = [[UIImageView alloc] initWithFrame:rect];
        [self addSubview:_imgV];
        [self addSubview:self.msgLabel];
    }
    return self;
}

-(void)configNationHeaderRVContentsWithAreaName:(NSString *)areaName{

    //_areaLabel.text = areaName;
    NSString *imgName = @"";
    if ([areaName rangeOfString:@"美洲"].location != NSNotFound) {
        imgName = @"ConditionTest_area_mz";
    }else if ([areaName rangeOfString:@"欧洲"].location != NSNotFound){
        imgName = @"ConditionTest_area_oz";
    }else if ([areaName rangeOfString:@"大洋洲"].location != NSNotFound){
        imgName = @"ConditionTest_area_dyz";
    }else{
        imgName = @"ConditionTest_area_yaz";
    }
    _imgV.image = [UIImage imageNamed:imgName];
    
}

- (void)setTitleLabelHide:(BOOL)isHiden //是否隐藏标题
{
    CGFloat widthRadio = [UIScreen mainScreen].bounds.size.width/350.0;
    CGRect rect = CGRectZero;
    rect.size = CGSizeMake(115.0 * widthRadio, 45.0 * widthRadio);
    
    if (isHiden) {
        rect.origin = CGPointMake((self.frame.size.width - rect.size.width)/2.0, (self.frame.size.height - rect.size.height)/2.0);
    }else{
        rect.origin = CGPointMake((self.frame.size.width - rect.size.width)/2.0, (self.frame.size.height - rect.size.height)/2.0 + CGRectGetMaxY(self.msgLabel.frame));
    }
    [_imgV setFrame:rect];
    
    self.msgLabel.hidden = isHiden;
}

-(UILabel *)msgLabel{
    
    if (_msgLabel == nil) {
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 15.0)];
        _msgLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        _msgLabel.font = [UIFont systemFontOfSize:FONT_UI32PX];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.text = @"想去哪个国家？";
    }
    return _msgLabel;
    
}

@end
