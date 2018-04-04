//
//  SingleProjVisaView.m
//  hinabian
//
//  Created by 何松泽 on 2017/8/21.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "SingleProjVisaView.h"
#import "IMHomeProjModel.h"
#import "IMHomeVisaModel.h"

#define CHARGE_UNIT @"元"
#define CHARGE_TEN_THOUSANDS_UNIT @"万"

@interface SingleProjVisaView () {
    BottomCellView *_firstView;
    BottomCellView *_secondView;
    BottomCellView *_thirdView;
    BottomCellView *_fourthView;
    
    float imageHeight;
}

@property (nonatomic, strong) UIImageView   *projImageView;

@property (nonatomic, strong) UIView        *bottomView;

@property (nonatomic, strong) UILabel       *tagLabel;

@property (nonatomic, strong) UIImageView   *tagImageView;

@end

@implementation SingleProjVisaView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
//        self.layer.borderWidth = 0.5f;
//        self.layer.borderColor = [UIColor DDR102_G102_B102ColorWithalph:0.3f].CGColor;
        self.layer.cornerRadius = 6.f;
        self.clipsToBounds = NO;
        self.layer.masksToBounds = YES;
        
        imageHeight = 160 * SCREEN_SCALE;
        
        [self setImageView];
        [self addBottomView];
    }
    return self;
}

- (void)setImageView {
    CGRect rect = self.bounds;
    rect.origin.x = 0.f;
    rect.size.width = self.bounds.size.width;
    rect.size.height = imageHeight;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [self addSubview:imageView];
    _projImageView = imageView;
    
    rect.origin.x = 0.f;
    rect.origin.y = 20.f;
    rect.size.height = 25.f;
    rect.size.width = 80.f;
    UIImageView *tagImageView = [[UIImageView alloc] initWithFrame:rect];
    [tagImageView setImage:[UIImage imageNamed:@"im_proj_tag"]];
    [self addSubview:tagImageView];
    _tagImageView = tagImageView;
    
    rect.origin.y = 0.f;
    rect.size.width = 70.f;
    UILabel *tagLabel = [[UILabel alloc] initWithFrame:rect];
    tagLabel.textColor = [UIColor whiteColor];
    tagLabel.font = [UIFont systemFontOfSize:FONT_UI24PX];
    tagLabel.textAlignment = NSTextAlignmentCenter;
//    tagLabel.text = @"投资移民";
    [_tagImageView addSubview:tagLabel];
    _tagLabel = tagLabel;
}

- (void)addBottomView {
    
    BOOL isFourItems = YES;
    
    if (isFourItems) {
        
    }
    _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_bottomView];
    
    _bottomView.sd_layout
    .topSpaceToView(_projImageView,0)
    .leftSpaceToView(self,0)
    .heightIs(self.bounds.size.height - imageHeight)
    .widthRatioToView(self,1.f);
    
    //增加阴影
    CALayer *layer=[[CALayer alloc]init];
    float shadowsWidth = 3.f;
    [layer setFrame:CGRectMake(2, imageHeight - shadowsWidth, self.bounds.size.width - 4, self.bounds.size.height - imageHeight)];
    layer.cornerRadius=self.layer.cornerRadius;
    layer.backgroundColor=[UIColor whiteColor].CGColor;//这里必须设置layer层的背景颜色，默认应该是透明的，导致设置的阴影颜色无法显示出来
    layer.shadowColor=[UIColor DDR102_G102_B102ColorWithalph:0.3f].CGColor;//设置阴影的颜色
    layer.shadowRadius=shadowsWidth;//设置阴影的宽度
    layer.shadowOffset=CGSizeMake(0, shadowsWidth);//设置偏移
    layer.shadowOpacity=0.6;
    [self.layer addSublayer:layer];
    [self bringSubviewToFront:_projImageView];
    [self bringSubviewToFront:_bottomView];
    [self bringSubviewToFront:_tagImageView];
    [self bringSubviewToFront:_tagLabel];
    
    
    float cellWidth = self.frame.size.width;
    
    CGRect rect = CGRectMake(0, 0, cellWidth/4, self.bounds.size.height - imageHeight);
    rect.size.width = self.bounds.size.width/4;
    _firstView = [[BottomCellView alloc] initWithFrame:rect];
    [_bottomView addSubview:_firstView];
    
    rect.origin.x = cellWidth/4;
    _secondView = [[BottomCellView alloc] initWithFrame:rect];
    [_bottomView addSubview:_secondView];
    
    rect.origin.x = cellWidth *2/4;
    _thirdView = [[BottomCellView alloc] initWithFrame:rect];
    [_bottomView addSubview:_thirdView];
    
    rect.origin.x = cellWidth *3/4;
    _fourthView = [[BottomCellView alloc] initWithFrame:rect];
    _fourthView.hidden = YES;
    [_bottomView addSubview:_fourthView];
}

