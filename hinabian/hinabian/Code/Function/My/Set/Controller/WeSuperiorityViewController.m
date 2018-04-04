//
//  WeSuperiorityViewController.m
//  hinabian
//
//  Created by 余坚 on 15/8/12.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "WeSuperiorityViewController.h"
#import "RDVTabBarController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

@interface WeSuperiorityViewController ()<UIWebViewDelegate>
{
    NSString * shareURL;
    NSString * shareTitle;
    NSString * shareFriendTitle;
    NSString * shareDesc;
    NSString * shareImageUrl;
}

@end

@implementation WeSuperiorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor DDNormalBackGround];
    self.title = @"关于海那边";
    // Do any additional setup after loading the view.
    //浏览器窗口
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - rectNav.size.height - rectStatus.size.height)];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.delegate = (id)self;
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.bounces = NO ;
    for (UIView *_aView in [self.webView subviews])
    {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
        }
    }
    
    [self.view addSubview:self.webView];
    
    
    if (!self.URL) {
        NSString* tmpURLString = [NSString  stringWithFormat:@"%@/%@",H5URL,@"about/advantage.html"];
        self.URL = [[NSURL alloc] withOutNilString:tmpURLString];
    }
    
    NSURLRequest *req = [NSURLRequest requestWithURL:self.URL];
    
    
    [self.webView loadRequest:req];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back_main);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
}

/* 点击分享按钮 */
-(void) shareContent
{
    if (![shareTitle isEqualToString:@""] && shareTitle != Nil)
    {
        [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
        [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.isShow = NO;
        //调用分享面板
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            
            
            if (platformType == UMSocialPlatformType_Sina) {
                
                UMSocialMessageObject *msgObj = [UMSocialMessageObject messageObject];
                msgObj.text = [NSString stringWithFormat:@"%@ %@",shareTitle,shareURL];
                
                UMShareImageObject *sharedObj = [[UMShareImageObject alloc] init];
                sharedObj.thumbImage = [HNBUtils getImageFromURL:shareImageUrl];
                sharedObj.shareImage = [HNBUtils getImageFromURL:shareImageUrl];
                msgObj.shareObject = sharedObj;
                
                [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                    messageObject:msgObj
                                            currentViewController:self
                                                       completion:nil];
                
            }else if (platformType == UMSocialPlatformType_WechatSession){
                UMSocialMessageObject *msgObj = [UMSocialMessageObject messageObject];
                
                UMShareWebpageObject *sharedObj = [UMShareWebpageObject shareObjectWithTitle:shareFriendTitle
                                                                                       descr:shareDesc
                                                                                   thumImage:[HNBUtils getImageFromURL:shareImageUrl]];
                sharedObj.webpageUrl = shareURL;
                msgObj.shareObject = sharedObj;
                
                [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                    messageObject:msgObj
                                            currentViewController:self
                                                       completion:nil];
            } else {
                
                UMSocialMessageObject *msgObj = [UMSocialMessageObject messageObject];
                
                UMShareWebpageObject *sharedObj = [UMShareWebpageObject shareObjectWithTitle:shareTitle
                                                                                       descr:shareDesc
                                                                                   thumImage:[HNBUtils getImageFromURL:shareImageUrl]];
                sharedObj.webpageUrl = shareURL;
                msgObj.shareObject = sharedObj;
                
                [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                    messageObject:msgObj
                                            currentViewController:self
                                                       completion:nil];
                
            }
            
        }];

    }
}

-(void) back_main
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([webView stringByEvaluatingJavaScriptFromString:@"document.title"] != nil) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    shareURL        = [webView stringByEvaluatingJavaScriptFromString:@"window.APP_SHARE_URL"];
    shareDesc       = [webView stringByEvaluatingJavaScriptFromString:@"window.APP_SHARE_FRIEND_DESC"];
    shareTitle      = [webView stringByEvaluatingJavaScriptFromString:@"window.APP_SHARE_TITLE"];
    shareFriendTitle= [webView stringByEvaluatingJavaScriptFromString:@"window.APP_SHARE_FRIEND_TITLE"];
    shareImageUrl   = [webView stringByEvaluatingJavaScriptFromString:@"window.APP_SHARE_IMG"];
    if ([shareTitle isEqualToString:@""] || shareTitle == Nil)
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [button setBackgroundImage:[UIImage imageNamed:@"share_button_normal"]forState:UIControlStateNormal];
        [button addTarget:self action:@selector(shareContent)
         forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = barButton;
        
    }
}


@end
