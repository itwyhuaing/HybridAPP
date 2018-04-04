//
//  PreferredPlanCell.h
//  hinabian
//
//  Created by hnbwyh on 2017/10/26.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PreferredPlanCell;
@protocol PreferredPlanCellDelegate <NSObject>
@optional
- (void)clickEventLookAllRlts:(UIButton *)btn;

@end

static NSString *cell_PreferredPlanCell = @"PreferredPlanCell";
@interface PreferredPlanCell : UITableViewCell

@property (nonatomic,weak) id<PreferredPlanCellDelegate> delegate;

- (void)setUpItemCellWithModel:(id)model;

@end