- (void)setProjModel:(IMHomeProjModel *)model {
    IMHomeProjModel *f = model;
    if (f) {
        if (f.type_cn && ![f.type_cn isEqualToString:@""]) {
            _tagLabel.text = f.type_cn;
        } else {
            _tagImageView.hidden = YES;
        }
        [_projImageView sd_setImageWithURL:[NSURL URLWithString:f.img_url]];
        [_firstView setValueString:f.time unitString:f.time_unit originValueString:@"" titleString:@"办理周期"];
        [_secondView setValueString:f.sum unitString:f.sum_unit originValueString:@"" titleString:@"投资额度"];
        [_thirdView setValueString:f.visa_type_cn unitString:@"" originValueString:@"" titleString:@"身份类型"];
        [_fourthView setValueString:f.service_charge unitString:CHARGE_UNIT originValueString:f.service_original titleString:@"服务费"];
        
        _fourthView.line.hidden = YES;
        _fourthView.hidden = NO;
    }
}

- (void)setVisaModel:(IMHomeVisaModel *)model {
    IMHomeVisaModel *f = model;
    if (f) {
        [_projImageView sd_setImageWithURL:[NSURL URLWithString:f.img_url]];
        
        float cellWidth = self.frame.size.width;
        CGRect rect = CGRectMake(0, 0, cellWidth/3, self.bounds.size.height - imageHeight);
        
        rect.size.width = self.bounds.size.width/3;
        [_firstView setFrame:rect];
        
        rect.origin.x = cellWidth/3;
        [_secondView setFrame:rect];
        
        rect.origin.x = cellWidth *2/3;
        [_thirdView setFrame:rect];
        
        [_firstView setValueString:f.time unitString:f.time_unit originValueString:@"" titleString:@"办理周期"];
        [_secondView setValueString:f.interview unitString:@"" originValueString:@"" titleString:@"面试要求"];
        [_thirdView setValueString:f.all_charge unitString:@"元" originValueString:f.service_original titleString:@"办理费"];
        
        _thirdView.line.hidden = YES;
        _tagImageView.hidden = YES;
        _fourthView.hidden = YES;
    }
    
}


@end


@implementation BottomCellView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.layer.borderColor = [UIColor DDR102_G102_B102ColorWithalph:0.3f].CGColor;
        _line.layer.borderWidth = 0.25f;
        [self addSubview:_line];
        
    }
    return self;
}

