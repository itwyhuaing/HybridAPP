//
//  ReplyTableViewCell.m
//  TextImageDemo
//
//  Created by hnbwyh on 16/10/8.
//  Copyright © 2016年 hnbwyh. All rights reserved.
//

#import "ReplyTableViewCell.h"
#import "CommentView.h"
#import "YYText.h"
#import "TribeDetailInfoCellManager.h"
#import "FloorCommentModel.h"
#import "FloorCommentReplyModel.h"
#import "FloorCommentUserInfoModel.h"

#import "YYLabel.h"
#import "YYImage.h"
#import "YYText.h"
#import "HTMLContentModel.h"
//#import "NSDictionary+ValueForKey.h"

@interface ReplyTableViewCell ()<YYTextViewDelegate>

@property (nonatomic,strong) YYLabel *yyLable;
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *userName;
@property (nonatomic,strong) UIImageView *certyfiedImageView;
@property (nonatomic,strong) UIImageView *levelImageView;
@property (nonatomic,strong) UIImageView *moderatorView;
@property (nonatomic,strong) UILabel *imStatus; // 移民状态
@property (nonatomic,strong) UILabel *dateAndFloorNum;
@property (nonatomic,strong) UIImageView *operations; // 举报图片
@property (nonatomic,strong) UIButton *reportBtn; // 举报按钮

@property (nonatomic,strong) UIButton *suportNum; // 点赞
@property (nonatomic,strong) UILabel *suportLable; // 赞数
@property (nonatomic,strong) UIButton *supportBtn; // 增大点赞区域
@property (nonatomic,strong) UIButton *comment; // 评论

@property (nonatomic,strong) CommentView *lastCommentView; // 记录上一个 CommentView

@end

@implementation ReplyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
       // [self setUpCell];
        
    }
    return self;
}

