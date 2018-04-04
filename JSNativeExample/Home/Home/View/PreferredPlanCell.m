//
//  PreferredPlanCell.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/26.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "PreferredPlanCell.h"
#import "PreferredPlanModel.h"

#define kDefaultWidth 56.0

@interface PreferredPlanCell()

@property (nonatomic, strong) UIImageView *projectImageV;
@property (nonatomic, strong) UIImageView *tipImageV;
@property (nonatomic, strong) UIImageView *arrowImageV;
@property (nonatomic, strong) UILabel *lookLabel;
@property (nonatomic,assign) CGRect selRect;

@end

@implementation PreferredPlanCell

#pragma mark ----- init

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell{
    
    // 398 + 100 = 498 , 498 / 2.0 = 249.0
    _projectImageV = [[UIImageView alloc] init];
    _tipImageV = [[UIImageView alloc] init];
    _arrowImageV = [[UIImageView alloc] init];
    _lookLabel = [[UILabel alloc] init];
    UIButton *lookAllRlts = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_projectImageV];
    [self addSubview:_tipImageV];
    [self addSubview:_arrowImageV];
    [self addSubview:_lookLabel];
    [self addSubview:lookAllRlts];
    
    _projectImageV.sd_layout
    .topSpaceToView(self, 0.0)
    .leftSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .rightSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .heightIs(199.0 * SCREEN_WIDTHRATE_6);
    
    _tipImageV.sd_layout
    .centerXEqualToView(self)
    .heightIs(71.0 * SCREEN_WIDTHRATE_6)
    .widthIs(71.0 * SCREEN_WIDTHRATE_6)
    //.bottomSpaceToView(_projectImageV, -35.50 * SCREEN_WIDTHRATE_6);
    .bottomSpaceToView(self, 14.5 * SCREEN_WIDTHRATE_6); // 249.0 - 199.0 - (71.0 / 2.0)
    
    _arrowImageV.sd_layout
    .widthIs(6.0 * SCREEN_WIDTHRATE_6)
    .heightIs(12.0 * SCREEN_WIDTHRATE_6)
    .rightSpaceToView(self, 14.0 * SCREEN_WIDTHRATE_6)
    .bottomSpaceToView(self, 23.0 * SCREEN_WIDTHRATE_6);
    
    _lookLabel.sd_layout
    .heightIs(13.0 * SCREEN_WIDTHRATE_6)
    .widthIs(60.0 * SCREEN_WIDTHRATE_6)
    .centerYEqualToView(_arrowImageV)
    .rightSpaceToView(_arrowImageV, 5.0 * SCREEN_WIDTHRATE_6);
    
    lookAllRlts.sd_layout
    .topSpaceToView(_projectImageV, 5.0)
    .bottomSpaceToView(self, 5.0)
    .leftEqualToView(_lookLabel)
    .rightEqualToView(self);
    
    _lookLabel.text = @"查看全部";
    _lookLabel.font = [UIFont boldSystemFontOfSize:FONT_UI26PX];
    _lookLabel.textAlignment = NSTextAlignmentRight;
    _lookLabel.textColor = [UIColor DDNavBarBlue];
    _arrowImageV.image = [UIImage imageNamed:@"blue_arrow"];
    _tipImageV.image = [UIImage imageNamed:@"home_look_detail"];
    _projectImageV.layer.cornerRadius = RRADIUS_LAYERCORNE;
    _projectImageV.contentMode = UIViewContentModeScaleAspectFill;
    _projectImageV.clipsToBounds = TRUE;
    [lookAllRlts addTarget:self action:@selector(clickEventBtn:) forControlEvents:UIControlEventTouchUpInside];
    
//    _projectImageV.backgroundColor = [UIColor greenColor];
//    _tipImageV.backgroundColor = [UIColor redColor];
//    _arrowImageV.backgroundColor = [UIColor cyanColor];
//    _lookLabel.backgroundColor = [UIColor yellowColor];
//    lookAllRlts.backgroundColor = [UIColor greenColor];
//    self.backgroundColor = [UIColor cyanColor];
    
}

#pragma mark ----- 按钮点击事件

- (void)clickEventBtn:(UIButton *)btn{
    if(_delegate && [_delegate respondsToSelector:@selector(clickEventLookAllRlts:)]){
        [_delegate clickEventLookAllRlts:btn];
    }
}

#pragma mark ----- 数据回调刷新

- (void)setUpItemCellWithModel:(id)model{
    if (model) {
        PreferredPlanModel *f = (PreferredPlanModel *)model;
        [_projectImageV sd_setImageWithURL:[NSURL URLWithString:f.app_img]];
    }
}

- (NSMutableAttributedString *)returnAttStringWithThem:(NSString *)themTitle des:(NSString *)des{
    NSString *flag = @":";
    NSString *str = [NSString stringWithFormat:@"%@%@%@",themTitle,flag,des];
    NSMutableAttributedString *rltString = [[NSMutableAttributedString alloc] initWithString:str];
    [rltString addAttribute:NSForegroundColorAttributeName
                      value:[UIColor colorWithRed:179.0/255.0 green:119.0/255.0 blue:0 alpha:1.0]
                      range:NSMakeRange(0, themTitle.length+1)];
    [rltString addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:@"Helvetica-Bold" size:FONT_UI22PX]
                      range:NSMakeRange(0, themTitle.length+1)];
    
    NSRange flagRange = [str rangeOfString:flag];
    NSRange xRange = NSMakeRange(flagRange.location+1, des.length);
    [rltString addAttribute:NSForegroundColorAttributeName
                      value:[UIColor colorWithRed:179.0/255.0 green:119.0/255.0 blue:0 alpha:1.0]
                      range:xRange];
    [rltString addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:FONT_UI22PX]
                      range:xRange];
    
    return rltString;
}

- (void)modifyConstraintWithText:(NSString *)txt{
    
//    CGFloat tmpMax = _lookLabel.frame.origin.x - 10.0 * SCREEN_WIDTHRATE_6 - _desLabel.frame.origin.x;
//    CGFloat max_width = tmpMax > 0 ? tmpMax : 0.0;
//    CGRect rect = [txt boundingRectWithSize:CGSizeMake(max_width, 20000)
//                                    options:NSStringDrawingUsesLineFragmentOrigin
//                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_UI22PX]}
//                                    context:nil];
//    CGFloat real_width = rect.size.width + 3.0;
//    CGFloat tmpWidth = max_width > real_width ? real_width : max_width;
    //NSLog(@" modifyConstraintWithText - tmpWidth :%f - real_width :%f - max_width:%f ",tmpWidth,real_width,max_width);
//    if (tmpWidth > 0) {
    
        //NSLog(@" _desLabel 1================> %@ ",_desLabel);
//        CGRect tmpRect = _desLabel.frame;
//        tmpRect.size.width = tmpWidth;
//        [_desLabel setFrame:tmpRect];
        //NSLog(@" _desLabel 2================> %@ ",_desLabel);
        
//    }
    
}

#pragma mark ----- 点击交互

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