- (void)setValueString:(NSString *)valueString
            unitString:(NSString *)unitString
     originValueString:(NSString *)originValueString
           titleString:(NSString *)titleString {
    UIFont *valueFont = SCREEN_WIDTH > SCREEN_WIDTH_6 ? [UIFont boldSystemFontOfSize:21.f] : [UIFont boldSystemFontOfSize:FONT_UI34PX];
    UIFont *labFont  = SCREEN_WIDTH > SCREEN_WIDTH_6 ? [UIFont boldSystemFontOfSize:FONT_UI28PX] : [UIFont boldSystemFontOfSize:FONT_UI24PX];
    UIFont *unitFont  = SCREEN_WIDTH > SCREEN_WIDTH_6 ? [UIFont boldSystemFontOfSize:FONT_UI28PX] : [UIFont boldSystemFontOfSize:FONT_UI24PX];
    UIFont *titleFont = SCREEN_WIDTH > SCREEN_WIDTH_6 ? [UIFont systemFontOfSize:FONT_UI24PX] : [UIFont systemFontOfSize:FONT_UI22PX];
    
    if (!valueString) {
        valueString = @"";
    }
    if (!unitString) {
        unitString = @"";
    }
    if (!originValueString) {
        originValueString = @"";
    }
    if (!titleString) {
        titleString = @"";
    }
    
    //判断现价
    NSString *service_charge = valueString;
    NSString *labUnit = @"";
    NSString *service_unit = unitString;
    if ([unitString isEqualToString:CHARGE_UNIT]) {//判断是否为价钱
        labUnit = @"¥";
        /*大于10000元的转化单位*/
        if ([service_charge floatValue] > 10000) {
            service_charge = [self numChange:service_charge];
            service_unit = CHARGE_TEN_THOUSANDS_UNIT;
        }else {
            service_unit = @"";
        }
    }
    
    NSMutableAttributedString *labPart = [[NSMutableAttributedString alloc] initWithString:labUnit];
    NSDictionary * labAttributes = @{ NSFontAttributeName:labFont,NSForegroundColorAttributeName:[UIColor colorWithRed:237/255.0f green:87/255.0f blue:87/255.0f alpha:1.0]};
    [labPart setAttributes:labAttributes range:NSMakeRange(0, labPart.length)];
    
    NSMutableAttributedString *firstPart = [[NSMutableAttributedString alloc] initWithString:service_charge];
    NSDictionary * firstAttributes = @{ NSFontAttributeName:valueFont,NSForegroundColorAttributeName:[UIColor colorWithRed:237/255.0f green:87/255.0f blue:87/255.0f alpha:1.0]};
    [firstPart setAttributes:firstAttributes range:NSMakeRange(0,firstPart.length)];
    [labPart appendAttributedString:firstPart];
    
    NSMutableAttributedString *secondPart = [[NSMutableAttributedString alloc] initWithString:service_unit];
    NSDictionary * secondAttributes = @{NSFontAttributeName:unitFont,NSForegroundColorAttributeName:[UIColor colorWithRed:68/255.0f green:68/255.0f blue:68/255.0f alpha:1.0]};
    [secondPart setAttributes:secondAttributes range:NSMakeRange(0,secondPart.length)];
    [labPart appendAttributedString:secondPart];
   
    self.valueLabel.attributedText = labPart;
    self.titleLabel.text = titleString;
    self.titleLabel.font = titleFont;
    
    //判断原价
    NSString *service_original = originValueString;
    if ([unitString isEqualToString:CHARGE_UNIT]) {//判断是否为价钱
        if ([originValueString floatValue] > 10000) {
            service_original = [NSString stringWithFormat:@"¥%@",[self numChange:originValueString]];
            service_unit = CHARGE_TEN_THOUSANDS_UNIT;
        }else{
            service_original = [NSString stringWithFormat:@"¥%@",service_original];
            service_unit = CHARGE_UNIT;
        }
    }
    
    NSString *originALL = [service_original stringByAppendingString:service_unit];
    NSMutableAttributedString *originStr = [[NSMutableAttributedString alloc]initWithString:originALL];
    [originStr addAttributes:@{
                               NSFontAttributeName:unitFont,
                               NSForegroundColorAttributeName:[UIColor DDCouponTextGray],
                               NSStrikethroughStyleAttributeName:@(NSUnderlineStyleThick),
                               NSForegroundColorAttributeName:
                                   [UIColor DDCouponTextGray],
                               NSBaselineOffsetAttributeName:
                                   @(0),
                               NSFontAttributeName: titleFont
                               } range:NSMakeRange(0, [originALL length])];
    self.originalLabel.attributedText = originStr;
    
    if (![originValueString isEqualToString:@""] && ![originValueString isEqualToString:@"0"]) {
        
        self.valueLabel.sd_layout
        .topSpaceToView(self,GAP_S)
        .leftSpaceToView(self,0)
        .heightIs(21.f*SCREEN_SCALE)
        .widthIs(self.frame.size.width);
        
        self.originalLabel.hidden = NO;
        
        self.originalLabel.sd_layout
        .topSpaceToView(self.valueLabel,0)
        .leftSpaceToView(self,0)
        .heightIs(18.f*SCREEN_SCALE)
        .widthIs(self.frame.size.width);
        
        self.titleLabel.sd_layout
        .topSpaceToView(self.originalLabel,0)
        .leftSpaceToView(self,0)
        .heightIs(18.f*SCREEN_SCALE)
        .widthIs(self.frame.size.width);
        
        self.line.sd_layout
        .topSpaceToView(self,GAP_S * 3*SCREEN_SCALE)
        .leftSpaceToView(self,self.frame.size.width - 1.f)
        .heightIs(self.frame.size.height - GAP_S * 3 * 2*SCREEN_SCALE)
        .widthIs(1.f);
    } else{
        self.valueLabel.sd_layout
        .topSpaceToView(self,GAP_S*1.8*SCREEN_SCALE)
        .leftSpaceToView(self,0)
        .heightIs(21.f*SCREEN_SCALE)
        .widthIs(self.frame.size.width);
        
        self.originalLabel.sd_layout
        .topSpaceToView(self.valueLabel,0)
        .leftSpaceToView(self,0)
        .heightIs(0)
        .widthIs(self.frame.size.width);
        self.originalLabel.hidden = YES;
        
        self.titleLabel.sd_layout
        .topSpaceToView(self.valueLabel, + 3*SCREEN_SCALE)
        .leftSpaceToView(self,0)
        .heightIs(18.f*SCREEN_SCALE)
        .widthIs(self.frame.size.width);
        
        self.line.sd_layout
        .topSpaceToView(self,GAP_S * 3*SCREEN_SCALE)
        .leftSpaceToView(self,self.frame.size.width - 1.f)
        .heightIs(self.frame.size.height - GAP_S * 3 * 2*SCREEN_SCALE)
        .widthIs(1.f);
        
        
    }
    
}

#pragma mark ==== Lazy Load

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_valueLabel];
    }
    return _valueLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setTextColor:[UIColor colorWithRed:58/255.0f green:58/255.0f blue:58/255.0f alpha:1.0]];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)originalLabel {
    if (!_originalLabel) {
        _originalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _originalLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_originalLabel];
    }
    return _originalLabel;
}

- (NSString *)numChange:(NSString *) num
{
    NSString * tmpString;
    float num_float = [num floatValue];
    if (num_float > 9999)    //五位数转换
    {
        float a = num_float / 10000.0;
        if (([num integerValue] % 10000) < 1000)  //能被整除
        {
            tmpString = [NSString stringWithFormat:@"%0.f",a];
        }
        else
        {
            tmpString = [NSString stringWithFormat:@"%0.1f",a];
        }
        
    }
    else
    {
        tmpString = num;
    }
    
    return tmpString;
}

@end