-(void)setManager:(TribeDetailInfoCellManager *)manager{
    
    __weak typeof(self) _self= self;
    /**< 赋值 >*/
    _manager = manager;
    
    /**< 重新布局固定 subViews >*/
    [self setUpCell];
    
    /**< 楼层评论 - 重新布局与赋值 >*/
    [self setUpCellWithModel:manager.model];
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    UIFont *font = FLOOR_TEXT_FONT;
    _yyLable.userInteractionEnabled = YES;
    _yyLable.numberOfLines = 0;
    _yyLable.textVerticalAlignment = YYTextVerticalAlignmentTop;
    
    /**< 楼层评论 - 重新布局与赋值 >*/
    NSArray *floorContentArr = manager.model.floorContentArr;
    for (NSInteger cou = 0; cou < floorContentArr.count; cou ++) {
        
        HTMLContentModel *f = floorContentArr[cou];

        switch (f.tagType) {
            case HTMLContentModelTagPText:
            {
                NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:f.textString];
                one.yy_font = font;
                one.yy_color = [UIColor DDR51_G51_B51ColorWithalph:1.0];
                one.yy_kern = [NSNumber numberWithFloat:KERN_SPACE];
                one.yy_lineSpacing = LINE_SPACE;
                [text appendAttributedString:one];
                //[text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
                
            }
                break;
            case HTMLContentModelTagImg:
            {
                // 是否 以 https: 开头
                NSString *imgURLString = f.imgURLString;
                if (![imgURLString hasPrefix:@"http"]) {
                    NSMutableString *tmp = [NSMutableString stringWithString:@"https:"];
                    [tmp appendString:imgURLString];
                    imgURLString = [NSString stringWithFormat:@"%@",tmp];
                }
                
                //NSLog(@" imgURLString =  %@ ",imgURLString);
                
                if (f.imgWidth <= DIFFER_BIG_SMALL_IMAGE) { // 小图
                    
                    UIImageView *imgView = [[UIImageView alloc] init];
                    imgView.clipsToBounds = YES;
                    imgView.contentMode = UIViewContentModeScaleAspectFill;
                    imgView.size = CGSizeMake(f.imgWidth, f.imgHeight);
                    [imgView sd_setImageWithURL:[NSURL URLWithString:imgURLString] placeholderImage:[UIImage imageNamed:@"homePage_tribe_post"]];
                    //[imgView startAnimating];
                    //imgView.backgroundColor = [UIColor redColor];
                    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imgView
                                                                                                          contentMode:UIViewContentModeScaleAspectFill
                                                                                                       attachmentSize:CGSizeMake(f.imgWidth, f.imgHeight)
                                                                                                          alignToFont:font
                                                                                                            alignment:YYTextVerticalAlignmentCenter];
                    [text appendAttributedString:attachText];
                    
                    
                } else {
                    
                    [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
                    UIImageView *imgView = [[UIImageView alloc] init];
                    imgView.clipsToBounds = YES;
                    imgView.contentMode = UIViewContentModeScaleAspectFill;
                    imgView.size = CGSizeMake(f.imgWidth, f.imgHeight);
                    [imgView sd_setImageWithURL:[NSURL URLWithString:imgURLString] placeholderImage:[UIImage imageNamed:@"homePage_tribe_post"]];
                    //[imgView startAnimating];
                    NSMutableAttributedString *attatchText = [NSMutableAttributedString yy_attachmentStringWithContent:imgView
                                                                                                           contentMode:UIViewContentModeScaleAspectFill
                                                                                                        attachmentSize:CGSizeMake(f.imgWidth, f.imgHeight)
                                                                                                           alignToFont:font
                                                                                                             alignment:YYTextVerticalAlignmentCenter];
                    [text appendAttributedString:attatchText];
                    [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
                    [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
                    
                }

                
            }
                break;
            case HTMLContentModelTagHref:
            {

                NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:f.hyperTitle];
                one.yy_font = font;
                one.yy_lineSpacing = LINE_SPACE;
                //one.yy_underlineStyle = NSUnderlineStyleSingle;
                [one yy_setTextHighlightRange:one.yy_rangeOfAll
                                        color:[UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000]
                              backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                                    tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                        
                                        [_self clickEvent:[NSString stringWithFormat:@"hyper:%@",f.hyperLink]];
                                        
                                    }];
                
                [text appendAttributedString:one];
            }
                break;
            case HTMLContentModelTagBr:
            {
                [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
            }
                break;
            default:
                break;
        }
        
        
        
    }
    
    _yyLable.attributedText = text;
    [_yyLable sizeToFit];
    _yyLable.sd_layout
    .topSpaceToView(_icon,GAP_S)
    .leftEqualToView(_icon)
    .heightIs(manager.floorCommentSize.height)
    .widthIs(manager.floorCommentSize.width);
    
    /**< 点赞按钮 与 评论按钮是否显示 >*/
    if (_cellStyle == ReplyTableViewCellReplyDetail) {
        
        _comment.hidden = YES;
        _suportNum.hidden = YES;
        _suportLable.hidden = YES;
        _supportBtn.hidden = YES;
        
    }else{
    
        _comment.hidden = NO;
        _suportNum.hidden = NO;
        _suportLable.hidden = NO;
        _supportBtn.hidden = NO;
    }
    
    /**< 回复楼层的评论 - 重新布局与赋值 >*/
    NSMutableArray *tmpReplyData = [[NSMutableArray alloc] init];
    if (_cellStyle == ReplyTableViewCellTribeDetail && manager.model.reply_infoArr.count > DISPLAY_REPLY_MAXNUM) {
        
        [tmpReplyData addObjectsFromArray:[manager.model.reply_infoArr subarrayWithRange:NSMakeRange(0, DISPLAY_REPLY_MAXNUM)]];
        
    } else {
        
        [tmpReplyData addObjectsFromArray:manager.model.reply_infoArr];
        
    }

    for (NSInteger cou = 0; cou < tmpReplyData.count; cou ++) {
        
        FloorCommentReplyModel *f = tmpReplyData[cou];
        NSValue *sizeValue = manager.replyFloorCommentHeights[cou];
        CGSize size = [sizeValue CGSizeValue];
        
        CGRect rect = CGRectZero;
        CommentView *v = [[CommentView alloc] initWithFrame:rect];
        v.eventBlock = ^(id eventSource,id info){
            
            [_self clickEvent:[NSString stringWithFormat:@"CommentView_userName:%@",info]];
            
        };
        [self addSubview:v];
        [v setContentsWithFloorCommentReplyModel:f];
        
        
        if (cou == 0 && _cellStyle == ReplyTableViewCellTribeDetail) {
            
            v.sd_layout
            .topSpaceToView(_comment,GAP_S)
            .leftSpaceToView(self,GAP_S)
            .heightIs(size.height)
            .widthIs(SCREEN_WIDTH - GAP_S * 2.f);
            
            
        }else if (cou == 0 && _cellStyle == ReplyTableViewCellReplyDetail){
            
            v.sd_layout
            .topSpaceToView(_yyLable,GAP_S)
            .leftSpaceToView(self,GAP_S)
            .heightIs(size.height)
            .widthIs(SCREEN_WIDTH - GAP_S * 2.f);
            
        } else {
            
            v.sd_layout
            .topSpaceToView(_lastCommentView,0.f)
            .leftEqualToView(_lastCommentView)
            .heightIs(size.height)
            .widthRatioToView(_lastCommentView,1.0);
            
        }
        
        
        v.content.sd_layout
        .topSpaceToView(v.userName,GAP_S)
        .leftEqualToView(v.userName)
        .heightIs(size.height - 50.f)
        .widthIs(SCREEN_WIDTH - GAP_S * 4.f);
        
        // 是否查看更多
        if (cou == (tmpReplyData.count - 1) && manager.seeMoreHeight != 0 && _cellStyle == ReplyTableViewCellTribeDetail) {
            
            
            YYLabel *label = [YYLabel new];
            label.textVerticalAlignment = YYTextVerticalAlignmentTop;
            [self addSubview:label];
            UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
            [label addSubview:btn];
            
            label.sd_layout
            .topSpaceToView(v,0.f)
            .leftSpaceToView(self,GAP_S)
            .rightSpaceToView(self,GAP_S)
            .heightIs(manager.seeMoreHeight);
            
            btn.sd_layout
            .topSpaceToView(label,0.f)
            .leftSpaceToView(label,0.f)
            .rightSpaceToView(label,0.f)
            .heightIs(manager.seeMoreHeight);
            
            [label setText:@"   查看更多回复"];
            label.font = [UIFont systemFontOfSize:FONT_UI28PX];
            [label setTextColor:[UIColor DDR63_G162_B255ColorWithalph:1.0]];
            btn.tag = ReplyTableViewCellSeeMoreTag;
            [btn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
            label.backgroundColor = [UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.f];
        }
        
        _lastCommentView = v;
        
    }

}

#pragma mark ------ setUpCell

- (void)setUpCell{
    
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    /**< 创建 >*/
    _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_icon];
    
    _userName = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_userName];
    
    _certyfiedImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_certyfiedImageView];
    
    _levelImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_levelImageView];
    
    _moderatorView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_moderatorView];
    
    _imStatus = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_imStatus];
    
    _operations = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_operations];
    
    _reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_reportBtn];
    
    _dateAndFloorNum = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_dateAndFloorNum];
    
    // 举报 按钮增大点击区域
    UIButton *opearateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:opearateBtn];
    
    _yyLable = [YYLabel new];
    [self addSubview:_yyLable];
    
    _comment = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_comment];
    
    _suportNum = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_suportNum];
    
    _suportLable = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_suportLable];
    
    // 点赞 按钮增大点击区域
    _supportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_supportBtn];
    
    /**< 自动布局 >*/
    _icon.sd_layout
    .topSpaceToView(self,GAP_S)
    .leftSpaceToView(self,GAP_S)
    .heightIs(ICON_WH)
    .widthIs(ICON_WH);
    
    _userName.sd_layout
    .topEqualToView(_icon)
    .leftSpaceToView(_icon,GAP_S/ 2.f)
    .heightIs(ICON_WH/ 2.f)
    .widthIs(80.0);// SCREEN_WIDTH / 3.f
    
    _levelImageView.sd_layout
    .leftSpaceToView(_userName,5.f)
    .centerYEqualToView(_userName)
    .heightIs(10.f)
    .widthIs(20.f);
    
    _certyfiedImageView.sd_layout
    .leftSpaceToView(_levelImageView,5.f)
    .centerYEqualToView(_userName)
    .heightIs(10.f)
    .widthIs(20.f);
    
    _moderatorView.sd_layout
    .leftSpaceToView(_certyfiedImageView,5.f)
    .centerYEqualToView(_userName)
    .heightIs(10.f)
    .widthIs(20.f);
    
    _imStatus.sd_layout
    .topSpaceToView(_userName,0)
    .leftEqualToView(_userName)
    .heightIs(ICON_WH/2.f)
    .rightSpaceToView(self,GAP_S);
    
    _operations.sd_layout
    .rightSpaceToView(self,GAP_S)
    .centerYEqualToView(_userName)
    .heightIs(BUTTON_BIG_H)
    .widthIs(BUTTON_BIG_H);
    
    _reportBtn.sd_layout
    .topSpaceToView(_operations,0.f)
    .rightSpaceToView(self,GAP_S)
    .heightIs(REPORT_H)
    .widthIs(REPORT_W);
    
    _dateAndFloorNum.sd_layout
    .rightSpaceToView(_operations,GAP_S)
    .centerYEqualToView(_operations)
    .heightIs(BUTTON_BIG_H)
    .leftSpaceToView(_certyfiedImageView,0);
    
    opearateBtn.sd_layout
    .rightSpaceToView(self,GAP_S)
    .centerYEqualToView(_operations)
    .heightIs(BUTTON_BIG_H)
    .widthIs(80.f);
    
    _yyLable.sd_layout
    .topSpaceToView(_icon,GAP_S)
    .leftEqualToView(_icon)
    .heightIs(0.f)
    .widthIs(SCREEN_WIDTH - GAP_S * 2.f);
    
    _comment.sd_layout
    .rightSpaceToView(self,GAP_S)
    .topSpaceToView(_yyLable,GAP_S)
    .heightIs(BUTTON_BIG_H)
    .widthIs(BUTTON_BIG_H);
    
    _suportLable.sd_layout
    .rightSpaceToView(_comment,5.0)
    .centerYEqualToView(_comment)
    .heightIs(BUTTON_BIG_H)
    .widthIs(20.0);
    
    _suportNum.sd_layout
    .rightSpaceToView(_suportLable,2.f)
    .centerYEqualToView(_comment)
    .heightIs(BUTTON_BIG_H * 0.8)
    .widthIs(BUTTON_BIG_H * 0.8);
    
    _supportBtn.sd_layout
    .centerXEqualToView(_suportNum)
    .centerYEqualToView(_suportNum)
    .heightRatioToView(_suportNum,2.0)
    .widthRatioToView(_suportNum,2.0);
    
    /**< 属性设置 >*/
    _icon.layer.cornerRadius = ICON_WH / 2.f;
    _icon.clipsToBounds = YES;
    _icon.contentMode = UIViewContentModeScaleAspectFill;
    _operations.contentMode = UIViewContentModeScaleAspectFit;
    _userName.font = [UIFont systemFontOfSize:FONT_UI28PX];
    _imStatus.font = [UIFont systemFontOfSize:FONT_UI20PX];
    _dateAndFloorNum.font = [UIFont systemFontOfSize:FONT_UI20PX];
    _suportLable.font = [UIFont systemFontOfSize:FONT_UI20PX];
    _userName.textAlignment = NSTextAlignmentLeft;
    _imStatus.textAlignment = NSTextAlignmentLeft;
    _dateAndFloorNum.textAlignment = NSTextAlignmentRight;
    _suportLable.textAlignment = NSTextAlignmentLeft;
    _suportLable.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0];
    _userName.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0];
    _imStatus.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0];
    _dateAndFloorNum.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0];
    _reportBtn.hidden = YES;
    _reportBtn.layer.borderWidth = 0.5;
    _reportBtn.layer.borderColor = [UIColor DDR238_G238_B238ColorWithalph:1.0].CGColor;
    _reportBtn.backgroundColor = [UIColor whiteColor];
    [_reportBtn setTitleColor:[UIColor DDR153_G153_B153ColorWithalph:1.0] forState:UIControlStateNormal];
    _reportBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_UI28PX];
    
    /**< 赋值 >*/
    [_reportBtn setTitle:@"举报" forState:UIControlStateNormal];
    [_operations setImage:[UIImage imageNamed:@"tribe_detailThem_repeat"]];
    [_suportNum setBackgroundImage:[UIImage imageNamed:@"tribe_show_zan"] forState:UIControlStateNormal];
    [_comment setBackgroundImage:[UIImage imageNamed:@"index_icon_pinglun"] forState:UIControlStateNormal];
    
    /**< 点击事件 >*/
    _icon.tag = ReplyTableViewCellIconTag;
    opearateBtn.tag = ReplyTableViewCellOperationTag;
    _comment.tag = ReplyTableViewCellCommentTag;
    _supportBtn.tag = ReplyTableViewCellSupportTag;
    _reportBtn.tag = ReplyTableViewCellReportTag;
    [_comment addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_supportBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_reportBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [opearateBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *icontap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEvent:)];
    _icon.userInteractionEnabled = YES;
    [_icon addGestureRecognizer:icontap];
    
}

