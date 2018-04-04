//
//  RecommanRribeCell.m
//  hinabian
//
//  Created by hnbwyh on 16/6/6.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "RecommanRribeCell.h"
#import "VerticalAligmentLabel.h"
#import "HomeHotPost.h"
#import "TribeIndexItem.h"
#import "DetailTribeHotestitem.h"
#import "DetailTribeLatestitem.h"

@interface RecommanRribeCell ()
@property (nonatomic,strong) NSString *tribeId;
@property (nonatomic,strong) NSString *type;
@end

@implementation RecommanRribeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self modifyCell];
    
    //[self setColor];
    
}

- (void)modifyCell{
    
    self.userName.font = [UIFont systemFontOfSize:FONT_UI20PX];
    self.userName.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0];
    
    self.title.font = [UIFont systemFontOfSize:FONT_UI32PX];
    self.title.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.0];
    self.title.numberOfLines = 0;
    self.title.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.subTitle.font = [UIFont systemFontOfSize:FONT_UI24PX];
    self.subTitle.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0];
    self.subTitle.numberOfLines = 0;
    
    self.time.font = [UIFont systemFontOfSize:FONT_UI18PX];
    self.time.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0];
    
    self.icon.clipsToBounds = YES;
    self.recommandImgView.clipsToBounds = YES;
    self.icon.layer.cornerRadius = 18.f / 2.0;
    self.recommandImgView.layer.cornerRadius = RRADIUS_LAYERCORNE;
    
    self.tribeImgView.layer.cornerRadius = RRADIUS_LAYERCORNE;
    self.tribeItemButton.layer.borderWidth = 0.5;
    self.tribeItemButton.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:1.0].CGColor;
    [self.tribeItemButton setTitleColor:[UIColor DDR63_G162_B255ColorWithalph:1.0] forState:UIControlStateNormal];
    self.tribeItemButton.layer.cornerRadius = 15.f / 2.0;
    self.tribeItemButton.titleLabel.font = [UIFont systemFontOfSize:FONT_UI18PX];
    self.tribeImgView.clipsToBounds = YES;
    [self.tribeItemButton addTarget:self action:@selector(clickTribeBtn:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setCellItemWithIndexTribeModel:(TribeIndexItem *)infoModel indexPath:(NSIndexPath *)indexPath
{
    _type = @"tribe_index";
    // 按钮 tag
    self.tribeItemButton.tag = 40 + indexPath.row;
    //self.curModel = infoModel;
    
    // 按钮长度
    NSString *tribeItemButtonText = infoModel.tribe_name;
    CGSize tribeSize = [tribeItemButtonText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_UI18PX]}];
    self.tribeItemButtonwidth.constant = tribeSize.width + CGRectGetHeight(self.tribeItemButton.frame);
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:infoModel.head_url]];
    [self.userName setText:infoModel.user_name];
    [self.tribeItemButton setTitle:infoModel.tribe_name forState:UIControlStateNormal];
    
    
    [self.subTitle setText:infoModel.desc];
    [self.time setText:infoModel.formated_time];
    [self.zanButton setTitle:[HNBUtils numConvert:infoModel.collect] forState:UIControlStateNormal];
    [self.commentButton setTitle:[HNBUtils numConvert:infoModel.comment_num] forState:UIControlStateNormal];
    [self.lookButton setTitle:[HNBUtils numConvert:infoModel.view_num] forState:UIControlStateNormal];
    self.tribeId = infoModel.tribe_id;
    NSString *img_url_string = infoModel.img_list;
    NSArray *img_url_arr = [img_url_string componentsSeparatedByString:@"&"];
    NSString *img_url= [img_url_arr firstObject];
    if (![img_url isEqualToString:@""]) {
        [self.tribeImgView sd_setImageWithURL:[NSURL URLWithString:img_url] placeholderImage:[UIImage imageNamed:@"homePage_tribe_post"] ];
    }
    /*
     1、置顶并且加精
     2、置顶非加精
     3、非置顶但加精
     4、非置顶非加精
     */
    
    self.creamImgView.hidden = ![infoModel.essence isEqualToString:@"1"];
    self.recommandImgView.hidden = ![infoModel.type isEqualToString:@"1"];
    [self.creamImgView setImage:[UIImage imageNamed:@"tribe_cream"]];
    [self.recommandImgView setImage:[UIImage imageNamed:@"tribe_top"]];
    if ([infoModel.type isEqualToString:@"1"] && [infoModel.essence isEqualToString:@"1"]) {
        
        self.creamImgLeadingRecommand.constant = 5.f;
        [self reloadFrameWithTitle:infoModel.title xoffSet:43.0];// 重新约束文本
        [self.title setText:[NSString stringWithFormat:@"            %@",infoModel.title]];
    }
    else if ([infoModel.type isEqualToString:@"1"] && [infoModel.essence isEqualToString:@"0"]) {
        
        self.creamImgLeadingRecommand.constant = 5.f;
        [self reloadFrameWithTitle:infoModel.title xoffSet:28.0];// 重新约束文本
        [self.title setText:[NSString stringWithFormat:@"       %@",infoModel.title]];
    }
    else if ([infoModel.type isEqualToString:@"0"] && [infoModel.essence isEqualToString:@"1"]) {
        
        self.creamImgLeadingRecommand.constant = -26.f;
        [self reloadFrameWithTitle:infoModel.title xoffSet:18.0];// 重新约束文本
        [self.title setText:[NSString stringWithFormat:@"     %@",infoModel.title]];
    }
    else {
        
        [self reloadFrameWithTitle:infoModel.title xoffSet:0.0];// 重新约束文本
        [self.title setText:[NSString stringWithFormat:@"%@",infoModel.title]];
    }
    
    
    /*认证V*/
    if ([infoModel.certified_type isEqualToString:@"other"]){
        if (infoModel.certified.length != 0) {
            //达人
            self.vImageView.hidden = NO;
            self.levelImageView.hidden = NO;
            [self.vImageView setImage:[UIImage imageNamed:@"tribe_talent"]];
            self.vImageViewLeadingUserName.constant = 30.f;
            
        }else{
            //普通用户
            self.levelImageView.hidden = NO;
            self.vImageView.hidden = YES;
        }
    }else if ([infoModel.certified_type isEqualToString:@"specialist"]) {
        //专家
        self.vImageView.hidden = NO;
        self.levelImageView.hidden = YES;
        [self.vImageView setImage:[UIImage imageNamed:@"specialist"]];
        self.vImageViewLeadingUserName.constant = 5.f;
        
    }else if ([infoModel.certified_type isEqualToString:@"authority"]){
        //官方
        self.vImageView.hidden = NO;
        self.levelImageView.hidden = YES;
        [self.vImageView setImage:[UIImage imageNamed:@"authority"]];
        self.vImageViewLeadingUserName.constant = 5.f;
        
    }
    /*获取用户等级*/
    if (infoModel.level) {
        [self.levelImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"LV%@",infoModel.level]]];
    }

}


