//
//  HomeGuideLogincell.h
//  hinabian
//
//  Created by hnbwyh on 17/5/18.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HomeGuideLogincell;
@protocol HomeGuideLogincellDelegate <NSObject>
@optional
- (void)homeGuideLogincell:(HomeGuideLogincell *)cell didClickLoginBtn:(UIButton *)btn;

@end


static NSString *cellNilName_HomeGuideLogincell = @"HomeGuideLogincell";
@interface HomeGuideLogincell : UITableViewCell

@property (nonatomic,weak) id<HomeGuideLogincellDelegate> delegate;


@property (weak, nonatomic) IBOutlet UILabel *topGapLabel;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomGapLabel;


- (void)configSubviewsDisplayStatus:(BOOL)isShow;
@end
