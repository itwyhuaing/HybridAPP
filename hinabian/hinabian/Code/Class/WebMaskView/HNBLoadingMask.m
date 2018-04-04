//
//  HNBLoadingMask.m
//  hinabian
//
//  Created by hnbwyh on 16/7/12.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "HNBLoadingMask.h"
#import "GIFImageView.h"
#import "GIFImage.h"

static GIFImageView *subInstance;
@interface HNBLoadingMask ()


@end

@implementation HNBLoadingMask

+(instancetype)shareManager{

    static HNBLoadingMask *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HNBLoadingMask alloc] init];
        subInstance = [[GIFImageView alloc] init];
        [subInstance setImage:[GIFImage imageNamed:@"loading.gif"]];
        [instance addSubview:subInstance];
        //NSLog(@" Loading --- 创建");
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        subInstance = [[GIFImageView alloc] init];
        [subInstance setImage:[GIFImage imageNamed:@"loading.gif"]];
        [self addSubview:subInstance];
    }
    return self;
}



-(void)loadingMaskWithSuperView:(UIView *)superV loadingMaskType:(LoadingMaskType)type yoffset:(CGFloat)yoffset{
    
    //NSLog(@" Loading 添加 ");
    
    CGRect frame = [self getFrameWithLoadingMaskType:type yoffset:yoffset];
    [self setFrame:frame];
    [superV addSubview:self];
    self.backgroundColor = [UIColor whiteColor];

    CGRect rect = CGRectZero;
    rect.size.width = 50.0;
    rect.size.height = rect.size.width;
    rect.origin.x = frame.size.width / 2.0 - rect.size.width / 2.0;
    rect.origin.y = frame.size.height / 2.0 - rect.size.height;
    [subInstance setFrame:rect];
    self.isStatus = TRUE;
}

-(void)dismiss{

    [self removeFromSuperview];
    //NSLog(@" Loading 移除操作 ");
    self.isStatus = FALSE;
}


#pragma mark ------ toolMethod

- (CGRect)getFrameWithLoadingMaskType:(LoadingMaskType)type yoffset:(CGFloat)yoffset{

    CGRect rect = CGRectZero;
    rect.origin.y = yoffset;
    rect.size.width = SCREEN_WIDTH;
    switch (type) {
        case LoadingMaskTypeNormal:
            rect.size.height = SCREEN_HEIGHT - SCREEN_STATUSHEIGHT - SCREEN_NAVHEIGHT - SCREEN_TABHEIGHT;
            break;
        case LoadingMaskTypeExtendNavBar:
            rect.size.height = SCREEN_HEIGHT - SCREEN_STATUSHEIGHT - SCREEN_TABHEIGHT;
            break;
        case LoadingMaskTypeExtendTabBar:
            rect.size.height = SCREEN_HEIGHT - SCREEN_STATUSHEIGHT - SCREEN_NAVHEIGHT;
            break;
        case LoadingMaskTypeExtendNavBarAndTabBar:
            rect.size.height = SCREEN_HEIGHT - SCREEN_STATUSHEIGHT;
            break;
            
        default:
            break;
    }
    return rect;
}

@end
