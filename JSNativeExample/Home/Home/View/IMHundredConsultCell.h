//
//  IMHundredConsultCell.h
//  hinabian
//
//  Created by hnbwyh on 16/5/24.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//


typedef enum : NSUInteger {
    IMHundredConsult_FirstBtn_Tag = 10,
    IMHundredConsult_SecondBtn_Tag,
    IMHundredConsult_ThirdBtn_Tag,
    IMHundredConsult_FourthBtn_Tag,
    IMHundredConsult_IAskBtn_Tag
} IMHundredConsultCellBtnTag;


//#define FONT_UI24PX 12
//#define FONT_UI18PX 12

#import <UIKit/UIKit.h>

static NSString *cellNibName_IMHundredConsultCell = @"IMHundredConsultCell";
@interface IMHundredConsultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *horizonLineLabel;

@property (weak, nonatomic) IBOutlet UILabel *vLineLabel;

@property (weak, nonatomic) IBOutlet UIButton *firstButton;

@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@property (weak, nonatomic) IBOutlet UIButton *thirdButton;

@property (weak, nonatomic) IBOutlet UIButton *fourthButton;

@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;

@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;

@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

@property (weak, nonatomic) IBOutlet UIImageView *fourthImageView;

@property (weak, nonatomic) IBOutlet UIImageView *freeImageView;

@property (weak, nonatomic) IBOutlet UILabel *firsttitle1Label;

@property (weak, nonatomic) IBOutlet UILabel *firsttitle2Label;

@property (weak, nonatomic) IBOutlet UILabel *firsttitle3Label;

@property (weak, nonatomic) IBOutlet UILabel *secondtitle1Label;

@property (weak, nonatomic) IBOutlet UILabel *secondtitle2Label;

@property (weak, nonatomic) IBOutlet UILabel *secondtitle3Label;

@property (weak, nonatomic) IBOutlet UILabel *thirdtitle1Label;

@property (weak, nonatomic) IBOutlet UILabel *thirdtitle2Label;

@property (weak, nonatomic) IBOutlet UILabel *thirdtitle3Label;

@property (weak, nonatomic) IBOutlet UILabel *fourthtitle1Label;

@property (weak, nonatomic) IBOutlet UILabel *fourthtitle2Label;
@property (weak, nonatomic) IBOutlet UILabel *fourthtitle3Label;

@property (weak, nonatomic) IBOutlet UIButton *iaskButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstImageViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstImageViewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fristImageViewTrainlingConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondImageViewTrainlingConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdImageViewTrainlingConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourthImageViewTrainlingConstraint;


- (void)setCellItem:(NSArray *)infos;

@end
