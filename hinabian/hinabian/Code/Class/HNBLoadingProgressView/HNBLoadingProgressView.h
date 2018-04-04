//
//  HNBLoadingProgressView.h
//  hinabian
//
//  Created by 何松泽 on 2017/11/7.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNBLoadingProgressView : UIView

//进度值
@property (nonatomic,assign) CGFloat progress;

//下方文字
@property (nonatomic,strong) UILabel *countryLabel;

//清除指示器
- (void)dismiss;

//示例化对象
+ (id)progressView; 

@end
