//
//  SpecialistAndTestCell.h
//  hinabian
//
//  Created by 何松泽 on 2017/6/8.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum :NSUInteger {
    SpecialTag = 1,
    TestTag,
}SpecialistAndTestBtn;

static NSString *cellNilName_SpecialistAndTestCell = @"SpecialistAndTestCell";

@interface SpecialistAndTestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (weak, nonatomic) IBOutlet UILabel *specialDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *testDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *testTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *specialBtn;
@property (weak, nonatomic) IBOutlet UIButton *testBtn;
@property (weak, nonatomic) IBOutlet UIImageView *specialImage;
@property (weak, nonatomic) IBOutlet UIImageView *testImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specialLeadingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *testLeadingLine;

-(void)setItemShow:(BOOL)isShow;

@end
