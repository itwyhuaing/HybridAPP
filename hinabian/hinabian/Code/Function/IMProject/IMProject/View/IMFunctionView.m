//
//  IMFunctionView.m
//  hinabian
//
//  Created by 何松泽 on 2017/8/23.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "IMFunctionView.h"

#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Before ([UIDevice currentDevice].systemVersion.floatValue < 9.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS10Before ([UIDevice currentDevice].systemVersion.floatValue < 10.0f)

enum IMFunction_Button{
    WALK_IN_BTN = 2,
    STRATEGY_BTN,
    IMASSESS_BTN,
    CONDITION_TEST_BTN,
};

@interface IMFunctionView()

@property (nonatomic, strong) UIButton *walkInBtn;
@property (nonatomic, strong) UIButton *strategyBtn;
@property (nonatomic, strong) UIButton *imAssessBtn;
@property (nonatomic, strong) UIButton *conditionTestBtn;

@property (nonatomic, strong) UIImageView *walkInImgView;
@property (nonatomic, strong) UIImageView *strategyImgView;
@property (nonatomic, strong) UIImageView *imAssessImgView;
@property (nonatomic, strong) UIImageView *conditionTestImgView;

@end

@implementation IMFunctionView

-(void)setNationName:(NSString *)nation {
    
    _walkInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setBtn:_walkInBtn originX:0 image:[UIImage imageNamed:@"im_walk_in"] title:[NSString stringWithFormat:@"走进%@",nation] tag:WALK_IN_BTN];
    
    _strategyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setBtn:_strategyBtn originX:self.frame.size.width/4 image:[UIImage imageNamed:@"im_strategy_icon"] title:@"达人攻略" tag:STRATEGY_BTN];
    
    _imAssessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setBtn:_imAssessBtn originX:self.frame.size.width*2/4 image:[UIImage imageNamed:@"im_assess_icon"] title:@"移民评估" tag:IMASSESS_BTN];
    
    _conditionTestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setBtn:_conditionTestBtn originX:self.frame.size.width*3/4 image:[UIImage imageNamed:@"im_condition_test"] title:@"条件测试" tag:CONDITION_TEST_BTN];
}

- (void)clickEvent:(UIButton *)btn {
    if (btn.tag == WALK_IN_BTN) {
        if (self.clickWalkIN) {
            self.clickWalkIN();
        }
    }else if (btn.tag == STRATEGY_BTN) {
        if (self.clickStrategy) {
            self.clickStrategy();
        }
    }else if (btn.tag == IMASSESS_BTN) {
        if (self.clickIMassess) {
            self.clickIMassess();
        }
    }else if (btn.tag == CONDITION_TEST_BTN) {
        if (self.clickTest) {
            self.clickTest();
        }
    }
}

- (void)setBtn:(UIButton *)btn originX:(float)originX image:(UIImage *)image title:(NSString *)title tag:(NSInteger)tag{
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect rect = CGRectZero;
    rect.origin.y = 5;
    rect.origin.x = originX;
    float buttonHeight = self.frame.size.height - rect.origin.y*2;
    float buttonWidth = self.frame.size.width/4;
    rect.size = CGSizeMake(buttonWidth, buttonHeight);
    [btn setFrame:rect];
    [btn setTag:tag];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI24PX]];
    [btn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    /*
     IOS8布局有所不同，
     */
    if (iOS9Later && iOS10Before) {
        
        float ios9_6 = SCREEN_WIDTH <= SCREEN_WIDTH_6 ? 15 : 0;
        float width = SCREEN_WIDTH >= SCREEN_WIDTH_6 ? 0+ios9_6 : 25+ios9_6;
        float edgeFont = SCREEN_WIDTH >= SCREEN_WIDTH_6 ? FONT_UI24PX : 0;
        
        //设置文字偏移：向下偏移图片高度＋向左偏移图片宽度 （偏移量是根据［图片］大小来的，这点是关键）
        btn.titleEdgeInsets = UIEdgeInsetsMake(btn.imageView.frame.size.height + 15.f, -btn.imageView.frame.size.width, 0, 0);
        //设置图片偏移：向上偏移文字高度＋向右偏移文字宽度 （偏移量是根据［文字］大小来的，这点是关键）
        btn.imageEdgeInsets = UIEdgeInsetsMake(-btn.titleLabel.bounds.size.height, 0, 0, -btn.titleLabel.bounds.size.width - width - (btn.titleLabel.text.length - 4)*edgeFont);
        
    }else if(iOS8Later && iOS9Before){
        
        float width = SCREEN_WIDTH >= SCREEN_WIDTH_6 ? 10 : 35;
        float edgeFont = SCREEN_WIDTH >= SCREEN_WIDTH_6 ? FONT_UI24PX : 0;
        //设置文字偏移：向下偏移图片高度＋向左偏移图片宽度 （偏移量是根据［图片］大小来的，这点是关键）
        btn.titleEdgeInsets = UIEdgeInsetsMake(btn.imageView.frame.size.height + 15.f, -btn.imageView.frame.size.width, 0, 0);
        //设置图片偏移：向上偏移文字高度＋向右偏移文字宽度 （偏移量是根据［文字］大小来的，这点是关键）
        btn.imageEdgeInsets = UIEdgeInsetsMake(-btn.titleLabel.bounds.size.height, 0, 0, -btn.titleLabel.bounds.size.width - width - (btn.titleLabel.text.length - 4)*edgeFont);
        
    }else {
        
        float width = SCREEN_WIDTH >= SCREEN_WIDTH_6 ? 15 : 0;
        float edgeFont = SCREEN_WIDTH >= SCREEN_WIDTH_6 ? FONT_UI24PX : 0;
        
        //设置文字偏移：向下偏移图片高度＋向左偏移图片宽度 （偏移量是根据［图片］大小来的，这点是关键）
        btn.titleEdgeInsets = UIEdgeInsetsMake(btn.imageView.frame.size.height + 15.f, -btn.imageView.frame.size.width, 0, 0);
        //设置图片偏移：向上偏移文字高度＋向右偏移文字宽度 （偏移量是根据［文字］大小来的，这点是关键）
        btn.imageEdgeInsets = UIEdgeInsetsMake(-btn.titleLabel.bounds.size.height, 0, 0, -btn.titleLabel.bounds.size.width - width - (btn.titleLabel.text.length - 4)*edgeFont);
    }
    
}

@end
