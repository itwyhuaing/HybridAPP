//
//  pageShowView.h
//  hinabian
//
//  Created by 余坚 on 16/10/25.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HNBPageShowViewDelegate;
@interface pageShowView : UIView
@property (nonatomic, weak) id<HNBPageShowViewDelegate> delegate;

- (void) setPageNum:(NSString *)text;
@end

#define PAGE_VIEW_WIDTH   (134*SCREEN_SCALE)
#define PAGE_VIEW_HEIGHT  36
#define PAGE_BUTTON_EDGE  5

@protocol HNBPageShowViewDelegate <NSObject>
@optional
-(void) HNBPageShowViewLeftButtonPressed;
-(void) HNBPageShowViewRightButtonPressed;
-(void) HNBPageShowViewCenterButtonPressed;
@end
