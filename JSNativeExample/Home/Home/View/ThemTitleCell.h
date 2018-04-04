//
//  ThemTitleCell.h
//  hinabian
//
//  Created by hnbwyh on 16/5/24.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//


//#define FONT_UI24PX 12
//#define FONT_UI18PX 14


#import <UIKit/UIKit.h>
@class HomeHotPost;

static NSString *cellNibName_ThemTitleCell = @"ThemTitleCell";
@interface ThemTitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *titleIcon;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;


- (void)setcellIcon:(NSString *)themIcon title:(NSString *)title detailTitle:(NSString *)detailTitle arrow:(NSString *)arrow;

@end
