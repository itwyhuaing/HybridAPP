//
//  IMAllCountryCell.h
//  hinabian
//
//  Created by 何松泽 on 2017/8/25.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMHomeNationTabModel.h"

static NSString *cellNib_IMAllCountryCell = @"IMAllCountryCell";

@interface IMAllCountryCell : UICollectionViewCell

- (void)setModel:(IMHomeNationTabModel *)model;


@end
