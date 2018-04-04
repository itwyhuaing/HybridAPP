//
//  IdeaBackMainView.h
//  hinabian
//
//  Created by 何松泽 on 2017/9/18.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdeaBackMainView : UIView

@property (nonatomic,strong) UITextView *describeTextView;
@property (nonatomic,strong) UITextView *placeHoldTextView;

- (instancetype)initWithFrame:(CGRect)frame
              superController:(UIViewController *)superController;

@end
