//
//  PersonalHeadTableViewCell.m
//  hinabian
//
//  Created by 余坚 on 15/7/2.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "PersonalHeadTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIFont+Fonts.h"
#import "PersonalInfoItemTableViewCell.h"
#import "LoginViewController.h"
#import "PersonalInfoViewController.h"
#import "PersonalInfo.h"
//#import "NSDictionary+ValueForKey.h"

static const int kHighestLevel = 30;

@interface PersonalHeadTableViewCell()
{
    CGPoint statePoint;
    CGPoint statusPoint;
    CGPoint linePoint;
    CGPoint statusStatePoint;
    CGPoint namePoint;
    CGPoint levelPoint;
    NSLayoutConstraint *certifiedConstraint;
    NSLayoutConstraint *uncertifiedConstraint;
}

@end

@implementation PersonalHeadTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    certifiedConstraint = [NSLayoutConstraint constraintWithItem:self.vImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.energyImage attribute:NSLayoutAttributeLeading multiplier:1.f constant:0.f];
    [self addConstraint:certifiedConstraint];
    
    uncertifiedConstraint = [NSLayoutConstraint constraintWithItem:self.levelImage attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.energyImage attribute:NSLayoutAttributeLeading multiplier:1.f constant:0.f];
    [self addConstraint:uncertifiedConstraint];
    
    /*设置白边*/
    [self setImageBorder:self.vImageView];
    [self setImageBorder:self.levelImage];
    [self setImageBorder:self.moderatorImage];
    
    self.vImageView.hidden =YES;
    self.levelImage.hidden = YES;
    self.moderatorImage.hidden = YES;
    /*头像边框*/
    self.borderView.backgroundColor = [UIColor DDR81_G197_B241ColorWithalph:1.f];
    self.borderView.layer.cornerRadius = 73.f / 2;
    self.borderView.layer.masksToBounds = YES;
    self.borderView.clipsToBounds = YES;
    
    /*不能直接取头像的Frame,100.f为头像的直径，暂且为固定值*/
    self.headImage.layer.cornerRadius = 67.f / 2;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.clipsToBounds = YES;
    
    [self.backgroundImageView setImage:[UIImage imageNamed:@"person_header_backImg"]];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    
    [self setLabel:self.statusLabel];
    [self setLabel:self.stateLabel];
    [self setLabel:self.statusStateLabel];
    [self setLabel:self.certifiedLabel];
    self.nameLabel.font   = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_UI32PX]; // 字体加粗
    self.statusStateLabel.hidden = YES;
    self.moderatorImage.hidden = YES;
    
    self.energyButton.tag = PersonHeaderViewEnergyBtnTag;
    self.levelButton.tag = PersonHeaderViewLevelBtnTag;
    self.vButton.tag = PersonHeaderViewVBtnTag;
    [self.energyButton addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.levelButton addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.vButton addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setLabel:(UILabel *)label
{
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_UI24PX];
    label.textColor = [UIColor colorWithRed:218.f/255.f green:245.f/255.f blue:255.f/255.f alpha:1.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) editPersonalInfo
{
    if (![HNBUtils isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.superController.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        PersonalInfoViewController * vc = [[PersonalInfoViewController alloc] init];
        [self.superController.navigationController pushViewController:vc animated:YES];
    }
}

-(void)setUserinfo:(PersonalInfo *)f
{
    NSString *imNation  = f.im_nation_cn;
    NSArray  *nations   = [imNation componentsSeparatedByString:@","];
    imNation = [nations firstObject];
    if (imNation.length <= 0) {
        imNation = nil;
    }
    NSString *status = f.im_state_cn;
    if (status.length <= 0) {
        status = nil;
    }
    if ([status isEqualToString:@"移民中"]) {
        status = @"已移民";
    }
    NSString *level = [f.levelInfo returnValueWithKey:@"level"];
    if (level.length <= 0) {
        level = nil;
    }
    
    if (f.head_url == nil) {
        [self.headImage setImage:[UIImage imageNamed:@"person_unlogin"]];
    }else{
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:f.head_url]];
    }
    
    self.nameLabel.text = f.name;
    
    /*判断用户等级*/
    if ([level integerValue] <= kHighestLevel && [level integerValue] >= 0) {
        self.levelImage.hidden = NO;
        [self.levelImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"LV%@",level]]];
    }else{
        self.levelImage.hidden = YES;
    }
    
    /*设置用户国家和移民状态*/
    [self setValueForStatus:status nations:imNation];
    
    /*设置用户身份*/
    [self setValueForCertified:f];
}

