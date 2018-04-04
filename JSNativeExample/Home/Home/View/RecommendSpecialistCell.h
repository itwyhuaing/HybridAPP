//
//  RecommendSpecialistCell.h
//  hinabian
//
//  Created by 何松泽 on 2017/10/19.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *cellNib_RecommendSpecialistCell = @"RecommendSpecialistCell";

@interface RecommendSpecialistCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *consultBtn;

- (void)setModel:(id)model;
- (void)setShowAllCell;

@end
