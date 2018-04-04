//
//  BigShotTalkView.h
//  hinabian
//
//  Created by 何松泽 on 2017/10/20.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BigShotTalkDelegate<NSObject>

@optional
/**
 * 查看
 */
- (void)bigShotTalkClick:(NSIndexPath*)indexPath;
@end

@interface BigShotTalkView : UIView

@property (nonatomic, strong)   NSArray *dataArr;
@property (nonatomic, weak)     id<BigShotTalkDelegate>delegate;

//- (instancetype) initWithFrame:(CGRect)frame specialists:(NSArray *)dataArr;

+ (instancetype) bigShotTalkWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr delegate:(id<BigShotTalkDelegate>)delegate;

- (void)reFreshViewWithDataSource:(id)data;

@end

