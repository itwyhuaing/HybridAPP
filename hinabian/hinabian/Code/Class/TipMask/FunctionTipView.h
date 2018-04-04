//
//  FunctionTipView.h
//  YHCALayerProject
//
//  Created by hnbwyh on 17/2/7.
//  Copyright © 2017年 hnbwyh. All rights reserved.
//

/**
 * 功能指引 替换 HNBTipMask 类
 */

#import <UIKit/UIKit.h>

/**< 交互代理方法>*/
@class FunctionTipView;
@protocol FunctionTipViewDelegate <NSObject>
@optional
- (void)functionTipView:(FunctionTipView *)tipView didTouchEvent:(UITouch *)touch;

@end

/**< 镂空部分形状样式 - 圆形 or 方形>*/
typedef enum : NSUInteger {
    CircleType = 100,
    SquareType,
} ShapeType;

/**< 镂空部分线条样式 - 实线 or 虚线>*/
typedef enum : NSUInteger {
    DashLineType = 200,
    SolidLineType,
} LineType;

@interface FunctionTipView : UIView

- (instancetype)initWithHollowRectA:(CGRect)rectA tipRectB:(CGRect)rectB;

@property (nonatomic,weak) id<FunctionTipViewDelegate> delegate;
@property (nonatomic,assign) ShapeType shapeType;
@property (nonatomic,assign) LineType lineType;
@property (nonatomic,copy) NSString *tipImageName;

@property (nonatomic,assign) CGRect hollowRect;
@property (nonatomic,assign) CGRect tipRect;

@end
