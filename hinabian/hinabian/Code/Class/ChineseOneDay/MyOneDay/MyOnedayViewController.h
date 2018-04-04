//
//  MyOnedayViewController.h
//  hinabian
//
//  Created by 何松泽 on 15/9/29.
//  Copyright © 2015年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "HNBUtils.h"
#import "DataFetcher.h"
#import "RefreshControl.h"
//#import "UMSocial.h"
//#import "MIBadgeButton.h"
#import "LineLayout.h"
#import "SWKMyOneDayCollectionViewCell.h"
#import "LoginViewController.h"
#import "PostingViewController.h"
#import "RDVTabBarController.h"
#import "PullRefreshViewController.h"
#import "PostMyDayViewController.h"



//@interface MyOnedayViewController : PullRefreshViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITabBarDelegate,UMSocialUIDelegate>
@interface MyOnedayViewController : PullRefreshViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITabBarDelegate>
{
    CGRect rectNav;
    CGRect rectStatus;
    CGFloat tabBarHight;
    
    UILabel *zanLabel;
    UILabel *commandLabel;
    UIEdgeInsets insets;
    
    NSMutableArray *urlArr;
    NSDictionary *urlDictionary;
    
    LineLayout *layout;
}


@property (strong, nonatomic) UIView            *buttonView;
//@property (strong, nonatomic) UIWebView           *webView;
@property (strong, nonatomic) NSURL             *URL;
@property (strong, nonatomic) NSString          *TimeStamp;


@end
