//
//  PersonalHeadTableViewCell.h
//  hinabian
//
//  Created by 余坚 on 15/7/2.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * cellNibName_PersonalHeadWithNoLogin = @"PersonalHeadWithNoLogin";

@interface PersonalHeadWithNoLogin : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) UIViewController * superController;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *btnLabel;



//-(void)setUserInfo:(NSString *)name status:(NSString *)status state:(NSString *)state avatarUrl:(NSString *)url;

-(void)didScroll:(CGFloat)offset;

+(CGFloat )getHeight;

@end
