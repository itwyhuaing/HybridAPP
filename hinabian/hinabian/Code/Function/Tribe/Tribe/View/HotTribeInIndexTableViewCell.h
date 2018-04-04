//
//  HotTribeInIndexTableViewCell.h
//  hinabian
//
//  Created by 余坚 on 16/6/8.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString * cellNibName_HotTribeInIndexCell = @"HotTribeInIndexTableViewCell";
@interface HotTribeInIndexTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *FirstImage;
@property (weak, nonatomic) IBOutlet UIImageView *SecondImage;
@property (weak, nonatomic) IBOutlet UIImageView *ThirdImage;
@property (weak, nonatomic) IBOutlet UIImageView *FourthImage;
@property (weak, nonatomic) IBOutlet UIImageView *FifthImage;
@property (weak, nonatomic) IBOutlet UIImageView *SixthImage;

@property (weak, nonatomic) IBOutlet UILabel *FirstTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *SecondTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ThirdTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *FourthTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *FifthTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *SixthTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *FirstThemeNum;
@property (weak, nonatomic) IBOutlet UIButton *SecondThemeNum;
@property (weak, nonatomic) IBOutlet UIButton *ThirdThemeNum;
@property (weak, nonatomic) IBOutlet UIButton *FourthThemeNum;
@property (weak, nonatomic) IBOutlet UIButton *FifthThemeNum;


@property (weak, nonatomic) IBOutlet UIButton *FirstFollowNum;
@property (weak, nonatomic) IBOutlet UIButton *SecondFollowNum;
@property (weak, nonatomic) IBOutlet UIButton *ThirdFollowNum;
@property (weak, nonatomic) IBOutlet UIButton *FourthFollowNum;
@property (weak, nonatomic) IBOutlet UIButton *FifthFollowNum;

@property (weak, nonatomic) IBOutlet UIButton *FirstTribeButton;
@property (weak, nonatomic) IBOutlet UIButton *SecondTribeButton;
@property (weak, nonatomic) IBOutlet UIButton *ThirdTribeButton;
@property (weak, nonatomic) IBOutlet UIButton *FourthTribeButton;
@property (weak, nonatomic) IBOutlet UIButton *FifthTribeButton;
@property (weak, nonatomic) IBOutlet UIButton *SixthTribeButton;
- (void) setHotTirbeInfo:(NSArray *)tribeInfoArray;
@end
