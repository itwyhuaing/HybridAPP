//
//  IMStrategyCell.h
//  hinabian
//
//  Created by hnbwyh on 16/5/24.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

typedef enum : NSUInteger {
    IMStrategy_FirstBtn_Tag = 20,
    IMStrategy_SecondBtn_Tag,
    IMStrategy_ThirdBtn_Tag,
    IMStrategy_FourthBtn_Tag
} IMStrategyCellBtnTag;


//#define FONT_UI24PX 16
//#define FONT_UI18PX 12

#import <UIKit/UIKit.h>
@class CountDownTimeView;

static NSString *cellNibName_IMStrategyCell = @"IMStrategyCell";
@interface IMStrategyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *firstButton;

@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@property (weak, nonatomic) IBOutlet UIButton *thirdButton;

@property (weak, nonatomic) IBOutlet UIButton *fourthButton;

@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;

@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;

@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

@property (weak, nonatomic) IBOutlet UIImageView *fourthImageView;

@property (weak, nonatomic) IBOutlet UILabel *firsttitle1Label;

@property (weak, nonatomic) IBOutlet UILabel *firsttitle2Label;

@property (weak, nonatomic) IBOutlet UILabel *secondtitle1Label;

@property (weak, nonatomic) IBOutlet UILabel *secondtitle2Label;

@property (weak, nonatomic) IBOutlet UILabel *thirdtitle1Label;

@property (weak, nonatomic) IBOutlet UILabel *thirdtitle2Label;

@property (weak, nonatomic) IBOutlet UILabel *fourthtitle1Label;

@property (weak, nonatomic) IBOutlet UILabel *fourthtitle2Label;

@property (weak, nonatomic) IBOutlet CountDownTimeView *tipView1;

@property (weak, nonatomic) IBOutlet CountDownTimeView *tipView2;

@property (weak, nonatomic) IBOutlet CountDownTimeView *tipView3;

@property (weak, nonatomic) IBOutlet CountDownTimeView *tipView4;


//- (void)setCellItem:(NSArray *)imgNames firstTitle:(NSArray *)firstTitles secondTitile:(NSArray *)secondTitles;

- (void)setCellItem:(NSArray *)infos;



@end
