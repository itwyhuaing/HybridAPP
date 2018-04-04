//
//  JudgeAppView.h
//  hinabian
//
//  Created by 何松泽 on 2017/9/22.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JudgeAppViewCloseButton,
    JudgeAppViewGoStoreButton,
    JudgeAppViewGoIdeaBackButton,
} JudgeAppViewButtonTag;

@class JudgeAppView;
@protocol JudgeAppViewDelegate <NSObject>
- (void)JudgeAppView:(JudgeAppView *)judgeAppView didClickButton:(UIButton *)btn;

@end

@interface JudgeAppView : UIView

@property (nonatomic,weak) id<JudgeAppViewDelegate> delegate;

@end
