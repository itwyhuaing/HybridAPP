//
//  ShufllingScrolView.h
//  hinabian
//
//  Created by 余坚 on 15/7/11.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShufllingScrolView : UIView
@property (strong, nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) UIScrollView * scrollViewItem;
@property (strong, nonatomic) UIPageControl* pgcontrol;
@property (strong, nonatomic) NSDictionary * ItemsTitle;
@property (strong, nonatomic) NSDictionary * ShufflingItemsMainTitle;
@property (strong, nonatomic) NSArray * imageArry;
@property (strong, nonatomic) NSTimer * ShufflingTime;
-(void) addShufflingScrollView;
@end