-(void)setCellItemWithDetailTribeHotestModel:(DetailTribeHotestitem *)infoModel indexPath:(NSIndexPath *)indexPath{
    
    _type = @"tribe_new";
    // 按钮长度
    NSString *tribeItemButtonText = infoModel.tribe_name;
    CGSize tribeSize = [tribeItemButtonText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_UI18PX]}];
    self.tribeItemButtonwidth.constant = tribeSize.width + CGRectGetHeight(self.tribeItemButton.frame);
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:infoModel.head_url]];
    [self.userName setText:infoModel.user_name];
    [self.tribeItemButton setTitle:infoModel.tribe_name forState:UIControlStateNormal];
    [self.subTitle setText:infoModel.desc];
    [self.time setText:infoModel.formated_time];
    [self.zanButton setTitle:[HNBUtils numConvert:infoModel.collect] forState:UIControlStateNormal];
    [self.commentButton setTitle:[HNBUtils numConvert:infoModel.comment_num] forState:UIControlStateNormal];
    [self.lookButton setTitle:infoModel.view_num forState:UIControlStateNormal];
    self.tribeId = infoModel.tribe_id;
    NSString *img_url_string = infoModel.img_list;
    NSArray *img_url_arr = [img_url_string componentsSeparatedByString:@"&"];
    NSString *img_url= [img_url_arr firstObject];
    if (![img_url isEqualToString:@""]) {
        [self.tribeImgView sd_setImageWithURL:[NSURL URLWithString:img_url] placeholderImage:[UIImage imageNamed:@"homePage_tribe_post"]];
    }
    
    /*
     1、置顶并且加精
     2、置顶非加精
     3、非置顶但加精
     4、非置顶非加精
     */
    self.creamImgView.hidden = ![infoModel.essence isEqualToString:@"1"];
    self.recommandImgView.hidden = ![infoModel.type isEqualToString:@"1"];
    [self.creamImgView setImage:[UIImage imageNamed:@"tribe_cream"]];
    [self.recommandImgView setImage:[UIImage imageNamed:@"tribe_top"]];
    if ([infoModel.type isEqualToString:@"1"] && [infoModel.essence isEqualToString:@"1"]) {
        
        self.creamImgLeadingRecommand.constant = 5.f;
        [self reloadFrameWithTitle:infoModel.title xoffSet:43.0];// 重新约束文本
        [self.title setText:[NSString stringWithFormat:@"            %@",infoModel.title]];
    }
    else if ([infoModel.type isEqualToString:@"1"] && [infoModel.essence isEqualToString:@"0"]) {
        
        self.creamImgLeadingRecommand.constant = 5.f;
        [self reloadFrameWithTitle:infoModel.title xoffSet:28.0];// 重新约束文本
        [self.title setText:[NSString stringWithFormat:@"       %@",infoModel.title]];
    }
    else if ([infoModel.type isEqualToString:@"0"] && [infoModel.essence isEqualToString:@"1"]) {
        
        self.creamImgLeadingRecommand.constant = -26.f;
        [self reloadFrameWithTitle:infoModel.title xoffSet:18.0];// 重新约束文本
        [self.title setText:[NSString stringWithFormat:@"     %@",infoModel.title]];
    }
    else {
        
        [self reloadFrameWithTitle:infoModel.title xoffSet:0.0];// 重新约束文本
        [self.title setText:[NSString stringWithFormat:@"%@",infoModel.title]];
    }
    
    
    /*认证V*/
    if ([infoModel.certified_type isEqualToString:@"specialist"]) {
        //专家
        self.vImageView.hidden = NO;
        self.levelImageView.hidden = YES;
        [self.vImageView setImage:[UIImage imageNamed:@"specialist"]];
        self.vImageViewLeadingUserName.constant = 5.f;
        
    }else if ([infoModel.certified_type isEqualToString:@"authority"]){
        //官方
        self.vImageView.hidden = NO;
        self.levelImageView.hidden = YES;
        [self.vImageView setImage:[UIImage imageNamed:@"authority"]];
        self.vImageViewLeadingUserName.constant = 5.f;
        
    }else{
        if (infoModel.certified.length != 0) {
            //达人
            self.vImageView.hidden = NO;
            self.levelImageView.hidden = NO;
            [self.vImageView setImage:[UIImage imageNamed:@"tribe_talent"]];
            self.vImageViewLeadingUserName.constant = 30.f;
            
        }else{
            //普通用户
            self.levelImageView.hidden = NO;
            self.vImageView.hidden = YES;
        }
    }
    /*判断用户等级*/
    if (infoModel.level) {
        [self.levelImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"LV%@",infoModel.level]]];
    }
    
}

