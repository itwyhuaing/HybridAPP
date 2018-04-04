//
//  IdeaBackSuccessView.m
//  hinabian
//
//  Created by 何松泽 on 2017/9/18.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#define IMAGE_HEIGT         130
#define DISTANCE            10
#define ITEM_LEADING_GAP    12

#import "IdeaBackSuccessView.h"

static const int kCloseViewHeight = 70.f;

@interface IdeaBackSuccessView()

/*完成绑定页面*/
@property (nonatomic,strong) UILabel        *titleLabel;
@property (nonatomic,strong) UIImageView    *successImageView;
@property (nonatomic,strong) UILabel        *alertLabel;
@property (nonatomic,strong) UIButton       *closeBtn;
@property (nonatomic,strong) UIView         *closeView;
@property (nonatomic,strong) UIViewController *superController;

@end

@implementation IdeaBackSuccessView

- (instancetype)initWithFrame:(CGRect)frame
              superController:(UIViewController *)superController
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.superController = superController;
        self.backgroundColor = [UIColor DDR153_G153_B153ColorWithalph:0.1f];
        
        _successImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"IdeaBack_Success_icon"]];
        [_successImageView setFrame:CGRectMake((SCREEN_WIDTH - 130)/2, 70, IMAGE_HEIGT, IMAGE_HEIGT)];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70 + IMAGE_HEIGT + DISTANCE , SCREEN_WIDTH, 20)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:FONT_UI36PX];
        _titleLabel.text = [NSString stringWithFormat:@"提交成功"];
        _titleLabel.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.f];
        
        _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70 + IMAGE_HEIGT + DISTANCE * 4, SCREEN_WIDTH, 40)];
        _alertLabel.numberOfLines = 2;
        _alertLabel.textColor = [UIColor colorWithRed:170/255.f green:170/255.f  blue:170/255.f  alpha:1.f];
        [self setLabelSpace:_alertLabel withString:@"感谢您的反馈，我们会在24小时内回复您，\n请留意小边给您的私信哦~" withValue:@"小边" withFont:[UIFont systemFontOfSize:FONT_UI28PX] withLineSpacing:5.f];
        
        CGRect statusFrame = [[UIApplication sharedApplication] statusBarFrame];
        CGRect rect = CGRectZero;
        /*完成*/
        rect.origin.x = 0;
        if (IS_IPHONE_X) {
            rect.origin.y = SCREEN_HEIGHT - statusFrame.size.height - SCREEN_NAVHEIGHT - SUIT_IPHONE_X_HEIGHT - kCloseViewHeight;
        }else{
            rect.origin.y = SCREEN_HEIGHT - statusFrame.size.height - SCREEN_NAVHEIGHT - kCloseViewHeight;
        }
        rect.size.width = SCREEN_WIDTH;
        rect.size.height = kCloseViewHeight;
        _closeView = [[UIView alloc]initWithFrame:rect];
        _closeView.backgroundColor = [UIColor whiteColor];
        _closeView.layer.borderColor = [UIColor DDEdgeGray].CGColor;
        _closeView.layer.borderWidth = 0.5f;
        
        rect.origin.x = ITEM_LEADING_GAP;
        rect.origin.y = 10;
        rect.size.width = SCREEN_WIDTH - ITEM_LEADING_GAP * 2;
        rect.size.height = kCloseViewHeight - 10 * 2;
        _closeBtn = [[UIButton alloc]initWithFrame:rect];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_UI28PX];
        _closeBtn.titleLabel.textColor = [UIColor whiteColor];
        _closeBtn.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0;
        _closeBtn.backgroundColor = [UIColor DDR63_G162_B255ColorWithalph:1.0f];
        _closeBtn.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:1.0f].CGColor;
        [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_successImageView];
        [self addSubview:_titleLabel];
        [self addSubview:_alertLabel];
        [_closeView addSubview:_closeBtn];
        [self addSubview:_closeView];
    }
    return self;
}




/*拨打固定的电话号码*/
- (void)close
{
    [self.superController.navigationController popViewControllerAnimated:YES];
}

//给UILabel设置行间距和字间距
-(void)setLabelSpace:(UILabel *)label
           withString:(NSString *)str
           withValue:(NSString *)value
            withFont:(UIFont *)font
     withLineSpacing:(float)lineSpacing{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineSpacing = lineSpacing; //设置行间距
    //设置字间距 NSKernAttributeName:@1.f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.f
                          };
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str attributes:dic];
    
    NSRange range = [str rangeOfString:value options:NSCaseInsensitiveSearch];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor DDNavBarBlue] range:range];
    label.attributedText = attributeStr;
}

@end
