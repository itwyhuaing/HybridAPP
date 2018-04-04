//
//  NationItemCell.h
//  hinabian
//
//  Created by hnbwyh on 17/6/9.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *cell_NationItemCell_identify = @"cell_NationItemCell_identify";
@interface NationItemCell : UICollectionViewCell

@property (nonatomic,assign) BOOL isSelected;
- (void)configNationItemCellContentsWithDataModel:(id)f;

@end
