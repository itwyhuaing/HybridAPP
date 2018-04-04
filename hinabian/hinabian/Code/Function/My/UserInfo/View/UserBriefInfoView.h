//
//  UserBriefInfoView.h
//  hinabian
//
//  Created by hnbwyh on 16/7/25.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserBriefInfoView : UIView

@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *itemTitle;
@property (strong, nonatomic) UILabel *content;
@property (strong, nonatomic) UIButton *eventButton;
@property (assign, nonatomic) BOOL needNextLine;

- (void)setUserBriefInfoViewWithInfo:(id)info;
- (void)setHeightWithInfo:(NSString *)introduce;

@end
