//
//  ProjectStateNoticeView.h
//  hinabian
//
//  Created by hnbwyh on 2018/1/22.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectStateModel;

@protocol ProjectStateNoticeViewDelegate<NSObject>
@optional
- (void)touchProjectStateNoticeEvent:(UIButton *)btn info:(NSDictionary *)info;

@end


@interface ProjectStateNoticeView : UIView

@property (nonatomic,weak) id<ProjectStateNoticeViewDelegate> delegate;

- (void)modifyViewWithData:(ProjectStateModel *)model;

@end
