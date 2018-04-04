//
//  FunctionCellItem.m
//  LXYHOCFunctionsDemo
//
//  Created by hnbwyh on 17/5/27.
//  Copyright © 2017年 lachesismh. All rights reserved.
//

#import "FunctionCellItem.h"
#import "IndexFunctionStatus.h"
#import "FunctionModel.h"
#import "ShowAllServicesModel.h"

#define IMGV_SIZE_WIDTH 45.0 // 35.0
#define IMGV_TOP_GAP 27.0 //16.0
#define TITLE_TOP_GAP 10.0
#define TITLE_LABEL_HEIGHT 13.0 // 15.0 //11.0

@interface FunctionCellItem ()

@property (nonatomic,assign) CGFloat ratio;

@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *titleLabel;

@end


@implementation FunctionCellItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect rect = CGRectMake((frame.size.width - IMGV_SIZE_WIDTH * self.ratio)/2.0,
                                 IMGV_TOP_GAP * self.ratio,
                                 IMGV_SIZE_WIDTH * self.ratio,
                                 IMGV_SIZE_WIDTH * self.ratio);
        _imgV = [[UIImageView alloc] initWithFrame:rect];
        rect = CGRectMake(0,
                          CGRectGetMaxY(_imgV.frame) + TITLE_TOP_GAP * self.ratio,
                          frame.size.width,
                          TITLE_LABEL_HEIGHT * self.ratio);
        _titleLabel = [[UILabel alloc] initWithFrame:rect];
        rect.size.width = 22.0 * self.ratio;
        rect.size.height = 12.0 * self.ratio;
        rect.origin.x = CGRectGetMaxX(_imgV.frame) - rect.size.width/2.0;
        rect.origin.y = CGRectGetMinY(_imgV.frame) - 2.0 * self.ratio;
        _tipLabel = [[UILabel alloc] initWithFrame:rect];
        
        [self addSubview:_imgV];
        [self addSubview:_titleLabel];
//        [self addSubview:_tipLabel];
        
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:FONT_UI24PX];
        [_titleLabel setTextColor:[UIColor colorWithRed:51.0/255.0f green:51.0/255.0f blue:51.0/255.0f alpha:1]];
        
        _tipLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_UI18PX];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.layer.cornerRadius = 6.0 * _ratio;
        _tipLabel.clipsToBounds = YES;
        _tipLabel.hidden = YES;
        _tipLabel.backgroundColor = [UIColor clearColor];
        
        
//        _tipLabel.backgroundColor = [UIColor redColor];
//        _imgV.backgroundColor = [UIColor greenColor];
//        _titleLabel.backgroundColor = [UIColor yellowColor];
//        self.backgroundColor = [UIColor purpleColor];
        
    }
    return self;
}

-(void)configContentsWithDataModel:(id)f{
    
    IndexFunctionStatus *tmpF = (IndexFunctionStatus *)f;
    _titleLabel.text = tmpF.title;
    [_imgV sd_setImageWithURL:[NSURL URLWithString:tmpF.pic]];
    if ([tmpF.isShowTip isEqualToString:@"1"]) {
        _tipLabel.hidden = NO;
        _tipLabel.text = tmpF.tipText;
        _tipLabel.backgroundColor = [UIColor colorFromHexString:tmpF.tipBgColor];
    }else{
        _tipLabel.hidden = YES;
        _tipLabel.text = @"";
    }
}

- (void)setUpAllServiceCell {
    
    _titleLabel.text = [NSString stringWithFormat:@"全部"];
    [_imgV setImage:[UIImage imageNamed:@"home_all_icon"]];
}

- (void)setUpItemCellWithModel:(id)model{
    if (model) {
        //<3.2
//        FunctionModel *f = (FunctionModel *)model;
//        _titleLabel.text = f.title;
//        [_imgV sd_setImageWithURL:[NSURL URLWithString:f.pic]];
        
        //3.2
        ShowAllServicesModel *f = (ShowAllServicesModel *)model;
        _titleLabel.text = f.name;
        [_imgV sd_setImageWithURL:[NSURL URLWithString:f.img]];
    }
}


-(CGFloat)ratio{
    if (_ratio <= 0) {
        // 不同尺寸 ， 取小数点后两位
        //NSString *tmpRatioString = [NSString stringWithFormat:@"%lf",[UIScreen mainScreen].bounds.size.width/320.0];
        NSString *tmpRatioString = [NSString stringWithFormat:@"%lf",[UIScreen mainScreen].bounds.size.width/375.0]; // V3.2
        NSInteger tmpLen = tmpRatioString.length >= 4 ? 4 : tmpRatioString.length;
        NSString *tmpRatio = [tmpRatioString substringWithRange:NSMakeRange(0, tmpLen)];
        _ratio = [tmpRatio floatValue];
//        NSLog(@"最终 _ratio %f",_ratio);
    }
    return _ratio;
}

@end
