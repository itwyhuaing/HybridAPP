//
//  ListLatestNewsCell.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/30.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "ListLatestNewsCell.h"
#import "VerticalAligmentLabel.h"
#import "LatestNewsModel.h"

@interface ListLatestNewsCell ()

@property (nonatomic,strong) UILabel *formated_day;
@property (nonatomic,strong) UILabel *formated_time;
@property (nonatomic,strong) VerticalAligmentLabel *title;
@property (nonatomic,strong) UILabel *verLine;
@property (nonatomic,strong) UILabel *horiLine;

@end

@implementation ListLatestNewsCell

#pragma mark ----- init

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell{
    
    _formated_day = [[UILabel alloc] init];
    _formated_time = [[UILabel alloc] init];
    _title = [[VerticalAligmentLabel alloc] init];
    _verLine = [[UILabel alloc] init];
    _horiLine = [[UILabel alloc] init];
    [self addSubview:_formated_day];
    [self addSubview:_formated_time];
    [self addSubview:_title];
    [self addSubview:_verLine];
    [self addSubview:_horiLine];

    _formated_day.sd_layout
    .topSpaceToView(self, 17.0 * SCREEN_WIDTHRATE_6)
    .leftSpaceToView(self, 0)
    .widthIs(75.0 * SCREEN_WIDTHRATE_6)
    .heightIs(21.0 * SCREEN_WIDTHRATE_6);

    _formated_time.sd_layout
    .topSpaceToView(_formated_day, 0)
    .leftEqualToView(_formated_day)
    .widthRatioToView(_formated_day, 1.0)
    .heightIs(30.0 / 2.0 * SCREEN_WIDTHRATE_6);

    _verLine.sd_layout
    .widthIs(1.0)
    .heightIs(44.0 / 2.0 * SCREEN_WIDTHRATE_6)
    .leftSpaceToView(_formated_day, 0)
    .centerYEqualToView(self);

    _horiLine.sd_layout
    .heightIs(1.0)
    .leftSpaceToView(_verLine, 5.0)
    .rightSpaceToView(self, 0)
    .bottomSpaceToView(self, 0);

    _title.sd_layout
    .leftSpaceToView(_verLine, 20.0 * SCREEN_WIDTHRATE_6)
    .rightSpaceToView(self, 45.0 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(self, 0)
    .bottomSpaceToView(_horiLine, 0);

    _formated_day.textColor = [UIColor colorWithRed:63.0/255.0 green:162.0/255.0 blue:255.0/255.0 alpha:1.0];
    _formated_day.textAlignment = NSTextAlignmentCenter;
    _formated_day.font = [UIFont systemFontOfSize:FONT_UI34PX];
    _formated_time.textColor = [UIColor DDR102_G102_B102ColorWithalph:1.0];
    _formated_time.textAlignment = NSTextAlignmentCenter;
    _formated_time.font = [UIFont systemFontOfSize:FONT_UI24PX];
    _title.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.0];
    _title.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_UI30PX];//[UIFont systemFontOfSize:FONT_UI30PX];
    _title.verticalAlignment = VerticalAlignmentMiddle;
    _title.numberOfLines = 0;
    // 行间距设置
    
    
    
    
//    _formated_day.backgroundColor = [UIColor redColor];
//    _formated_time.backgroundColor = [UIColor greenColor];
    _verLine.backgroundColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor];
    _horiLine.backgroundColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor];
//    _title.backgroundColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor];
    
    
}

#pragma mark ----- 数据回调刷新

- (void)setModel:(id)model{
    if (model) {
        LatestNewsModel *f = (LatestNewsModel *)model;
        _formated_day.text = f.formated_day;
        _formated_time.text = f.formated_time;
        //_title.backgroundColor = [UIColor redColor];
        [_title setAttributedText:[self modifyLineSpaceWithContent:f.title]];
    }
}

- (NSAttributedString *)modifyLineSpaceWithContent:(NSString *)cnt{
    NSMutableAttributedString *mutableAttribetedString = [[NSMutableAttributedString alloc] initWithString:cnt];
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
    [para setLineSpacing:5.f];
    [mutableAttribetedString addAttribute:NSParagraphStyleAttributeName
                                    value:para
                                    range:NSMakeRange(0, cnt.length)];
    return mutableAttribetedString;
}

#pragma mark ----- 点击交互

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)test{}

@end