- (void)setUpCellWithModel:(FloorCommentModel *)model{
    
    /**< 赋值 >*/
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.u_info.head_url]];
    [_userName setText:model.u_info.name];
    NSString *u_im_state_cn = model.u_info.im_state_cn;
    if ([u_im_state_cn isEqualToString:@"移民中"]) {
        model.u_info.im_state_cn = @"已移民";
        u_im_state_cn = @"已移民";
    }
    [_imStatus setText:[NSString stringWithFormat:@"%@  %@",u_im_state_cn,model.u_info.im_nation_cn]];
    [_dateAndFloorNum setText:[NSString stringWithFormat:@"%@ | %@楼",model.show_time,model.floor]];
    
    if ([model.praise isEqualToString:@"0"] || model.praise == nil) {
        [_suportLable setText:@""];
    }else{
        [_suportLable setText:model.praise];
    }
    
    /*认证V*/
    if ([model.u_info.certified_type isEqualToString:@"specialist"]) {
        //专家
        _certyfiedImageView.hidden = NO;
        self.levelImageView.hidden = YES;
        [_certyfiedImageView setImage:[UIImage imageNamed:@"specialist"]];
        
        _certyfiedImageView.sd_layout
        .leftSpaceToView(_userName,5.f)
        .centerYEqualToView(_userName)
        .heightIs(10.f)
        .widthIs(20.f);
        
    }else if ([model.u_info.certified_type isEqualToString:@"authority"]){
        //官方
        _certyfiedImageView.hidden = NO;
        _levelImageView.hidden = YES;
        [_certyfiedImageView setImage:[UIImage imageNamed:@"authority"]];
        
        _certyfiedImageView.sd_layout
        .leftSpaceToView(_userName,5.f)
        .centerYEqualToView(_userName)
        .heightIs(10.f)
        .widthIs(20.f);
    }else{
        if (model.u_info.certified.length != 0) {
            //达人
            _certyfiedImageView.hidden = NO;
            _levelImageView.hidden = NO;
            [_certyfiedImageView setImage:[UIImage imageNamed:@"tribe_talent"]];
            //更换回原来的约束
            _certyfiedImageView.sd_layout
            .leftSpaceToView(_levelImageView,5.f)
            .centerYEqualToView(_userName)
            .heightIs(10.f)
            .widthIs(20.f);
            
        }else{
            //普通用户
            _levelImageView.hidden = NO;
            _certyfiedImageView.hidden = YES;
        }
    }
    const char *cName = [model.u_info.name UTF8String];
    
    /*版主*/
    if (model.u_info.moderator && model.u_info.moderator.count > 0) {
        if (model.u_info.certified.length == 0){
            _moderatorView.sd_layout
            .leftSpaceToView(_levelImageView,5.f)
            .centerYEqualToView(_userName)
            .heightIs(10.f)
            .widthIs(20.f);
        }
        
        [self.moderatorView setImage:[UIImage imageNamed:@"moderator"]];
    }
    /*判断用户等级*/
    if (model.u_info.levelInfo) {
        NSString *level = [model.u_info.levelInfo returnValueWithKey:@"level"];
        [self.levelImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"LV%@",level]]];
    }
    
    /**< 点赞图片是否高亮 >*/
    if (model.praised) {
        [_suportNum setBackgroundImage:[UIImage imageNamed:@"tribe_show_zan_pressed"] forState:UIControlStateNormal];
    } else {
        [_suportNum setBackgroundImage:[UIImage imageNamed:@"tribe_show_zan"] forState:UIControlStateNormal];
    }
    
    /**< 更新约束 >*/
    [_userName sizeToFit];
    if (SCREEN_HEIGHT <= SCREEN_HEIGHT_6 && strlen(cName) > 22 && model.u_info.moderator && model.u_info.moderator.count > 0) {
        _userName.sd_layout
        .topEqualToView(_icon)
        .leftSpaceToView(_icon,GAP_S/ 2.f)
        .heightIs(ICON_WH/ 2.f)
        .widthIs(80.0);// SCREEN_WIDTH / 3.f
    }else{
        CGFloat f = _userName.size.width > (SCREEN_WIDTH * 0.4) ? (SCREEN_WIDTH * 0.4) : _userName.size.width;
        _userName.sd_layout
        .topEqualToView(_icon)
        .leftSpaceToView(_icon,GAP_S/ 2.f)
        .heightIs(ICON_WH/ 2.f)
        .widthIs(f);// SCREEN_WIDTH / 3.f
    }
    
}

