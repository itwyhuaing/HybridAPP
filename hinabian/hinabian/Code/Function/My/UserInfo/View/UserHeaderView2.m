//
//  UserHeaderView2.m
//  hinabian
//
//  Created by 何松泽 on 16/12/15.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "UserHeaderView2.h"
#import "PersonInfoModel.h"


@interface UserHeaderView2 ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UIImageView *vImageView;
@property (weak, nonatomic) IBOutlet UIImageView *levelImage;
@property (weak, nonatomic) IBOutlet UIImageView *moderatorImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UILabel *imstatus;
@property (weak, nonatomic) IBOutlet UILabel *ImDestinationPlace;
@property (weak, nonatomic) IBOutlet UILabel *vLabel;
@property (weak, nonatomic) IBOutlet UILabel *btnLine;
@property (weak, nonatomic) IBOutlet UILabel *tmpLabel;
@property (weak, nonatomic) IBOutlet UIButton *careButton;
@property (weak, nonatomic) IBOutlet UIButton *msgButton;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UIButton *vButton;
@property (weak, nonatomic) IBOutlet UIButton *levelButton;
@property (weak, nonatomic) IBOutlet UIView *borderView;


@property (nonatomic,strong) PersonInfoModel *currentModel;

@end



@implementation UserHeaderView2

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.clipsToBounds = YES;
    
    /*设置白边*/
    [self setImageBorder:self.vImageView];
    [self setImageBorder:self.levelImage];
    [self setImageBorder:self.moderatorImage];
    
    /*头像边框*/
    self.borderView.backgroundColor = [UIColor DDR81_G197_B241ColorWithalph:1.f];
    self.borderView.layer.cornerRadius = 76.f/2;
    self.borderView.layer.masksToBounds = YES;
    self.borderView.clipsToBounds = YES;
    self.borderView.layer.shouldRasterize = YES;
    self.borderView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    /*不能直接取头像的Frame,100.f为头像的直径，暂且为固定值*/
    self.userIcon.layer.cornerRadius = 70.f/2;
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.clipsToBounds = YES;
    self.userIcon.layer.shouldRasterize = YES;
    self.userIcon.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
//    self.vLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    self.vLabel.font = [UIFont systemFontOfSize:12.5f];
    self.userName.textColor = [UIColor whiteColor];
    self.userName.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_UI32PX];
    self.line.backgroundColor = [UIColor colorWithRed:255.f/255.f green:255.f/255.f blue:255.f/255.f alpha:0.3f];
    self.btnLine.backgroundColor = [UIColor colorWithRed:255.f/255.f green:255.f/255.f blue:255.f/255.f alpha:0.3f];
    
    [self modifyLabel:self.imstatus];
    [self modifyLabel:self.ImDestinationPlace];
    [self modifyLabel:self.tmpLabel];
    
    self.imstatus.textAlignment = NSTextAlignmentRight;
    self.ImDestinationPlace.textAlignment = NSTextAlignmentLeft;
    self.tmpLabel.textAlignment = NSTextAlignmentLeft;
    
//    self.vLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"userinfo_certification_icon"]];
//    self.vLabel.textColor = [UIColor DDR255_G104_B47ColorWithalph:1.f];
//    self.vLabel.layer.cornerRadius = 8.f;
//    self.vLabel.layer.masksToBounds = YES;
    
    [self modifyButton:self.careButton image:[UIImage imageNamed:@"userinfo_follow_btn_default"]];
    [self modifyButton:self.msgButton image:[UIImage imageNamed:@"userinfo_privateletter_btn_default"]];
    
    self.careButton.tag = UserHeaderViewCareBtnTag;
    self.msgButton.tag = UserHeaderViewMsgBtnTag;
    self.vButton.tag = UserHeaderViewVBtnTag;
    self.levelButton.tag = UserHeaderViewLevelBtnTag;
    
    self.moderatorImage.hidden = YES;
    self.careButton.hidden = YES;
    self.msgButton.hidden = YES;
    self.vButton.hidden = YES;
    self.levelButton.hidden = NO;
    self.line.hidden = YES;
    
