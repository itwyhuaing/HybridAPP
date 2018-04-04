//
//  ShowAllServicesView.h
//  ShowAllServicesViewController
//
//  Created by 何松泽 on 2018/3/26.
//  Copyright © 2018年 HSZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowAllServicesModel;

@protocol ShowAllServicesViewDelegate<NSObject>

- (void)ShowAllServicesViewClickEvent:(ShowAllServicesModel *)model;

@end

static const CGFloat kShowAllServicesViewLabelHeight   = 30.f;

@interface ShowAllServicesView : UIView

@property (nonatomic, weak) id<ShowAllServicesViewDelegate> delegate;

- (void)setDataArr:(NSArray *)datas title:(NSString *)title;

@end
