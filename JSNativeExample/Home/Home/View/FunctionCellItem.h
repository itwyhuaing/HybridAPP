//
//  FunctionCellItem.h
//  LXYHOCFunctionsDemo
//
//  Created by hnbwyh on 17/5/27.
//  Copyright © 2017年 lachesismh. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *cell_FunctionCellItem_identify = @"FunctionCellItem";
@interface FunctionCellItem : UICollectionViewCell

- (void)configContentsWithDataModel:(id)f;

- (void)setUpItemCellWithModel:(id)model;

- (void)setUpAllServiceCell;

@end
