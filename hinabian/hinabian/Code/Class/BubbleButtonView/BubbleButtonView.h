//
//  BubbleButtonView.h
//  hinabian
//
//  Created by 何松泽 on 2018/1/3.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+BubbleBadge.h"

@protocol BubbleButtonDelegate<NSObject>

@optional
- (void)clickBubbleButton:(id)sender;

@end

@interface BubbleButtonView : UIView

//@property (nonatomic, readonly) UIButton *segmentButton;
@property (nonatomic, weak) id<BubbleButtonDelegate> delegate;

/**
 * pagram(title) 按钮的标题
 * pagram(controlState) 按钮的状态
 */
- (void)setBubbleButtonTitle:(NSString *)title state:(UIControlState)controlState;

/**
 * pagram(tag) 按钮tag，用于区分点击事件
 */
- (void)setBubbleTag:(NSInteger)tag;

/**
 * 设置被选中样式
 */
- (void)setChoosen:(BOOL)isChoosen;


@end
