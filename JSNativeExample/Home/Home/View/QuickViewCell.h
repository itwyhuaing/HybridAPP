//
//  QuickViewCell.h
//  hinabian
//
//  Created by 何松泽 on 2017/10/18.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDCycleScrollView;

static NSString *cellNib_QuickViewCell = @"QuickViewCell";

@interface QuickViewCell : UITableViewCell

@property (nonatomic,strong) SDCycleScrollView *quickNewsView;

@end