-(void)setUserinfoWithoutNetWorking:(NSDictionary *)dic
{
    NSString *name      = [dic objectForKey:@"name"];
    NSString *imNation  = [dic objectForKey:@"im_nation_cn"];
    NSArray  *nations   = [imNation componentsSeparatedByString:@","];
    imNation = [nations firstObject];
    if (imNation.length <= 0) {
        imNation = nil;
    }
    NSString *status = [dic objectForKey:@"im_state_cn"];
    if (status.length <= 0) {
        status = nil;
    }
    
    self.nameLabel.text = name;
    self.certifiedLabel.hidden = YES;
    self.nameTopBorderViewConstraints.constant = 15.f;
    self.StatusLabelTopNameConstraints.constant = 13.f;
    /*设置用户国家和移民状态*/
    [self setValueForStatus:status nations:imNation];
}

-(void)setValueForStatus:(NSString *)status nations:(NSString *)imNation
{
    /*判断移民状态与目标国家*/
    if (status != nil && imNation != nil) {
        
        self.line.hidden = NO;
        self.stateLabel.hidden = NO;
        self.statusLabel.hidden = NO;
        self.statusStateLabel.hidden = YES;
        self.statusLabel.text = status;
        self.stateLabel.text = imNation;
        
    }else if (status != nil){
        
        self.line.hidden = YES;
        self.stateLabel.hidden = YES;
        self.statusLabel.hidden = YES;
        self.statusStateLabel.hidden = NO;
        self.statusStateLabel.text = status;
        
    }else if (imNation != nil){
        
        self.line.hidden = YES;
        self.stateLabel.hidden = YES;
        self.statusLabel.hidden = YES;
        self.statusStateLabel.hidden = NO;
        self.statusStateLabel.text = imNation;
        
    }
}

-(void)setValueForCertified:(PersonalInfo *)f
{
    /*根据名字长度设置约束*/
    const char *cName = [f.name UTF8String];
    
    if (f.certified.length != 0) {
        //认证用户
        if (SCREEN_HEIGHT <= SCREEN_HEIGHT_5 && strlen(cName) > 22) {
            certifiedConstraint.active      = YES;
            uncertifiedConstraint.active    = NO;
        }else{
            certifiedConstraint.active      = NO;
            uncertifiedConstraint.active    = NO;
        }
    }else{
        //非认证用户
        if (SCREEN_HEIGHT <= SCREEN_HEIGHT_5 && strlen(cName) > 22
            ) {
            uncertifiedConstraint.active    = YES;
            certifiedConstraint.active      = NO;
        }else{
            uncertifiedConstraint.active    = NO;
            certifiedConstraint.active      = NO;
        }
    }
    if (f.certified.length == 0) {
        self.nameTopBorderViewConstraints.constant = 15.f;
        self.StatusLabelTopNameConstraints.constant = 13.f;
    }else{
        self.nameTopBorderViewConstraints.constant = 0.f;
        self.StatusLabelTopNameConstraints.constant = 18.f;
    }
    
    /*判断用户身份*/
    if (f.moderator && f.moderator.count != 0) {//版主
        self.moderatorImage.hidden = NO;
        [self.moderatorImage setImage:[UIImage imageNamed:@"moderator"]];
        if (f.certified.length == 0) {
            self.moderatorImageLeadingLevelImage.constant = 5.f;
        }else{
            self.moderatorImageLeadingLevelImage.constant = 30.f;
        }
    }else{
        self.moderatorImage.hidden = YES;
    }
    
    if ([f.certified_type isEqualToString:@"other"]){//其他用户
        
        self.energyImage.hidden = NO;
        self.energyButton.hidden = NO;
        if (f.certified.length == 0) {//普通用户
            
            self.certifiedLabel.hidden  = YES;
            self.vImageView.hidden      = YES;
            self.vButton.hidden         = YES;
            
        }else{//社区达人
            
            self.certifiedLabel.hidden  = NO;
            self.vImageView.hidden      = NO;
            self.vButton.hidden         = NO;
            
            [self.vImageView setImage:[UIImage imageNamed:@"tribe_talent"]];
            [self.certifiedLabel setText:[NSString stringWithFormat:@"海那边认证：%@",f.certified]];
        }
    }else if ([f.certified_type isEqualToString:@"specialist"]) {//专家
        
        self.energyImage.hidden     = YES;
        self.energyButton.hidden    = YES;
        self.certifiedLabel.hidden  = NO;
        self.vImageView.hidden      = NO;
        self.vButton.hidden         = NO;
        
        [self.vImageView setImage:[UIImage imageNamed:@"specialist"]];
        [self.certifiedLabel setText:[NSString stringWithFormat:@"海那边认证：%@",f.certified_label]];//专家显示特定的标识
        
    }else if([f.certified_type isEqualToString:@"authority"]){//官方
        
        self.energyImage.hidden     = YES;
        self.energyButton.hidden    = YES;
        self.certifiedLabel.hidden  = NO;
        self.vImageView.hidden      = NO;
        self.vButton.hidden         = NO;
        
        [self.vImageView setImage:[UIImage imageNamed:@"authority"]];
        [self.certifiedLabel setText:[NSString stringWithFormat:@"海那边认证：%@",f.certified]];
        
    }
}

