//
//  ChangeTextViewController.h
//  dada
//
//  Created by 余坚 on 15/2/4.
//  Copyright (c) 2015年 Dongxiang Cai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeTextViewController : UIBaseViewController
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) NSString * tilteString;
@property (strong, nonatomic) NSString * changeString;

-(void)setIsTextField:(BOOL)inPutBool;
@end
