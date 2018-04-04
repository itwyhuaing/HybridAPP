//
//  HNBTipMask.m
//  hinabian
//
//  Created by hnbwyh on 16/6/24.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "HNBTipMask.h"

@interface HNBTipMask ()

@property (nonatomic) CGRect locationRect;
@property (nonatomic) CGRect functionRect;
@property (nonatomic) CGRect showRect;

@property (nonatomic,copy) NSString *functionTitle;
@property (nonatomic,copy) NSString *functionImgName;
@property (nonatomic,copy) NSString *showImgName;

@end

@implementation HNBTipMask

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
    }
    return self;
}

-(void)setUpWithLocation:(CGRect)locationRect newFunctionFrame:(CGRect)functionRect functionTitle:(NSString *)functionTitle functionImgName:(NSString *)imgName showRect:(CGRect)showRect showImgName:(NSString *)showImgName flag:(NSString *)falg{
    
    _locationRect = locationRect;
    _functionRect = functionRect;
    _showRect = showRect;
    _functionTitle = functionTitle;
    _functionImgName = imgName;
    _showImgName = showImgName;
    
    if ([falg isEqualToString:@"message"] || [falg isEqualToString:@"search"]) {
        [self setUpMaskFunctionMessage];
    }else if ([falg isEqualToString:@"tribe"]){
        [self setUpMaskFunctionTribe];
    }
    
    
    
}

#pragma mark ------ createView

- (void)setUpMaskFunctionMessage{

    UIImageView *bottom = [[UIImageView alloc] initWithFrame:_locationRect];
    [self drawLineDash:bottom];
    UIImageView *top = [[UIImageView alloc] initWithFrame:_functionRect];
    [top setCenter:CGPointMake(_locationRect.size.width / 2.0, _locationRect.size.height / 2.0)];
    [top setImage:[UIImage imageNamed:_functionImgName]];
    
    UIImageView *showTip = [[UIImageView alloc] initWithFrame:_showRect];
    [showTip setImage:[UIImage imageNamed:_showImgName]];
    
    [self addSubview:bottom];
    [bottom addSubview:top];
    [self addSubview:showTip];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
}

- (void)setUpMaskFunctionTribe{

    UIImageView *bottom = [[UIImageView alloc] initWithFrame:_locationRect];
    bottom.layer.cornerRadius = CGRectGetHeight(bottom.frame)/2.0;
    bottom.backgroundColor = [UIColor whiteColor];
    
    UIButton *top = [UIButton buttonWithType:UIButtonTypeCustom];
    [top setFrame:_functionRect];
    [top setTitle:_functionTitle forState:UIControlStateNormal];
    top.layer.cornerRadius = CGRectGetHeight(top.frame)/2.0;
    top.layer.borderWidth = 1.0;
    top.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:1.0].CGColor;
    [top setTitleColor:[UIColor DDR63_G162_B255ColorWithalph:1.0] forState:UIControlStateNormal];
    top.titleLabel.font = [UIFont systemFontOfSize:FONT_UI18PX];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:_showRect];
    [imgV setImage:[UIImage imageNamed:@"newFunction_tip_tribe"]];
    
    [self addSubview:imgV];
    [self addSubview:bottom];
    [self addSubview:top];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
}

#pragma mark ------ drawLineDash
- (void)drawLineDash:(UIImageView *)imgView
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = imgView.bounds;//设置shapeLayer的尺寸和位置
    //[shapeLayer setPosition:imgView.center];
    
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    // 设置虚线颜色为 whiteColor
    [shapeLayer setStrokeColor:[[UIColor whiteColor] CGColor]];
    
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:1.5f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    // 6=线的长度 5=每条线的间距
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:6],
      [NSNumber numberWithInt:3],nil]];
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, imgView.frame.size.width, imgView.frame.size.height)];
    
    [shapeLayer setPath:circlePath.CGPath];
    
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    [[imgView layer] addSublayer:shapeLayer];
    
}


- (void)drawRect:(CGRect)rect {
    
    if (_maskType == HNBTipMaskDashType) {
        
        
        
    }else if (_maskType == HNBTipMaskRoundType){
    
        CGRect myRect = _holeRect;
        int radius = myRect.size.height/2.0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_superViewRect cornerRadius:0];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(_holeRect.origin.x,_holeRect.origin.y,2.0 * radius,2.0 * radius) cornerRadius:radius];
        [path appendPath:circlePath];
        //[path setUsesEvenOddFillRule:YES];
        
        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        fillLayer.path = path.CGPath;
        fillLayer.fillRule =kCAFillRuleEvenOdd;
        fillLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6].CGColor;
        //fillLayer.opacity =0.5;
        //[self.superV.layer addSublayer:fillLayer];
        [self.layer addSublayer:fillLayer];
        
    }else if (_maskType == HNBTipMaskOvalType){
        
        CGRect myRect = _holeRect;
        int radius = myRect.size.height/2.0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_superViewRect cornerRadius:0];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:_holeRect cornerRadius:radius];
        [path appendPath:circlePath];
        //[path setUsesEvenOddFillRule:YES];
        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        
        fillLayer.path = path.CGPath;
        fillLayer.fillRule =kCAFillRuleEvenOdd;
        fillLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6].CGColor;
        //fillLayer.opacity = 0.5;
        //[self.superV.layer addSublayer:fillLayer];
        [self.layer addSublayer:fillLayer];
        
        
    }else if (_maskType == HNBTipMaskSquarType){
        
        //[[UIColor colorWithWhite:0.0f alpha:0.6f] setFill];// 阴影效果 根据透明度来设计
        [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6] setFill];// 阴影效果 根据透明度来设计
        UIRectFill(rect);
        CGRect holeRectIntersection = CGRectIntersection(_holeRect,rect);
        [[UIColor clearColor] setFill];
        UIRectFill(holeRectIntersection);
        
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if (_delegate && [_delegate respondsToSelector:@selector(touchEventOnView:)]) {
        [_delegate touchEventOnView:self];
    }

}

@end
