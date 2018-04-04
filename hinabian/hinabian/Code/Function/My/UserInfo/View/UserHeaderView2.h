//
//  UserHeaderView2.h
//  hinabian
//
//  Created by 何松泽 on 16/12/15.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

typedef enum : NSUInteger {
    UserHeaderViewCareBtnTag = 100,
    UserHeaderViewMsgBtnTag,
    UserHeaderViewVBtnTag,
    UserHeaderViewLevelBtnTag
} UserHeaderViewButtonTag;

#import <UIKit/UIKit.h>

@interface UserHeaderView2 : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *careButtonLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgButtonTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moderatorImageLeadingLevelImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tmpLabelYborderViewCenter;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tmpLabelTopNameLabel;


-(void)setUserHeaderViewWithInfo:(id)info;

@end
