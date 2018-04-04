//
//  OverSeaClassViewCell.m
//  hinabian
//
//  Created by 何松泽 on 2018/1/9.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "OverSeaClassViewCell.h"
#import "OverSeaClassModel.h"

@interface OverSeaClassViewCell()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UIView *describeView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *headLabel;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UIButton *lookAllContentBtn;

@end

@implementation OverSeaClassViewCell

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
    _imageV = [[UIImageView alloc] init];
    _describeView = [[UIView alloc] init];
    _titleLabel = [[UILabel alloc] init];
    _headLabel = [[UILabel alloc] init];
    _describeLabel = [[UILabel alloc] init];
    _lookAllContentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self addSubview:_imageV];
    [self addSubview:_titleLabel];
    [self addSubview:_describeView];
    [_describeView addSubview:_headLabel];
    [_describeView addSubview:_describeLabel];
    [_describeView addSubview:_lookAllContentBtn];
    
    _imageV.sd_layout
    .leftSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .rightSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(self, 0)
    .heightIs(150.0 * SCREEN_WIDTHRATE_6);
    
    _titleLabel.sd_layout
    .leftSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .rightSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(_imageV, 10)
    .heightIs(40);
    
    _describeView.sd_layout
    .leftSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .rightSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(_titleLabel, 10)
    .heightIs(120.0);
    
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
    
    
    //test
//    _titleLabel.backgroundColor = [UIColor orangeColor];
//    _describeLabel.backgroundColor = [UIColor blueColor];
//    _lookAllContentBtn.backgroundColor = [UIColor purpleColor];
//    [_imageV setImage:[UIImage imageNamed:@"loading_image"]];
//    _describeLabel.text = @"1、大雄做时光机回到过去改变历史让特朗普落选了；\n2、大雄又回到过去自己当了总统;\n3、大雄又回到过去放弃当总统;\n4、大雄又回到过去让特朗普当了总统;";
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
    if (_delegate && [_delegate respondsToSelector:@selector(lookClassess)]) {
        [_delegate lookClassess];
    }
}

- (void)setCellModel:(OverSeaClassModel *)model
{
    if (model) {
        [_imageV sd_setImageWithURL:[NSURL URLWithString: model.img]];
        //设置行间距
        [_titleLabel setAttributedText:[self setContent:model.title]];
        _describeLabel.text = model.summary;
//        _titleLabel.text = model.title;
    }
}

@end
