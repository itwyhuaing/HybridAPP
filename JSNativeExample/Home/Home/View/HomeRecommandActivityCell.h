//
//  HomeRecommandActivityCell.h
//  hinabian
//
//  Created by hnbwyh on 2017/10/20.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HRcmActCellHeight (150.0 * SCREEN_WIDTHRATE_6)+55.0

typedef void(^HomeRecommandActivityCellClickBtn)(UIButton *btn);

static NSString *cell_HomeRecommandActivityCell = @"HomeRecommandActivityCell";
@interface HomeRecommandActivityCell : UITableViewCell

@property (nonatomic,copy) HomeRecommandActivityCellClickBtn clickCellBtnBlock;

- (void)setUpItemCellWithModel:(id)model;

- (void)setHiddenCell:(BOOL)isHidden;

@end
