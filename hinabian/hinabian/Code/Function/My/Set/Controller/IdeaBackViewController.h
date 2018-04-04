//
//  IdeaBackViewController.h
//  hinabian
//
//  Created by 何松泽 on 16/1/8.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdeaBackViewController : UIBaseViewController

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextView * connectTextView;
@property (strong, nonatomic) UITextView * connectPlaceHoldTextView;
@property (strong, nonatomic) UITextView * postIdeaTextView;
@property (strong, nonatomic) UITextView * placeHoldTextView;

-(void)setUpTextView;

@end
