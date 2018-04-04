//
//  RecommendSpecialistView.h
//  hinabian
//
//  Created by 何松泽 on 2017/10/19.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecommendSpecialistView;
@protocol RecommendSpecialistDelegate<NSObject>

@optional
/**
 * 点击咨询
 */
- (void)recommendSpecialistConsult:(NSInteger)index;
/**
 * 查看专家资料 - 跳转他人的个人中心
 * perId - 个人中心 id
 */
- (void)recommendSpecialistCheckAtIndexPath:(NSIndexPath *)indexPath;
/**
 * 查看全部专家
 */
- (void)RecomendSpecialShowAll;
@end

@interface RecommendSpecialistView : UIView

@property (nonatomic, strong)   NSArray *dataArr;
@property (nonatomic, weak)     id<RecommendSpecialistDelegate>delegate;

//- (instancetype) initWithFrame:(CGRect)frame specialists:(NSArray *)dataArr;

+ (instancetype) recommendSpecialistWithFrame:(CGRect)frame specialists:(NSArray *)dataArr delegate:(id<RecommendSpecialistDelegate>)delegate;

- (void)reFreshViewWithDataSource:(id)data;

@end
