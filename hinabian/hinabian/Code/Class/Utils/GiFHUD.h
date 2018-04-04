//
//  GiFHUD.h
//  GiFHUD
//
//  Created by yujian on 15/6/17.
//  Copyright (c) 2015 yujian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiFHUD : UIView

+ (void)show;
+ (void)showWithOverlay;

+ (void)dismiss;

+ (void)setGifWithImages:(NSArray *)images;
+ (void)setGifWithImageName:(NSString *)imageName;
+ (void)setGifWithURL:(NSURL *)gifUrl;
+ (BOOL)isShowing;

@end