-(void)setImageBorder:(UIView *)view
{
    view.layer.cornerRadius = 2.0f;
    view.layer.borderWidth = 0.5f;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.masksToBounds = YES;
    view.clipsToBounds = YES;
}

-(void)didScroll:(CGFloat)offset
{
    if(offset<=0){
        CGFloat newHeight = [PersonalHeadTableViewCell getHeight] - offset;
        CGFloat scale = newHeight / [PersonalHeadTableViewCell getHeight];
        CGFloat newWidth = [UIScreen mainScreen].bounds.size.width *scale;
        CGFloat newX = ([UIScreen mainScreen].bounds.size.width - newWidth)/2;
        
        self.backgroundImageView.frame = CGRectMake(newX, offset, newWidth, newHeight);
        
        
        [self setViewTransform:self.borderView offset:offset];
        [self setViewTransform:self.statusLabel offset:offset];
        [self setViewTransform:self.stateLabel offset:offset];
        [self setViewTransform:self.line offset:offset];
        [self setViewTransform:self.nameLabel offset:offset];
        [self setViewTransform:self.certifiedLabel offset:offset];
        [self setViewTransform:self.energyImage offset:offset];
        [self setViewTransform:self.energyButton offset:offset];
        [self setViewTransform:self.levelImage offset:offset];
        [self setViewTransform:self.levelButton offset:offset];
        [self setViewTransform:self.vImageView offset:offset];
        [self setViewTransform:self.vButton offset:offset];
        [self setViewTransform:self.statusStateLabel offset:offset];
        [self setViewTransform:self.moderatorImage offset:offset];
    }
    else{
        self.backgroundImageView.transform = CGAffineTransformIdentity;
        self.borderView.transform = CGAffineTransformIdentity;
        self.nameLabel.transform = CGAffineTransformIdentity;
        self.statusLabel.transform = CGAffineTransformIdentity;
        self.stateLabel.transform = CGAffineTransformIdentity;
        self.certifiedLabel.transform = CGAffineTransformIdentity;
        self.line.transform = CGAffineTransformIdentity;
        self.vButton.transform = CGAffineTransformIdentity;
        self.energyImage.transform = CGAffineTransformIdentity;
        self.energyButton.transform = CGAffineTransformIdentity;
        self.levelImage.transform = CGAffineTransformIdentity;
        self.levelButton.transform = CGAffineTransformIdentity;
        self.vImageView.transform = CGAffineTransformIdentity;
        self.vButton.transform = CGAffineTransformIdentity;
        self.statusStateLabel.transform = CGAffineTransformIdentity;
        self.moderatorImage.transform = CGAffineTransformIdentity;
    }

}

-(void)setViewTransform:(UIView *)view offset:(CGFloat)offset
{
    CGFloat imageScale = ([PersonalHeadTableViewCell getHeight] - offset*0.6) / [PersonalHeadTableViewCell getHeight];
    CGAffineTransform transfer = CGAffineTransformMakeScale(imageScale, imageScale);
    transfer = CGAffineTransformTranslate(transfer, 0, offset * 0.6);
    
    view.transform = transfer;
    view.transform = CGAffineTransformMakeTranslation(0, offset * 0.4);
}

- (void)clickEvent:(UIButton *)btn{
    if ((btn.tag == PersonHeaderViewEnergyBtnTag )) {
        [[NSNotificationCenter defaultCenter] postNotificationName:USERINFO_ENERGYBUTTON object:nil];
    }else if((btn.tag == PersonHeaderViewLevelBtnTag)){
        [[NSNotificationCenter defaultCenter] postNotificationName:USERINFO_LEVELBUTTON object:nil];
    }else if (btn.tag == PersonHeaderViewVBtnTag){
        [[NSNotificationCenter defaultCenter] postNotificationName:USERINFO_VBUTTON object:nil];
    }
}

+(CGFloat )getHeight
{
    return 170;
    //return 200;
}

@end
