//
//  BindingSuccessView.m
//  hinabian
//
//  Created by 何松泽 on 16/9/8.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#define PHONE_IMAGE_HEIGT 130

#import "BindingSuccessView.h"


@interface BindingSuccessView()
{
    NSString *bindingPhoneNum;
}

/*完成绑定页面*/
@property (nonatomic,strong) UILabel *phoneNumLabel;
@property (nonatomic,strong) UIImageView *phoneImageView;
@property (nonatomic,strong) UILabel *alertLabel;
@property (nonatomic,strong) UILabel *callLabel;

@end

@implementation BindingSuccessView

- (instancetype)initWithFrame:(CGRect)frame
                 withPhoneNum:(NSString *)phoneNum
{
    self = [super initWithFrame:frame];
    if (self) {
        bindingPhoneNum = phoneNum;
        [self loadViewWithFame:frame];
    }
    return self;
}


- (void)loadViewWithFame:(CGRect)frame{

    _phoneImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"boundphoneic_content_ic"]];
    [_phoneImageView setFrame:CGRectMake((SCREEN_WIDTH - 130)/2, 70, PHONE_IMAGE_HEIGT, PHONE_IMAGE_HEIGT)];
    [self addSubview:_phoneImageView];
    
    _phoneNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70 + PHONE_IMAGE_HEIGT + 25 , SCREEN_WIDTH, 20)];
    _phoneNumLabel.textAlignment = NSTextAlignmentCenter;
    _phoneNumLabel.font = [UIFont systemFontOfSize:FONT_UI26PX];
    _phoneNumLabel.text = [NSString stringWithFormat:@"绑定的手机号：%@",bindingPhoneNum ];
    _phoneNumLabel.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.f];
    [self addSubview:_phoneNumLabel];
    
    _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70 + PHONE_IMAGE_HEIGT + 25 + 10 + 15, SCREEN_WIDTH, 40)];
    _alertLabel.numberOfLines = 2;
    _alertLabel.textColor = [UIColor colorWithRed:170/255.f green:170/255.f  blue:170/255.f  alpha:1.f];
    [self setLabelSpace:_alertLabel withValue:@"您可通过手机号快速登录\n如需更换请联系" withFont:[UIFont systemFontOfSize:FONT_UI22PX] withLineSpacing:5.f];
    [self addSubview:_alertLabel];
    
    _callLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, _alertLabel.frame.origin.y + _alertLabel.frame.size.height + 5, 100, 20)];
    _callLabel.textColor = [UIColor DDR51_G51_B51ColorWithalph:0.8f];
    _callLabel.numberOfLines = 2;
    _callLabel.textAlignment = NSTextAlignmentCenter;
    _callLabel.font = [UIFont systemFontOfSize:FONT_UI22PX];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:DEFAULT_TELNUM]];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    _callLabel.attributedText = content;
    [self addSubview:_callLabel];
    
    UIImageView *callImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"boundphoneic_content_phone_ic"]];
    [callImageView setFrame:CGRectMake((SCREEN_WIDTH - 100)/2 - 3, _alertLabel.frame.origin.y + _alertLabel.frame.size.height + 9, 9, 12)];
    [self addSubview:callImageView];
    
    UIButton *callBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, _alertLabel.frame.origin.y + _alertLabel.frame.size.height, 100, 30)];
    callBtn.backgroundColor = [UIColor clearColor];
    [callBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:callBtn];
}

/*拨打固定的电话号码*/
- (void)call
{
    [HNBClick event:@"148013" Content:nil];
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",DEFAULT_TELNUM];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

//给UILabel设置行间距和字间距
-(void)setLabelSpace:(UILabel*)label
           withValue:(NSString*)str
            withFont:(UIFont*)font
     withLineSpacing:(float)lineSpacing{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineSpacing = lineSpacing; //设置行间距
    //设置字间距 NSKernAttributeName:@1.f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}



@end
