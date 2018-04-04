//
//  HNBCustomActionSheet.h
//  hinabian
//
//  Created by 余坚 on 15/6/18.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@protocol HNBCustomActionSheetDelegate <NSObject>

-(void)done;

@end

@interface HNBCustomActionSheet : UIView
{
    UIToolbar* toolBar;
}
-(id)initWithView:(UIView *)view AndHeight:(float)height;

-(void)showInView:(UIView *)view;

@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,assign) CGFloat LXActionSheetHeight;
@property(nonatomic,unsafe_unretained) id<HNBCustomActionSheetDelegate> doneDelegate;

@end
