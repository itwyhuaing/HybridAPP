//
//  IMAssessRemindView.h
//  hinabian
//
//  Created by hnbwyh on 16/12/14.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    IMAssessRemindViewCloseButton,
    IMAssessRemindViewNextButton,
} IMAssessRemindViewButtonTag;

@class IMAssessRemindView;
@protocol IMAssessRemindViewDelegate <NSObject>
- (void)imAssessRemindView:(IMAssessRemindView *)imassessremindview didClickButton:(UIButton *)btn;

@end

@interface IMAssessRemindView : UIView

@property (nonatomic,weak) id<IMAssessRemindViewDelegate> delegate;

/**
 * 显示
 **/
@property (nonatomic,copy) NSString *imassessCountString;

/**
 * 跳转所需数据参数
 **/
@property (nonatomic,strong) NSArray *indexFunctions;

@end
