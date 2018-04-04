//
//  ListSpecialCell.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/30.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "ListSpecialCell.h"
#import "RcmdSpecialModel.h"

@interface ListSpecialCell ()

@property (nonatomic,strong) UIImageView *specilcon;
@property (nonatomic,strong) UILabel *specialName;
@property (nonatomic,strong) UILabel *specialEngName;
@property (nonatomic,strong) UILabel *specialPosition;
@property (nonatomic,strong) UILabel *skilledNation;
@property (nonatomic,strong) UILabel *years;
@property (nonatomic, strong) UIButton *consultBtn;

@end

@implementation ListSpecialCell

#pragma mark ----- init

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setUpCell];
        //[self test];
    }
    return self;
}

- (void)setUpCell{
    _specilcon = [[UIImageView alloc] init];
    _specialName = [[UILabel alloc] init];
    _specialEngName = [[UILabel alloc] init];
    _specialPosition = [[UILabel alloc] init];
    _skilledNation = [[UILabel alloc] init];
    _years = [[UILabel alloc] init];
    _consultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self addSubview:_specilcon];
    [self addSubview:_specialName];
    //[self addSubview:_specialEngName];
    [self addSubview:_specialPosition];
    [self addSubview:_skilledNation];
    [self addSubview:_years];
    [self addSubview:_consultBtn];
    
    _specilcon.sd_layout
    .leftSpaceToView(self, 14.0 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(self, 25.0 * SCREEN_WIDTHRATE_6)
    .heightIs(156.0/2.0 * SCREEN_WIDTHRATE_6)
    .widthEqualToHeight();
    
    _consultBtn.sd_layout
    .rightSpaceToView(self, 12.0 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(self, 27.0 *SCREEN_WIDTHRATE_6)
    .widthIs(100.0 * SCREEN_WIDTHRATE_6)
    .heightIs(30.0 * SCREEN_WIDTHRATE_6);

    _specialName.sd_layout
    .leftSpaceToView(_specilcon, 25.0 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(self, 24.0 * SCREEN_WIDTHRATE_6)
    .rightSpaceToView(_consultBtn, 10.0 * SCREEN_WIDTHRATE_6)
    .heightIs(19.0 * SCREEN_WIDTHRATE_6);
    
    _specialPosition.sd_layout
    .leftEqualToView(_specialName)
    .topSpaceToView(_specialName, 9.0 * SCREEN_WIDTHRATE_6)
    .rightEqualToView(_specialName)
    .heightIs(15.0 * SCREEN_WIDTHRATE_6);
    
    _skilledNation.sd_layout
    .leftEqualToView(_specialName)
    .rightEqualToView(_consultBtn)
    .topSpaceToView(_specialPosition, 23.0/2.0 * SCREEN_WIDTHRATE_6)
    .heightIs(13.0 * SCREEN_WIDTHRATE_6);
    
    _years.sd_layout
    .leftEqualToView(_specialName)
    .rightEqualToView(_consultBtn)
    .topSpaceToView(_skilledNation, 5.0 * SCREEN_WIDTHRATE_6)
    .heightIs(13.0 * SCREEN_WIDTHRATE_6);
    
    // 属性设置
    _specilcon.layer.cornerRadius = (156.0/2.0 * SCREEN_WIDTHRATE_6 / 2.0);
    _specilcon.clipsToBounds = TRUE;
    _specilcon.contentMode = UIViewContentModeScaleAspectFill;
    [_consultBtn setImage:[UIImage imageNamed:@"homepage_consultBtn"] forState:UIControlStateNormal];
    _specialPosition.textColor = [UIColor DDR102_G102_B102ColorWithalph:1.0];
    _specialPosition.font = [UIFont systemFontOfSize:FONT_UI28PX];
    [_consultBtn addTarget:self action:@selector(clickConsultBtn:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ----- 数据回调刷新

- (void)setModel:(id)model{
    if (model) {
        RcmdSpecialModel *f = (RcmdSpecialModel *)model;
        // 头像显示
        if (f.specilIcon != nil || f.specilIcon.length > 0) {
            [_specilcon sd_setImageWithURL:[NSURL URLWithString:f.specilIcon]];
        }else{
            [_specilcon sd_setImageWithURL:[NSURL URLWithString:f.specialImage_url]];
        }
        
        
        [_specialName setAttributedText:[self returnNameWithChineseName:f.specialName egName:f.specialEngName]];
        [_skilledNation setAttributedText:[self returnAttStringWithThem:@"擅长国家" des:f.nationstring]];
        
        NSString *yearString = f.years;
        if ([f.years rangeOfString:@"年"].location == NSNotFound) {
            yearString = [NSString stringWithFormat:@"%@年",f.years];
        }
        [_years setAttributedText:[self returnAttStringWithThem:@"从业年限" des:yearString]];

        _specialPosition.text = f.specialPosition;
        
    }
}

- (NSMutableAttributedString *)returnNameWithChineseName:(NSString *)cname egName:(NSString *)egName{
    // 名字 [UIFont fontWithName:@"Helvetica-Bold" size:FONT_UI36PX]
    NSString *spcFlag = @"|";
    NSString *name = [NSString stringWithFormat:@"%@ %@ %@",cname,spcFlag,egName];
    NSMutableAttributedString *mutableAttName = [[NSMutableAttributedString alloc] initWithString:name];
    [mutableAttName addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:FONT_UI36PX]
                           range:NSMakeRange(0, name.length)];
    [mutableAttName addAttribute:NSForegroundColorAttributeName
                           value:[UIColor DDR51_G51_B51ColorWithalph:1.0]
                           range:NSMakeRange(0, name.length)];
    
    NSRange spcFlagRange = [name rangeOfString:spcFlag];
    NSRange xRange = NSMakeRange(spcFlagRange.location+2, egName.length);
    [mutableAttName addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:FONT_UI34PX]
                           range:xRange];
    [mutableAttName addAttribute:NSForegroundColorAttributeName
                           value:[UIColor DDR102_G102_B102ColorWithalph:1.0]
                           range:xRange];
    
    return mutableAttName;
    
}

- (NSMutableAttributedString *)returnAttStringWithThem:(NSString *)themTitle des:(NSString *)des{
    NSString *flag = @":";
    NSString *str = [NSString stringWithFormat:@"%@%@%@",themTitle,flag,des];
    NSMutableAttributedString *rltString = [[NSMutableAttributedString alloc] initWithString:str];
    [rltString addAttribute:NSForegroundColorAttributeName
                      value:[UIColor DDR51_G51_B51ColorWithalph:1.0]
                      range:NSMakeRange(0, 4)];//str.length)];
    [rltString addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:@"Helvetica-Bold" size:FONT_UI24PX]//[UIFont systemFontOfSize:FONT_UI24PX]
                      range:NSMakeRange(0, 4)];//str.length)];
    
    NSRange flagRange = [str rangeOfString:flag];
    NSRange xRange = NSMakeRange(flagRange.location+1, des.length);
    [rltString addAttribute:NSForegroundColorAttributeName
                      value:[UIColor DDR85_G85_B85ColorWithalph:1.0]
                      range:xRange];
    [rltString addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:FONT_UI24PX]
                      range:xRange];//str.length)];
    
    return rltString;
}


#pragma mark ----- 点击交互

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)clickConsultBtn:(UIButton *)btn{
    if (self.consultBlock) {
        self.consultBlock(btn);
    }
}


- (void)test{
    
    _specilcon.backgroundColor = [UIColor redColor];
    _specialName.backgroundColor = [UIColor greenColor];
    _consultBtn.backgroundColor = [UIColor purpleColor];
    _specialPosition.backgroundColor = [UIColor greenColor];
    _skilledNation.backgroundColor = [UIColor redColor];
    _years.backgroundColor = [UIColor greenColor];
    
}

@end
