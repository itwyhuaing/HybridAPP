//
//  HomeTitleCell.h
//  hinabian
//
//  Created by 何松泽 on 2017/11/6.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTitleCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *detailTitleLabel;

@property (strong, nonatomic) UIImageView *arrowImageView;


- (void)setcellTitle:(NSString *)title detailTitle:(NSString *)detailTitle arrow:(NSString *)arrow;

- (void)setHiddenCell:(BOOL)isHidden;

@end
