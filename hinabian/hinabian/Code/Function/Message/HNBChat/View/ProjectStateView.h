//
//  ProjectStateView.h
//  hinabian
//
//  Created by hnbwyh on 16/6/14.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectStateModel;
@class VerticalAligmentLabel;


typedef enum : NSUInteger {
    CloseViewBtnTag = 10,
    LookLinkBtnTag,
} ProjectStateViewButtonTag;



@protocol ProjectStateViewDelegate<NSObject>
@optional
- (void)touchEvent:(UIButton *)btn info:(NSDictionary *)info;

@end

static NSString *viewNib_ProjectStateView = @"ProjectStateView";
@interface ProjectStateView : UIView

@property (weak, nonatomic) IBOutlet UILabel *stateTip;

@property (weak, nonatomic) IBOutlet UILabel *project;

@property (weak, nonatomic) IBOutlet UILabel *projectName;

@property (weak, nonatomic) IBOutlet UILabel *state;

@property (weak, nonatomic) IBOutlet UILabel *blueline;

@property (weak, nonatomic) IBOutlet UILabel *grayWhiteline;

@property (weak, nonatomic) IBOutlet UILabel *finishedState;

@property (weak, nonatomic) IBOutlet UILabel *goonState;

@property (weak, nonatomic) IBOutlet UILabel *unStartState;

@property (weak, nonatomic) IBOutlet UIImageView *successImgView;

@property (weak, nonatomic) IBOutlet UILabel *successLabel;

@property (weak, nonatomic) IBOutlet VerticalAligmentLabel *leftState;

@property (weak, nonatomic) IBOutlet VerticalAligmentLabel *middleState;

@property (weak, nonatomic) IBOutlet VerticalAligmentLabel *rightState;

@property (weak, nonatomic) IBOutlet UIButton *lookLink;

@property (weak, nonatomic) IBOutlet UILabel *specialLink;

@property (nonatomic,weak) id<ProjectStateViewDelegate> delegate;

- (void)setViewWithModel:(ProjectStateModel *)model;

@end
