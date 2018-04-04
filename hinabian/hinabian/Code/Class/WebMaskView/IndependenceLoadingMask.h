//
//  IndependenceLoadingMask.h
//  hinabian
//
//  Created by 余坚 on 16/11/7.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndependenceLoadingMask : UIView
/**
 * 添加 loading
 * superV   - 父视图
 * type     - 是否覆盖导航栏 、状态栏及底部标签栏
 * yoffset  - 顶部偏移
 */
- (void)loadingMaskWithSuperView:(UIView *)superV frame:(CGRect)rect;

/**
 * 移除 loading
 */
- (void)dismiss;
@end
