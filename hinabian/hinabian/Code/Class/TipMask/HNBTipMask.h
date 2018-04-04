//
//  HNBTipMask.h
//  hinabian
//
//  Created by hnbwyh on 16/6/24.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HNBTipMaskDashType,
    HNBTipMaskSquarType,
    HNBTipMaskRoundType,
    HNBTipMaskOvalType,
} HNBTipMaskType;



@class HNBTipMask;
@protocol HNBTipMaskDelegate <NSObject>
@optional
- (void) touchEventOnView:(HNBTipMask *)tipView;

@end

@interface HNBTipMask : UIView

@property (nonatomic,weak) id<HNBTipMaskDelegate> delegate;

@property (nonatomic) HNBTipMaskType maskType;
@property (nonatomic) CGRect holeRect;
@property (nonatomic) CGRect superViewRect;


/**
 * 创建 新功能提醒 蒙版
 * locationRect - hole 位置
 * functionRect - 待提醒功能控件 位置
 * functionTitle - ...         标题
 * imgName         ...         图片
 * showRect      - 提示图片 位置
 * showImgName   - 提示图片 名字
 * falg          - 不同样式的区分字段
 **/
-(void)setUpWithLocation:(CGRect)locationRect
        newFunctionFrame:(CGRect)functionRect
           functionTitle:(NSString *)functionTitle
         functionImgName:(NSString *)imgName
                showRect:(CGRect)showRect
             showImgName:(NSString *)showImgName
                    flag:(NSString *)falg;



@end
