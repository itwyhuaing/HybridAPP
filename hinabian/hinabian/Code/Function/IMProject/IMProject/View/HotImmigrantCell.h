//
//  HotImmigrantCell.h
//  hinabian
//
//  Created by hnbwyh on 2017/11/6.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HHotImmigrantCellHeight (165.0 * SCREEN_WIDTHRATE_6)+55.0

typedef void(^HotImmigrantCellClickBtn)(UIButton *btn);

static NSString *cell_HotImmigrantCell = @"HotImmigrantCell";
@interface HotImmigrantCell : UITableViewCell

@property (nonatomic,copy) HotImmigrantCellClickBtn clickCellBtnBlock;

- (void)setUpItemCellWithModel:(id)model;

@end
