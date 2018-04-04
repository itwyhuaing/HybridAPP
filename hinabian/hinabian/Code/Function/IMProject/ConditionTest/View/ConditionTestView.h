//
//  ConditionTestView.h
//  hinabian
//
//  Created by hnbwyh on 17/6/9.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

@class ConditionTestView;

@protocol ConditionTestViewDelegate <NSObject>

@optional
-(void)jumpToProjectTest:(NSString *)url;

@end

#import <UIKit/UIKit.h>

@interface ConditionTestView : UIView

@property (nonatomic, weak) id<ConditionTestViewDelegate> testDelegate;
@property (nonatomic, assign) BOOL isBackToNation;

- (instancetype)initWithFrame:(CGRect)frame dataModel:(id)model;

- (void)refreshMainViewWithDataSource:(NSArray *)dataSource fetchState:(BOOL)fetchState;
- (void)backToNation;

@end
