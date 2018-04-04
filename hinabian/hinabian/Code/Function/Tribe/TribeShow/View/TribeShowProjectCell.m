//
//  TribeShowProjectCell.m
//  hinabian
//
//  Created by hnbwyh on 17/4/18.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "TribeShowProjectCell.h"
#import "VerticalAligmentLabel.h"
#import "TribeShowProjectModel.h"

#define VERTICAL_GAP_ONE 16.0
#define VERTICAL_GAP_TWO 6.0

#define LABEL_HEIGHT_ONE 20.0
#define LABEL_HEIGHT_TWO 15.0


@interface TribeShowProjectCell ()

@property (nonatomic,strong) UILabel *proTitle;
@property (nonatomic,strong) UILabel *advantageItem;
@property (nonatomic,strong) VerticalAligmentLabel *advantage;
@property (nonatomic,strong) UILabel *visaType;
@property (nonatomic,strong) UILabel *takePeriod;
@property (nonatomic,strong) UILabel *investLimit;
@property (nonatomic,strong) UILabel *liveDemand;
@property (nonatomic,strong) UILabel *thirdExpense;

@end


@implementation TribeShowProjectCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpCell];
    }
    return self;
    
}

- (void)setUpCell{

    _proTitle = [[UILabel alloc] init];
    [self addSubview:_proTitle];
    _advantageItem = [[UILabel alloc] init];
    [self addSubview:_advantageItem];
    _advantage = [[VerticalAligmentLabel alloc] init];
    [self addSubview:_advantage];
    _visaType = [[UILabel alloc] init];
    [self addSubview:_visaType];
    _takePeriod = [[UILabel alloc] init];
    [self addSubview:_takePeriod];
    _investLimit = [[UILabel alloc] init];
    [self addSubview:_investLimit];
    _liveDemand = [[UILabel alloc] init];
    [self addSubview:_liveDemand];
    _thirdExpense = [[UILabel alloc] init];
    [self addSubview:_thirdExpense];
    
    _proTitle.sd_layout
    .topSpaceToView(self,VERTICAL_GAP_ONE)
    .leftSpaceToView(self,HORIZON_GAP)
    .rightSpaceToView(self,HORIZON_GAP)
    .heightIs(LABEL_HEIGHT_ONE);
    
    _advantageItem.sd_layout
    .topSpaceToView(_proTitle,VERTICAL_GAP_TWO)
    .leftEqualToView(_proTitle)
    .widthIs(TRIBESHOW_ADVANTAGE_ITEM_WIDTH)
    .heightIs(LABEL_HEIGHT_TWO);
    
    _advantage.sd_layout
    .topEqualToView(_advantageItem)
    .leftSpaceToView(_advantageItem,0)
    .rightSpaceToView(self,HORIZON_GAP)
    .heightIs(LABEL_HEIGHT_TWO);
    
    _visaType.sd_layout
    .topSpaceToView(_advantage,VERTICAL_GAP_TWO)
    .leftEqualToView(_proTitle)
    .widthIs(SCREEN_WIDTH/2.0 - HORIZON_GAP)
    .heightIs(LABEL_HEIGHT_TWO);
    
    _takePeriod.sd_layout
    .topEqualToView(_visaType)
    .rightSpaceToView(self,HORIZON_GAP)
    .leftSpaceToView(_visaType,0)
    .heightIs(LABEL_HEIGHT_TWO);
    
    _investLimit.sd_layout
    .topSpaceToView(_visaType,VERTICAL_GAP_TWO)
    .leftEqualToView(_proTitle)
    .rightEqualToView(_proTitle)
    .heightIs(LABEL_HEIGHT_TWO);
    
    _liveDemand.sd_layout
    .topSpaceToView(_investLimit,VERTICAL_GAP_TWO)
    .leftEqualToView(_proTitle)
    .rightEqualToView(_proTitle)
    .heightIs(LABEL_HEIGHT_TWO);
    
    _thirdExpense.sd_layout
    .topSpaceToView(_liveDemand,VERTICAL_GAP_TWO)
    .leftEqualToView(_proTitle)
    .rightEqualToView(_proTitle)
    .heightIs(LABEL_HEIGHT_TWO);
    
    
    _advantage.numberOfLines = 0;
    _advantage.verticalAlignment = VerticalAlignmentTop;
    
//    _proTitle.backgroundColor = [UIColor greenColor];
//    _advantageItem.backgroundColor = [UIColor purpleColor];
//    _advantage.backgroundColor = [UIColor greenColor];
//    _visaType.backgroundColor = [UIColor greenColor];
//    _takePeriod.backgroundColor = [UIColor greenColor];
//    _investLimit.backgroundColor = [UIColor purpleColor];
//    _liveDemand.backgroundColor = [UIColor greenColor];
//    _thirdExpense.backgroundColor = [UIColor purpleColor];
    
}

