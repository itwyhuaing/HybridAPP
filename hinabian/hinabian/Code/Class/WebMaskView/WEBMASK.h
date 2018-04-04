//
//  WEBMASK.h
//  hinabianIMAssess
//
//  Created by 何松泽 on 15/12/31.
//  Copyright © 2015年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WEBMASK : UIView

@property (nonatomic, assign) BOOL shown;
@property (nonatomic, strong) UIView *overlayView;

+(void)show;
+(void)dismiss;
+(instancetype)instance;
+(BOOL)isShowing;
+(void)setMaskFrame:(CGRect)frame;

@end