#pragma mark clickEvent

- (void)clickEvent:(id)eventSource{
    
    id sendInfo = @"";
    
    if ([eventSource isKindOfClass:[UITapGestureRecognizer class]]){
        
        [HNBClick event:@"107045" Content:nil];
        
        // icon
        sendInfo = _manager.model.u_info.id;
        _reportBtn.hidden = YES;
        
    }else if ([eventSource isKindOfClass:[UILabel class]]){
        
        
        NSLog(@" [UILabel class] ");
        
        _reportBtn.hidden = YES;
        
    }else if ([eventSource isKindOfClass:[UIButton class]]) {
        
        UIButton *btn = (UIButton *)eventSource;
        switch (btn.tag) {
            case ReplyTableViewCellCommentTag:
            {
                [HNBClick event:@"107046" Content:nil];
                
                sendInfo = _manager;
                _reportBtn.hidden = YES;
            }
                break;
            case ReplyTableViewCellOperationTag:
            {
                // Operations
                sendInfo = _manager.model.floorId;
                _reportBtn.hidden = !_reportBtn.hidden;
                return;
            }
                break;
            case ReplyTableViewCellSupportTag:
            {
                [HNBClick event:@"107047" Content:nil];
                
                sendInfo = [NSString stringWithFormat:@"%dFlooId:%@",_manager.model.praised,_manager.model.floorId];
                _reportBtn.hidden = YES;
                
            }
                break;
            case ReplyTableViewCellReportTag:
            {
                
                sendInfo = _manager.model.floorId;
                _reportBtn.hidden = YES;
            }
                break;
            case ReplyTableViewCellSeeMoreTag:
            {
                
                sendInfo = _manager;//[NSString stringWithFormat:@"%@?floor=%@",_manager.model.floorId,_manager.model.floor];
                _reportBtn.hidden = YES;
            }
                break;
                
            default:
                break;
        }
        
        
    }else if ([eventSource isKindOfClass:[NSString class]]){
        
        /*
         1. 来自 CommentView 用户名的点击事件 - 此处eventSource为用户id
         2. 来自超链接
         */
        sendInfo = (NSString *)eventSource;
        _reportBtn.hidden = YES;
        
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(replyTableViewCell:eventSource:info:)]) {
        [_delegate replyTableViewCell:self eventSource:eventSource info:sendInfo];
    }

}


#pragma mark ------ reqNetImage

- (UIImage *)reqNetImageFromURLString:(NSString *)URLString{
    
    __block UIImage *img = nil;
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:URLString]
                      options:0
                                                         progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                                             
                                                         }completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                                             img = image;
                                                         }];
    
    return img;
}

@end
