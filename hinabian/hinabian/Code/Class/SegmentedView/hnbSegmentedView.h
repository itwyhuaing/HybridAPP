//
//  hnbSegmentedView.h
//  hinabian
//
//  Created by hnb on 16/4/13.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^btnClickBlock)(NSInteger index);

@protocol hnbSegmentedViewDelegate;

@interface hnbSegmentedView : UIView
/**
 *  未选中时的文字颜色,默认黑色
 */
@property (nonatomic,strong) UIColor *titleNomalColor;

/**
 *  选中时的文字颜色,默认红色
 */
@property (nonatomic,strong) UIColor *titleSelectColor;

/**
 * 设置底部线条 与 按钮 的 起点 X 差值
 */
@property (nonatomic) CGFloat x_0ffset;


/**
 * 设置常态下的线条高度
 */
@property (nonatomic) CGFloat normalLineHeight;


/**
 *  字体大小，默认17
 */
@property (nonatomic,strong) UIFont  *titleFont;

/**
 *  默认选中的index=1，即第一个
 */
@property (nonatomic,assign) NSInteger defaultIndex;

/**
 *  点击后的block
 */
@property (nonatomic,copy)btnClickBlock block;

/**
 * 设置 _selectLine 的圆角
 *  BOOL - YES设置 ， NO 不设置
 */
@property (nonatomic) BOOL isRoundCorner;


@property (nonatomic, weak) id<hnbSegmentedViewDelegate> delegate;

/**
 *  初始化方法
 *
 *  @param frame      frame
 *  @param titleArray 传入数组
 *  @param block      点击后的回调
 *
 *  @return
 */
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray clickBlick:(btnClickBlock)block;

/**
 *  设置选择
 *
 *  @param index
 */
-(void) setIndex:(int)index;

/**
 * 重新设置按钮标题数组
 * titles           标题数组
 */
- (void)setItemsWithTitles:(NSArray *)titles;


/**
 * 依据 删除的标题 重新 布局 Tab
 **/
- (void)relayoutTabAfterDeleteTitle:(NSString *)title;

@end

@protocol hnbSegmentedViewDelegate <NSObject>
@optional
-(void) titleButtonPressed:(NSInteger) tag;
@end
