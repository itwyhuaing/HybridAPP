//
//  ProjectsView.h
//  hinabian
//
//  Created by hnbwyh on 17/6/9.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

static const int kChosenNationTag = 100;
static const int kTmpProjectBtnTag = 13;

#import <UIKit/UIKit.h>

@class ProjectsView;

@protocol ProjectViewDelegate <NSObject>

-(void)cancelNationEvent;
-(void)clickProjectItem:(NSString *)p_id;

@end

@class ProjectNationsModel;

@interface ProjectsView : UIScrollView

@property (nonatomic, weak) id<ProjectViewDelegate> proDelegate;
@property (nonatomic, strong) NSArray *proDataSource;

- (void)setViewWithNationModel:(ProjectNationsModel *)f;

@end
