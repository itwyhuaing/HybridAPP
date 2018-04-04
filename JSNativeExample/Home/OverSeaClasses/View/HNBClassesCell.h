//
//  HNBClassesCell.h
//  hinabian
//
//  Created by 何松泽 on 2018/1/30.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OverSeaClassModel;
@protocol HNBClassesCellDelegate<NSObject>

- (void)lookClassess:(OverSeaClassModel *)model;

@end

static NSString *cell_HNBClassesCell = @"HNBClassesCell";

@class OverSeaClassModel;
@interface HNBClassesCell : UITableViewCell

@property (nonatomic, weak)id <HNBClassesCellDelegate>delegate;

- (void)setCellModel:(OverSeaClassModel *)model;

@end

