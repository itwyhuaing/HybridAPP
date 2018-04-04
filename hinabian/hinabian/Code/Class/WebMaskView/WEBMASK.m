//
//  WEBMASK.m
//  hinabianIMAssess
//
//  Created by 何松泽 on 15/12/31.
//  Copyright © 2015年 &#20313;&#22362;. All rights reserved.
//

#import "WEBMASK.h"
#import "GiFHUD.h"
#import "AppDelegate.h"
#import <ImageIO/ImageIO.h>

#define APPDELEGATE     ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define FadeDuration    0.1


@implementation WEBMASK

static WEBMASK *instance;

+(instancetype)instance
{
    if (!instance) {
        instance = [[WEBMASK alloc]init];
    }
    return instance;
}

-(instancetype)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [APPDELEGATE.window addSubview:self];
        
    }
    return self;
}

+(void)setMaskFrame:(CGRect)frame
{
    [[self instance]setFrame:frame];
}

+ (BOOL)isShowing
{
    return [[self instance] shown];
}
+ (void)showWithOverlay {
    [self dismiss:^{
        [APPDELEGATE.window addSubview:[[self instance] overlay]];
        [self show];
    }];
}

+ (void)show {
    [self dismiss:^{
        [APPDELEGATE.window bringSubviewToFront:[self instance]];
        //Setup GiFHUD image
        [GiFHUD setGifWithImageName:@"loading.gif"];
        [GiFHUD show];
        [[self instance] setShown:YES];
        [[self instance] fadeIn];
    }];
}


+ (void)dismiss {
    [[[self instance] overlay] removeFromSuperview];
    [[self instance] fadeOut];
    [GiFHUD dismiss];
}

+ (void)dismiss:(void(^)(void))complated {
    if (![[self instance] shown])
        return complated ();
    
    [[self instance] fadeOutComplate:^{
        [[[self instance] overlay] removeFromSuperview];
        complated ();
    }];
}

#pragma mark Effects

- (void)fadeIn {
    [UIView animateWithDuration:FadeDuration animations:^{
        [self setAlpha:1];
    }];
}

- (void)fadeOut {
    [UIView animateWithDuration:FadeDuration animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self setShown:NO];
    }];
}

- (void)fadeOutComplate:(void(^)(void))complated {
    [UIView animateWithDuration:FadeDuration animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self setShown:NO];
        complated ();
    }];
}


- (UIView *)overlay {
    
    if (!self.overlayView) {
        self.overlayView = [[UIView alloc] initWithFrame:APPDELEGATE.window.frame];
        [self.overlayView setBackgroundColor:[UIColor blackColor]];
        [self.overlayView setAlpha:0];
        
        [UIView animateWithDuration:FadeDuration animations:^{
            [self.overlayView setAlpha:0.3];
        }];
    }
    return self.overlayView;
}


@end
