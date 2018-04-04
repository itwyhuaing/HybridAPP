//
//  PromotionCell.m
//  hinabian
//
//  Created by hnbwyh on 16/6/1.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "PromotionCell.h"
#import "HomeHotPost.h"


@implementation PromotionCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self modifyCell];

}

- (void)modifyCell{

    
    self.title.font = [UIFont systemFontOfSize:FONT_UI32PX];
    self.title.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.0];
    self.title.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.promotion.textColor = [UIColor DDR255_G138_B93ColorWithalph:1.0];
    self.promotion.font = [UIFont systemFontOfSize:9.0];
    
    self.promotionImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.promotionImgView.layer.cornerRadius = RRADIUS_LAYERCORNE;
    self.promotionImgView.clipsToBounds = YES;
    
//    self.icon.contentMode = UIViewContentModeScaleAspectFill;
//    self.icon.layer.cornerRadius = CGRectGetHeight(self.icon.frame) / 2.0;
//    self.icon.clipsToBounds = YES;
//    self.userName.textAlignment = NSTextAlignmentLeft;
//    self.userName.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0];
//    self.userName.font = [UIFont systemFontOfSize:9.0];
//    self.desc.textAlignment = NSTextAlignmentLeft;
//    self.desc.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0];
//    self.desc.numberOfLines = 0;
//    self.desc.font = [UIFont systemFontOfSize:12.0];
    
}

-(void)setCellItemWithModel:(HomeHotPost *)infoModel indexPath:(NSIndexPath *)indexPath{

    //self.promotionImgViewHeight.constant = 110.0 * SCREEN_SCALE;
    if([infoModel.desc isEqualToString:@"0"])
    {
        self.titleLabelHeight.constant = 0.0f;
        self.title.hidden = TRUE;
        self.promotionLabelHeight.constant = 0.0f;
        self.promotion.hidden = TRUE;
    }
    else
    {
        self.titleLabelHeight.constant = 20.0f;
        self.title.hidden = FALSE;
        self.promotionLabelHeight.constant = 20.0f;
        self.promotion.hidden = FALSE;
    }
    
    [self.title setText:infoModel.title];
    [self.promotion setText:@"推广"];
   
    NSString *img_url_string = infoModel.img_list;
    NSArray *img_urls = [img_url_string componentsSeparatedByString:@"&"];
    NSString *img_url = [img_urls firstObject];
    if (![img_url isEqualToString:@""]) {
    [self.promotionImgView sd_setImageWithURL:[NSURL URLWithString:img_url] placeholderImage:[UIImage imageNamed:@"loading_image"]];
    
    }
    
//    [self.icon sd_setImageWithURL:[NSURL URLWithString:infoModel.head_url]];
//    [self.userName setText:infoModel.user_name];
//    [self.desc setText:infoModel.desc];
    
}



//- (void)setColor{
//
//    self.icon.backgroundColor = [UIColor redColor];
//    self.userName.backgroundColor = [UIColor greenColor];
//    self.promotion.backgroundColor = [UIColor purpleColor];
//    self.promotionImgView.backgroundColor = [UIColor blueColor];
//    self.desc.backgroundColor = [UIColor orangeColor];
//    
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
