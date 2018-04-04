//
//  TribeShowHeaderView.h
//  hinabian
//
//  Created by hnbwyh on 16/6/7.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TribeShowBriefInfo.h"

@interface TribeShowHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *tribeImgView;

@property (weak, nonatomic) IBOutlet UILabel *tribeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIButton *posts;

@property (weak, nonatomic) IBOutlet UIButton *cares;

@property (weak, nonatomic) IBOutlet UIButton *careBtn;

@property (weak, nonatomic) IBOutlet UIView *tribeHostView;

@property (weak, nonatomic) IBOutlet UILabel *tribeHostTitle;

@property (weak, nonatomic) IBOutlet UILabel *tribeHostNames;

@property (weak, nonatomic) IBOutlet UILabel *gapLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tribeImgViewConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tribeHostViewHeightConstranit;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gapTopSpaceConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tribeHostTitleHeightConstraint;

- (void)setViewWithInfo:(TribeShowBriefInfo *)info;

@end
