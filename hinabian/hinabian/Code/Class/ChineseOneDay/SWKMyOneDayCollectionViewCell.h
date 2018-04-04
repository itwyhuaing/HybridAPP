//
//  SWKMyOneDayCollectionViewCell.h
//  hinabian
//
//  Created by hnbwyh on 16/8/17.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNBWKWebView.h"

#import <WebKit/WebKit.h>

const static NSString *cellNIbName_SWKMyOneDayCollectionViewCell = @"SWKMyOneDayCollectionViewCell";

typedef enum{
    LEFT_BUTTON = 1,
    ZAN_BUTTON,
    COMMAND_BUTTON,
    SHARE_BUTTON,
    RIGHT_BUTTON,
}Button_tag;

@interface SWKMyOneDayCollectionViewCell : UICollectionViewCell <UIScrollViewDelegate,UITextViewDelegate,WKNavigationDelegate>
{
    NSString * shareURL;
    NSString * shareTitle;
    NSString * shareFriendTitle;
    NSString * shareDesc;
    NSString * shareImageUrl;
    
    NSString * praiseNum;
    NSString * commentNum;
    
    NSTimer *myTimer;
    
    UILabel *zanLabel;
    UILabel *commentLabel;
    
    UIEdgeInsets insets;
    CGFloat oldContentOffsetY;
    CGFloat disContentOffsetY;
}

@property (assign, nonatomic) BOOL              isZan;
@property (strong, nonatomic) UITextView        *inputTextView;
@property (strong, nonatomic) UITextView        *placeholderTextView;

@property (strong, nonatomic) UIView            *inputView;
@property (strong, nonatomic) UIView            *buttonView;
@property (nonatomic, strong) HNBWKWebView      *wkWebView;
@property (strong, nonatomic) UIButton          *sendButton;
@property (strong, nonatomic) UIImageView       *bgImageView;
@property (strong, nonatomic) UIViewController  *superController;

@property (strong, nonatomic) NSString          *T_ID;

@end
