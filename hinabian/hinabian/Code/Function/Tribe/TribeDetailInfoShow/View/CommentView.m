

//
//  CommentView.m
//  TextImageDemo
//
//  Created by hnbwyh on 16/10/9.
//  Copyright © 2016年 hnbwyh. All rights reserved.
//

#import "CommentView.h"
#import "FloorCommentReplyModel.h"
#import "FloorCommentUserInfoModel.h"
#import "YYLabel.h"
#import "YYText.h"
#import "HTMLContentModel.h"

@interface CommentView ()

@property (nonatomic ,strong) FloorCommentReplyModel *userInfoModel;

@end

@implementation CommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /**< 创建 >*/
        _userName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_userName];
        
        _date = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_date];
        
        _content = [YYLabel new];
        [self addSubview:_content];
        
        /**< 约束 >*/
        _userName.sd_layout
        .topSpaceToView(self,GAP_S)
        .leftSpaceToView(self,GAP_S)
        .heightIs(ICON_WH/2.f)
        .widthRatioToView(self,0.5f);
        
        _date.sd_layout
        .topEqualToView(_userName)
        .rightSpaceToView(self,GAP_S)
        .heightRatioToView(_userName,1.f)
        .widthRatioToView(self,0.5);
        
        _content.sd_layout
        .topSpaceToView(_userName,GAP_S)
        .leftEqualToView(_userName)
        .heightIs(0.f)
        .widthIs(SCREEN_WIDTH - GAP_S * 4.f);

        /**< 属性设置 >*/
        [self modifyLabel:_userName font:FONT_UI28PX alignment:NSTextAlignmentLeft color:[UIColor DDR63_G162_B255ColorWithalph:1.0]];
        [self modifyLabel:_date font:FONT_UI20PX alignment:NSTextAlignmentRight color:[UIColor DDR153_G153_B153ColorWithalph:1.0]];
        _content.font = [UIFont systemFontOfSize:FONT_UI28PX];
        _content.numberOfLines = 0;
        _content.textAlignment = NSTextAlignmentLeft;
        //[_content setTextColor:[UIColor DDR51_G51_B51ColorWithalph:1.0]];
        self.backgroundColor = [UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.f];

        /**< 用户名点击事件 >*/
        UITapGestureRecognizer *userNameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEventFromCommentViewTap:)];
        _userName.userInteractionEnabled = YES;
        [_userName addGestureRecognizer:userNameTap];
        
    }
    return self;
}


#pragma mark ------ modifyLabel

- (void)modifyLabel:(UILabel *)label font:(CGFloat)font alignment:(NSTextAlignment)alignment color:(UIColor *)color{

    label.font = [UIFont systemFontOfSize:font];
    label.numberOfLines = 0;
    label.textAlignment = alignment;
    [label setTextColor:color];
    
}

- (void)setContentsWithFloorCommentReplyModel:(FloorCommentReplyModel *)model{

    _userInfoModel = model;
    
    _userName.text = model.u_info.name;
    _date.text = model.show_time;
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    UIFont *font = REPLY_FLOOR_TEXT_FONT;
    _content.userInteractionEnabled = YES;
    _content.numberOfLines = 0;
    _content.textVerticalAlignment = YYTextVerticalAlignmentTop;
    NSArray *replyContents = model.replyContentArr;
    for (NSInteger cou = 0; cou < replyContents.count; cou ++) {
        
        HTMLContentModel *f = replyContents[cou];
        
        if (f.tagType == HTMLContentModelTagPText) {
            
            // text
            NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:f.textString];
            one.yy_font = font;
            one.yy_color = [UIColor DDR51_G51_B51ColorWithalph:1.0];
            one.yy_kern = [NSNumber numberWithFloat:KERN_SPACE];
            one.yy_lineSpacing = LINE_SPACE;
            [text appendAttributedString:one];
            //[text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
            
        } else if(f.tagType == HTMLContentModelTagImg){
            
            // 是否 以 https: 开头
            NSString *imgURLString = f.imgURLString;
            if (![imgURLString hasPrefix:@"http"]) {
                NSMutableString *tmp = [NSMutableString stringWithString:@"https:"];
                [tmp appendString:imgURLString];
                imgURLString = [NSString stringWithFormat:@"%@",tmp];
            }
            
            // 小图
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.clipsToBounds = YES;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.size = CGSizeMake(f.imgWidth, f.imgHeight);
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgURLString] placeholderImage:[UIImage imageNamed:@"homePage_tribe_post"]];
            //[imgView startAnimating];
            NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imgView
                                                                                                  contentMode:UIViewContentModeScaleAspectFill
                                                                                               attachmentSize:CGSizeMake(f.imgWidth, f.imgHeight)
                                                                                                  alignToFont:font
                                                                                                    alignment:YYTextVerticalAlignmentCenter];
            [text appendAttributedString:attachText];
            
        }
        
    }
    _content.attributedText = text;
    [_content sizeToFit];

}


#pragma mark ------ tooMethod 

#pragma mark 

- (void)clickEventFromCommentViewTap:(UITapGestureRecognizer *)tap{

    UILabel *l = (UILabel *)tap.view;
    
    //NSLog(@" 点击获取到的 _userInfoModel.u_info.id %@",_userInfoModel.u_info.id);
    
    if (_eventBlock) {
        _eventBlock(l,_userInfoModel.u_info.id);
    }
    
}


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
