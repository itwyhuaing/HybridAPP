//
//  PersonalHeadTableViewCell.h
//  hinabian
//
//  Created by 余坚 on 15/7/2.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

typedef enum : NSUInteger {
    PersonHeaderViewEnergyBtnTag,
    PersonHeaderViewLevelBtnTag,
    PersonHeaderViewVBtnTag
} PersonHeaderViewButtonTag;

#import <UIKit/UIKit.h>

@class PersonalInfo;
static NSString * cellNibName_PersonalHeadTableViewCell = @"PersonalHeadTableViewCell";

@interface PersonalHeadTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *line;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) IBOutlet UILabel *certifiedLabel;
@property (strong, nonatomic) IBOutlet UIImageView *levelImage;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIImageView *energyImage;
@property (strong, nonatomic) IBOutlet UIImageView *moderatorImage;
@property (strong, nonatomic) IBOutlet UIButton *energyButton;
@property (strong, nonatomic) IBOutlet UIButton *levelButton;
@property (strong, nonatomic) IBOutlet UIButton *vButton;
@property (strong, nonatomic) IBOutlet UIImageView *vImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusStateLabel;
@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) UIViewController * superController;
@property (strong, nonatomic) UIButton *editButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *StatusLabelTopNameConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTopBorderViewConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moderatorImageLeadingLevelImage;


-(void)setUserinfo:(PersonalInfo *)f;
-(void)setUserinfoWithoutNetWorking:(NSDictionary *)dic;

-(void)didScroll:(CGFloat)offset;

+(CGFloat )getHeight;

@end
