//
//  UserBriefInfoView.m
//  hinabian
//
//  Created by hnbwyh on 16/7/25.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "UserBriefInfoView.h"
#import "PersonInfoModel.h"

#define Distance    8

@interface UserBriefInfoView ()

@property (nonatomic,strong) PersonInfoModel *currentModel;

@end

@implementation UserBriefInfoView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.needNextLine = NO;
        
        CGRect rect = frame;
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(Distance * 2, rect.size.height/2 - 8, 16 , 16)];
        self.icon.contentMode = UIViewContentModeScaleAspectFill;
        self.icon.clipsToBounds = YES;
        self.icon.layer.cornerRadius = 8.f;//CGRectGetWidth(self.userIcon.frame);
        
        rect.origin.y = self.icon.origin.y;
        rect.origin.x = CGRectGetMaxX(self.icon.frame) + Distance/2;
        rect.size.width = 60.f;
        rect.size.height = 16.f;
        self.itemTitle = [[UILabel alloc] initWithFrame:rect];
        
        rect.origin.x = CGRectGetMaxX(self.itemTitle.frame) + Distance;
        rect.size.width = SCREEN_WIDTH - CGRectGetMaxX(self.itemTitle.frame) - Distance * 3;
        self.content.numberOfLines = 0;
        self.content = [[UILabel alloc] initWithFrame:rect];
        
//        rect.origin.x = 0;
//        rect.origin.y = 0;
//        rect.size.width = SCREEN_WIDTH;
//        rect.size.height = frame.size.height;
//        self.eventButton = [[UIButton alloc] initWithFrame:rect];
//        [self.eventButton addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [self modifyLabel:self.itemTitle color:[UIColor blackColor] font:FONT_UI24PX alignment:NSTextAlignmentLeft];
        [self modifyLabel:self.content color:[UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:0.5] font:FONT_UI24PX alignment:NSTextAlignmentRight]; //#323232
        
        [self addSubview:self.icon];
        [self addSubview:self.itemTitle];
        [self addSubview:self.content];
        [self addSubview:self.eventButton];
        
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)modifyLabel:(UILabel *)label color:(UIColor *)color font:(CGFloat)font alignment:(NSTextAlignment)alignment{
    
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.textAlignment = alignment;
    
}


- (void)setUserBriefInfoViewWithInfo:(id)info{

    PersonInfoModel *f = (PersonInfoModel *)info;
    _currentModel = f;
    
    if (f.certified.length != 0) {
        self.icon.hidden = YES;
        self.itemTitle.text = @"认证说明";
    }else{
        self.icon.image = [UIImage imageNamed:@"userInfo_expert_icon"];
        self.itemTitle.text = @"个性签名";
    }
    
    self.content.text = f.introduce;
    CGRect rect = [self.content.text boundingRectWithSize:CGSizeMake(self.content.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_UI24PX]} context:nil];
    CGSize textSize = [self.content.text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FONT_UI24PX]}];
    NSUInteger textRow = (NSUInteger)(rect.size.height / textSize.height);
    if (f.certified.length != 0) {  /*认证用户、专家、官方*/
        [self.itemTitle setFrame:CGRectMake(Distance * 2, self.icon.origin.y, 60.f, 16.f)];
         //专家与普通人的不同颜色
        self.content.textColor = [UIColor blackColor];
         //大于等于两行
        if (textRow >= 2) {
            [self.itemTitle setFrame:CGRectMake(Distance * 2, self.icon.origin.y - 8, 60.f, 16.f)];
            [self setContentWhileLongText];
        }
        
    }else{  /*普通用户*/
        self.content.textColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:0.5];
        
         //大于等于两行
        if (textRow >= 2) {
            [self setContentWhileLongText];
        }
    }
    
    
    // 为空时的缺省文本
    if (f.introduce.length == 0 && ![f.type isEqualToString:@"special"]) {
        
        self.content.text = @"TA很懒,什么都没写";
    }else if (f.introduce.length == 0 && [f.type isEqualToString:@"special"]){
        self.content.text = @"";
    }
}

-(void)setHeightWithInfo:(NSString *)introduce
{
    CGRect rect = [introduce boundingRectWithSize:CGSizeMake(self.content.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_UI24PX]} context:nil];
    CGSize textSize = [introduce sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FONT_UI24PX]}];
    NSUInteger textRow = (NSUInteger)(rect.size.height / textSize.height);
    if (textRow >= 2) {
        self.needNextLine = YES;
    }else{
        self.needNextLine = NO;
    }
}

- (void)setContentWhileLongText
{
    self.content.numberOfLines = 2;
    self.content.textAlignment = NSTextAlignmentLeft;
    
    CGRect rect = self.content.frame;
    rect.origin.y = self.itemTitle.origin.y;
    rect.size.height = self.frame.size.height/2;
    rect.origin.x = CGRectGetMaxX(self.itemTitle.frame) + Distance * 3;
    rect.size.width = SCREEN_WIDTH - CGRectGetMaxX(self.itemTitle.frame) - Distance * 4;
    [self.content setFrame:rect];
}

//- (void)clickEvent:(UIButton *)btn{
//
//    //NSLog(@" 专家介绍 ====== > %s",__FUNCTION__);
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:USERINFO_BRIEFINFOBUTTON object:_currentModel];
//}

@end
