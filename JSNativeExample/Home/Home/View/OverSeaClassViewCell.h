//
//  OverSeaClassViewCell.h
//  hinabian
//
//  Created by 何松泽 on 2018/1/9.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OverSeaClassViewCellDelegate<NSObject>

- (void)lookClassess;

@end

static NSString *cell_OverSeaClassViewCell = @"OverSeaClassViewCell";

@class OverSeaClassModel;
@interface OverSeaClassViewCell : UITableViewCell

@property (nonatomic, weak)id <OverSeaClassViewCellDelegate>delegate;

- (void)setCellModel:(OverSeaClassModel *)model;

@end
