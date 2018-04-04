//
//  HNBClassesCell.m
//  hinabian
//
//  Created by 何松泽 on 2018/1/30.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "HNBClassesCell.h"
#import "OverSeaClassModel.h"

@interface HNBClassesCell()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *describeView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *headLabel;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UIButton *lookAllContentBtn;
@property (nonatomic, strong) OverSeaClassModel *currentModel;

@end

@implementation HNBClassesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell
{
    _backView = [[UIView alloc] init];
    _imageV = [[UIImageView alloc] init];
    _describeView = [[UIView alloc] init];
    _titleLabel = [[UILabel alloc] init];
    _headLabel = [[UILabel alloc] init];
    _describeLabel = [[UILabel alloc] init];
    _lookAllContentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self addSubview:_backView];
    [_backView addSubview:_imageV];
    [_backView addSubview:_titleLabel];
    [_backView addSubview:_describeView];
    [_describeView addSubview:_headLabel];
    [_describeView addSubview:_describeLabel];
    [_describeView addSubview:_lookAllContentBtn];
    
    _backView.sd_layout
    .leftSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .rightSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(self, 20)
    .heightIs(150.0 * SCREEN_WIDTHRATE_6 + 195);
    
    _imageV.sd_layout
    .leftSpaceToView(_backView, 10.0 * SCREEN_WIDTHRATE_6)
    .rightSpaceToView(_backView, 10.0 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(_backView, 10)
    .heightIs(150.0 * SCREEN_WIDTHRATE_6);
    
    _titleLabel.sd_layout
    .leftSpaceToView(_backView, 10.0 * SCREEN_WIDTHRATE_6)
    .rightSpaceToView(_backView, 10.0 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(_imageV, 10)
    .heightIs(40);
    
    _describeView.sd_layout
    .leftSpaceToView(_backView, 10.0 * SCREEN_WIDTHRATE_6)
    .rightSpaceToView(_backView, 10.0 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(_titleLabel, 10)
    .heightIs(110.0);
    
    _headLabel.sd_layout
    .leftSpaceToView(_describeView, 10.0 * SCREEN_WIDTHRATE_6)
    .rightSpaceToView(_describeView, 10.0 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(_describeView, 7.f)
    .heightIs(15.f);
    
    _describeLabel.sd_layout
    .leftSpaceToView(_describeView, 10.0 * SCREEN_WIDTHRATE_6)
    .rightSpaceToView(_describeView, 10.0 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(_headLabel, 0.f)
    .heightIs(60.f);
    
    _lookAllContentBtn.sd_layout
    .centerXEqualToView(_describeView)
    .topSpaceToView(_describeLabel, 0.f)
    .widthIs(200.f)
    .heightIs(30.f);
    
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _imageV.clipsToBounds = YES;
    _imageV.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0 * SCREEN_WIDTHRATE_6;
    
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.clipsToBounds = YES;
    _backView.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0 * SCREEN_WIDTHRATE_6;
    
    _headLabel.font = [UIFont systemFontOfSize:FONT_UI24PX];
    _headLabel.textColor = [UIColor DDR253_G187_B56Withalph:0.8f];
    _headLabel.text = @"本期看点：";
    _headLabel.numberOfLines = 2;
    
    _titleLabel.font = [UIFont systemFontOfSize:FONT_UI28PX];
    _titleLabel.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.f];
    _titleLabel.numberOfLines = 2;
    
    _describeLabel.font = [UIFont systemFontOfSize:FONT_UI24PX];
    _describeLabel.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.f];
    _describeLabel.numberOfLines = 4;
    
    _describeView.backgroundColor = [UIColor DDR253_G187_B56Withalph:0.1f];
    _describeView.clipsToBounds = YES;
    _describeView.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0 * SCREEN_WIDTHRATE_6;

    [_lookAllContentBtn setTitle:@"查看本期海外课堂，收听详情" forState:UIControlStateNormal];
    [_lookAllContentBtn.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI24PX]];
    [_lookAllContentBtn setTitleColor:[UIColor colorWithRed:63.f/255.f green:162.f/255.f blue:255.f/255.f alpha:1.f] forState:UIControlStateNormal];
    [_lookAllContentBtn addTarget:self action:@selector(clickLookAllContentBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 设置行间距
- (NSMutableAttributedString *)setContent:(NSString *)content
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5]; //设置行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    
    return attributedString;
}

- (void)clickLookAllContentBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(lookClassess:)]) {
        [_delegate lookClassess:_currentModel];
    }
}

- (void)setCellModel:(OverSeaClassModel *)model
{
    if (model) {
        [_imageV sd_setImageWithURL:[NSURL URLWithString: model.img]];
        //设置行间距
        [_titleLabel setAttributedText:[self setContent:model.title]];
        _describeLabel.text = model.summary;
        _currentModel = model;
    }
}

@end