//    self.careButtonLeadingConstraint.constant = 65.0 * SCREEN_WIDTHRATE_6;
//    self.msgButtonTrailingConstraint.constant = 65.0 * SCREEN_WIDTHRATE_6;
    
    [self.headButton addTarget:self action:@selector(clickHeadButon:) forControlEvents:UIControlEventTouchUpInside];
    [self.vButton addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.levelButton addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setImageBorder:(UIView *)view
{
    view.layer.cornerRadius = 2.0f;
    view.layer.borderWidth = 0.5f;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.masksToBounds = YES;
    view.clipsToBounds = YES;
    view.layer.shouldRasterize = YES;
    view.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)modifyLabel:(UILabel *)label{
    
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:FONT_UI24PX];
    label.textAlignment = NSTextAlignmentLeft;
    
}

- (void)modifyButton:(UIButton *)btn image:(UIImage *)image{

    [btn setAdjustsImageWhenHighlighted:NO];
    //[btn setBackgroundImage:[UIColor createImageWithColor:[UIColor DDR81_G197_B241ColorWithalph:1.f]] forState:UIControlStateNormal];
    //[btn setBackgroundImage:[UIColor createImageWithColor:[UIColor DDR59_G189_B239ColorWithalph:1.f]] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIColor createImageWithColor:[UIColor DDR129_G194_B255ColorWithalph:1.0]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIColor createImageWithColor:[UIColor DDR147_G203_B255ColorWithalph:1.0]] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:FONT_UI28PX];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 0)];
    [btn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setUserHeaderViewWithInfo:(id)info{
    
    PersonInfoModel *f = (PersonInfoModel *)info;
    _currentModel = f;
    
    if (f.certified.length == 0) {
        //非认证用户
        self.tmpLabelTopNameLabel.constant = 10.f;
        self.tmpLabelYborderViewCenter.constant = 12.f;
    }else{
        //认证用户
        self.tmpLabelTopNameLabel.constant = 7.f;
        self.tmpLabelYborderViewCenter.constant = 4.f;
    }
    
    [self.bgImageView setImage:[UIImage imageNamed:@"userinfo_content_bg"]];
    self.bgImageView.backgroundColor = [UIColor DDNavBarBlue];
    if (f.bg_url.length != 0) {
        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:f.bg_url]];
    }
    
    /*判断用户身份*/
    if (f.moderator && f.moderator.count != 0) {
        self.moderatorImage.hidden = NO;
        [self.moderatorImage setImage:[UIImage imageNamed:@"moderator"]];
        if (f.certified.length == 0) {
            self.moderatorImageLeadingLevelImage.constant = 5.f;
        }else{
            self.moderatorImageLeadingLevelImage.constant = 30.f;
        }
    }
    
    self.userIcon.backgroundColor = [UIColor clearColor];
    if (f.head_url.length != 0) {
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:f.head_url]];
    }
    
    if (f.name.length == 0) {
        self.userName.text = @"";
    }else{
        self.userName.text = f.name;
    }
    
    if ([f.isFollow isEqualToString:@"1"]) {
        [self modifyButton:self.careButton image:[UIImage imageNamed:@"userinfo_follow_btn_pressed"]];
        [self.careButton setTitle:@"已关注" forState:UIControlStateNormal];
    }else{
        [self modifyButton:self.careButton image:[UIImage imageNamed:@"userinfo_follow_btn_default"]];
        [self.careButton setTitle:@"关注" forState:UIControlStateNormal];
    }
    [self.msgButton setTitle:@"私信" forState:UIControlStateNormal];
    
    self.careButton.hidden = NO;
    self.msgButton.hidden = NO;
    
    [self setValuesForLabelsWith:f];
    [self setLevelByInfo:f];
}


- (void)clickEvent:(UIButton *)btn{
    
    //NSLog(@" 关注与发消息 ====== > %ld",btn.tag);

    if (btn.tag == UserHeaderViewCareBtnTag && _currentModel) {
        NSDictionary *info = @{
                               @"btn":btn,
                               @"model":_currentModel
                               };
        [[NSNotificationCenter defaultCenter] postNotificationName:USERINFO_CAREBUTTON object:info];
        
    }else if(btn.tag == UserHeaderViewMsgBtnTag){
        
        /*
         ** 需要判断是否关注了该用户（只有关注了才允许私信。注意！！！专家号除外）
         */
        if ([_currentModel.is_Need_Follow isEqualToString:@"1"] && [_currentModel.isFollow isEqualToString:@"0"]) {
            [[HNBToast shareManager] toastWithOnView:self.superview msg:@"私信Ta，要先关注Ta哦" afterDelay:1.f style:HNBToastHudOnlyText];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:USERINFO_MSGBUTTON object:_currentModel];
        }
        
    }else if (btn.tag == UserHeaderViewVBtnTag){
        [[NSNotificationCenter defaultCenter] postNotificationName:USERINFO_VBUTTON object:_currentModel];
    }else if (btn.tag == UserHeaderViewLevelBtnTag){
        [[NSNotificationCenter defaultCenter] postNotificationName:USERINFO_LEVELBUTTON object:_currentModel];
    }
    
}