-(void)setCellItemWithDetailTribeLatestModel:(DetailTribeLatestitem *)infoModel indexPath:(NSIndexPath *)indexPath{
    _type = @"tribe_last";
    // 按钮长度
    NSString *tribeItemButtonText = infoModel.tribe_name;
    CGSize tribeSize = [tribeItemButtonText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_UI18PX]}];
    self.tribeItemButtonwidth.constant = tribeSize.width + CGRectGetHeight(self.tribeItemButton.frame);
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:infoModel.head_url]];
    [self.userName setText:infoModel.user_name];
    [self.tribeItemButton setTitle:infoModel.tribe_name forState:UIControlStateNormal];
    [self.subTitle setText:infoModel.desc];
    [self.time setText:infoModel.formated_time];
    [self.zanButton setTitle:[HNBUtils numConvert:infoModel.collect] forState:UIControlStateNormal];
    [self.commentButton setTitle:[HNBUtils numConvert:infoModel.comment_num] forState:UIControlStateNormal];
    [self.lookButton setTitle:infoModel.view_num forState:UIControlStateNormal];
    
    NSString *img_url_string = infoModel.img_list;
    NSArray *img_url_arr = [img_url_string componentsSeparatedByString:@"&"];
    NSString *img_url= [img_url_arr firstObject];
    if (![img_url isEqualToString:@""]) {
        [self.tribeImgView sd_setImageWithURL:[NSURL URLWithString:img_url] placeholderImage:[UIImage imageNamed:@"homePage_tribe_post"]];
    }
    
    /*
     1、置顶并且加精
     2、置顶非加精
     3、非置顶但加精
     4、非置顶非加精
     */
    self.creamImgView.hidden = ![infoModel.essence isEqualToString:@"1"];
    self.recommandImgView.hidden = ![infoModel.type isEqualToString:@"1"];
    [self.creamImgView setImage:[UIImage imageNamed:@"tribe_cream"]];
    [self.recommandImgView setImage:[UIImage imageNamed:@"tribe_top"]];
    if ([infoModel.type isEqualToString:@"1"] && [infoModel.essence isEqualToString:@"1"]) {
        
        self.creamImgLeadingRecommand.constant = 5.f;
        [self reloadFrameWithTitle:infoModel.title xoffSet:43.0];// 重新约束文本
        [self.title setText:[NSString stringWithFormat:@"            %@",infoModel.title]];
    }
    else if ([infoModel.type isEqualToString:@"1"] && [infoModel.essence isEqualToString:@"0"]) {
        
        self.creamImgLeadingRecommand.constant = 5.f;
        [self reloadFrameWithTitle:infoModel.title xoffSet:28.0];// 重新约束文本
        [self.title setText:[NSString stringWithFormat:@"       %@",infoModel.title]];
    }
    else if ([infoModel.type isEqualToString:@"0"] && [infoModel.essence isEqualToString:@"1"]) {
        
        self.creamImgLeadingRecommand.constant = -26.f;
        [self reloadFrameWithTitle:infoModel.title xoffSet:18.0];// 重新约束文本
        [self.title setText:[NSString stringWithFormat:@"     %@",infoModel.title]];
    }
    else {
        
        [self reloadFrameWithTitle:infoModel.title xoffSet:0.0];// 重新约束文本
        [self.title setText:[NSString stringWithFormat:@"%@",infoModel.title]];
    }
    
    
    /*认证V*/
    if ([infoModel.certified_type isEqualToString:@"specialist"]) {
        //专家
        self.vImageView.hidden = NO;
        self.levelImageView.hidden = YES;
        [self.vImageView setImage:[UIImage imageNamed:@"specialist"]];
        self.vImageViewLeadingUserName.constant = 5.f;
        
    }else if ([infoModel.certified_type isEqualToString:@"authority"]){
        //官方
        self.vImageView.hidden = NO;
        self.levelImageView.hidden = YES;
        [self.vImageView setImage:[UIImage imageNamed:@"authority"]];
        self.vImageViewLeadingUserName.constant = 5.f;
        
    }else{
        if (infoModel.certified.length != 0) {
            //达人
            self.vImageView.hidden = NO;
            self.levelImageView.hidden = NO;
            [self.vImageView setImage:[UIImage imageNamed:@"tribe_talent"]];
            self.vImageViewLeadingUserName.constant = 30.f;
        }else{
            //普通用户
            self.levelImageView.hidden = NO;
            self.vImageView.hidden = YES;
        }
    }
    /*判断用户等级*/
    if (infoModel.level) {
        [self.levelImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"LV%@",infoModel.level]]];
    }
}