- (NSAttributedString *)handleAttributedStringWithItemString:(NSString *)item contentString:(NSString *)content{
    
    NSMutableString *tmpString = [NSMutableString stringWithFormat:@"%@%@",item,content];
    NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:tmpString];
    if ([item rangeOfString:@"["].location != NSNotFound) {
        
        [textString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_UI32PX] range:NSMakeRange(0, tmpString.length)];
        [textString addAttribute:NSForegroundColorAttributeName value:[UIColor DDR63_G162_B255ColorWithalph:1.0] range:NSMakeRange(0, item.length)];
        [textString addAttribute:NSForegroundColorAttributeName value:[UIColor DDR51_G51_B51ColorWithalph:1.0] range:NSMakeRange(item.length, content.length)];
        
    }else if ([item rangeOfString:@"优势"].location != NSNotFound){
        
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//        [paragraphStyle setLineSpacing:TRIBESHOW_PROITEM_LINESPACE];
//        [textString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
        [textString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_UI24PX] range:NSMakeRange(0, tmpString.length)];
        [textString addAttribute:NSForegroundColorAttributeName value:[UIColor DDR136_G136_B136ColorWithalph:1.0] range:NSMakeRange(item.length, content.length)];
    }else if ([item rangeOfString:@"海那边服务费"].location != NSNotFound){
        [tmpString appendString:@"人民币"];
        [textString appendAttributedString:[[NSAttributedString alloc] initWithString:@"人民币"]];
        [textString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_UI24PX] range:NSMakeRange(0, tmpString.length)];
        [textString addAttribute:NSForegroundColorAttributeName value:[UIColor DDR51_G51_B51ColorWithalph:1.0] range:NSMakeRange(0, item.length)];
        [textString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:120.0/255.0 blue:0 alpha:1.0] range:NSMakeRange(item.length, content.length)];
        [textString addAttribute:NSForegroundColorAttributeName value:[UIColor DDR136_G136_B136ColorWithalph:1.0] range:NSMakeRange(item.length+content.length, 3)];
    }else {
        [textString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_UI24PX] range:NSMakeRange(0, tmpString.length)];
        [textString addAttribute:NSForegroundColorAttributeName value:[UIColor DDR51_G51_B51ColorWithalph:1.0] range:NSMakeRange(0, item.length)];
        [textString addAttribute:NSForegroundColorAttributeName value:[UIColor DDR136_G136_B136ColorWithalph:1.0] range:NSMakeRange(item.length, content.length)];
    }
    
    return textString;
}

- (void)setTribeShowProCellWithModel:(TribeShowProjectModel *)infoModel indexPath:(NSIndexPath *)indexPath{

//    _proTitle.attributedText = [self handleAttributedStringWithItemString:@"[技术] " contentString:@"190-澳洲单板技术移民"];
//    _advantageItem.attributedText = [self handleAttributedStringWithItemString:@"优势：" contentString:@""];
//    _advantage.attributedText = [self handleAttributedStringWithItemString:@"" contentString:@"留学+移民，无排期无名额限制，专业学习"];
//    _visaType.attributedText = [self handleAttributedStringWithItemString:@"签证：" contentString:@"临时居民"];
//    _takePeriod.attributedText = [self handleAttributedStringWithItemString:@"办理周期：" contentString:@"7-12个月"];
//    _investLimit.attributedText = [self handleAttributedStringWithItemString:@"投资额度：" contentString:@"1000万"];
//    _liveDemand.attributedText = [self handleAttributedStringWithItemString:@"居住要求：" contentString:@"居住要求原则上六块腹肌拉钢铝"];
//    _thirdExpense.attributedText = [self handleAttributedStringWithItemString:@"海那边服务费：" contentString:@"1000万"];
    
    _advantage.sd_layout
    .topEqualToView(_advantageItem)
    .leftSpaceToView(_advantageItem,0)
    .rightSpaceToView(self,HORIZON_GAP)
    .heightIs(infoModel.advantageHeight);
    
    _proTitle.attributedText = [self handleAttributedStringWithItemString:[NSString stringWithFormat:@"[%@] ",infoModel.label_name] contentString:infoModel.name];
    _advantageItem.attributedText = [self handleAttributedStringWithItemString:@"优势：" contentString:@""];
    _advantage.attributedText = [self handleAttributedStringWithItemString:@"" contentString:infoModel.recommended_reason2];
    _visaType.attributedText = [self handleAttributedStringWithItemString:@"签证：" contentString:infoModel.visa_type];
    _takePeriod.attributedText = [self handleAttributedStringWithItemString:@"办理周期：" contentString:infoModel.cycle];
    _investLimit.attributedText = [self handleAttributedStringWithItemString:@"投资额度：" contentString:infoModel.amount_investment];
    _liveDemand.attributedText = [self handleAttributedStringWithItemString:@"居住要求：" contentString:infoModel.immigrant];
    _thirdExpense.attributedText = [self handleAttributedStringWithItemString:@"海那边服务费：" contentString:infoModel.service_price];
    
    
}


@end