- (void)clickHeadButon:(UIButton *)btn{
    [[NSNotificationCenter defaultCenter] postNotificationName:USERINFO_HEADBUTTON object:_currentModel];
}

#pragma mark ------ 不同情况下的布局与赋值

- (void)setLevelByInfo:(PersonInfoModel *)f{
    /*判断用户等级*/
    if (f.level) {
        [self.levelImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"LV%@",f.level]]];
    }
}

- (void)setValuesForLabelsWith:(PersonInfoModel *)f{
    if ([f.type isEqualToString:@"special"]) {
        /*用户为专家*/
        self.imstatus.hidden = YES;
        self.ImDestinationPlace.hidden = YES;
        self.line.hidden = YES;
        self.vButton.hidden = NO;
        [self.vImageView setImage:[UIImage imageNamed:@"specialist"]];
        if (f.leftText.length != 0 && f.rightText.length != 0){
            self.tmpLabel.hidden = NO;
            self.vLabel.text = [NSString stringWithFormat:@"海那边认证：%@",f.leftText]; //专家显示专家标签
            self.tmpLabel.text = [NSString stringWithFormat:@"好评率：%@%@",f.rightText,@"%"];
        }else if (f.leftText.length == 0 && f.rightText.length != 0){
            self.tmpLabel.hidden = NO;
            self.vLabel.hidden = YES;
            self.vImageView.center = CGPointMake(SCREEN_WIDTH/2, self.vImageView.center.y);
            self.tmpLabel.text = [NSString stringWithFormat:@"好评率：%@%@",f.rightText,@"%"];
        }else if (f.rightText.length == 0 && f.leftText.length != 0){
            self.tmpLabel.hidden = YES;
            self.vLabel.text = [NSString stringWithFormat:@"海那边认证：%@",f.leftText]; //专家显示专家标签
        }
        
    }else{
        if (f.leftText.length != 0 && f.rightText.length != 0) { // 左右样式
            self.imstatus.hidden = NO;
            self.ImDestinationPlace.hidden = NO;
            self.line.hidden = NO;
            self.tmpLabel.hidden = YES;
            self.imstatus.text = f.leftText;
            self.ImDestinationPlace.text = f.rightText;
        }else if (f.leftText.length == 0 && f.rightText.length != 0){ // 居中样式
            self.tmpLabel.hidden = NO;
            self.imstatus.hidden = YES;
            self.ImDestinationPlace.hidden = YES;
            self.line.hidden = YES;
            self.tmpLabel.text = f.rightText;
        }else if (f.rightText.length == 0 && f.leftText.length != 0){ // 居中样式
            self.tmpLabel.hidden = NO;
            self.imstatus.hidden = YES;
            self.ImDestinationPlace.hidden = YES;
            self.line.hidden = YES;
            self.tmpLabel.text = f.leftText;
        }else{
            self.tmpLabel.hidden = YES;
            self.imstatus.hidden = YES;
            self.ImDestinationPlace.hidden = YES;
            self.line.hidden = YES;
        }
        if (f.certified.length != 0){
            /*用户为认证用户*/
            if ([f.certified rangeOfString:@"移民专家,"].location == NSNotFound ) {
                self.vLabel.text = [NSString stringWithFormat:@"海那边认证：%@",f.certified]; //认证用户显示认证标签
            }else{
                //如果带有移民专家的不显示
                NSMutableString *certifiedStr = [[NSMutableString alloc] initWithString:f.certified];
                NSRange range = [certifiedStr rangeOfString:@"移民专家,"];
                [certifiedStr deleteCharactersInRange:range];
                self.vLabel.text = [NSString stringWithFormat:@"海那边认证：%@",certifiedStr]; //认证用户显示认证标签
            }
            if ([f.certified_type isEqualToString:@"authority"]) {
                [self.vImageView setImage:[UIImage imageNamed:@"authority"]];
            }else{
                [self.vImageView setImage:[UIImage imageNamed:@"tribe_talent"]];
            }
            self.vButton.hidden = NO;
        }else{
            /*用户为普通用户*/       
            self.vLabel.hidden = YES;
            self.vImageView.hidden = YES;
            self.vButton.hidden = YES;
        }
    }
    
}

@end
