//
//  ActivityItemTableViewCell.m
//  hinabian
//
//  Created by 余坚 on 15/10/8.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "ActivityItemTableViewCell.h"
#import "SWKTribeShowViewController.h"
#import "TribeDetailInfoViewController.h"

@implementation ActivityItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

-(void) setActivityItem:(NSString *) imageUrl  Title:(NSString *)titleString isNew:(BOOL)isNew See:(NSString *) seeNum Url:(NSString *)urlString
{
    
    [self.ActivityMainImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"special_activtity"]];
    self.ActivityTitleLabel.text = titleString;
    self.IsNewImage.hidden = !isNew;
    [self.ActivitySeeButton setTitle:seeNum forState:UIControlStateNormal];
    [self.ActivityPressedButton setTitle:urlString forState:UIControlStateSelected];
    [self.ActivityPressedButton addTarget:self action:@selector(touchPressedButton:) forControlEvents:UIControlEventTouchUpInside];

}

- (void) touchPressedButton:(UIButton *)sender
{
    /* 无网络判断 */
    if([[sender titleForState:UIControlStateSelected] isEqualToString:@""] || [sender titleForState:UIControlStateSelected] == Nil)
    {
        return;
    }
    
    NSString * tmpUrlString = [sender titleForState:UIControlStateSelected];
    NSRange range = [tmpUrlString rangeOfString:@"theme/detail"];//判断字符串是否包含
    
    if (range.location == NSNotFound)
    {
        NSDictionary *dict = @{@"url" : tmpUrlString,@"type" : @"Activity"};
        [MobClick event:@"clickIndexActivity" attributes:dict];
 
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [vc.webManger configNativeNavWithURLString:tmpUrlString
                                                       ctle:@"1"
                                                 csharedBtn:@"1"
                                                       ctel:@"0"
                                                  cfconsult:@"1"];
        [self.superController.navigationController pushViewController:vc animated:YES];
        
    }
    else {
        NSDictionary *dict = @{@"url" : tmpUrlString,@"type" : @"Tribe"};
        [MobClick event:@"clickIndexActivity" attributes:dict];
        
        
        NSString *isNativeString = [HNBUtils sandBoxGetInfo:[NSString class] forKey:TRIBEDETAILTHEME_NATIVEUI_WEB];
        if ([isNativeString isEqualToString:@"1"]) {
            
            TribeDetailInfoViewController * vc = [[TribeDetailInfoViewController alloc] init];
            vc.URL = [[NSURL alloc] withOutNilString:tmpUrlString];
            [self.superController.navigationController pushViewController:vc animated:YES];
            
        } else {
            
            SWKTribeShowViewController * vc = [[SWKTribeShowViewController alloc] init];
            vc.URL = [[NSURL alloc] withOutNilString:tmpUrlString];
            [self.superController.navigationController pushViewController:vc animated:YES];

            
        }
        
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
