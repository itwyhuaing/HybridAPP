//
//  HNBTribeShowActionSheet.h
//  hinabian
//
//  Created by 余坚 on 16/6/13.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HNBTribeShowActionSheetDelegate <NSObject>

-(void)done:(NSString *)chosePage;

-(void)jumpToFirstPage;

-(void)jumpToLastPage;

@end

@interface HNBTribeShowActionSheet : UIView
{
    UIToolbar* toolBar;
}
-(id)initWithView:(NSInteger)totle currentPage:(NSInteger)current AndHeight:(float)height;

-(void)showInView:(UIView *)view;

@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,assign) CGFloat LXActionSheetHeight;
@property(nonatomic,weak) id<HNBTribeShowActionSheetDelegate> doneDelegate;

@end
