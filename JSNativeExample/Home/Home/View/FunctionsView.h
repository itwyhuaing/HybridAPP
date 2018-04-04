//
//  FunctionsView.h
//  LXYHOCFunctionsDemo
//
//  Created by hnbwyh on 17/5/27.
//  Copyright © 2017年 lachesismh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FunctionsView;
@protocol FunctionsViewDelegate <NSObject>
@optional
- (void)functionsViewDidSelectedModel:(id)model;

- (void)functionsViewDidSelectedV30Model:(id)model;

- (void)functionsViewToAllShowServices;

@end

@interface FunctionsView : UIView

@property (nonatomic,weak) id<FunctionsViewDelegate> delegate;

- (void)refreshCollectionWithData:(NSArray *)data;

- (void)refreshCollectionWithV30Data:(NSArray *)data;

@end