- (void)clickTribeBtn:(UIButton *)btn{
    if([_type isEqualToString:@"tribe_index"])
    {
        NSArray *tmpArray = @[@"tribe_index",self.tribeId];
        [[NSNotificationCenter defaultCenter] postNotificationName:TRIBE_INDEX_TRIBE_IN_CELL_NOTIFICATION object:tmpArray];
    }
}

- (void)setColor{
    
    self.icon.backgroundColor = [UIColor redColor];
    self.userName.backgroundColor = [UIColor greenColor];
    self.tribeItemButton.backgroundColor = [UIColor orangeColor];
    self.title.backgroundColor = [UIColor orangeColor];
    self.subTitle.backgroundColor = [UIColor redColor];
    self.tribeImgView.backgroundColor = [UIColor greenColor];
    self.time.backgroundColor = [UIColor purpleColor];
    
    self.zanButton.backgroundColor = [UIColor redColor];
    self.commentButton.backgroundColor = [UIColor greenColor];
    self.lookButton.backgroundColor = [UIColor blueColor];
    
    self.recommandImgView.backgroundColor = [UIColor redColor];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark ------ toolMethod

// 126.0 - 约束之后 title 文本控件的宽度   ， 39.0 - title 文本控件的高度  ，xoffset = 28 推荐图片所占用的宽度
- (void)reloadFrameWithTitle:(NSString *)title xoffSet:(CGFloat)xoffset{

    CGSize labelSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_UI32PX]}];
    CGFloat actualWidth = labelSize.width + xoffset;
    
    if ((actualWidth < (SCREEN_WIDTH - 126.0) && actualWidth > 0)) {
        
        self.titleHeight.constant = labelSize.height;
        
    }else{
        
        self.titleHeight.constant = 39.0;
        
    }
    
}

@end
