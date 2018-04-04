//
//  PlusIMHundredConsultCell.h
//  hinabian
//
//  Created by hnbwyh on 16/6/29.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PlusIMHundredConsult_FirstBtn_Tag = 10,
    PlusIMHundredConsult_SecondBtn_Tag,
    PlusIMHundredConsult_ThirdBtn_Tag,
    PlusIMHundredConsult_FourthBtn_Tag,
    PlusIMHundredConsult_IAskBtn_Tag
} PlusIMHundredConsultCellBtnTag;


static NSString *cellNib_PlusIMHundredConsultCell = @"PlusIMHundredConsultCell";
@interface PlusIMHundredConsultCell : UITableViewCell

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

- (void)setCellItem:(NSArray *)infos;

@end
